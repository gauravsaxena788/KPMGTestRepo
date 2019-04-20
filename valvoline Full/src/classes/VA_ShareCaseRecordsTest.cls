@istest(isParallel= false)
public class VA_ShareCaseRecordsTest{

@testSetup
    static void setupTestData(){
       
    
    }
    public static testmethod void shareCaseRecordsMethod(){
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
       
       map<string,User> mapProfileNameToUser = new map<string,User>();
       mapProfileNameToUser = VA_utilClass.createUser();
       User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
       system.debug('@@objCreditUser'+objCreditUser);
       system.debug('@@owner'+objCase.OwnerId);
       
       /*CaseShare cshare = new CaseShare();
       cshare.CaseId= objCase.id;
       cshare.UserOrGroupId = objCase.Ownerid;
       cshare.CaseAccessLevel = 'Read';
       insert cshare;*/
       
       String olduserAndRecordId = objCreditUser.Id +'-'+ objCase.id;
       List<string> lstolduserAndRecordId = new List<string>();
       
       lstolduserAndRecordId.add(olduserAndRecordId);
       test.startTest();
      // system.runAs(objCreditUser ) {
           VA_ShareCaseRecords.shareRecords(lstolduserAndRecordId);
      // }
        
       test.stopTest();
    }
    
   
}