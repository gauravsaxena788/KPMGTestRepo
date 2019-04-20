@isTest(seeAllData=false)
public class VCPL_ClearRollUpFieldBatchTracker {
    public static testmethod void testClearRollUpFieldMethod(){
    User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runAs(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Test.startTest();
            VCPL_ClearRollUpFieldBatch batchUpdatenoti = new VCPL_ClearRollUpFieldBatch();
            DataBase.executeBatch(batchUpdatenoti); 
            Test.stopTest();
        }
    }

}