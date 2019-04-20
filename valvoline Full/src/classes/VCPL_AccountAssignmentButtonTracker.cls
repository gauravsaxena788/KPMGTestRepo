@isTest(seeAllData=false)
public class VCPL_AccountAssignmentButtonTracker {
	static testMethod void testAccountAssignmentButtonMethod() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        system.runAs(objOtherUser){
        VCPL_AccountAssignmentButtonController.checkVisibility();
            VCPL_RedirectCustCommunityController.checkVisibility();
        }
    }
}