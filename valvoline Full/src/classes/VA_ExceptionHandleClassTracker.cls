@isTest
public class VA_ExceptionHandleClassTracker{
    private static testmethod void testm1(){
        Test.startTest();
        Case objCase = VA_utilClass.createPostTestCase();
        Case objCasenew = VA_utilClass.createPostTestCase();
        Account objAcc = VA_utilClass.createAccount();
        objAcc.VA_POST_Allowed__c = 'Yes';
        insert objAcc;
        Contact objContact = VA_utilClass.createContact(objAcc.Id);
        insert objContact ;
        List<sObject> lstSobj = new List<sObject>();
        List<Case> lstCase = new List<Case>();
        lstSobj.add(objCase);
        lstCase.add(objCasenew);
        Boolean bol = VA_ExceptionHandleClass.insertionHandler( lstSobj);
        Boolean boll = VA_ExceptionHandleClass.updationHandler( lstSobj);
        Database.UpsertResult[] results = Database.upsert(lstCase, false);
        Boolean bolll = VA_ExceptionHandleClass.upsertionHandler(results );
        Test.stopTest();
    } 
}