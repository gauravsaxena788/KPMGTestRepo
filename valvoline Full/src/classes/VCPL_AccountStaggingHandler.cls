/*
    @author: Shubham Shukla
    @company: Saasfocus
    @description: This class is working As an Handler for AccountStaggingTrigger. 
*/

public class VCPL_AccountStaggingHandler {
    
    public void InsertAccount(list<VCPL_Account_Stagging__c> triggerNew)
    {
        list<Account> lstAccount = new list<Account>();
        Id AccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
        map<String,string> mapUnSuccessfulRecordIdByError = new map<String,string>(); 
        set<String> SetSuccessRecordId = new  set<String>();
        set<string> setCityState = new set<string>();
        Map<string,VCPL_Dealer_Mapping__c> mapDealerbyCityState = new  Map<string,VCPL_Dealer_Mapping__c>();
        map<string,string> mapProcessDesbyName = new map<string,string>();
        integer i;
        
        Try{
            
            for (VCPL_Account_Stagging__c objAccountStagging : triggerNew)
            {
                if (!string.isblank(objAccountStagging.City__c) && !string.isblank(objAccountStagging.State__c)){
                    setCityState.add(objAccountStagging.City__c + objAccountStagging.State__c );
                }
            }
            
            if (setCityState.size() > 0){
                for(VCPL_Dealer_Mapping__c objVCPLDealerCustomer :[select VCPL_Dealer_Account__c,VCPL_Unique_City_State__c,VCPL_StateCity__c from VCPL_Dealer_Mapping__c where VCPL_StateCity__c Like:setCityState ]) 
                {
                    mapDealerbyCityState.put(objVCPLDealerCustomer.VCPL_StateCity__c.ToLowerCase(),objVCPLDealerCustomer);                     
                }
            }
            
            
            for(VCPL_Account_Stagging__c objAccountStagging: triggerNew)
            {
                if (!string.isblank(objAccountStagging.Account_ID__c)){
                    Account objAcc = new Account();
                    objAcc.VCPL_CDOS_AccountId__c = objAccountStagging.Account_ID__c;
                    objAcc.RecordTypeId = AccRecordTypeId;
                    objAcc.Name = objAccountStagging.Customer_Name__c;
                    objAcc.VCPL_CDOS_Alias__c = objAccountStagging.Alias__c;
                    objAcc.VCPL_CDOS_Status__c = objAccountStagging.Account_Status__c;
                    objAcc.Shippingcity = objAccountStagging.City__c;
                    objAcc.ShippingState = objAccountStagging.State__c;
                    objAcc.VCPL_CDOS_Account_Segment__c = objAccountStagging.Account_Segment__c;
                    objAcc.VCPL_CDOS_Account_Creation_Date__c = VCPL_CommonUtilityClass.convertCDOSDate(objAccountStagging.Created_Date__c);
                    
                    if (!mapDealerbyCityState.containskey((objAccountStagging.City__c +objAccountStagging.State__c).ToLowerCase())){ 
                        mapProcessDesbyName.put(objAccountStagging.name,'Dealer Not Found ');   
                    }
                    
                    if (objAccountStagging.Filter_Sales__c == 'Y'){
                        objAcc.VCPL_CDOS_Filter_Sales__c = True;
                    }
                    else
                    {
                        objAcc.VCPL_CDOS_Filter_Sales__c = false;
                    }
                    
                    objAcc.VCPL_Current_Fin_Year_Total_Potential__c = objAccountStagging.Potential__c;
                    objAcc.Zone__c = 'All';
                    objAcc.Market_Segment__c = 'Cummins Rental';
                    objAcc.Indutry_Segment__c  ='Cummins Dealer Secondary customer';
                    objAcc.Account_Type__c  ='Secondary Customer through Channel';
                    objAcc.Name = objAccountStagging.Customer_Name__c +' '+ objAccountStagging.Account_ID__c;
                    objAcc.Status__c = 'Activated';
                    objAcc.Is_Parent__c='Y';
                    lstAccount.add(objAcc);
                } 
                else
                {   
                    mapUnSuccessfulRecordIdByError.put(objAccountStagging.Name,'AccountId Cannot Be Blank'); 
                }
            }
            
            If (!lstAccount.IsEmpty()){
                Schema.SObjectField f = Account.Fields.VCPL_CDOS_AccountId__c ;
                List<Database.upsertResult> uResults = Database.upsert(lstAccount,f,False);
                i=0;
                for (database.upsertResult each : uResults)
                {
                    if (each.isSuccess())
                    { 
                        SetSuccessRecordId.add(triggerNew[i].Name);
                    }
                    else
                    {
                        for(Database.Error eachErr : each.getErrors()){  
                            mapUnSuccessfulRecordIdByError.put(triggerNew[i].Name,eachErr.getStatusCode() + ': ' +  eachErr.getMessage());
                        }             
                    }
                    i++;  
                }
            }
            
            
            If (!lstAccount.IsEmpty()){
                list<VCPL_Dealer_Customer_Mapping__c> lstVCPLDealerAccount = new list<VCPL_Dealer_Customer_Mapping__c>();
                for (Account ObjAccount:lstAccount){
                    if (ObjAccount.id != null){ 
                        VCPL_Dealer_Customer_Mapping__c objVCPLDealerAccount = new VCPL_Dealer_Customer_Mapping__c();
                        if (mapDealerbyCityState.containskey((ObjAccount.Shippingcity + ObjAccount.ShippingState).ToLowerCase())){
                            
                            VCPL_Dealer_Mapping__c objMapping = mapDealerbyCityState.get((ObjAccount.Shippingcity + ObjAccount.ShippingState).ToLowerCase()); 
                            objVCPLDealerAccount.VCPL_Customer_Account__c = ObjAccount.ID;
                            objVCPLDealerAccount.VCPL_DealerCustomerID__c =string.valueof(ObjAccount.id) + objMapping.VCPL_Dealer_Account__c ;
                            objVCPLDealerAccount.VCPL_Dealer_Account__c = objMapping.VCPL_Dealer_Account__c ;
                            objVCPLDealerAccount.Dealer_Mapping__c = objMapping.id;
                            lstVCPLDealerAccount.add(objVCPLDealerAccount);
                        }
                    }           
                }
                if (!lstVCPLDealerAccount.isempty())
                {
                    //upsert lstVCPLDealerAccount;
                    Schema.SObjectField f = VCPL_Dealer_Customer_Mapping__c.Fields.VCPL_DealerCustomerID__c;
                    Database.UpsertResult [] cr = Database.upsert(lstVCPLDealerAccount, f, false);
                }
            }
            
            
            list<VCPL_Account_Stagging__c> lstAcc = new list<VCPL_Account_Stagging__c>();
            list<VCPL_Account_Stagging__c> lstAccSt = [select ID,Name,Status__c,Error__c from VCPL_Account_Stagging__c where id =: triggernew];                
            
            for(VCPL_Account_Stagging__c objAccSt: lstAccSt)
            {    
                if (SetSuccessRecordId !=null && SetSuccessRecordId.size() > 0){
                    if (SetSuccessRecordId.contains(objAccSt.Name))
                    {
                        objAccSt.Status__c = 'Processed';
                    }
                }
                
                if (mapUnSuccessfulRecordIdByError != null && mapUnSuccessfulRecordIdByError.Size()> 0){
                    if (mapUnSuccessfulRecordIdByError.containskey(objAccSt.Name)){
                        objAccSt.Status__c = 'Has Error';
                        objAccSt.Error__c = mapUnSuccessfulRecordIdByError.get(objAccSt.Name);
                    }
                }
                
                if (mapProcessDesbyName.containskey(objAccSt.Name)){
                    objAccSt.Proccessed_Description__c = mapProcessDesbyName.get(objAccSt.Name);
                }
                
                lstAcc.add(objAccSt); 
            }
            if (!lstAcc.isempty())
            update lstAcc;
            
        }
        Catch(exception ex){
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;
        }
        
        if(test.isRunningTest()){
            integer a = Integer.valueof('Invalid Input');
        }
        
    }
    
    
    /*public void getDealerMapping(list<VCPL_Account_Stagging__c> triggerNew)
    {
        set<string> setCityState = new set<string>();
        for (VCPL_Account_Stagging__c objVCPLAccountStagging : triggerNew)
        {
            if (!string.isblank(objVCPLAccountStagging.City__c) && !string.isblank(objVCPLAccountStagging.State__c)){
                setCityState.add(objVCPLAccountStagging.City__c + objVCPLAccountStagging.State__c );
            }      
        }
        
    }
*/
    
}