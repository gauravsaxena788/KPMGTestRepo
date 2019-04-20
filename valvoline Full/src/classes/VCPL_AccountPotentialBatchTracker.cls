@isTest(seeAllData=false)
public class VCPL_AccountPotentialBatchTracker 
{
    static list<Account_Potential__c> potentiallist;
@isTest
    public static void method1()
    {
       
       loaddata(); 
        test.startTest();
        VCPL_AccountPotentialBatch obj= new VCPL_AccountPotentialBatch();
            DataBase.executeBatch(obj);
                Test.stopTest();
    }
     public static void loadData()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;

            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VCPL_ID_Customer').getRecordTypeId();
            Account ac = new Account(name ='Grazitti'+(math.random()*10).intValue()) ;
            ac.Indutry_Segment__c = 'Industrial';
            ac.RecordTypeId = accRecordTypeId; 
            ac.BU_Name__c = 'C&I';
            ac.Account_Type__c = 'Secondary Customer through ID';
            ac.Market_Segment__c = 'Industrial Distributor';
            ac.Zone__c = 'North';
            ac.ShippingCity='delhi';
            ac.OwnerId = objOtherUser.Id;              
            insert ac;
            
            Account_Potential__c Potential= new Account_Potential__c();
            potential.Valvoline_Financial_Year__c='2017';
            potential.Potential_Volume_in_kL__c= 2;
            potential.Account__c= ac.id;
            potential.BU_Name__c= 'C&I'; 
            potential.Valvoline_Financial_Year__c='2017';
            potential.VCPL_Is_Current_Financial_Year__c= true;
            potential.PH6_Qlikview__c='Antifreeze';
            
            insert potential;
            
            list<Account_Potential__c> potentiallist= new list<Account_Potential__c>();
            potentiallist.add(potential);
            
        }          
}
}