@isTest
public class VCPL_ExpireDifferentialPricingTracker {
    static testMethod void testDPexpirationNotificationMethod() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){ 
            VCPL_Differential_Pricing__c objDPUpdate;
            List<String> lstStr;
            Test.startTest();
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
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
            String strDPVal = VCPL_DiffrentialPricingController.upsertDiffrentailPricingRecord(JSON.serialize(objDP));
            VCPL_DiffrentialPricingController.wrapObjectwithdata objCons = (VCPL_DiffrentialPricingController.wrapObjectwithdata)JSON.deserialize(strDPVal, VCPL_DiffrentialPricingController.wrapObjectwithdata.class);
            lstStr= objCons.strId.split(';');
            if(lstStr.size() == 1 && objCons.objectName == 'SUCCESS'){
                List<String> lstOfdate = Label.VCPL_Differential_Pricing_Notification.split(';');
                objDPUpdate = new VCPL_Differential_Pricing__c(id=lstStr[0],VCPL_DP_Request_Status__c='Approved',VCPL_DP_Expiry_Date__c=System.today().adddays(Integer.valueof(lstOfdate[0])));
                update objDPUpdate;
                system.debug('objDPUpdate==='+objDPUpdate);                
                VCPL_ExpireDiffPricingBatchNotification batchUpdatenoti = new VCPL_ExpireDiffPricingBatchNotification();
            	DataBase.executeBatch(batchUpdatenoti);                 
            }            
            Test.stopTest();
        }
    }
    static testMethod void testDPexpirationMethod() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){ 
            VCPL_Differential_Pricing__c objDPUpdate;
            List<String> lstStr;
            Test.startTest();
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
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
            String strDPVal = VCPL_DiffrentialPricingController.upsertDiffrentailPricingRecord(JSON.serialize(objDP));
            VCPL_DiffrentialPricingController.wrapObjectwithdata objCons = (VCPL_DiffrentialPricingController.wrapObjectwithdata)JSON.deserialize(strDPVal, VCPL_DiffrentialPricingController.wrapObjectwithdata.class);
            lstStr= objCons.strId.split(';');
            if(lstStr.size() == 1 && objCons.objectName == 'SUCCESS'){
                List<String> lstOfdate = Label.VCPL_Differential_Pricing_Notification.split(';');
                objDPUpdate = new VCPL_Differential_Pricing__c(id=lstStr[0],VCPL_DP_Request_Status__c='Approved',VCPL_DP_Expiry_Date__c=System.today());
                update objDPUpdate;
                system.debug('objDPUpdate==='+objDPUpdate);                
                VCPL_ExpireDifferentialPricingBatch batchUpdatenoti = new VCPL_ExpireDifferentialPricingBatch();
            	DataBase.executeBatch(batchUpdatenoti);                 
            }            
            Test.stopTest();
        }
    }
}