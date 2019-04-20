@IsTest  

public class VA_ShowDataControllerTest {    
    
    @testSetup
    static void setupTestData(){
        
        Account objAccount = new Account(Name='jain',Is_Parent__c='Y',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Service Network',Zone__c = 'North');
        insert objAccount;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        insert objContact;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User Login' LIMIT 1];
                
        User usr = new User(LastName = 'LIVESTON',
                            FirstName='JASON',
                            Alias = 'jliv',
                            Email = 'jason.liveston@asdf.com',
                            Username = 'jason.liveston@asdf.com',
                            ProfileId = profileId.id,
                            ContactId = objContact.Id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'      
                           );  
         
        insert usr;   
        
        Account objAccount1 = new Account(Name='Raj',Is_Parent__c='N',ParentId =objAccount.Id,Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Service Network',Zone__c = 'North');
        insert objAccount1; 
        }
    
    
    @isTest static void showDataControllerTestMethod (){   
        Test.Starttest();
        User userObj = [Select Id,ContactId From User Where FirstName='JASON'];  
        Contact objContact = [select id From Contact Where LastName='jain'];   
        System.runAs(userObj) {  
        VA_ShowDataController.listAllAccount(); 
        }   
        Test.stopTest();    
    }   
    
    
}