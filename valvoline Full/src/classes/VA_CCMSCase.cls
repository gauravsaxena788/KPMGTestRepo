public without  sharing class VA_CCMSCase {
    
    @AuraEnabled
    public static Case getCases(id Caseid)
    {
        list<case> lstCase = new list<case>();
        System.debug('myId+++++++++++'+Caseid);
        if (Caseid != null)
        {
            Id devRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register a Complaint').getRecordTypeId();
            
            lstCase = [Select Id, Subject, Type, Origin, Status,VA_Complaint_Category__c,VA_Complaint_Description__c,
                       VA_Other_Complaints__c,VA_Customer_Closure_Consent__c,Consent_Comment__c,VA_Offer_FOC_Replacement__c,FOC_Reason__c,
                       VA_Product_to_be_replaced__c,VA_Replacement_Qty__c,VA_Stacking_pattern__c,VA_Quantity_Affected__c,VA_Physical_Sample__c,
                       VA_Product__c,Batch_No__c,VA_Pack_Size_Unit__c,VA_Leakage_Damage_observed_at__c,VA_Is_it_a_case_of_part_load_to_Retailor__c,
                       VA_Leakage_Damage_happened_at__c,VA_Physical_Pack_Sample__c,VA_Mould_Number__c,VA_Shortage_During_Receipt_From__c,VA_Complaint_Location__c,
                       VA_Weight_Of_Pack__c,VA_Weight_of_Pack_Unit__c,VA_Pack_Size__c,VA_Is_The_Sealing_Intact_With_Image__c,VA_Damage_Observed_During_Delivery_To__c,VA_Is_It_A_Case_Of_Part_Load__c,
                       SuppliedEmail,VA_On_Hold_Reason__c,Priority,VA_Additional_Comments__c,Description,VA_Containment__c,VA_Correction__c,VA_Corrective_Action__c,
                       VA_Root_Cause__c,VA_Why_1__c,VA_Why_2__c,VA_Why_3__c,VA_Why_4__c,VA_Why_5__c,VA_Man__c,VA_Machine__c,VA_Material__c,VA_Measurement__c,
                       VA_Method__c,VA_Mother_Nature__c,Owner.Username,VA_Complaint_Id__c ,VA_Product__r.Name,Contact.Name,Account.Name,VA_Project__c
                       From Case where  id =: Caseid limit 1 ];
            system.debug('<<objcase>>' +lstCase );
        }
        
        if(lstCase != NULL && !lstCase.isEmpty())
        {
            return lstCase[0];
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static String saveCase(Case objCase) {
        try{
            if (objCase != null)
            {
                system.debug('<<ca>>' + objCase);
                if (objCase.id == null)
                    objCase.Status = 'Open';
                
                Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register a Complaint').getRecordTypeId();
                objCase.RecordTypeId = devRecordTypeId; 
                system.debug('<<ca>>' + objCase);    
                upsert objCase;
                return objCase.Id;
            }  
            else
            {
                return null;
            }
        }
        catch(Exception e){
            return 'Error: ' + e.getMessage();
        }
    }
    
    @AuraEnabled
    public static List < String > getselectOptions( string fld) {
        //system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = case.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    
    @AuraEnabled
    public static map<string,list<string>> fetchlistPickListVals(map<string,string> mapfld) {
        //system.debug('objObject --->' + objObject);
        system.debug('fld --->' + mapfld);
        
        map<string,list<string>> mapfieldsbyvalues = new map<string,list<string>>();
        
        // Get the object type of the SObject.
        Schema.sObjectType objType = case.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map <String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        
        // Get the list of picklist values for this field.
        for(string str:mapfld.keySet())
        {
            List < String > allOpts = new list <String> (); 
            list <Schema.PicklistEntry > values =
                fieldMap.get(str).getDescribe().getPickListValues();
            
            // Add these values to the selectoption list.
            for (Schema.PicklistEntry a: values) {
                allOpts.add(a.getValue());
            }
            system.debug('allOpts ---->' + allOpts);
            system.debug('sttr ---->' + mapfld.get(str));   
            allOpts.sort();
            mapfieldsbyvalues.put(mapfld.get(str),allOpts);     
        }
        
        return mapfieldsbyvalues;
    }
    
    
    @AuraEnabled
    public static Account getAccountNameMethod(string strRecordId){
        system.debug('@@@recId'+strRecordId);
        
        if(String.isBlank(strRecordId)){
            String userId = UserInfo.getUserId();
            List<User> userLst = [Select id,ContactId, Profile.Name from User WHERE id =:userId];
            
            /*
                Date: 27-11-2018
                Developer Name: Sumit Kumar Banarji | SaasFocus
                Description: Change added to allow partner portal users to use Customer Portal
            */
            //if(!userLst.isEmpty() && (userLst[0].Profile.Name == 'Customer Community User Login' || userLst[0].Profile.Name == 'Customer Community User Login_Post')){
            if(VCPL_CommonUtilityClass.hasCustomerPortalAccess(userLst[0].Profile.Name)){
                List<Contact> conLst = [Select id,AccountId,Account.Name, Name from Contact WHERE id =:userLst[0].ContactId];
                if(!conLst.isEmpty()){
                    Account acc = new Account();
                    acc.Id = conLst[0].AccountId;
                    acc.Name = conLst[0].Account.Name;
                    return acc;
                }
                else{
                    return null;
                }
            }
            else{
                return null;
            }
        }
        else if (!String.isBlank(strRecordId)){
            if(strRecordId.startsWith('500')){
                List<Case> caseLst = [Select id, AccountId FROM Case where id=:strRecordId];
                if(!caseLst.isEmpty()){
                    List<Account> accLst = [Select id, Name from Account WHERE id =:caseLst[0].AccountId];
                    if(!accLst.isEmpty())
                        return accLst[0];
                    else {
                        return null;
                    }
                }
                else{
                    return null;
                }
            }else{
                List<Account> accLst = [Select id, Name from Account WHERE id =:strRecordId];
                if(!accLst.isEmpty())
                    return accLst[0];
                else {
                    return null;
                }
            }
        }
        
        else{
            return null;
        }
        
    }
    
    private static List<Contact> getloggedInUserContactDetails(){
        String userId = UserInfo.getUserId();
        List<Contact> conLst = new List<Contact>();
        List<User> userLst = [Select id,ContactId, Profile.Name from User WHERE id =:userId];
        
        /*
            Date: 27-11-2018
            Developer Name: Sumit Kumar Banarji | SaasFocus
            Description: Change added to allow partner portal users to use Customer Portal
        */
        //if(!userLst.isEmpty() && (userLst[0].Profile.Name == 'Customer Community User Login' || userLst[0].Profile.Name == 'Customer Community User Login_Post')){
        if(VCPL_CommonUtilityClass.hasCustomerPortalAccess(userLst[0].Profile.Name)){
          conLst = [Select id,AccountId,FirstName, LastName, Account.Name, Name from Contact WHERE id =:userLst[0].ContactId];
        }
        return conLst;
    }
    
    @AuraEnabled
    public static Contact getContactNameMethod(){
        List<Contact> conLst = VA_CCMSCase.getloggedInUserContactDetails();
        if(!conLst.isEmpty()){
            Contact con = new Contact();
            con.Id = conLst[0].Id;
            con.FirstName = conLst[0].FirstName;
            con.LastName = conLst[0].LastName;
            return con;
        }
        else{
            return null;
        }
    }
}