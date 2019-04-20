public Class VCPL_CommonUtilityClass { 
    
    // This is used to share records with all account Partner user
    public Static void shareRecordswithUser(List<Account> lstAcc, Set<String> setofAccId){
      // Variables defined
      List<AccountShare> lstAccShare = new List<AccountShare>();
             
      List<User> lstOfUser;
      if(!setofAccId.isEmpty())
        lstOfUser = [SELECT id, Name FROM User WHERE AccountId IN : setofAccId AND IsActive = True];
      
      if(lstOfUser != null && !lstOfUser.isEmpty()){
        for(User objUser : lstOfUser){
            for(Account objAcc: lstAcc){
                if(objUser.Id != objAcc.OwnerId){
                    AccountShare objAccShare = new AccountShare();
                    objAccShare.AccountId = objAcc.Id;
                    objAccShare.UserOrGroupId = objUser.Id;
                    objAccShare.AccountAccessLevel = 'Read';
                    objAccShare.OpportunityAccessLevel = 'Read';
                    lstAccShare.Add(objAccShare);
                 }
            }
        }
        if(!lstAccShare.isEmpty())
            insert lstAccShare;
      }
      
    }
    
    public static List<String> getPrimaryAccountRecordType(){
        List<String> setofRecordType = new List<String>();
        for(String objstr : Label.VCPL_Primary_Account_Recordtype.split(';')){
          setofRecordType.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(objstr).getRecordTypeId());
        }
        return setofRecordType ;
    }
    
    public static List<String> getCustomerPortalProfiles(){
        List<String> setProfiles = new List<String>();
        for(String objstr : Label.VCPL_Customer_Portal_Member_Profiles.split(';')){
            objstr = objstr.trim();
            setProfiles.add(objstr);
        }
        return setProfiles;
    }
    
    public static boolean hasCustomerPortalAccess(string profileName){
        
        if(getCustomerPortalProfiles().Contains(profileName)){
            return true;
        }
        else return false;
    }
    
    public static boolean hasCustomerPortalAccess(Id profileId){
        
        list<Profile> lstProfile = [SELECT Id from Profile where Name in: getCustomerPortalProfiles() and Id =: profileId];
        if(lstProfile != null && lstProfile.size() > 0)return true;
        else return false;
    }
    
    public static Date convertCDOSDate(String myDate) {
        /*
            Expected Date Format is yyyy-MM-dd
        */
        
        String[] strDate = myDate.trim().split('-');
        Date d = Date.newInstance(integer.valueOf(strDate[0]), integer.valueOf(strDate[1]), integer.valueOf(strDate[2]));
        return d;
    }
}