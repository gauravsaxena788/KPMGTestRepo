@isTest(seeAllData=false)
public class VCPL_IDButtonControllerTracker {
    
    public static testmethod void testIdButMethod(){
        
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        
        System.runas(objOtherUser){
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUser.id);
            insert objPortalUser;
            test.startTest();
            Boolean returnVal = VCPL_IDButtonController.checkVisibility();
            System.runas(objPortalUser){
                returnVal = VCPL_IDButtonController.checkVisibility();
            }
            test.stopTest();
        }
    }
    
    
}