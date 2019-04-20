@IsTest 
public class VA_CustomLookupControllerTest{ 
    @testSetup
    static void setupTestData(){
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        VA_Project__c objproject = VA_utilClass.createProject(objAccount.id, objContact.id);
        insert objproject;
        
        
    }
    testMethod static void customLookupContorllerTestMethod(){
        VA_Project__c objproject = [select id, Name,VA_Account__c , VA_Contact__c, VA_Reason__c, VA_Frequency__c , VA_No_Of_Equipment__c, VA_Outcome__c from VA_Project__c limit 1 ];
         Test.startTest();
            VA_CustomLookupController.fetchLookUpValues('test', 'VA_Project__c', objproject.id);
         Test.stopTest();
    }
    
    
    
    
 }