@istest
public class TestCreationControllerTest{

@testSetup
    static void setupTestData(){
        
    
    }
    public static testmethod void testCreationControllerMethod(){
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('System Administrator'); 
      
        test.startTest();
        
        
        TestCreationController.getLoggedInUserId();
        
        
        test.stopTest();
    }
    
    
    
    
}