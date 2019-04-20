@isTest
public Class VCPL_Customer_Home_ContTracker{

 private static TestMethod void testmethodof(){
     String profileName = Label.Community_User_Profile;
     Account objAcc = VA_utilClass.createAccount();
     objAcc.VA_POST_Allowed__c = 'Yes';
     insert objAcc;
     Contact objContact = VA_utilClass.createContact(objAcc.Id);
     insert objContact ;
     
      Case objCase = VA_utilClass.createPostTestCase(); 
        objCase.ContactId = objContact .Id;
        insert objCase;
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
            
             List<Case> lstCase = VCPL_Customer_Home_Controller.getServiceRequest();
            }
     
     VA_WrapperofImage objWrpIMg = new VA_WrapperofImage ();
 }
}