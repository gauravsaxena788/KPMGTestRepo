@isTest(seeAllData=false)
public class VCPL_BLISControllerTracker {
  public static testmethod void testBLISControllerMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            String strFinacialYear,strActualFinYear;
            if(System.today().month() > 9){                    
                    strFinacialYear = String.valueof(System.today().Year()+1);
                  strActualFinYear = String.valueof(System.today().Year());
                }
            else{            
                    strFinacialYear = String.valueof(System.today().Year());
                  strActualFinYear = String.valueof(System.today().Year()-1);
            }        
            
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
             VCPL_BLISController.getDealers();
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
                VCPL_BLISController.getDealers();
                VCPL_BLISController.getBLISgroups('');
                VCPL_BLIS_Group__c objblisGroup;
                VCPL_Group_Branch__c objBlisbranch;
                VCPL_AVD_QVD__c objAVDQVD;
                VCPL_AVD_QVD__c objAVDQVD1;
                VCPL_Customer_Plan__c objCusPlan;
                VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem;
                VCPL_Secondary_Sales__c objSecSale;
                System.runas(objOtherUser){
                    objCusPlan =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,6);
                    objCusPlan.VCPL_CD_Customer__c = objCDAccountnew.Id;
                    objCusPlan.VCPL_Assignment_Classification__c = 'Others';
                    objCusPlan.VCPL_Financial_Year__c = strFinacialYear;
                    insert objCusPlan;
                    date objdate = Date.newInstance(Integer.valueOf(strActualFinYear), 10, 1);
                    objSecSale = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate,objCusPlan.id);
                    objSecSale.VCPL_Branch_Customer__c = objCusPlan.Id;
                    insert objSecSale;
                    objSecSaleLineItem = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale.Id);
                    insert objSecSaleLineItem;
                    
                    VCPL_Secondary_Sales__c objSecSale1 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(3),objCusPlan.id);
                    objSecSale1.VCPL_Branch_Customer__c = objCusPlan.Id;
                    insert objSecSale1;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem1 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale1.Id);
                    insert objSecSaleLineItem1;
                    
                    VCPL_Secondary_Sales__c objSecSale2 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(6),objCusPlan.id);
                    objSecSale2.VCPL_Branch_Customer__c = objCusPlan.Id;
                    insert objSecSale2;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem2 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale2.Id);
                    insert objSecSaleLineItem2;
                    
                    VCPL_Secondary_Sales__c objSecSale3 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(9),objCusPlan.id);
                    objSecSale3.VCPL_Branch_Customer__c = objCusPlan.Id;
                    insert objSecSale3;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem3 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale3.Id);
                    insert objSecSaleLineItem3;
                    
                    VCPL_Secondary_Sales__c objSecSale4 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(9),objCusPlan.id);
                    objSecSale4.VCPL_Branch_Customer__c = objCusPlan.Id;
                    insert objSecSale4;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem4 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale4.Id);
                    insert objSecSaleLineItem4;
                    
                    VCPL_Customer_Plan__c objCusPlanrev =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,6);
                    objCusPlanrev.VCPL_CD_Customer__c = objCDAccountnew.Id;
                    objCusPlanrev.VCPL_Assignment_Classification__c = 'Others';
                    objCusPlanrev.VCPL_Financial_Year__c = String.valueOf(Integer.valueOf(strFinacialYear)-1);
                    insert objCusPlanrev;
                    date objdateprev = Date.newInstance((Integer.valueOf(strActualFinYear)-1), 10, 1);
                    VCPL_Secondary_Sales__c objSecSaleprev = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdateprev,objCusPlanrev.id);
                    insert objSecSaleprev;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItemprev = IDCumminsTestadataClass.createSecondarySalesItems(objSecSaleprev.Id);
                    insert objSecSaleLineItemprev;
                    
                    VCPL_Secondary_Sales__c objSecSaleprev1 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdateprev.addMonths(3),objCusPlanrev.id);
                    insert objSecSaleprev1;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItemprev1 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSaleprev1.Id);
                    insert objSecSaleLineItemprev1;
                    
                    VCPL_Secondary_Sales__c objSecSaleprev2 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdateprev.addMonths(6),objCusPlanrev.id);
                    insert objSecSaleprev2;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItemprev2 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSaleprev2.Id);
                    insert objSecSaleLineItemprev2;
                    
                    VCPL_Secondary_Sales__c objSecSaleprev3 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdateprev.addMonths(9),objCusPlanrev.id);
                    insert objSecSaleprev3;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItemprev3 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSaleprev3.Id);
                    insert objSecSaleLineItemprev3;
                    
                    VCPL_Secondary_Sales__c objSecSaleprev4 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdateprev.addMonths(9),objCusPlanrev.id);
                    insert objSecSaleprev4;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItemprev4 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSaleprev4.Id);
                    insert objSecSaleLineItemprev4;
                                        
                    objAVDQVD = IDCumminsTestadataClass.createAVDQVD('BLIS',strFinacialYear);
                    insert objAVDQVD;
                    objAVDQVD1 = IDCumminsTestadataClass.createAVDQVD('BLIS',String.valueof(Integer.valueof(strFinacialYear)-1));
                    insert objAVDQVD1; 
                    objblisGroup = IDCumminsTestadataClass.createBlisGroupRecords(objOtherUser,objaccDealer,'Approved');
                    insert objblisGroup;
                    objBlisbranch = IDCumminsTestadataClass.createBlisGroupRecords(objblisGroup,objaccBranch);
                    insert objBlisbranch;  
                }
                VCPL_BLISController.getBLISgroups(objblisGroup.Id);
                VCPL_BLISController.getbranches(objaccDealer.Id);
                VCPL_BLISController.getPicklists();
                VCPL_BLISController.DataWrapper objDataWrap =  VCPL_BLISController.getData(objblisGroup.Id,strFinacialYear,objaccBranch.Id);
                }
            System.runas(objPortalHODUser){
                VCPL_BLISController.getDealers();
            }
        }
    }
}