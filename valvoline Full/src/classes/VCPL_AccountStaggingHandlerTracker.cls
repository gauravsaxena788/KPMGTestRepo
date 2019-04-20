@isTest
public class VCPL_AccountStaggingHandlerTracker {
	

    private static TestMethod void AccountstaggingInsert(){
        VCPL_Dealer_Mapping__c objDealerMapping = new VCPL_Dealer_Mapping__c();
        objDealerMapping.VCPL_City__c = 'NEW DELHI';
        objDealerMapping.VCPL_State__c = 'DELHI';
        objDealerMapping.VCPL_StateCity__c = 'NEW DELHIDELHI';
        insert objDealerMapping;
        
        list<VCPL_Account_Stagging__c> lstVCPLAccountStagging = new list<VCPL_Account_Stagging__c>();
        VCPL_Account_Stagging__c objVCPLAccountStagging = new VCPL_Account_Stagging__c();
        objVCPLAccountStagging.Account_Id__c = '1-15L-2182';
        objVCPLAccountStagging.Account_Segment__c ='';
        objVCPLAccountStagging.Account_Status__c = 'Active';
        objVCPLAccountStagging.Created_Date__c = '12-06-2018';
        objVCPLAccountStagging.City__c = 'NEW DELHI';
        objVCPLAccountStagging.state__c = 'DELHI';
        objVCPLAccountStagging.Filter_Sales__c ='Y';
        lstVCPLAccountStagging.add(objVCPLAccountStagging);
        
        VCPL_Account_Stagging__c objVCPLAccountStagging1 = new VCPL_Account_Stagging__c();
        objVCPLAccountStagging1.Account_Segment__c ='';
        objVCPLAccountStagging1.Account_Status__c = 'Active';
        objVCPLAccountStagging1.Created_Date__c = '12-10-13';
        objVCPLAccountStagging1.City__c = 'NEW DELHI';
        objVCPLAccountStagging1.state__c = 'DELHIT';
        objVCPLAccountStagging1.Filter_Sales__c ='N';
        objVCPLAccountStagging1.Status__c ='Has Error';
        lstVCPLAccountStagging.add(objVCPLAccountStagging1);
        insert lstVCPLAccountStagging;
        
    }
}