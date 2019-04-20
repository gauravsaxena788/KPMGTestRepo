@isTest(seeAllData=false)
public class VCPL_BLISGroupTriggerHandlerTracker {
  static testMethod void testBLISGroupTriggerMethod() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objSMUser = IDCumminsTestadataClass.createUser('SM',False,'');
        insert objSMUser;
        system.runAs(objOtherUser){            
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.Is_Parent__c = 'Y';
            objaccDealer.Indutry_Segment__c = 'Cummins Dealer';
            insert objaccDealer;
            AccountTeamMember objAccTeam = new AccountTeamMember(AccountId = objaccDealer.Id,UserId = objSMUser.Id,TeamMemberRole = 'Segment Manager');
            insert objAccTeam;
            
            VCPL_BLIS_Group__c objBG = new VCPL_BLIS_Group__c();
            objBG.Name = 'Test';
            objBG.VCPL_Status__c = 'Draft';
            //objBG.VCPL_Approver__c = objSMUser.Id; 
            objBG.VCPL_Dealer__c = objaccDealer.Id;
            insert objBG;
            update objBG;
            
        }
    }

}