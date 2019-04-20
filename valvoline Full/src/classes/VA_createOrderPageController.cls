public without sharing class VA_createOrderPageController 
{
    public static List<Contact> getloggedInUserContactDetails(){
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
    public static Account getAccountNameMethod(){
            List<Contact> conLst = VA_createOrderPageController.getloggedInUserContactDetails();
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

      @AuraEnabled
    public static Account getAccountNameMethod2(String accId){
            
        System.debug('ZZZ In VA_createOrderPageControllerCLS-->getAccName2-->passed accId-->'+accId);
        List<Account> accLst = [Select Id,Name,Is_Parent__c,ParentId From Account Where Id=:accId];
        System.debug('ZZZ In VA_createOrderPageControllerCLS-->getAccName2-->accLst-->'+accLst);
        if(!accLst.isEmpty()){
          //List<UserRecordAccess> usrAccLst =  [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId()  AND RecordId = ]]
            return accLst[0];
        }else{
            return null;
        }
            
            
    }


    @AuraEnabled
    public static string saveOrder(Order objOrder){
        try{
            objOrder.Status = 'Draft';
            system.debug('@@@caseObj'+objOrder.Id);
            upsert objOrder;
            return objOrder.Id;
            
          }
          catch(Exception e){
            return 'Error: ' + e.getMessage();
          }
    }    
}