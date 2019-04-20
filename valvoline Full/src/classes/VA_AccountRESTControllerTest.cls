@istest
public class VA_AccountRESTControllerTest{

@testSetup
    static void setupTestData(){
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
       
    
    }
    public static testmethod void AccountRestmethod(){
    
        Account objAccount = [select id , name ,Zone__c,Indutry_Segment__c,Market_Segment__c,SFDC_Account_ID__c,VA_Block__c from Account limit 1];
        Map<String,VA_DatabaseUtility.StatementResponse> response = new Map<String,VA_DatabaseUtility.StatementResponse>(); 
        test.startTest();
        List<VA_AccountRESTController.AccountWrapper> lstwrapper = new List<VA_AccountRESTController.AccountWrapper>();
        VA_AccountRESTController.AccountRequest objRequest = new VA_AccountRESTController.AccountRequest();
        VA_AccountRESTController.AccountWrapper wrapper = new VA_AccountRESTController.AccountWrapper();
        wrapper.accountInstance = objAccount;
        lstwrapper.add(wrapper);
        objRequest.accDataList = lstwrapper;
        VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
        VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
        List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
        objStatementResponse.Id = objAccount.SFDC_Account_ID__c;
        objStatementResponse.status = 'success';
        //List<String> messages = new List<String> ();
        //messages.add('success');
        //objStatementResponse.Message = messages;
        objStatementResponse.Message = 'Success';
        lstStatementResponse.add(objStatementResponse);
        
        objasc.lstStatementResponse = lstStatementResponse;

        response.put(objAccount.SFDC_Account_ID__c,objStatementResponse);
        VA_AccountRESTController.saveAccounts(objRequest);
        
        objStatementResponse.status = 'error';
        //List<String> messages = new List<String> ();
        //messages.add('error');
        //objStatementResponse.Message = messages;
        objStatementResponse.Message = 'Error';
        lstStatementResponse.add(objStatementResponse);
        response.put(objAccount.SFDC_Account_ID__c,objStatementResponse);
        VA_AccountRESTController.saveAccounts(objRequest);
        
        test.stopTest();
    }
    
   
}