@isTest
public class VCPL_DiffrentialPricingControllerTracker {
    public static testmethod void testDPMethod(){
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
             
            Account objCDAccount = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','P S CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccount.Service_By__c ='Dealer';
            objCDAccount.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO7O';
            objCDAccount.Is_Parent__c ='Y';
            objCDAccount.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccount.Status__c = 'Activated';
            insert objCDAccount;
            
            Account objCDAccountnew = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','GONA CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccountnew.Service_By__c ='Dealer';
            objCDAccountnew.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO71';
            objCDAccountnew.Is_Parent__c ='Y';
            objCDAccountnew.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccountnew.Status__c = 'Activated';
            insert objCDAccountnew;
            
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
            }
            test.startTest();
            System.runas(objPortalUser){ 
                VCPL_Differential_Pricing__c objDPReturn = VCPL_DiffrentialPricingController.getvaluesforDiffrentailPricing(null);
                objDPReturn = VCPL_DiffrentialPricingController.getvaluesforDiffrentailPricing(objCDAccount.Id);
                Decimal DiscountVar = VCPL_DiffrentialPricingController.getMarginpercentage(100);
                VCPL_DiffrentialPricingController.wrapdatewithmessage returndateval = VCPL_DiffrentialPricingController.validateDateRecord(String.valueOf(System.today()));
                returndateval = VCPL_DiffrentialPricingController.validateDateRecord(String.valueOf(System.today().addDays(-10)));
                returndateval = VCPL_DiffrentialPricingController.validateDateRecord(String.valueOf(System.today().addMonths(-4)));
                Product2 objprod = IDCumminsTestadataClass.returnTestProduct();
                insert objprod;
                CD_SKU_Mapping__c objCDSKU = new CD_SKU_Mapping__c();
                objCDSKU.Name ='123456';
                objCDSKU.VCPL_Product_SKU_Id__c = '123456';
                insert objCDSKU;
                
                VCPL_Differential_Pricing__c objDP = IDCumminsTestadataClass.returnDPData(objaccBranch, objCDAccount, objprod);
                objDP.VCPL_Dealer_Name__c = objaccDealer.Id;
                String strDPVal = VCPL_DiffrentialPricingController.upsertDiffrentailPricingRecord(JSON.serialize(objDP));
                String strLoginUserProfile  =VCPL_DiffrentialPricingController.getloginuserProfile();
                VCPL_Differential_Pricing__c objDPnew = IDCumminsTestadataClass.returnDPData(objaccBranch, objCDAccountnew, objprod);
                objDPnew.VCPL_Dealer_Name__c = objaccDealer.Id;
                objDPnew.VCPL_DAM__c = objDPReturn.VCPL_DAM__c;
                objDPnew.VCPL_Alert_message_for_Branch_Head__c ='Test';
                objDPnew.VCPL_Discount_L__c = 101;
                objDPnew.VCPL_Validity_Start_Date__c = system.today().addDays(-1);
                objDPnew.VCPL_HOD__c = objDPReturn.VCPL_DAM__c;
                //insert objDPnew;
                system.debug('====objDPnew====='+objDPnew);
                objDPReturn = VCPL_DiffrentialPricingController.getvaluesforDiffrentailPricing(objDPnew.Id);
                strDPVal = VCPL_DiffrentialPricingController.upsertDiffrentailPricingRecord(JSON.serialize(objDPnew));
                VCPL_DiffrentialPricingController.wrapObjectwithdata objCons = (VCPL_DiffrentialPricingController.wrapObjectwithdata)JSON.deserialize(strDPVal, VCPL_DiffrentialPricingController.wrapObjectwithdata.class);
                List<String> lstStr= objCons.strId.split(';');
                System.debug('lstStr'+lstStr);
                VCPL_DiffrentialPricingController.returnrelatedata('Product',objprod.Id,objaccDealer.Id,objCDAccountnew.Id);
                VCPL_DiffrentialPricingController.returnrelatedata('Customers',objCDAccountnew.Id,objaccDealer.Id,objprod.Id);
                if(lstStr.size() == 1 && objCons.objectName == 'SUCCESS'){
                    objDPReturn = VCPL_DiffrentialPricingController.getvaluesforDiffrentailPricing(lstStr[0]);
                    String getDPmessage = VCPL_DiffrentialPricingController.gettheDiffdataonforExpire(lstStr[0]);
                    getDPmessage = VCPL_DiffrentialPricingController.ShowToastMessage(lstStr[0]);
                    List<String>  lstStrval = VCPL_DiffrentialPricingController.getPickliskvalue('VCPL_Differential_Pricing__c','VCPL_Customer_nature_of_business__c');
                    VCPL_clsforIdCustomerQuote.WrapobjError objsubmit =  VCPL_DiffrentialPricingController.submitforApproval(lstStr[0]);
                    VCPL_DiffrentialPricingController.ExpireDPRequest(lstStr[0]);
                    VCPL_DiffrentialPricingController.RenewDPRequest(lstStr[0]);
                    VCPL_DiffrentialPricingController.gettheDiffdataonforupdate(lstStr[0],String.valueOf(System.today()),'Expire test');
                    System.runas(objOtherUser){
                        VCPL_Differential_Pricing__c objDPUpdate = new VCPL_Differential_Pricing__c(id=lstStr[0],VCPL_DP_Request_Status__c='Approved');
                        update objDPUpdate;
                    }
                    VCPL_DiffrentialPricingController.ExpireDPRequest(lstStr[0]);
                    VCPL_DiffrentialPricingController.RenewDPRequest(lstStr[0]);
                    System.runas(objOtherUser){
                        VCPL_DiffrentialPricingController.gettheDiffdataonforExpire(lstStr[0]);
                        VCPL_DiffrentialPricingController.RenewDPRequest(lstStr[0]);
                        VCPL_DiffrentialPricingController.ExpireDPRequest(lstStr[0]);
                    }
                    strDPVal = VCPL_DiffrentialPricingController.upsertDiffrentailPricingRecord(JSON.serialize(objDPnew));
                
                }
                    
                
            }
            test.stopTest();
        }
    }
    }