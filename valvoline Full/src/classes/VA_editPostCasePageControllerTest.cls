@IsTest (isParallel= false)
public class VA_editPostCasePageControllerTest{ 
    @testSetup
    static void setupTestData(){
        
        
    }
   
    testMethod static void postKitMethod(){  
        
        Map<string,string> mapOfFid = new Map<string,string>();
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        Id PostKitcaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Request Kit').getRecordTypeId();
        case objPostKitCase = new case(Status='New',recordtypeid=PostKitcaseRecordTypeId  ,ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false);
        insert objPostKitCase;
        
        
        case objPostTestCase = VA_utilClass.createPostTestCase();
        objPostTestCase.ContactId = objContact.Id;
        objPostTestCase.AccountId = objAccount .Id;
        insert objPostTestCase;
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        
        Kit_Price__c objKitPrice = new Kit_Price__c();
        objKitPrice.Price__c = 1200.00;
        insert objKitPrice;
                    
        Test.startTest();
            
            
            system.runAS(User){
                VA_editPostCasePageController.getCaseDetails(objPostKitCase.Id);
                VA_editPostCasePageController.getCaseDetails(null);
                VA_editPostCasePageController.getAccountNameMethod();
                VA_editPostCasePageController.getContactNameMethod();
                VA_editPostCasePageController.getselectOptions('Status');
                mapOfFid.put('Status', 'New');
                VA_editPostCasePageController.fetchlistPickListVals(mapOfFid);
                VA_editPostCasePageController.savePostKitDataMethod(objPostKitCase);
                VA_editPostCasePageController.getBottlesDataMethod(objAccount.id);
                VA_editPostCasePageController.fetchExistingValuesMethod(objPostKitCase.id);
                VA_editPostCasePageController.savePostCase(objPostTestCase);
                VA_editPostCasePageController.getKitPriceMethod();
            }
        Test.stopTest();
    	VA_editPostCasePageController.getAccountNameMethod();
        VA_editPostCasePageController.getContactNameMethod();
        VA_editPostCasePageController.getBottlesDataMethod(null);
        VA_editPostCasePageController.fetchExistingValuesMethod(null);
    }
    
    
    
    
    
 }