@isTest(seeAllData=false)
public class VCPL_AccountAssignmentTracker {
    public static testmethod void testAccountAssignMethod(){
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
                String parentAccountId = VCPL_AccountAssignmentController.getParentAccount();
                List<VCPL_AccountAssignmentController.dataWrapper> lstWrap = VCPL_AccountAssignmentController.getData('');
                VCPL_AccountAssignmentController.getFilteredValues(JSON.serialize(lstWrap),'','') ;        
                VCPL_AccountAssignmentController.saveData(JSON.serialize(lstWrap));
            }
            System.runas(objPortalHODUser){
                List<VCPL_AccountAssignmentController.dataWrapper> lstWrap = VCPL_AccountAssignmentController.getData('');
                VCPL_AccountAssignmentController.getFilteredValues(JSON.serialize(lstWrap),'','') ;        
                VCPL_AccountAssignmentController.saveData(JSON.serialize(lstWrap));
            }
             System.runas(objOtherUser){
                
                VCPL_Customer_Plan__c objCP = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objCDAccountnew,10);
                objCP.VCPL_Month__c = 'January';
                if(System.today().month() > 9){                    
                    objCP.VCPL_Financial_Year__c = String.valueof(System.today().Year()+1);                    
                }
                else                   
                    objCP.VCPL_Financial_Year__c = String.valueof(System.today().Year());               
                insert objCP;
                
                VCPL_Customer_Plan__c objCP2 = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objCDAccount,10);
                objCP2.VCPL_Month__c = 'January';
                if(System.today().month() > 9){                    
                    objCP2.VCPL_Financial_Year__c = String.valueof(System.today().Year()+1);                    
                }
                else                   
                    objCP2.VCPL_Financial_Year__c = String.valueof(System.today().Year());               
                insert objCP2;
                
                VCPL_Customer_Plan__c objCPnew2 = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objCDAccountnew,10);
                objCPnew2.VCPL_Month__c = 'January';
                if(System.today().month() > 9){                    
                    objCPnew2.VCPL_Financial_Year__c = String.valueof(System.today().Year());                    
                }
                else                   
                    objCPnew2.VCPL_Financial_Year__c = String.valueof(System.today().Year()-1);               
                insert objCPnew2;
                
                VCPL_Customer_Plan__c objCPnew = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objCDAccount,10);
                objCPnew.VCPL_Month__c = 'January';
                if(System.today().month() > 9){                    
                    objCPnew.VCPL_Financial_Year__c = String.valueof(System.today().Year());                    
                }
                else                   
                    objCPnew.VCPL_Financial_Year__c = String.valueof(System.today().Year()-1);               
                insert objCPnew;
                 List<VCPL_AccountAssignmentController.dataWrapper> lstWrap = VCPL_AccountAssignmentController.getData('');
                VCPL_AccountAssignmentController.getFilteredValues(JSON.serialize(lstWrap),'','') ;        
                VCPL_AccountAssignmentController.saveData(JSON.serialize(lstWrap));
            }
            System.runas(objPortalHODUser){
                String parentAccountId = VCPL_AccountAssignmentController.getParentAccount();
                List<VCPL_AccountAssignmentController.dataWrapper> lstWrap = VCPL_AccountAssignmentController.getData(parentAccountId);
                VCPL_AccountAssignmentController.getFilteredValues(JSON.serialize(lstWrap),'','') ;        
                VCPL_AccountAssignmentController.saveData(JSON.serialize(lstWrap));
            }
            test.stopTest(); 
            
        }    
    }
}