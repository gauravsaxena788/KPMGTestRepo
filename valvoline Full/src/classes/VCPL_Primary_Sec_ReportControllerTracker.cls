@isTest
public class VCPL_Primary_Sec_ReportControllerTracker {
	
    static testmethod void setup(){
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
            ac.Zone__c = 'East';
            ac.ShippingCity = 'Delhi';
            ac.ParentId = objaccDealer.id;
            ac.OwnerId = objOtherUser.Id;              
            insert ac;
            
            Opportunity testOpp = IDCumminsTestadataClass.returnBDOpportunityTestdata('Monthly_Plan','TestOpp', ac);
            testOpp.Financial_Year__c = '2018';
            testOpp.Monthly_Plan_Month__c = 'Nov';
            insert testOpp; 
            
            VCPL_Customer_Plan__c testVar = new VCPL_Customer_Plan__c();
            testVar.VCPL_Customer_Account__c = ac.id;
            testVar.Name = 'Test';
            insert testVar;
            
            VCPL_Secondary_Sales__c test1 = new VCPL_Secondary_Sales__c();
            test1.VCPL_Financial_Year_picklist__c = '2018';
            test1.VCPL_Branch_Customer__c = testVar.Id;
            test1.VCPL_Month_Picklist__c = 'Nov';
            insert test1;
            
            
            VCPL_Primary_Sec_ReportController testing = new VCPL_Primary_Sec_ReportController();
            VCPL_Primary_Sec_ReportController.primarySecData();
            List<list<VCPL_Primary_Sec_ReportController.primSecData>> obj = testing.listPrimSecData;
            
		}    
    }
    
}