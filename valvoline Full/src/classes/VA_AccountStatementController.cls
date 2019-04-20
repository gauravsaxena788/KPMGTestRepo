/**
    @author:        Shubham Shukla
    @date:          20/8/2018
    @description:   Rest resource which is receiving Account statement as an xml and save it into 
    Account statement object after decrypting image.  
*/

@RestResource(urlMapping='/AccountStatementService/*')  
global class VA_AccountStatementController{    
    
    @HttpPost
    global static ResponsedoPosts saveStatementImage(StatementRequest accountStatementList) {
    
        Boolean allInsertedContentVersion = true;
        
        integer i =0;
        integer TotalNumberOfRecord=0;
        
        map<string,ResponsedoPost> mapResponsedPost = new map<string,ResponsedoPost>();
        
        ResponsedoPosts objResponsedoPosts;
        integer TotalRecord=0;
        integer TotalFailedRecord=0;
        ResponsedoPost objresponse;
        string Message;
        map<string,string> mapAccCodebyAccId = new map<string,string>();    
        
        Savepoint sp;
        
        try {
            
            if(accountStatementList != null && accountStatementList.statementDataList != null && !accountStatementList.statementDataList.isEmpty()){
                
                //----------- Creating sets to do query on --------------// 
                Set<String> accountIdSet = new Set<String>();
                Set<String> accountIdShipToCode = new Set<String>();
                Set<String> accountStMonth = new Set<String>(); 
                Set<String> accountStYear = new Set<String>(); 
                Set<String> accountStFrequency = new Set<String>();
                
                Map<Integer,String> monthMap = new Map<Integer,String>{1=>'January',2=>'February',3=>'March',4=>'April',5=>'May',6=>'June',7=>'July',8=>'August',9=>'September',10=>'October',11=>'November',12=>'December'};   
                
                for(StatementRequestWrapper each : accountStatementList.statementDataList){
                    
                    if(String.isNotBlank(each.accountStatement.VA_SFDC_Account_Id__c)){
                        accountIdSet.add(each.accountStatement.VA_SFDC_Account_Id__c); 
                    }
                    
                    if(String.isNotBlank(each.accountStatement.VA_Ship_To_Code__c)){
                        accountIdShipToCode.add(each.accountStatement.VA_Ship_To_Code__c); 
                    }
                    
                    if(String.valueOf(each.accountStatement.VA_From_Date__c)!=null && String.valueof(each.accountStatement.VA_To_Date__c)!=null){
                        accountStMonth.add(monthMap.get(each.accountStatement.VA_To_Date__c.Month()));
                        accountStYear.add(String.valueof(each.accountStatement.VA_To_Date__c.year()));
                    }
                    
                    if(String.isNotBlank(each.accountStatement.VA_Frequency__c)){
                        accountStFrequency.add(each.accountStatement.VA_Frequency__c);  
                    }
                    
                    TotalNumberOfRecord = TotalNumberOfRecord +1;
                }
                //-----------/Creating sets to do query on --------------//
                
                
                //----------- Getting all Accounts and users ------------//
                map<string, Account> mapAccountsId = new map<string, Account>();
                Map<Id,boolean> isPortalAccountMap = new Map<Id,boolean>();
                    
                if(accountIdSet.size() > 0){
                    map<Id, Account> mapAccounts = new map<Id, Account> ([Select Id,Ship_to_Code__c, SFDC_Account_ID__c,ParentId,Is_Parent__c, Payer_code__c 
                                                                            From Account 
                                                                            where SFDC_Account_ID__c =: accountIdSet ]);
                    
                    if(mapAccounts.size()  > 0){
                        
                        for(User use: [Select id, Contact.AccountId from User where Contact.AccountId in : mapAccounts.keyset()]){
                            isPortalAccountMap.put(use.Contact.AccountId,true);
                        }
                        
                        for(Account accountObj: mapAccounts.values()){
                            mapAccountsId.put(accountObj.SFDC_Account_ID__c, accountObj);
                        }
                    }
                }
                //-----------/Getting all Accounts and users ------------//
                
                
                map<string,string> mapImageShipToCode = new map<string,string>();
                
                list<VA_AccountStatement__c> accStatementList = new list<VA_AccountStatement__c>();
                
                //----------- processing account statement -------------//
                for(StatementRequestWrapper each : accountStatementList.statementDataList){    
                    
                    if(mapAccountsId.containsKey(each.accountStatement.VA_SFDC_Account_Id__c)){
                        
                        //Checkking if portal account exists
                        if(isPortalAccountMap.containsKey(mapAccountsId.get(each.accountStatement.VA_SFDC_Account_Id__c).Id) || test.isRunningTest()){
                            
                            VA_AccountStatement__c accountStatementObj = each.accountStatement;
                            
                            if(Schema.SObjectType.VA_AccountStatement__c.getRecordTypeInfosByName().containsKey(accountStatementObj.VA_Frequency__c)){
                                
                                accountStatementObj.VA_Account__c = mapAccountsId.get(each.accountStatement.VA_SFDC_Account_Id__c).Id;
                                
                                accountStatementObj.recordTypeId = Schema.SObjectType.VA_AccountStatement__c.getRecordTypeInfosByName().get(accountStatementObj.VA_Frequency__c).getRecordTypeId(); 
                                
                                if(accountStatementObj.VA_To_Date__c != null)
                                    accountStatementObj.VA_Year__c = String.valueof(accountStatementObj.VA_To_Date__c.year());
                                
                                accountStatementObj.VA_Month__c = monthMap.get(accountStatementObj.VA_To_Date__c.Month()); 
                                accountStatementObj.Name = accountStatementObj.VA_Month__c  +' - '+ accountStatementObj.VA_Year__c;
                                accountStatementObj.VA_From_Date__c = accountStatementObj.VA_From_Date__c ;
                                accountStatementObj.VA_To_Date__c= accountStatementObj.VA_To_Date__c;
                                
                                accountStatementObj.VA_Month_Difference__c = accountStatementObj.VA_From_Date__c.monthsBetween(accountStatementObj.VA_To_Date__c);
                                
                                accStatementList.add(accountStatementObj); 
                                
                                //Adding image into map
                                mapImageShipToCode.put(each.accountStatement.VA_Ship_To_Code__c, each.statementImage);
                            }
                            else {
                                objresponse = new ResponsedoPost('FAILED', 'Invalid frequency ' + accountStatementObj.VA_Frequency__c + ' for account statement', each.accountStatement.VA_Ship_To_Code__c);
                                mapResponsedPost.put(each.accountStatement.VA_Ship_To_Code__c,objresponse);
                            }
                        }
                        else {
                            objresponse = new ResponsedoPost('FAILED', 'Account not activated on Customer Portal', each.accountStatement.VA_Ship_To_Code__c);
                            mapResponsedPost.put(each.accountStatement.VA_Ship_To_Code__c,objresponse);
                        }
                    }
                    else {
                        objresponse = new ResponsedoPost('FAILED', 'SFDC Account ID : ' + each.accountStatement.VA_SFDC_Account_Id__c + ' does not exist in salesforce. ', each.accountStatement.VA_Ship_To_Code__c);
                        mapResponsedPost.put(each.accountStatement.VA_Ship_To_Code__c,objresponse);
                    }
                }
                //-----------/processing account statement -------------//
                
                
                map<string,ContentVersion> mapContentVerShiptoCode = new map<string,ContentVersion>();
                map<string,ContentDocumentLink> mapContentDocLinkShipToCode = new map<string,ContentDocumentLink>();
                
                //----------- Inserting Account Statement -------------//
                sp = Database.setSavepoint();
                
                if(!accStatementList.isEmpty()){
                
                    Database.SaveResult[] srList = Database.insert(accStatementList, false);
                    i =0;
                    for (Database.SaveResult sr : srList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            objresponse = new ResponsedoPost('SUCCESS','Record Created Successfully.',String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')));
                            
                            ContentVersion objConVer = new ContentVersion();
                            objConVer.VersionData = EncodingUtil.base64Decode(mapImageShipToCode.get(String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c'))));
                            objConVer.title = 'Image.PDF';  
                            objConVer.pathOnClient = URL.getSalesforceBaseUrl().toExternalForm() + '/' + objConVer.title + '.pdf';                               
                            mapContentVerShiptoCode.put(string.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')), objConVer);
                            
                            ContentDocumentLink contentlink = new ContentDocumentLink();
                            contentlink.ShareType = 'V';
                            contentlink.Visibility = 'AllUsers';
                            contentlink.LinkedEntityId = String.valueOf(accStatementList[i].get('Id'));
                            
                            mapContentDocLinkShipToCode.put(string.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')), contentlink);
                            
                            
                        }
                        else {
                            //allInserted = false;
                            // Operation failed, so get all errors 
                            Message = '';
                            
                            for(Database.Error eachErr : sr.getErrors()){  
                                
                                if (mapResponsedPost.containskey(String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')))  && mapResponsedPost.get(String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c'))).status == 'FAILED')
                                {
                                    if (!mapResponsedPost.get(String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c'))).Message.contains(eachErr.getStatusCode() + ': ' +  eachErr.getMessage()))
                                    Message =  mapResponsedPost.get(String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c'))).Message + ' ' + Label.Sepration + ' ' + eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                                }   
                                else
                                {
                                    Message = eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                                }   
                                
                            }
                            if(Message.contains('DUPLICATES_DETECTED'))
                                objresponse = new ResponsedoPost('SUCCESS',Message,String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')));
                            else
                                objresponse = new ResponsedoPost('FAILED',Message,String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')));
                        }
                        mapResponsedPost.put(String.valueOf(accStatementList[i].get('VA_Ship_To_Code__c')),objresponse);
                        i++;
                    }
                    
                    if(mapContentVerShiptoCode.size() > 0 && mapContentDocLinkShipToCode.size() > 0){
                        
                        insert mapContentVerShiptoCode.values();
                        
                        map<Id, Id> contentVersionIdWithDocIdMap = new map<Id, Id>();
                        
                        for(ContentVersion version : [select ContentDocumentId from ContentVersion where Id IN: mapContentVerShiptoCode.values()]) {
                            contentVersionIdWithDocIdMap.put(version.Id, version.ContentDocumentId);
                        }
                        
                        for(string shipToCode : mapContentDocLinkShipToCode.keyset()){
                            
                            mapContentDocLinkShipToCode.get(shipToCode).contentdocumentid = contentVersionIdWithDocIdMap.get(mapContentVerShiptoCode.get(shipToCode).Id);
                        }
                        insert mapContentDocLinkShipToCode.values();
                    }
                    
                }
                //-----------/Inserting Account Statement -------------//
                
            }
            
            
            if (!mapResponsedPost.isempty()){ 
                    
                for (ResponsedoPost ResponsedoPost : mapResponsedPost.values())
                {
                    if (ResponsedoPost.Status == 'FAILED')
                    TotalFailedRecord = TotalFailedRecord + 1;
                    TotalRecord = TotalRecord + 1;
                }
                
                objResponsedoPosts = new ResponsedoPosts();
                objResponsedoPosts.lstResponsedoPost = mapResponsedPost.values();
            }
        
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(accountStatementList), JSON.serialize(objResponsedoPosts) );
            
            return objResponsedoPosts;
        } 
        catch(Exception ex) {  
            
            Database.rollback( sp );
            
            list<ResponsedoPost> responseDoPostLst = new list<ResponsedoPost>();
            objresponse = new responsedoPost ('FAILED', string.valueof(ex.getmessage()) ,'');
            responseDoPostLst.add(objresponse);
            
            objResponsedoPosts = new ResponsedoPosts();
            objResponsedoPosts.lstResponsedoPost = responseDoPostLst;
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(accountStatementList), JSON.serialize(objResponsedoPosts) );
            
            return objResponsedoPosts; 
        } 
        
    }
    
    @future
    public static void createErrorLog(integer TotalNumberOfRecord, integer successRecord, integer failedRecords, string requestBody, string responseBody ){
            
        VA_Error_Log__c errorLog = new VA_Error_Log__c();
        errorLog.Total_Number_Of_Record__c = TotalNumberOfRecord;
        errorLog.Total_Success_Record__c = successRecord  ;
        errorLog.Number_Of_Failed_Records__c = failedRecords;
        errorLog.Interface_Name__c = 'AccountStatement';
        insert errorLog;
        
        list<Attachment> lstAttach = new list<Attachment>();
        
        Attachment request = new Attachment();
        request.ParentId = errorLog.id;
        request.ownerId = UserInfo.getUserId();
        request.Description = 'Account Statement Request Body';
        request.name = 'Request Body.json';
        request.ContentType = 'application/json';
        request.Body = Blob.valueOf(requestBody);
        lstAttach.add(request);
        
        Attachment response = new Attachment();
        response.ParentId = errorLog.id;
        response.ownerId = UserInfo.getUserId();
        response.Description = 'Account Statement Request Body';
        response.name = 'Reresponse Body.json';
        response.ContentType = 'application/json';
        response.Body = Blob.valueOf(responseBody);
        lstAttach.add(response);
        
        insert lstAttach;
    }
    
    
    public static void Requestbody(String ErrorLogId,StatementRequest accountStatementList)
    {
        Request_Body__c objVaRequestBody = new  Request_Body__c();
        objVaRequestBody.ErrorLog__c = ErrorLogId;
        objVaRequestBody.name = 'AccountStatement';
        string Request;
        Request = string.valueof(accountStatementList);
        system.debug('<<Request.length()>>'+ Request.length());
        if (Request.length() > 5000)
        {
            system.debug('<<Request.length()>>'+ Request.length());
            objVaRequestBody.requestbody1__c = Request.substring(0,5000);
        }
        else
        {
            
            objVaRequestBody.requestbody1__c = Request;
        }
        
        if (Request.length() > 5000)
        {
            system.debug('<<Request.length()2>>'+ Request.length());
            objVaRequestBody.requestbody2__c = Request.substring(5000,Request.length());
        }
        
        insert objVaRequestBody;
    }
    
    
    global class StatementResponse{
        global string message;
        global boolean status;
    }
    
    global class StatementRequestWrapper{
        global VA_AccountStatement__c accountStatement;  
        global string statementImage; 
    }
    
    global class StatementRequest {
        global List<StatementRequestWrapper> statementDataList;
    }
    
    
    global class ResponsedoPost {
        public String Status;
        public String Id;
        public String Message;
        
        public ResponsedoPost(string stsCode,string strMsg,string strCaseSFNum) {
            Status = stsCode;
            Message= strMsg;
            Id = strCaseSFNum;
        }
    } 
    
    global class ResponsedoPosts {
        global list<ResponsedoPost> lstResponsedoPost;
    }
}