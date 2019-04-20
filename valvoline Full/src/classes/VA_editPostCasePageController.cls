public with sharing class VA_editPostCasePageController 
{
    @AuraEnabled
    public static Case getCaseDetails(string strRecordId)
    {   
        list<Case> lstCase = new list<Case>();
        if(strRecordId != NULL)
        {
            lstCase = [SELECT id ,VA1_Lab__c,Owner.Name,VA_Request_Purpose__c,VA_Project__c,VA_Type_Of_Sample__c,
                       VA_Complaint_Number__c,VA_Report_Release_Date__c,VA_Other_Sample__c,VA_Test_Price__c,VA_Additional_Comments__c,
                       VA_Test_Results_Size__c,VA_Additive_Elements_Testing_Required__c,VA_POST_Number__c,VA_Product__c,
                       VA_Engine_Make_Model__c,Product_Category__c,VA_Veh_Reg_No__c,Va_Engine_Serial_No__c,VA_Date_of_Sample_Drawn__c,
                       VA_Equipment_ID__c,VA_Total_Engine_Hours__c,VA_Hours_Km_seen_by_Oil__c,Status,Request_Purpose_Other_Than_Project__c ,
                       VA_On_Hold_Reason__c,VA_Other_Reason__c ,VA_Cancellation_Reason__c,VA_FOC__c,VA_Paid__c,VA_PO_Number__c ,Subject,VA_Source1__c,
                       SuppliedEmail,Priority,Origin,Description,VA_Project__r.Name  
                       FROM Case where id=:strRecordId limit 1];
        }
        if(lstCase != NULL && !lstCase.isEmpty())
        {
            return lstCase[0];
        }
        else
            return null;
    }
    
    @AuraEnabled
    public static Account getAccountNameMethod(){
            List<Contact> conLst = VA_editPostCasePageController.getloggedInUserContactDetails();
            if(!conLst.isEmpty()){
                Account acc = new Account();
                acc.Id = conLst[0].AccountId;
                acc.Name = conLst[0].Account.Name;
                System.debug('ZZ in VA_editPostCasePgConCls-->getAccName_M-->RET Acc-->'+acc);
                return acc;
            }
        else{
            return null;
        }
    }

     @AuraEnabled
    public static Account getAccountNameMethod2(String accId){
            
                System.debug('ZZZ In VA_editPostCasePageControllerCLS-->getAccName2-->passed accId-->'+accId);

               

                List<Account> accLst = [Select Id,Name,Is_Parent__c,ParentId From Account Where Id=:accId];
                System.debug('ZZZ In VA_editPostCasePageControllerCLS-->getAccName2-->accLst-->'+accLst);
                if(!accLst.isEmpty()){
                    //List<UserRecordAccess> usrAccLst =  [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId()  AND RecordId = ]]
                    System.debug('ZZ in VA_editPostCasePgConCls-->getAccName2_M-->RET AccLst-->'+accLst);
                    return accLst[0];
                }else{
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
            System.debug('ZZ in VA_editPostCasePgConCls-->getloggedInUsrConDet_M--> Ret ConLst-->'+conLst);
        }
        return conLst;
    }
    
    @AuraEnabled
    public static Contact getContactNameMethod(){
        List<Contact> conLst = VA_editPostCasePageController.getloggedInUserContactDetails();
        if(!conLst.isEmpty()){
            Contact con = new Contact();
            con.Id = conLst[0].Id;
            con.FirstName = conLst[0].FirstName;
            con.LastName = conLst[0].LastName;
            System.debug('ZZ in VA_editPostCasePgConCls-->getContactName_M--> Ret Con-->'+con);
            return con;
        }
        else{
            return null;
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
    public static String savePostKitDataMethod(Case caseObj) {
        system.debug('ZZZ @@@case'+caseObj);
        try{
            caseObj.Status = 'New';
            caseObj.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request Kit').getRecordTypeId();
            system.debug('@@@caseObj'+caseObj.Id);
            upsert caseObj;
            return caseObj.Id;
            
          }
          catch(Exception e){
            return 'Error: ' + e.getMessage();
          }
    }
    
    @AuraEnabled
    public static Account getBottlesDataMethod(String accId) {
        if(!String.isBlank(accId)){
            List<Account> accLst = [Select id,VA_Total_No_Of_Bottles_Requested__c, VA_Total_Test_Already_Requested__c FROM Account WHERE Id=:accId];
            if(!accLst.isEmpty()){
                return accLst[0];
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static Case fetchExistingValuesMethod(String recId){
       List<Case> casLst = [Select id, Status,VA_new_Total_Bottles_Already_Requested__c,VA_Bottle_Balance_With_Customer__c,
                                VA_Total_Tests_Already_Requested__c,VA_No_Of_Bottles_Requested__c,VA_Complaint_Number__c,
                                VA_Additional_Bottle_Other_Reason__c,VA_Reason__c,VA1_Lab__c,VA_Project__c,VA_Project__r.Name,
                                VA_Request_Purpose__c, ContactId,Contact.Name, AccountId, Account.Name,VA_Product__c,VA_Product__r.Name,
                                Product_Category__c,Product_Category__r.Name FROM Case 
                                WHERE id=:recId];
        if(!casLst.isEmpty()){
            return casLst[0];
        }
        else{
            return null;
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////@@@@@@@@@@@@@@Added By Rishi on 4/7/18@@@@@@@@@@@@@@@@@@@@@@@@@@@@@////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    public static string savePostCase(Case objCase)
    {
        system.debug('@@@case'+objCase);
        try{
            //objCase.Status = 'New';
            objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sample Test Request').getRecordTypeId();
            system.debug('@@@caseObj'+objCase.Id);
            upsert objCase;
            return objCase.Id;
            
          }
          catch(Exception e){
            return 'Error: ' + e.getMessage();
          }
    }
    
    @AuraEnabled
    public static String getKitPriceMethod() {
        String pid = UserInfo.getProfileId();
        Kit_Price__c kitPrice = Kit_Price__c.getInstance(pid);
        system.debug('@@@'+kitPrice.Price__c);
        return String.valueOf(kitPrice.Price__c);
    }
    
    
    
}