@isTest
public class VCPL_SendNotificationOnNegativeDPTracker {
	static testMethod void testDPexpirationNotificationMethod() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;    
        User objSMUser = IDCumminsTestadataClass.createUser('TBM',False,'');
        insert objSMUser;
        Map < Integer, String > mapNameMonthNum = new Map < Integer, String > {
                                                    1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr', 5 => 'May', 6 => 'Jun',
                                                    7 => 'Jul', 8 => 'Aug', 9 => 'Sep', 10 => 'Oct',11 => 'Nov', 12 => 'Dec' };
            
        System.runas(objOtherUser){ 
            VCPL_Differential_Pricing__c objDPUpdate;
            List<String> lstStr;
            Test.startTest();
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.OwnerId = objSMUser.Id;
            insert objaccDealer;
            Account objaccPrimary = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Primary Account',objOtherUser.Id,True,objaccDealer.id);
            objaccPrimary.OwnerId = objSMUser.Id;
            insert objaccPrimary;
            Opportunity objOppSAP= IDCumminsTestadataClass.returnBDOpportunityTestdata('Monthly_Plan','SAP Opport',objaccPrimary);
            objOppSAP.VCPL_Previous_Month_Closing_Balance__c = -90009;
            objOppSAP.Sub_Stage__c = '';
            objOppSAP.CloseDate = Date.newInstance(System.Today().year(),(System.Today().month()-1),15);   
            objOppSAP.Opportunity_Type__c = 'Business Development - New Account';
            objOppSAP.Month_sap__c = mapNameMonthNum.get(System.Today().month()-1);
        	objOppSAP.Calendar_Year__c= String.valueof(System.Today().year());
            insert objOppSAP;
            
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Account objCDAccount = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','P S CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccount.Service_By__c ='Dealer';
            objCDAccount.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO7O';
            objCDAccount.Is_Parent__c ='Y';
            objCDAccount.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccount.Status__c = 'Activated';
            insert objCDAccount;
            Product2 objprod = IDCumminsTestadataClass.returnTestProduct();
            insert objprod;
            CD_SKU_Mapping__c objCDSKU = new CD_SKU_Mapping__c();
            objCDSKU.Name ='123456';
            objCDSKU.VCPL_Product_SKU_Id__c = '123456';
            insert objCDSKU; 
            VCPL_Differential_Pricing__c objDP = IDCumminsTestadataClass.returnDPData(objaccBranch, objCDAccount, objprod);
            objDP.VCPL_Dealer_Name__c = objaccDealer.Id;
            objDP.VCPL_Dealer_Name__c = objaccDealer.Id;
            //objDPnew.VCPL_DAM__c = objPortalHODUser.Id;
            objDP.VCPL_Alert_message_for_Branch_Head__c ='Test';
            objDP.VCPL_Discount_L__c = 101;
            objDP.VCPL_Validity_Start_Date__c = system.today().addDays(-1);
            objDP.VCPL_DP_Expiry_Date__c= system.today().addDays(180);
            //objDPnew.VCPL_HOD__c = objPortalHODUser.Id;
            objDP.VCPL_DP_Request_Status__c='Approved';
            insert objDP;                          
            VCPL_SendNotificationOnNegativeDP batchUpdatenoti = new VCPL_SendNotificationOnNegativeDP();
            DataBase.executeBatch(batchUpdatenoti);
            Test.stopTest();
        }
    }
}