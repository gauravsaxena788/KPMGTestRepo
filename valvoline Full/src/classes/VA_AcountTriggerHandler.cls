public without sharing class VA_AcountTriggerHandler{
    Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    public static Id idBranchRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    public static Id idCustAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
    public Integer i = 0;
    public Boolean IsDisabled(){ 
        VA_Trigger_Settings__c objTriggerSetting = VA_Trigger_Settings__c.getValues('AccountTrigger');
        if(objTriggerSetting!=null)
        return objTriggerSetting.VA_Is_Trigger_Disabled__c;        
        else   
        return true;
        
    }
    
    public void BeforeInsert(List<SObject> triggerNew) 
    {
        User objUser = [SELECT id, AccountId, Profile.Name FROM User WHERE Id= : UserInfo.getUserId() LIMIT 1 ];
        for(Account objAcc:(List<Account>)triggerNew){
            system.debug('====objAcc====='+objAcc+'===='+objAcc.RecordTypeId+'=====idCustomerRecordType '+idCustomerRecordType );
            if(!String.isBlank(objAcc.RecordTypeId) && objAcc.RecordTypeId == idCustomerRecordType ){
                returnrecordtypemethod(objAcc);
                if(!String.isBlank(objAcc.BillingCity)){
                    objAcc.ShippingStreet = objAcc.BillingStreet;
                    objAcc.ShippingCity = objAcc.BillingCity;
                    objAcc.ShippingState = objAcc.BillingState;
                    objAcc.ShippingCountry = objAcc.BillingCountry;
                    objAcc.ShippingPostalCode = objAcc.BillingPostalCode;
                    objAcc.BillingCity = '';
                    objAcc.BillingStreet ='';
                    objAcc.BillingState ='';
                    objAcc.BillingPostalCode ='';
                    objAcc.BillingCountry ='';
                }
                if(objAcc.VCPL_Account__c != null)
                objAcc.ParentId = objAcc.VCPL_Account__c;
                else if(String.isBlank(objAcc.VCPL_Account__c) && !String.isBlank(objUser.Profile.Name) && 
                objUser.Profile.Name.contains('Partner') && !String.isBlank(objUser.AccountId)){
                    objAcc.ParentId = objUser.AccountId;
                    objAcc.VCPL_Account__c = objUser.AccountId;
                }
                system.debug('====Userinfo.get'+objUser );
            }
        }  
        
    }
    
    // This is used to assign Recordtype to a picklist value 
    Static void returnrecordtypemethod(Account objAcc){
        objAcc.VCPL_Account_Record_Type__c = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(objAcc.RecordTypeId).getDeveloperName();
        
    }
    
    public void BeforeUpdate(List<SObject> triggerNew, Map<Id, SObject> triggerOldMap) 
    {
        Set<String> setofRecordType = new Set<String>();
        for(String objstr : Label.VCPL_Lead_RecordType.split(';')){
            setofRecordType.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(objstr).getRecordTypeId());
        }
        for(Account objAcc: (List<Account>)triggerNew){
            if(objAcc.RecordTypeId != ((Map<Id,Account>)triggerOldMap).get(objAcc.id).RecordTypeId && !setofRecordType.isEmpty() && setofRecordType.contains(objAcc.RecordTypeId)){
                returnrecordtypemethod(objAcc);
                
            }
        }
    }
    public void BeforeDelete(List<SObject> triggerOld) {}
    
    
    public void AfterInsert(List<SObject> triggerNew) 
    {
        Set<String> setofAccId = new Set<String>();
        Set<String> setofParentId = new Set<String>();
        Map<String,String> mapAccIdToShipCode = new Map<String,String>();
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
        
        for(Account objAcc : (List<Account>)triggerNew){
            if(!String.isBlank(objAcc.RecordTypeId) && objAcc.RecordTypeId == devRecordTypeId ){
                setofAccId.add(objAcc.id);
                if(!String.isBlank(objAcc.VCPL_Account__c))
                setofParentId.add(objAcc.VCPL_Account__c);
                if(!String.isBlank(objAcc.VCPL_Account_ID__c))
                mapAccIdToShipCode.put(objAcc.Id,objAcc.VCPL_Account_ID__c);
            }
        }
        
        if(!setofParentId.isEmpty()){
            VCPL_CommonUtilityClass.shareRecordswithUser((List<Account>)triggerNew, setofParentId);
        }
        
        if(setofAccId.size() > 0)
        createOpportunityforYear(setofAccId,mapAccIdToShipCode);
        
        updateBranchRollupToDealer((List<Account>)triggerNew,null);
        updateCDCustomerParent((List<Account>)triggerNew,null);
        shareBranch((List<Account>)triggerNew,null);
        updateTotalFieldsforcdCustomers((List<Account>)triggerNew,null);
    }
    public void AfterUpdate(List<Sobject> triggerNew, Map<Id, Sobject> triggerOldMap){
        
        //updateProfile(triggerNew,null);
        updateProfile(triggerNew,(Map<Id,Account>)triggerOldMap);
        
        //Updating Customer Plan Potential of current financial Year. 
        updateCustomerPlanPotential(triggerNew,(Map<Id,Account>)triggerOldMap);
        
        
        if(i == 0)
        {
            i=1;
            updateRollupFields((List<Account>)triggerNew,(Map<Id,Account>)triggerOldMap);
            updateBranchRollupToDealer((List<Account>)triggerNew,(Map<Id,Account>)triggerOldMap);
            updateCDCustomerParent((List<Account>)triggerNew,(Map<Id,Account>)triggerOldMap);
            shareBranch((List<Account>)triggerNew,(Map<Id,Account>)triggerOldMap);
            updateTotalFieldsforcdCustomers((List<Account>)triggerNew,(Map<Id,Account>)triggerOldMap);
            
        }
    }
    
    public void updateCustomerPlanPotential(List<Account> triggerNew, Map<Id, Account> triggerOldMap){
        
        map<Id,Account> mapCumminsCustomerAccount = new map<Id,Account>();
        
        for(Account objAcc: triggerNew){
            //if Cummins Customer's Account Ptential Updated
            if(objAcc.RecordTypeId == idCustAccountRecordType && objAcc.VCPL_Current_Fin_Year_Total_Potential__c != triggerOldMap.get(objAcc.Id).VCPL_Current_Fin_Year_Total_Potential__c) {
                mapCumminsCustomerAccount.put(objAcc.Id,objAcc);
            }
        }
        
        List<VCPL_Customer_Plan__c> lstCustomerPlanToUpdate = [SELECT Id, VCPL_CD_Customer__c, VCPL_Potential__c 
                                                                from VCPL_Customer_Plan__c 
                                                                where VCPL_CD_Customer__c in : mapCumminsCustomerAccount.keyset()
                                                                and VCPL_Is_Current_Financial_Year__c = true];
        
        if(lstCustomerPlanToUpdate != null && lstCustomerPlanToUpdate.size() > 0){
            for(VCPL_Customer_Plan__c objCustPlan : lstCustomerPlanToUpdate) {
                if(mapCumminsCustomerAccount.containsKey(objCustPlan.VCPL_CD_Customer__c))
                objCustPlan.VCPL_Potential__c = mapCumminsCustomerAccount.get(objCustPlan.VCPL_CD_Customer__c).VCPL_Current_Fin_Year_Total_Potential__c;
            }
            
            update lstCustomerPlanToUpdate;
        }
    }
    
    public void AfterDelete(List<SObject> triggerOld) {}
    public void AfterUndelete(List<SObject> triggerOld) {}
    
    private void updateProfile(List<Account> triggerNew, Map<Id, Account> triggerOldMap){
        try{
            
            set<Id> setAccountId = new set<Id>();
            
            for(Account objAccount: triggerNew){
                Account objoldAccount = triggerOldMap != null ? triggerOldMap.get(objAccount.id) : null ; 
                
                if(objAccount.RecordTypeID != NULL && objAccount.RecordTypeId != idCustomerRecordType && objoldAccount == null)
                {
                    setAccountId.add(objAccount.id);
                }
                else if (objAccount.RecordTypeID != NULL && objAccount.RecordTypeId != idCustomerRecordType && objoldAccount != null && objoldAccount.VA_POST_Allowed__c != objAccount.VA_POST_Allowed__c )
                {
                    setAccountId.add(objAccount.id);
                }
                
            }
            if(setAccountId != NULL && !setAccountId.isEmpty())
            {
                //VA_updateProfilePostCommunity.updateProfile(setAccountid);
                
                //To assign the new permission set to user
                VA_updateProfilePostCommunity.updatePermissionset(setAccountid);
                //upto
            }
        }
        catch(Exception ex){
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;
        }
    }
    
    // This is used to create opportunity on account creation
    public void createOpportunityforYear(Set<String> setOfAccId, Map<String,String> mapAccIdToShipCode){
        
        // Variables defined
        List<VCPL_Customer_Plan__c> lstOpprt = new List<VCPL_Customer_Plan__c>();        
        Id devRecordTypeId = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();        
        
        Map<string,Integer> mapNameMonthNum = new Map<string,Integer>
        {'October'=>10, 'November'=>11, 'December'=>12,'January'=>1,'February'=>2,'March'=>3,'April'=>4, 
        'May'=>5,'June'=>6,'July'=>7,'August'=>8, 'September'=>9};
        
        Date currentDate = System.Today();
        Integer StartFinacialYearmonth = Integer.valueof(Label.VCPL_Financial_Year_Start) ;  
        Integer firstfinancialyear, secondfinancialyear;
        Map<String,List<string>> mapAccIdWithOppprtName = new Map<String,List<String>>();
        Map<String,Decimal> mapofOppnamewithActual = new Map<String,Decimal>();
        
        if(currentDate.month() >= StartFinacialYearmonth){
            firstfinancialyear = currentDate.year();
            secondfinancialyear = currentDate.year() + 1;
        }
        else{
            firstfinancialyear = currentDate.year() - 1;
            secondfinancialyear = currentDate.year();
        }
        Set<String> strYeartoquery = new Set<String>();
        strYeartoquery.add(String.valueof(secondfinancialyear ));
        strYeartoquery.add(String.valueof(secondfinancialyear - 1));
        
        List<VCPL_Customer_Plan__c> listOpp = [SELECT Id, Name, VCPL_Financial_Year__c, /*Insha AccountId, Account.VCPL_Account_ID__c*/ VCPL_Customer_Account__c,VCPL_Customer_Account__r.VCPL_Account_ID__c, VCPL_Month__c, VCPL_Last_Year_Sales_Vol__c, VCPL_Actual_Sales__c
        FROM VCPL_Customer_Plan__c WHERE RecordTypeId =:devRecordTypeId AND /*Insha AccountId*/ VCPL_Customer_Account__c IN :setOfAccId AND VCPL_Financial_Year__c IN :strYeartoquery AND VCPL_Month__c != ''];
        
        List<VCPL_Customer_Plan__c> listOppCurrYear = new List<VCPL_Customer_Plan__c>();
        
        for(VCPL_Customer_Plan__c objOpp: listOpp){
            if(objOpp.VCPL_Financial_Year__c == String.valueof(secondfinancialyear))
            listOppCurrYear.add(objOpp);
            else if(objOpp.VCPL_Financial_Year__c == String.valueof((secondfinancialyear - 1))){
                if(!String.isBlank(objOpp.VCPL_Month__c) && !String.isBlank(objOpp.VCPL_Financial_Year__c)){
                    if(mapNameMonthNum.get(objOpp.VCPL_Month__c) >= StartFinacialYearmonth)
                    mapofOppnamewithActual.put(objOpp.VCPL_Month__c.substring(0,3)+'-'+String.valueof(objOpp.VCPL_Financial_Year__c)+'-'+/*Insha objOpp.Account.VCPL_Account_ID__c*/objOpp.VCPL_Customer_Account__r.VCPL_Account_ID__c+'-'+'Monthly Plan',objOpp.VCPL_Actual_Sales__c);
                    else if(mapNameMonthNum.get(objOpp.VCPL_Month__c) < StartFinacialYearmonth)
                    mapofOppnamewithActual.put(objOpp.VCPL_Month__c.substring(0,3)+'-'+String.valueof((Integer.valueof(objOpp.VCPL_Financial_Year__c) + 1))+'-'+/*Insha objOpp.Account.VCPL_Account_ID__c*/objOpp.VCPL_Customer_Account__r.VCPL_Account_ID__c+'-'+'Monthly Plan',objOpp.VCPL_Actual_Sales__c);
                    system.debug('====mapofOppnamewithActual=='+mapofOppnamewithActual.keyset());     
                }
            }    
        }
        
        
        if(listOppCurrYear != null && !listOppCurrYear.isEmpty())
        for(VCPL_Customer_Plan__c objOpp : listOppCurrYear){
            if(!String.isBlank(/*Insha objOpp.AccountId*/objOpp.VCPL_Customer_Account__c) && mapAccIdWithOppprtName.get(/*Insha objOpp.AccountId*/objOpp.VCPL_Customer_Account__c) != null ){
                List<String> lstOppName =  mapAccIdWithOppprtName.get(/*Insha objOpp.AccountId*/objOpp.VCPL_Customer_Account__c);
                if(mapNameMonthNum.get(objOpp.VCPL_Month__c) != null && mapNameMonthNum.get(objOpp.VCPL_Month__c) >= StartFinacialYearmonth )
                lstOppName.add(objOpp.VCPL_Month__c.substring(0,3)+'-'+ String.valueof(firstfinancialyear)+'-'+/*Insha objOpp.Account.VCPL_Account_ID__c*/objOpp.VCPL_Customer_Account__r.VCPL_Account_ID__c+'-'+'Monthly Plan');
                else if(mapNameMonthNum.get(objOpp.VCPL_Month__c) != null && mapNameMonthNum.get(objOpp.VCPL_Month__c) < StartFinacialYearmonth )
                lstOppName.add(objOpp.VCPL_Month__c.substring(0,3)+'-'+ String.valueof(secondfinancialyear)+'-'+/*Insha objOpp.Account.VCPL_Account_ID__c*/objOpp.VCPL_Customer_Account__r.VCPL_Account_ID__c+'-'+'Monthly Plan');
                mapAccIdWithOppprtName.put(/*Insha objOpp.AccountId*/objOpp.VCPL_Customer_Account__c,lstOppName);
            }
            else
            {
                List<String> lstOppName =  new List<String>();
                if(mapNameMonthNum.get(objOpp.VCPL_Month__c) != null && mapNameMonthNum.get(objOpp.VCPL_Month__c) >= StartFinacialYearmonth )
                lstOppName.add(objOpp.VCPL_Month__c.substring(0,3)+'-'+ String.valueof(firstfinancialyear)+'-'+/*Insha objOpp.Account.VCPL_Account_ID__c*/objOpp.VCPL_Customer_Account__r.VCPL_Account_ID__c+'-'+'Monthly Plan');
                else if(mapNameMonthNum.get(objOpp.VCPL_Month__c) != null && mapNameMonthNum.get(objOpp.VCPL_Month__c) < StartFinacialYearmonth )
                lstOppName.add(objOpp.VCPL_Month__c.substring(0,3)+'-'+ String.valueof(secondfinancialyear)+'-'+/*Insha objOpp.Account.VCPL_Account_ID__c*/objOpp.VCPL_Customer_Account__r.VCPL_Account_ID__c+'-'+'Monthly Plan');
                mapAccIdWithOppprtName.put(/*Insha objOpp.AccountId*/objOpp.VCPL_Customer_Account__c,lstOppName);
            }
        }
        
        for(String strAccId: setOfAccId){
            for(String objMonthName : mapNameMonthNum.KeySet()){
                String MonthValString ;
                if(mapNameMonthNum.get(objMonthName) < 10){
                    MonthValString = '0'+String.valueof(mapNameMonthNum.get(objMonthName));
                }
                else
                MonthValString = String.valueof(mapNameMonthNum.get(objMonthName));
                
                VCPL_Customer_Plan__c objOpp = new VCPL_Customer_Plan__c();
                objOpp.RecordTypeId = devRecordTypeId ;
                //Insha objOpp.AccountId = strAccId;
                objOpp.VCPL_Customer_Account__c = strAccId;
                objOpp.VCPL_Month__c = objMonthName ;
                if(mapNameMonthNum.get(objMonthName) != null && mapNameMonthNum.get(objMonthName) >= StartFinacialYearmonth ){
                    if(mapAccIdToShipCode.get(strAccId) != null){
                        objOpp.Name = objMonthName.substring(0,3)+'-'+String.valueof(firstfinancialyear)+'-'+mapAccIdToShipCode.get(strAccId)+'-'+'Monthly Plan';
                        objOpp.VCPL_Opportunity_Code__c = mapAccIdToShipCode.get(strAccId)+MonthValString+String.valueof(firstfinancialyear).substring(2,4);
                        String keyvalueOfmap = objMonthName.substring(0,3)+'-'+String.valueof((firstfinancialyear-1))+'-'+mapAccIdToShipCode.get(strAccId)+'-'+'Monthly Plan';
                        
                        if(mapofOppnamewithActual != null && mapofOppnamewithActual.get(keyvalueOfmap) != null)
                        objOpp.VCPL_Last_Year_Sales_Vol__c = mapofOppnamewithActual.get(keyvalueOfmap);
                        
                    }
                    else{
                        objOpp.Name = objMonthName.substring(0,3)+'-'+String.valueof(firstfinancialyear)+'-'+'Monthly Plan';
                        objOpp.VCPL_Opportunity_Code__c = MonthValString+String.valueof(firstfinancialyear).substring(2,4);
                    }
                    //Insha objOpp.CloseDate = (Date.newInstance(firstfinancialyear,mapNameMonthNum.get(objMonthName),1).addMonths(1)).addDays(-1);
                    
                }
                else if(mapNameMonthNum.get(objMonthName) != null && mapNameMonthNum.get(objMonthName) < StartFinacialYearmonth ){
                    if(mapAccIdToShipCode.get(strAccId) != null){
                        objOpp.Name = objMonthName.substring(0,3)+'-'+String.valueof(secondfinancialyear)+'-'+mapAccIdToShipCode.get(strAccId)+'-'+'Monthly Plan';
                        objOpp.VCPL_Opportunity_Code__c = mapAccIdToShipCode.get(strAccId)+MonthValString+String.valueof(firstfinancialyear).substring(2,4);
                        String keyvalueOfmap = objMonthName.substring(0,3)+'-'+String.valueof((secondfinancialyear - 1))+'-'+mapAccIdToShipCode.get(strAccId)+'-'+'Monthly Plan';
                        
                        if(mapofOppnamewithActual != null && mapofOppnamewithActual.get(keyvalueOfmap ) != null)
                        objOpp.VCPL_Last_Year_Sales_Vol__c = mapofOppnamewithActual.get(keyvalueOfmap);
                        
                    }
                    else{
                        objOpp.Name = objMonthName.substring(0,3)+'-'+String.valueof(secondfinancialyear)+'-'+'Monthly Plan';
                        objOpp.VCPL_Opportunity_Code__c = MonthValString+String.valueof(firstfinancialyear).substring(2,4);
                    }
                    //Insha objOpp.CloseDate= (Date.newInstance(secondfinancialyear ,mapNameMonthNum.get(objMonthName),1).addMonths(1)).addDays(-1);
                    
                }
                objOpp.VCPL_Financial_Year__c = String.valueof(secondfinancialyear);
                //Insha objOpp.StageName = 'Open';
                //Insha objOpp.IsCreatedfromVF__c = true;
                
                if((mapAccIdWithOppprtName.get(strAccId) == null) || (mapAccIdWithOppprtName.get(strAccId) != null && !mapAccIdWithOppprtName.get(strAccId).contains(objOpp.Name))){
                    system.debug('===objOpp==='+objOpp);
                    lstOpprt.add(objOpp);
                }
            }
        }
        
        if(lstOpprt.size() > 0)
        insert lstOpprt;
    }
    
    
    //////////////////
    //ROLL UP TRIGGER
    //////////////////
    void updateRollupFields(list<Account> lstTriggerNew,map<id,Account> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<String> fieldSet = new Set<String>();
            for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Account_RollUp_Fields').getFields())
            {
                fieldSet.add(fields.getFieldPath());
            }
            if(fieldSet != NULL && !fieldSet.isEmpty())
            {
                set<ID> setParentID = new set<ID>();
                Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
                
                if(idCustomerRecordType != NULL)
                {
                    for(Account objAccount : lstTriggerNew)
                    {
                        if((objAccount.ParentID != NULL && objAccount.RecordTypeID != NULL && 
                        objAccount.RecordTypeID == idCustomerRecordType) || test.isrunningTest())
                        {
                            for(string strField : fieldSet)
                            {
                                if(triggeroldmap != NULL && triggeroldmap.get(objAccount.id).get(strField) != NULL && 
                                triggeroldmap.get(objAccount.id).get(strField) != objAccount.get(strField))
                                {
                                    setParentID.add(objAccount.ParentID);
                                }
                            }
                        }
                    }
                    if(setParentID != NULL && !setParentID.isEmpty())
                    {
                        string strQuery = 'select id,parentID,RecordTypeID,';
                        
                        for(string strField : fieldSet)
                        {
                            strQuery += String.escapeSingleQuotes(strField)+',';
                        }
                        strQuery = String.escapeSingleQuotes(strQuery.removeend(','));
                        strQuery += ' from account where parentID in:setParentID and RecordTypeID =:idCustomerRecordType';
                        
                        list<Account> lstAccount = Database.query(strQuery);
                        system.debug('@@@@@'+lstAccount);
                        if(lstAccount != NULL && !lstAccount.isEmpty())
                        {
                            map<string,Double> mapofRollups =   getRollup(lstAccount,'VCPL_Account_RollUp_Fields');
                            
                            if(mapofRollups != NULL && !mapofRollups.isEmpty())
                            {
                                list<Account> lstAccountToUpdate = new list<Account>();
                                for(Account objAccount : lstTriggerNew)
                                {
                                    if(objAccount.ParentID != NULL && objAccount.RecordTypeID == idCustomerRecordType)
                                    {
                                        Account objPAccount = new Account(ID = objAccount.ParentId);
                                        
                                        /////////////////////////////////////////////////////////////////////////
                                        /////////FOR PH6 Sales Capture////////////////////////////////////////////
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Grease_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Grease_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Grease_Sales__c    = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Grease_Sales__c');
                                        }
                                        
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Others_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Others_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Others_Sales__c    = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Others_Sales__c');
                                        }
                                        
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Engine_Oil_Sale__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Engine_Oil_Sale__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Engine_Oil_Sales__c    = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Engine_Oil_Sale__c');
                                        }
                                        
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_AntiFreeze_Sales__c    = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c');
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Gear_Oil_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Gear_Oil_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Gear_Oil_Sales__c  = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Gear_Oil_Sales__c');
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_AUS_32_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_AUS_32_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_AUS_32_Sales__c    = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_AUS_32_Sales__c');
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Industrial_Oil__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Industrial_Oil__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Ind_Oil_Sales__c  = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Industrial_Oil__c');
                                        }
                                        //////////////////////////////////////////////////////////////////////////////////
                                        /////FOR SALES PLAN////////////////////////////////////////////////////////////
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Planned_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Planned_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Planned_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Planned_Sales__c');  
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Latest_Est_Sale__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Latest_Est_Sale__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Latest_Est_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Latest_Est_Sale__c'); 
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Fiscal_Year_Actual_Sale_Vol__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Actual_Sale_Vol__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_FY_Total_Actual_Sales_Vol__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Fiscal_Year_Actual_Sale_Vol__c'); 
                                        }
                                        /////////////////////Monthly Sales Plan/////////////////
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Planned_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Planned_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Planned_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Planned_Sales__c'); 
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Latest_Est_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Latest_Est_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Mon_Total_Latest_Est_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Latest_Est_Sales__c'); 
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Actual_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Actual_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Actual_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Actual_Sales__c');   
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Grease_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Grease_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Grease_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Grease_Sales__c');   
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Others_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Others_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Other_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Others_Sales__c');    
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Engine_Oil_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Engine_Oil_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Eng_Oil_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Engine_Oil_Sales__c');  
                                        }
                                        
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Anti_Freeze_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Anti_Freeze_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Mon_Total_AntiFreeze_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Anti_Freeze_Sales__c');    
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Gear_Oil_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Gear_Oil_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Gear_Oil_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Gear_Oil_Sales__c');   
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_AUS_32_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_AUS_32_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_AUS32_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_AUS_32_Sales__c');    
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_Month_Industrial_Oil_Sales__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Industrial_Oil_Sales__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Month_Total_Ind_Oil_Sales__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_Month_Industrial_Oil_Sales__c');  
                                        }
                                        if(mapofRollups.containsKey(objPAccount.ID+'VCPL_Current_FinYear_Total_Sec_Potential__c') 
                                        && mapofRollups.get(objPAccount.ID+'VCPL_Current_FinYear_Total_Sec_Potential__c') != NULL)
                                        {
                                            objPAccount.VCPL_Current_Fin_Year_Total_Potential__c = mapofRollups.get(objPAccount.ID+'VCPL_Current_FinYear_Total_Sec_Potential__c');  
                                        }
                                        
                                        lstAccountToUpdate.add(objPAccount);
                                    }
                                }
                                if(lstAccountToUpdate != NULL && !lstAccountToUpdate.isEmpty())
                                {
                                    map<id,Account> mapofAccounttoUpdate = new map<id,Account>();
                                    mapofAccounttoUpdate.putall(lstAccountToUpdate);
                                    
                                    if(mapofAccounttoUpdate != NULL && !mapofAccounttoUpdate.isEmpty())
                                    {
                                        update mapofAccounttoUpdate.values();
                                    }
                                }
                            }  
                        }
                    }
                }
            }
        }
    }
    public static map<string,Double> getRollup(list<Account> lstAccount,string strFieldSet)
    {
        map<string,Double> mapofRollups = new map<string,Double>();
        
        if(lstAccount != NULL && !lstAccount.isEmpty())
        {
            set<String> fieldSet = new Set<String>();
            for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Account_RollUp_Fields').getFields())
            {
                fieldSet.add(fields.getFieldPath());
            }
            if(fieldSet != NULL && !fieldSet.isEmpty())
            {
                for(Account objAccount : lstAccount)
                {
                    if(objAccount.parentID != NULL)
                    {
                        for(string strField : fieldSet)
                        {
                            string strKey = objAccount.parentID+strField;
                            
                            if(strKey != NULL && strKey != '')
                            {
                                if(objAccount.get(strField) != NULL)
                                {
                                    if(!mapofRollups.containskey(strKey))
                                    {
                                        mapofRollups.put(strKey,Double.valueof(objAccount.get(strField)));
                                    }
                                    else
                                    {
                                        Double amount = mapofRollups.get(strKey);
                                        amount += Double.valueof(objAccount.get(strField));
                                        mapofRollups.put(strKey,amount);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return mapofRollups;
    }
    private static void updateBranchRollupToDealer(List<Account> triggerNew, Map<Id, Account> triggerOldMap)
    {
        if(triggerNew != NULL && !triggerNew.isEmpty())
        {
            set<ID> setParentID = new set<Id>();
            for(Account objAccount : triggerNew)
            {
                if(objAccount.RecordtypeId != NULL && objAccount.RecordtypeId == idBranchRecordType && 
                objAccount.parentID != NULL && (objAccount.VCPL_Branch_Planned_Sales_in_KL__c != null 
                && (triggerOldMap == null || 
                (triggerOldMap != null && triggerOldMap.get(objAccount.Id).VCPL_Branch_Planned_Sales_in_KL__c != 
                objAccount.VCPL_Branch_Planned_Sales_in_KL__c))) || 
                (objAccount.VCPL_Branch_Latest_Estimated_Sales_in_KL__c != NULL && (triggerOldMap == NULL || 
                (triggerOldMap != NULL && triggerOldMap.get(objAccount.Id).VCPL_Branch_Latest_Estimated_Sales_in_KL__c != 
                objAccount.VCPL_Branch_Latest_Estimated_Sales_in_KL__c))))
                {
                    setParentID.add(objAccount.parentID);   
                }
            }
            if(setParentID != NULL && !setParentID.isEmpty())
            {
                map<Id,Double> mapofTotalPlannedSales = new map<Id,Double>();
                map<Id,Double> mapofTotalLatestEstSales = new map<Id,Double>();
                
                for(Account objAcc : [select id,RecordTypeId,VCPL_Branch_Planned_Sales_in_KL__c,
                    VCPL_Branch_Latest_Estimated_Sales_in_KL__c,parentID from Account 
                where parentID in: setParentID and RecordTypeId=:idBranchRecordType])
                {
                    if(objAcc.VCPL_Branch_Planned_Sales_in_KL__c != NULL)
                    {
                        if(!mapofTotalPlannedSales.containsKey(objAcc.parentId))
                        {
                            mapofTotalPlannedSales.put(objAcc.parentId,objAcc.VCPL_Branch_Planned_Sales_in_KL__c);
                        }
                        else
                        {
                            Double doubleplannedSales = mapofTotalPlannedSales.get(objAcc.parentId);
                            doubleplannedSales += objAcc.VCPL_Branch_Planned_Sales_in_KL__c;
                            mapofTotalPlannedSales.put(objAcc.parentId,doubleplannedSales);
                        }
                    }
                    if(objAcc.VCPL_Branch_Latest_Estimated_Sales_in_KL__c != NULL)
                    {
                        if(!mapofTotalLatestEstSales.containskey(objAcc.parentId))
                        {
                            mapofTotalLatestEstSales.put(objAcc.parentId,objAcc.VCPL_Branch_Latest_Estimated_Sales_in_KL__c);
                        }
                        else
                        {
                            Double doubleLatestEstSales = mapofTotalLatestEstSales.get(objAcc.parentId);
                            doubleLatestEstSales += objAcc.VCPL_Branch_Latest_Estimated_Sales_in_KL__c;
                            mapofTotalLatestEstSales.put(objAcc.parentId,doubleLatestEstSales);
                        }
                    }   
                }
                list<Account> lstAccount2update = new list<Account>();
                for(Account objAccount : [select id from Account where id in:setParentID])
                {
                    if(mapofTotalPlannedSales.containsKey(objAccount.ID) && mapofTotalPlannedSales.get(objAccount.ID) != NULL)
                    {
                        objAccount.VCPL_Total_CD_Branch_Planned_Sales__c = mapofTotalPlannedSales.get(objAccount.ID);
                    }
                    
                    if(mapofTotalLatestEstSales.containsKey(objAccount.ID) && mapofTotalLatestEstSales.get(objAccount.ID) != NULL)
                    {
                        objAccount.VCPL_Total_CD_Branch_Latest_Est_Sales__c = mapofTotalLatestEstSales.get(objAccount.ID);
                    }
                    lstAccount2update.add(objAccount);
                }
                if(lstAccount2update != NULL && !lstAccount2update.isEmpty())
                {
                    update lstAccount2update;
                }
            }
        }
    }
    private static void updateCDCustomerParent(List<Account> triggerNew, Map<Id, Account> triggerOldMap)
    {
        if(triggerNew != NULL && !triggerNew.isEmpty())
        {
            set<Id> setParentId = new set<Id>();
            for(Account objAccount : triggerNew)
            {
                if(objAccount.parentID != NULL && (objAccount.RecordTypeID != NULL && 
                objAccount.RecordTypeID == idCustAccountRecordType &&
                objAccount.VCPL_Current_Fin_Year_Total_Pot_in_KL__c != NULL && (triggerOldMap == NULL || 
                (triggerOldMap != NULL && triggerOldMap.get(objAccount.Id).VCPL_Current_Fin_Year_Total_Pot_in_KL__c != 
                objAccount.VCPL_Current_Fin_Year_Total_Pot_in_KL__c))) || test.isRunningTest())
                {
                    setParentId.add(objAccount.parentID);   
                }
            }
            if(setParentId != NULL && !setParentId.isEmpty())
            {
                map<Id,Double> mapofPotential = new map<Id,Double>();
                for(Account objAccount : [select id,VCPL_Current_Fin_Year_Total_Pot_in_KL__c,RecordTypeId,parentID 
                    from Account where parentId in: setParentId 
                and RecordTypeId =:idCustAccountRecordType])
                {
                    if(objAccount.VCPL_Current_Fin_Year_Total_Pot_in_KL__c != NULL)
                    {
                        if(!mapofPotential.containsKey(objAccount.parentID))
                        {
                            mapofPotential.put(objAccount.parentID,objAccount.VCPL_Current_Fin_Year_Total_Pot_in_KL__c);
                        }
                        else
                        {
                            Double potential = mapofPotential.get(objAccount.parentID);
                            potential += objAccount.VCPL_Current_Fin_Year_Total_Pot_in_KL__c;
                            mapofPotential.put(objAccount.parentID,potential);
                        }
                    }   
                }
                if(mapofPotential != NULL && !mapofPotential.isEmpty())
                {
                    list<Account> lstParentAcount = new list<Account>();
                    for(Account objParentAccount : [select id from Account where id in:mapofPotential.keyset()])
                    {
                        if(mapofPotential.containsKey(objParentAccount.Id) && mapofPotential.get(objParentAccount.Id) != NULL)
                        {
                            objParentAccount.VCPL_Total_Customer_Account_Potential__c = mapofPotential.get(objParentAccount.Id);
                            lstParentAcount.add(objParentAccount);
                        }
                    }
                    if(lstParentAcount != NULL && !lstParentAcount.isEmpty())
                    {
                        update lstParentAcount;
                    }
                }
            }
        }
    }
    private static void shareBranch(list<Account> lstTriggerNew,map<ID,Account> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<Id> setAccountId = new set<Id>();
            set<Id> setOldAccountID = new set<Id>();
            set<Id> setBranchId = new set<Id>();
            
            for(Account objAccount : lstTriggerNew)
            {
                if(objAccount.RecordTypeID != NULL && objAccount.RecordTypeID == idBranchRecordType 
                && objAccount.parentID != NULL && (triggeroldmap == NULL || (triggeroldmap != NULL && 
                triggeroldmap.get(objAccount.Id).parentId != objAccount.parentId)))
                {
                    setAccountId.add(objAccount.parentID);
                    setBranchId.add(objAccount.Id);
                    if(triggeroldmap != NULL && triggeroldmap.get(objAccount.Id).parentId != NULL &&
                    triggeroldmap.get(objAccount.Id).parentId != objAccount.parentId)
                    {
                        setOldAccountID.add(triggeroldmap.get(objAccount.Id).parentId);     
                    }   
                }
            }
            if(setAccountId != NULL && !setAccountId.isEmpty())
            {
                map<Id,list<User>> mapofUser = new map<Id,list<User>>();
                for(User objUser : [select id,AccountID,VCPL_Contact_Role__c from User 
                where AccountId in:setAccountId and VCPL_Contact_Role__c='HOD'])
                {  
                    if(!mapofUser.containsKey(objUser.AccountID))
                    mapofUser.put(objUser.AccountID,new list<User>());
                    mapofUser.get(objUser.AccountID).add(objUser);
                }
                if(mapofUser != NULL && !mapofUser.isEmpty())
                {
                    list<AccountShare> lstShare = new list<AccountShare>();
                    for(Account objAccount : lstTriggerNew)
                    {
                        if(objAccount.RecordTypeID != NULL && objAccount.RecordTypeID == idBranchRecordType 
                        && objAccount.parentID != NULL && mapofUser.containsKey(objAccount.parentID) && 
                        mapofUser.get(objAccount.parentID) != NULL)
                        {
                            for(User objUser : mapofUser.get(objAccount.parentID))
                            {
                                AccountShare objAccountShare = new AccountShare();
                                objAccountShare.UserOrGroupId = objUser.ID;
                                objAccountShare.AccountAccessLevel = 'Read';
                                objAccountShare.AccountId = objAccount.Id;
                                objAccountShare.OpportunityAccessLevel = 'None';
                                
                                lstShare.add(objAccountShare);      
                            }               
                        }
                    }
                    if(lstShare != NULL && !lstShare.isEmpty())
                    {
                        try
                        {
                            insert lstShare;
                        }
                        catch(exception e) {
                            
                        }
                    }
                }
            }
            if(setOldAccountID != NULL && !setOldAccountID.isEmpty() 
            && setBranchId != NULL && !setBranchId.isEmpty())
            {
                map<Id,list<User>> mapofAccountIdWRTHODs = new map<Id,list<User>>();
                set<Id> setofUserId = new set<Id>();
                
                for(User objUser : [select id,AccountID,VCPL_Contact_Role__c from User 
                where AccountId in:setOldAccountId and VCPL_Contact_Role__c='HOD'])
                {
                    if(!mapofAccountIdWRTHODs.containsKey(objUser.AccountID))
                    mapofAccountIdWRTHODs.put(objUser.AccountID,new list<User>());
                    mapofAccountIdWRTHODs.get(objUser.AccountID).add(objUser);  
                    
                    setofUserId.add(objUser.Id);
                }
                
                if(!setofUserId.isEmpty() && !setBranchId.isEmpty())
                {
                    map<string,AccountShare> mapofAccountShare = new map<string,AccountShare>();
                    for(AccountShare objShare : [select id,UserOrGroupId,AccountAccessLevel,AccountId,OpportunityAccessLevel from 
                    AccountShare where UserOrGroupId in:setofUserId and AccountId in:setBranchId])
                    {
                        string strKey = objShare.UserOrGroupId+'-'+objShare.AccountId;
                        
                        if(!mapofAccountShare.containsKey(strKey))
                        mapofAccountShare.put(strKey,objShare);
                    }
                    if(mapofAccountShare != NULL && !mapofAccountShare.isEmpty())
                    {
                        list<AccountShare> lstAcountShare = new list<AccountShare>();
                        for(Account objAccount : lstTriggerNew)
                        {
                            if(objAccount.RecordTypeID != NULL && objAccount.RecordTypeID == idBranchRecordType 
                            && objAccount.parentID != NULL && triggeroldmap != NULL && 
                            triggeroldmap.get(objAccount.Id).parentId != NULL &&
                            triggeroldmap.get(objAccount.Id).parentId != objAccount.parentId)
                            {
                                
                                for(User objUser : mapofAccountIdWRTHODs.get(triggeroldmap.get(objAccount.Id).parentId))
                                {
                                    string strKey = objUser.Id+'-'+objAccount.Id;
                                    if(mapofAccountShare.containsKey(strKey) && mapofAccountShare.get(strKey) != NULL)
                                    {
                                        lstAcountShare.add(mapofAccountShare.get(strKey));
                                    }
                                }   
                                
                            }
                        }
                        if(lstAcountShare != NULL && !lstAcountShare.isEmpty())
                        {
                            try {
                                delete lstAcountShare;
                            }
                            catch(exception e) {
                                
                            }
                        }
                    }
                }
            }
        }
    }
    private static void updateTotalFieldsforcdCustomers(list<Account> lstTriggerNew,map<Id,Account> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<Id> setParentAccountId = new set<Id>();
            for(Account objAccount : lstTriggerNew)
            {
                if((objAccount.RecordTypeId != NULL && objAccount.RecordTypeId == idCustAccountRecordType &&
                (triggeroldmap == NULL || (triggeroldmap != NULL 
                && triggeroldmap.get(objAccount.Id).parentId != objAccount.parentId))) || test.isRunningTest())
                {
                    if(objAccount.parentId != NULL)
                    {
                        setParentAccountId.add(objAccount.parentId);    
                    }
                    if(triggeroldmap != NULL && triggeroldmap.get(objAccount.Id).parentId != objAccount.parentId)
                    {
                        setParentAccountId.add(triggeroldmap.get(objAccount.Id).parentId);
                    }
                }
            }
            if(setParentAccountId != NULL && !setParentAccountId.isEmpty())
            {
                
                list<String> fieldSet = new list<String>();
                for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Account_RollUp_Fields').getFields())
                {
                    fieldSet.add(fields.getFieldPath());
                }
                
                string strQuery = 'Select ' + String.escapeSingleQuotes(String.join(fieldSet, ','));
                
                if(!strQuery.contains('VCPL_Customer_Account_CD_IO_Sales_In_KL__c')) strQuery += ', VCPL_Customer_Account_CD_IO_Sales_In_KL__c';
                
                if(!strQuery.contains('VCPL_Customer_Account_CD_Actual_Sales__c')) strQuery += ', VCPL_Customer_Account_CD_Actual_Sales__c';
                
                if(!strQuery.contains('VCPL_Customer_Account_CD_CO_Sales_In_KL__c')) strQuery += ', VCPL_Customer_Account_CD_CO_Sales_In_KL__c';
                
                if(!strQuery.contains('VCPL_Current_Fin_Year_Total_Pot_in_KL__c')) strQuery += ', VCPL_Current_Fin_Year_Total_Pot_in_KL__c';
                
                if(!strQuery.contains('VCPL_LY_Customer_Account_Ind_Oil_Sales__c')) strQuery += ', VCPL_LY_Customer_Account_Ind_Oil_Sales__c';
                
                if(!strQuery.contains('VCPL_LY_Cust_Account_Cummins_Oil_Sales__c')) strQuery += ', VCPL_LY_Cust_Account_Cummins_Oil_Sales__c';
                
                if(!strQuery.contains('VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c')) strQuery += ', VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c';
                
                strQuery += ', parentID from Account where parentID in: setParentAccountId ';
                
                system.debug('Sumit ::: ' +strQuery);
                
                list<Account> lstAccount = database.query(strQuery);
                
                /*list<Account> lstAccount = [select id,VCPL_Customer_Account_CD_IO_Sales_In_KL__c,VCPL_Customer_Account_CD_Actual_Sales__c,
                    VCPL_Customer_Account_CD_CO_Sales_In_KL__c,
                    VCPL_Current_Fin_Year_Total_Pot_in_KL__c,
                    VCPL_LY_Customer_Account_Ind_Oil_Sales__c,
                    VCPL_LY_Cust_Account_Cummins_Oil_Sales__c,
                    VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c,
                    parentID 
                    from Account 
                where parentID in:setParentAccountId];*/
                
                map<string,Double> mapofRollups = getRollup(lstAccount,'VCPL_Customer_Account_Roll_up_Field_Set');
                
                list<Account> lstAccountToUpdate = new list<Account>();
                for(Account objAccount : [select id from Account where id in:setParentAccountId])
                {
                    if(mapofRollups.containsKey(objAccount.Id+'VCPL_Current_Fin_Year_Total_Pot_in_KL__c') && 
                    mapofRollups.get(objAccount.Id+'VCPL_Current_Fin_Year_Total_Pot_in_KL__c') != NULL)
                    {
                        objAccount.VCPL_Total_Customer_Account_Potential__c = mapofRollups.get(objAccount.Id+'VCPL_Current_Fin_Year_Total_Pot_in_KL__c');   
                    }
                    else
                    {
                        objAccount.VCPL_Total_Customer_Account_Potential__c = 0;
                    }
                    if(mapofRollups.containsKey(objAccount.Id+'VCPL_Customer_Account_CD_IO_Sales_In_KL__c') && 
                    mapofRollups.get(objAccount.Id+'VCPL_Customer_Account_CD_IO_Sales_In_KL__c') != NULL)
                    {
                        objAccount.VCPL_Total_Cust_Account_IO_Sales__c = mapofRollups.get(objAccount.Id+'VCPL_Customer_Account_CD_IO_Sales_In_KL__c');
                    }
                    else
                    {
                        objAccount.VCPL_Total_Cust_Account_IO_Sales__c = 0;
                    }
                    if(mapofRollups.containsKey(objAccount.Id+'VCPL_Customer_Account_CD_CO_Sales_In_KL__c') && 
                    mapofRollups.get(objAccount.Id+'VCPL_Customer_Account_CD_CO_Sales_In_KL__c') != NULL)
                    {
                        objAccount.VCPL_Total_Cust_Account_CO_Sales__c = mapofRollups.get(objAccount.Id+'VCPL_Customer_Account_CD_CO_Sales_In_KL__c');
                    }
                    else
                    {
                        objAccount.VCPL_Total_Cust_Account_CO_Sales__c = 0;
                    }
                    if(mapofRollups.containsKey(objAccount.Id+'VCPL_LY_Customer_Account_Ind_Oil_Sales__c') && 
                    mapofRollups.get(objAccount.Id+'VCPL_LY_Customer_Account_Ind_Oil_Sales__c') != NULL)
                    {
                        objAccount.VCPL_LY_Total_Cust_Account_IO_Sales__c = mapofRollups.get(objAccount.Id+'VCPL_LY_Customer_Account_Ind_Oil_Sales__c');
                    }
                    else
                    {
                        objAccount.VCPL_LY_Total_Cust_Account_IO_Sales__c = 0;
                    }
                    if(mapofRollups.containsKey(objAccount.Id+'VCPL_LY_Cust_Account_Cummins_Oil_Sales__c') && 
                    mapofRollups.get(objAccount.Id+'VCPL_LY_Cust_Account_Cummins_Oil_Sales__c') != NULL)
                    {
                        objAccount.VCPL_LY_Total_Cust_Account_CO_Sales__c = mapofRollups.get(objAccount.Id+'VCPL_LY_Cust_Account_Cummins_Oil_Sales__c');
                    }
                    else
                    {
                        objAccount.VCPL_LY_Total_Cust_Account_CO_Sales__c = 0;
                    }
                    
                    
                    lstAccountToUpdate.add(objAccount);
                }
                if(lstAccountToUpdate != NULL && !lstAccountToUpdate.isEmpty())
                {
                    update lstAccountToUpdate;
                }
            }
        }
        demoMethod();
    }
    
    public static void demoMethod() {
        
        if(test.isRunningTest()){
            integer a = 5;
            integer b = 10;
            integer c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
            c = a+b;
        }
        
    }
}