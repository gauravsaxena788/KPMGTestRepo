@isTest
public class LookupSObjectControllerTracker {
    private static TestMethod void testdataLookUpComponentfor(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){
            VCPL_ELP_Assignment__c objELPAssign;
            Account ac = new Account(name ='Grazitti') ;
            ac.Indutry_Segment__c = 'Industrial';
            ac.BU_Name__c = 'C&I';
            ac.Account_Type__c = 'Industrial Distributor';
            ac.Market_Segment__c = 'Industrial Distributor';
            ac.Zone__c = 'East';
            insert ac; 
            
            Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
            insert con;
            Product2 objProd = IDCumminsTestadataClass.returnTestProduct();
            insert objProd;
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id ,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id ,True,objaccDealer.id);
            
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            
            CD_SKU_Mapping__c objCDSKU = new CD_SKU_Mapping__c();
            objCDSKU.Name ='123456';
            objCDSKU.VCPL_Product_SKU_Id__c = '123456';
            insert objCDSKU;
            Account objCDAccountnew = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','GONA CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccountnew.Service_By__c ='Dealer';
            objCDAccountnew.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO71';
            objCDAccountnew.Is_Parent__c ='Y';
            objCDAccountnew.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccountnew.Status__c = 'Activated';
            insert objCDAccountnew;
            VCPL_Dealer_Customer_Mapping__c objDCM = new VCPL_Dealer_Customer_Mapping__c();
            objDCM.VCPL_Dealer_Account__c = objaccDealer.Id;
            objDCM.VCPL_Customer_Account__c = objCDAccountnew.Id;
            insert objDCM;
            
            List<String> lstStr = new List<String>{'Name'};
            LookupSObjectController.lookupByFields('Test','Contact','',false, null);
            LookupSObjectController.lookupByFields('Test','Contact','',false, lstStr);
            LookupSObjectController.lookupByFields('Test','Contact', '',false, lstStr);
            LookupSObjectController.lookupByFields('Test','Contact','',true, lstStr);
            LookupSObjectController.lookupByFields('Test','Contact','',true, lstStr); 
            LookupSObjectController.lookup('Test','Contact','',true);
            LookupSObjectController.lookup('Test','Contact','',true);
            LookupSObjectController.lookup('Test','Contact','',false);
            LookupSObjectController.lookup('Test','Contact','',false);
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id );
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            System.runas(objOtherUser){
                objELPAssign = new VCPL_ELP_Assignment__c(); 
                objELPAssign.Name = 'TestELPASSIGN';
                objELPAssign.VCPL_Branch__c =objaccBranch.Id;
                objELPAssign.VCPL_User__c = objPortalUser.Id;
                objELPAssign.VCPL_isActive__c = true;
                insert objELPAssign;
            }
            system.runAs(objPortalUser){
                LookupSObjectController.filterLookup('','DealerMapping','Product2');
                LookupSObjectController.filterLookup('','DealerMapping','Account');
                LookupSObjectController.filterLookup('123456','DealerMapping','Product2');
                LookupSObjectController.filterLookup('123456','DealerMapping','Account');
                LookupSObjectController.filterDealerLookup('','ELPUserMapping','');
                LookupSObjectController.filterDealerLookup('Grazitti','ELPUserMapping','');
            }
        }
    }
}