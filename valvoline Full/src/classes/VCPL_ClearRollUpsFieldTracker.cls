@isTest(seeAllData=false)
public class VCPL_ClearRollUpsFieldTracker {
    
    static testMethod void testMethod1() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
        }
        
        Test.startTest();
        
        VCPL_ClearRollUpsField obj = new VCPL_ClearRollUpsField();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}