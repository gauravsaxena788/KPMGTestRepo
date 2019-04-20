@IsTest(isParallel=false) 
public class VA_PostAccessCommunityTest{ 

    
    testMethod static void POSTAccessCommunityTestMethod1(){ 
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        
       Account objAccount = new Account(Name='test',Is_Parent__c='N',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North', VA_POST_Allowed__c = 'Yes');
         system.debug(objAccount );
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
        system.runAs(user) {
            VA_PostAccessCommunity.wrapperClass wrapper = new VA_PostAccessCommunity.wrapperClass();
            wrapper.lstUser = lstuser ;
            wrapper.isrendered = true;
            system.debug('@@wrapper'+wrapper);
            
            system.debug('@@@'+wrapper);
            VA_PostAccessCommunity.initMethod(wrapper.lstUser[0].name);
        }

       
    
    }
    testMethod static void POSTAccessCommunityTestMethod2(){ 
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        
        Account objAccount = VA_utilClass.createAccount();
         system.debug(objAccount );
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
        system.runAs(user) {
            VA_PostAccessCommunity.wrapperClass wrapper = new VA_PostAccessCommunity.wrapperClass();
            wrapper.lstUser = lstuser ;
            wrapper.isrendered = true;
            system.debug('@@wrapper'+wrapper);
            
            system.debug('@@@'+wrapper);
            VA_PostAccessCommunity.initMethod(wrapper.lstUser[0].name);
        }

       
    
    }
    
    testMethod static void POSTAccessCommunityTestMethod3(){ 
        test.startTest();
            VA_PostAccessCommunity.initMethod('test');
        test.stopTest();
    }
       
}