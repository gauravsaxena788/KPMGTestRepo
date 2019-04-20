@istest
public class VA_PicklistValuesControllerTest{

@testSetup
    static void setupTestData(){
        
    
    }
    
    
    public static testmethod void picklistValuesControllerTestMethod(){
 
        VA_PicklistValuesController.getPickListValues('Case','Status');
    }
   
}