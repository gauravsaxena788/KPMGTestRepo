@isTest(seeAllData=false)
public class VCPL_CumminsSalesCaptureTracker {
	 public static testmethod void testCummSalesCapMethod(){
     User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
     insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            
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
            
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conHOD = new Contact(LastName ='testConHOD'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conHOD; 
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            VCPL_Dealer_Customer_Mapping__c objDCM = new VCPL_Dealer_Customer_Mapping__c();
            objDCM.VCPL_Dealer_Account__c = objaccDealer.Id;
            objDCM.VCPL_Customer_Account__c = objCDAccount.Id;
            insert objDCM;
            VCPL_Dealer_Customer_Mapping__c objDCMnew = new VCPL_Dealer_Customer_Mapping__c();
            objDCMnew.VCPL_Dealer_Account__c = objaccDealer.Id;
            objDCMnew.VCPL_Customer_Account__c = objCDAccountnew.Id;
            insert objDCMnew;
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            User objPortalHODUser = IDCumminsTestadataClass.createUser('CD HOD Partner User',True,objOtherUser.Id);
            objPortalHODUser.Contactid = conHOD.Id;
            objPortalHODUser.VCPL_Contact_Role__c = 'HOD';
            insert objPortalHODUser;
            
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
                VCPL_CumminsSalesCaptureController.getBranches(objaccDealer.Id);
                VCPL_CumminsSalesCaptureController.getBranches(null);
                List<VCPL_CumminsSalesCaptureController.DataWrapper> objDataWrap = VCPL_CumminsSalesCaptureController.getData(objaccBranch.Id,objaccDealer.Id);
                VCPL_CumminsSalesCaptureController.getFilteredValues(JSON.serialize(objDataWrap),'Others',''); 
                VCPL_CumminsSalesCaptureController.saveData(JSON.serialize(objDataWrap));
            }
            System.runas(objPortalHODUser){
                VCPL_CumminsSalesCaptureController.getBranches(null);
                VCPL_CumminsSalesCaptureController.getParentAccount();
            }
             System.runas(objOtherUser){
                
                VCPL_Customer_Plan__c objCP = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,10);
                objCP.VCPL_Month__c = 'January';
                objCP.VCPL_CD_Customer__c = objCDAccountnew.Id;
                objCP.VCPL_Assignment_Classification__c ='Others';
                if(System.today().month() > 9){                    
                    objCP.VCPL_Financial_Year__c = String.valueof(System.today().Year()+1);                    
                }
                else                   
                    objCP.VCPL_Financial_Year__c = String.valueof(System.today().Year());               
                insert objCP;
                
                VCPL_Customer_Plan__c objCP2 = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,10);
                objCP2.VCPL_Month__c = 'January';
                objCP2.VCPL_CD_Customer__c = objCDAccount.Id;
                objCP2.VCPL_Assignment_Classification__c ='Others';
                if(System.today().month() > 9){                    
                    objCP2.VCPL_Financial_Year__c = String.valueof(System.today().Year()+1);                    
                }
                else                   
                    objCP2.VCPL_Financial_Year__c = String.valueof(System.today().Year());               
                insert objCP2;
                
                VCPL_Customer_Plan__c objCPnew2 = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,10);
                objCPnew2.VCPL_Month__c = 'January';
                objCPnew2.VCPL_CD_Customer__c = objCDAccountnew.Id;
                objCPnew2.VCPL_Assignment_Classification__c ='Others';
                if(System.today().month() > 9){                    
                    objCPnew2.VCPL_Financial_Year__c = String.valueof(System.today().Year());                    
                }
                else                   
                    objCPnew2.VCPL_Financial_Year__c = String.valueof(System.today().Year()-1);               
                insert objCPnew2;
                
                VCPL_Customer_Plan__c objCPnew = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,10);
                objCPnew.VCPL_Month__c = 'January';
                objCPnew.VCPL_CD_Customer__c = objCDAccount.Id;
                objCPnew.VCPL_Assignment_Classification__c ='Others';
                if(System.today().month() > 9){                    
                    objCPnew.VCPL_Financial_Year__c = String.valueof(System.today().Year());                    
                }
                else                   
                    objCPnew.VCPL_Financial_Year__c = String.valueof(System.today().Year()-1);               
                insert objCPnew;
            }
            System.runas(objPortalBHUser){
                VCPL_CumminsSalesCaptureController.getBranches(null);
                VCPL_CumminsSalesCaptureController.getParentAccount();
                List<VCPL_CumminsSalesCaptureController.DataWrapper> objDataWrap = VCPL_CumminsSalesCaptureController.getData(objaccBranch.Id,objaccDealer.Id);
                for(VCPL_CumminsSalesCaptureController.DataWrapper objwrap :objDataWrap){
                    objwrap.plannedSales =1;
                    objwrap.latestEstSales =1;
                }
                VCPL_CumminsSalesCaptureController.getFilteredValues(JSON.serialize(objDataWrap),'Others',objCDAccount.Name); 
                VCPL_CumminsSalesCaptureController.saveData(JSON.serialize(objDataWrap));
            }
            test.stopTest(); 
            
        }    
    }
}