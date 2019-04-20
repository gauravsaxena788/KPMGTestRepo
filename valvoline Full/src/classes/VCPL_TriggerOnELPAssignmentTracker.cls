@isTest
public class VCPL_TriggerOnELPAssignmentTracker {
	public static testmethod void testELPAssignMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
             Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            // Insert BH User
            User objPortalBHUser = IDCumminsTestadataClass.createUser('CD BH Partner User',True,objOtherUser.Id);
            objPortalBHUser.Contactid = conBH.Id;
            objPortalBHUser.VCPL_Contact_Role__c = 'Branch Head';
            insert objPortalBHUser;
            System.runas(objOtherUser){
                objELPAssign = new VCPL_ELP_Assignment__c(); 
                objELPAssign.Name = 'TestELPASSIGN';
                objELPAssign.VCPL_Branch__c =objaccBranch.Id;
                objELPAssign.VCPL_User__c = objPortalUser.Id;
                objELPAssign.VCPL_isActive__c = true;
                insert objELPAssign;
                objELPAssign.VCPL_isActive__c = false;
                update objELPAssign;
                objELPAssign.VCPL_isActive__c = true;
                update objELPAssign;
            }
        }
    }
}