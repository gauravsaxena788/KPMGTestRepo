@isTest
public class AccountStructureTracker 
{

    @istest public static void AccountStructuremethod()
    {   
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        
        System.runas(objOtherUser){
        
         Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
        insert objaccDealer;
        Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
        insert objaccBranch;        
        
        new AccountStructure();
        AccountStructure obj= new AccountStructure();
        obj.setcurrentId(objaccDealer.Id);
        obj.getObjectStructure();
        obj.formatObjectStructure(objaccDealer.Id);
        }
    }


}