@IsTest (isParallel= false)
public class VA_CCMSCaseTest{ 
    @testSetup
    static void setupTestData(){
        
        
    }
   
    testMethod static void ccmsCaseTestMethod(){  
        
        Map<string,string> mapOfFid = new Map<string,string>();
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        Id caseRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register a Complaint').getRecordTypeId();
        case objCase = new case(Status='Open',Batch_No__c= '123',recordtypeid=caseRecordTypeId  ,VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false);
        insert objCase;
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
                    
                    
        Test.startTest();
            VA_CCMSCase.getCases(objCase.Id);
            VA_CCMSCase.saveCase(objCase);
            VA_CCMSCase.getselectOptions('Status');
            mapOfFid.put('Status', 'Open');
            VA_CCMSCase.fetchlistPickListVals(mapOfFid);
            
            system.runAS(User){
                VA_CCMSCase.getAccountNameMethod(objCase.id);
                VA_CCMSCase.getContactNameMethod();
            }
        Test.stopTest();
    
    }
    
    testMethod static void updateConsentTestMethod1(){  
        
        Map<string,string> mapOfFid = new Map<string,string>();
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        Id caseRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register a Complaint').getRecordTypeId();
        case objCase = new case(Status='Open',Batch_No__c= '123',recordtypeid=caseRecordTypeId  ,VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false);
        insert objCase;
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        
        Test.startTest();
            VA_CCMSCase.getCases(objCase.Id);
            VA_CCMSCase.saveCase(objCase);
            VA_CCMSCase.getselectOptions('Status');
            mapOfFid.put('Status', 'Open');
            VA_CCMSCase.fetchlistPickListVals(mapOfFid);
            
            system.runAS(User){
                VA_CCMSCase.getAccountNameMethod('');
                VA_CCMSCase.getContactNameMethod();
            }
        Test.stopTest();
    
    }
    
    
    
    
 }