@IsTest (isParallel= false)
public class VA_updateProfilePostCommunityTest{ 

    private static testmethod void updateProfileCommunitymethod(){ 
        Id profileId = [select id from profile where name='Customer Community User Login_Post'].id;
        Set<id> setAccountId = new Set<Id>();
        Account objAccount = new Account(Name='test',Is_Parent__c='N',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North', VA_POST_Allowed__c = 'Yes');
        system.debug(objAccount );
        setAccountId.add(objAccount.id);
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId = objAccount.Id);
        system.debug(objContact );
        insert objContact;
        
        List<User> lstuser = new List<user>();
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
                
        lstuser.add(User);
        
       
        insert lstuser;
        
        test.startTest();
        set<id> accdids = new set<id>();
        
        accdids.add(objAccount.id);
        VA_updateProfilePostCommunity.updateProfile(accdids);
        objAccount.VA_POST_Allowed__c = 'Yes' ;
        update objAccount;
        VA_updateProfilePostCommunity.updateProfile(accdids);
        VA_updateProfilePostCommunity.updatePermissionset(accdids);
        test.stopTest();
    }
    
      private static testmethod void updateProfileCommunitymethod1(){ 
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        Set<id> setAccountId = new Set<Id>();
        Account objAccount = VA_utilClass.createAccount();
        system.debug(objAccount );
        setAccountId.add(objAccount.id);
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId = objAccount.Id);
        system.debug(objContact );
        insert objContact;
        
        List<User> lstuser = new List<user>();
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
                
        lstuser.add(User);
        
       
        insert lstuser;
        
        test.startTest();
        set<id> accdids = new set<id>();
        
        accdids.add(objAccount.id);
        VA_updateProfilePostCommunity.updateProfile(accdids);
        VA_updateProfilePostCommunity.updatePermissionset(accdids);
        test.stopTest();
    }  
}