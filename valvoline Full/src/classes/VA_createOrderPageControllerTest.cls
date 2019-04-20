@IsTest (isParallel= false)
public class VA_createOrderPageControllerTest{ 
    @testSetup
    static void setupTestData(){
        
        
    }
   
    testMethod static void createOrderPageTestMethod(){  
        
        
        Account objAccount = VA_utilClass.createAccount();
        //Id priAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Primary Account').getRecordTypeId();
        //objAccount.RecordTypeId = priAccRecordTypeId;
        //System.debug('ZZZ Acc-->'+objAccount);
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
                    
                    
        Test.startTest();
           
            
            system.runAS(User){
                VA_createOrderPageController.getloggedInUserContactDetails();
                VA_createOrderPageController.getAccountNameMethod();
                VA_createOrderPageController.getAccountNameMethod2(objAccount.Id);
                VA_createOrderPageController.saveOrder(objOrder);
            }
        Test.stopTest();
    
    }
    testMethod static void negativeScenarios()
    {
        VA_createOrderPageController.getAccountNameMethod();
        VA_createOrderPageController.getAccountNameMethod2(null);
         VA_createOrderPageController.saveOrder(null);
    }
    
    
    
    
    
 }