@RestResource(urlMapping='/AccountService/*')  

global class VA_AccountRESTController{
    
    @HttpPost
    global static VA_DatabaseUtility.StatementResponses saveAccounts(AccountRequest accountList){
        Map<String,VA_DatabaseUtility.StatementResponse> response;    
        integer TotalFailedRecord = 0;
        integer TotalRecord = 0;
        integer TotalNumberOfRecord = 0;
        try{ 
            system.debug('@@@123'+accountList);                       
            List<Account> accList = new List<Account>();
            
            List<String> accSFDCNumberLst = new List<String>();
            Map<String, Id> accNumberIdMap = new Map<String, Id>();
            Map<String, String> zoneAccIdMap = new Map<String, String>();
            Map<String, String> industrySegmentAccIdMap = new Map<String, String>();
            Map<String, String> marketSegmentAccIdMap = new Map<String, String>();
            Map<String, String> buAccIdMap = new Map<String, String>();
            
            if(accountList != null && accountList.accDataList != null){
                
                for(AccountWrapper each : accountList.accDataList){
                    if(each.accountInstance != null){       
                        accSFDCNumberLst.add(each.accountInstance.SFDC_Account_ID__c);
                        TotalNumberOfRecord = TotalNumberOfRecord +1;
                    }
                }
                
                
                for(Account acc: [Select id,SFDC_Account_ID__c,BU_Name__c,Indutry_Segment__c,Market_Segment__c,Zone__c FROM Account WHERE SFDC_Account_ID__c in :accSFDCNumberLst]){
                    
                    accNumberIdMap.put(acc.SFDC_Account_ID__c ,acc.Id);
                    zoneAccIdMap.put(acc.SFDC_Account_ID__c ,acc.Zone__c);
                    industrySegmentAccIdMap.put(acc.SFDC_Account_ID__c ,acc.Indutry_Segment__c);
                    marketSegmentAccIdMap.put(acc.SFDC_Account_ID__c ,acc.Market_Segment__c);
                    buAccIdMap.put(acc.SFDC_Account_ID__c, acc.BU_Name__c);
                }
                
                for(AccountWrapper each : accountList.accDataList){
                    if(each.accountInstance != null){
                        if(each.accountInstance.VA_Block__c == 'X'){
                            each.accountInstance.Is_Blocked__c = True;
                        }
                        
                        else{
                            each.accountInstance.Is_Blocked__c = False;
                        }
                        
                        if(accNumberIdMap != null && accNumberIdMap.containsKey(each.accountInstance.SFDC_Account_ID__c)){
                            each.accountInstance.Id = accNumberIdMap.get(each.accountInstance.SFDC_Account_ID__c);
                        }
                        
                        if(zoneAccIdMap!= null && zoneAccIdMap.containsKey(each.accountInstance.SFDC_Account_ID__c)){
                            each.accountInstance.Zone__c=zoneAccIdMap.get(each.accountInstance.SFDC_Account_ID__c);
                        }
                        
                        if(industrySegmentAccIdMap != null && industrySegmentAccIdMap.containsKey(each.accountInstance.SFDC_Account_ID__c)){
                            each.accountInstance.Indutry_Segment__c=industrySegmentAccIdMap.get(each.accountInstance.SFDC_Account_ID__c);
                        }
                        
                        if(marketSegmentAccIdMap!= null && marketSegmentAccIdMap.containsKey(each.accountInstance.SFDC_Account_ID__c)){
                            each.accountInstance.Market_Segment__c= marketSegmentAccIdMap.get(each.accountInstance.SFDC_Account_ID__c);
                        }
                        
                        if(buAccIdMap!= null && buAccIdMap.containsKey(each.accountInstance.SFDC_Account_ID__c)){
                            each.accountInstance.BU_Name__c = buAccIdMap.get(each.accountInstance.SFDC_Account_ID__c);
                        }
                        
                        accList.add(each.accountInstance);
                    }
                }
            }
            
            
            if(!accList.isEmpty()) {
                response = VA_DatabaseUtility.insertionUtility(accList,'Ship_to_Code__c','update','Account');             
            }
            
            system.debug('<<response>>'+ response);
            VA_DatabaseUtility.StatementResponses objasc = new VA_DatabaseUtility.StatementResponses();
            objasc.lstStatementResponse = response.values();
            
            for (VA_DatabaseUtility.StatementResponse objresponse : response.values())
            {
                if (objresponse.Status == 'FAILED')
                TotalFailedRecord = TotalFailedRecord + 1;
                TotalRecord = TotalRecord + 1;
            }    
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(accountList), JSON.serialize(objasc) );
            
            return objasc;
            
            }catch(exception e){
            
            VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
            objResponse.Id = '';
            objResponse.status = 'FAILED';
            objResponse.Message = e.getMessage();
            list<VA_DatabaseUtility.StatementResponse> lststatement = new list<VA_DatabaseUtility.StatementResponse>();
            lststatement.add(objResponse);
            
            VA_DatabaseUtility.StatementResponses objasc = new VA_DatabaseUtility.StatementResponses();
            objasc.lstStatementResponse = lststatement;
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(accountList), JSON.serialize(objasc));
            
            return objasc;
        }     
        
        
    }
    
    @future
    public static void createErrorLog(integer TotalNumberOfRecord, integer successRecord, integer failedRecords, string requestBody, string responseBody ){
        
        VA_Error_Log__c errorLog = new VA_Error_Log__c();
        errorLog.Total_Number_Of_Record__c = TotalNumberOfRecord;
        errorLog.Total_Success_Record__c = successRecord  ;
        errorLog.Number_Of_Failed_Records__c = failedRecords;
        errorLog.Interface_Name__c = 'Account';
        insert errorLog;
        
        list<Attachment> lstAttach = new list<Attachment>();
        
        Attachment request = new Attachment();
        request.ParentId = errorLog.id;
        request.ownerId = UserInfo.getUserId();
        request.Description = 'Account Request Body';
        request.name = 'Request Body.json';
        request.ContentType = 'application/json';
        request.Body = Blob.valueOf(requestBody);
        lstAttach.add(request);
        
        Attachment response = new Attachment();
        response.ParentId = errorLog.id;
        response.ownerId = UserInfo.getUserId();
        response.Description = 'Account Response Body';
        response.name = 'Response Body.json';
        response.ContentType = 'application/json';
        response.Body = Blob.valueOf(responseBody);
        lstAttach.add(response);
        
        insert lstAttach;
    }
    
    
    
    
    
    
    global class AccountWrapper{
        global Account accountInstance;
    }
    
    global class AccountRequest{
        global List<AccountWrapper> accDataList;
    }  
}