@isTest
Public Class VA_DatabaseUtilityTracker{

    private static testmethod void test1(){
        List<Id> accLst = new List<Id>();
        Account objAcc = VA_utilClass.createAccount();
        objAcc.VA_POST_Allowed__c = 'Yes';
        insert objAcc;
        
        accLst.add(objAcc.id);
        Contact objContact = VA_utilClass.createContact(objAcc.Id);
        insert objContact ;
        Order objOrder = VA_utilClass.createOrder(objAcc.Id);
        objOrder.Status = 'Registered';
        //insert objOrder ;
        List<Order> lstOrder = new List<Order>();
        lstOrder.add(objOrder);
        Case objCase = VA_utilClass.createPostTestCase(); 
        objCase.ContactId = objContact .Id;
        insert objCase;
        
        Product2 objProd = VA_utilClass.createProduct();
        insert objProd ;
        PricebookEntry objPribk = VA_utilClass.createPriceBookEntry(objProd.Id);
        insert objPribk ;
        objPribk.Pricebook2 =null;
        List<PricebookEntry > lstProd = new List<PricebookEntry >();
        lstProd.add(objPribk);
         String profileName = Label.Community_User_Profile;
         List<Profile> lstPrf = [SELECT Id,Name FROM Profile where name = :profileName];
        
            
            User objUser = new User();
            objUser.Alias = 'standt';
            objUser.Email='standarduser@testorg.com';
            objUser.EmailEncodingKey='UTF-8';
            objUser.LastName='Testing';
            objUser.LanguageLocaleKey='en_US';
            objUser.LocaleSidKey='en_US'; 
            objUser.ProfileId = lstPrf[0].Id;
            objUser.TimeZoneSidKey='America/Los_Angeles';
            objUser.UserName = 'gsdgsd@ggd.vom';
            objUser.ContactId = objContact.Id;
            objUser.FederationIdentifier = '123';
            insert objUser ;
            
            system.runAs(objUser){
            Map<String,VA_DatabaseUtility.StatementResponse> responseTemp = VA_DatabaseUtility.insertionUtility(lstOrder,'VA_SAP_Order_Id__c','insert','Order');  
            Schema.SObjectField ftoken = PricebookEntry.Fields.SKU_Id__c;
            responseTemp = VA_DatabaseUtility.upsertionUtility(lstProd,ftoken,'SKU_Id__c','upsert','PricebookEntry');
            VA_DatabaseUtility.isPortalAccount(accLst);
           }
    }
}