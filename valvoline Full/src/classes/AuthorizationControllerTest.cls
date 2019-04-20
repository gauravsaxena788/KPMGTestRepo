@isTest(SeeAllData=false)
public class AuthorizationControllerTest {
    
   @isTest public static void Test1()
    {
            Test.setMock(HttpCalloutMock.class, new HTTPCalloutMockTestCommon());
              AuthorizationController  objAuthorization = new AuthorizationController();
       	objAuthorization.authCode = '200';
            
            Test.startTest();
           objAuthorization.getAuthorizationCode();
           objAuthorization.makeCallout();
            Test.stopTest();
    }
    
}