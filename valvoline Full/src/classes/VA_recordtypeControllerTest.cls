@istest
public class VA_recordtypeControllerTest{

@testSetup
    static void setupTestData(){
       
    
    }
    public static testmethod void recordTypeControllerrmethod(){
       Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
       Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo
                   = cfrSchema.getRecordTypeInfosByName();
       Id rtId = CaseRecordTypeInfo.get('Sample Test Request').getRecordTypeId();
       
       Account objAccount = VA_utilClass.createAccount();
       objAccount.VA_POST_Allowed__c = 'Yes';
       insert objAccount ;
        
       Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
       insert objContact;
       
       Case objCase = VA_utilClass.createPostTestCase();
       
       
       objCase.ContactId = objContact.Id;
       objCase.AccountId = objAccount .Id;
       insert objCase;
       String olduserAndRecordId = objCase.OwnerId +'-'+ objCase.id;
       List<string> lstolduserAndRecordId = new List<string>();
       lstolduserAndRecordId.add(olduserAndRecordId);
       test.startTest();
           VA_recordtypeController.fetchRecordTypeValues();
           VA_recordtypeController.getRecTypeId('Sample Test Request');
           
        
       test.stopTest();
    }
    
   
}