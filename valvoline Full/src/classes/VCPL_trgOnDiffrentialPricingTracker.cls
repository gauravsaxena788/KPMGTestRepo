@isTest
public class VCPL_trgOnDiffrentialPricingTracker{
    public static testmethod void testDifferentailPricingMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        Product2 objprod ;
        
        System.runas(objOtherUser){            
            VA_Trigger_Settings__c objTriggerSetting = new VA_Trigger_Settings__c();
            objTriggerSetting.Name ='DifferentialPricing';
            objTriggerSetting.VA_Is_Trigger_Disabled__c = false;
            insert objTriggerSetting;
            String strFinacialYear,strActualFinYear;
            if(System.today().month() > 9){                    
                strFinacialYear = String.valueof(System.today().Year()+1); 
                strActualFinYear = String.valueof(System.today().Year());
            }
            else{                   
                strFinacialYear = String.valueof(System.today().Year());
                strActualFinYear = String.valueof(System.today().Year()-1);
            } 
            
            
            
            Account objCDAccountparent = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','P S CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccountparent.Service_By__c ='Dealer';
            objCDAccountparent.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO69';
            objCDAccountparent.Is_Parent__c ='Y';
            objCDAccountparent.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccountparent.Status__c = 'Draft';
            insert objCDAccountparent;
            
            Account objCDAccount = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','P S CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccount.Service_By__c ='Dealer';
            objCDAccount.ParentId = objCDAccountparent.Id;
            objCDAccount.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO7O';
            objCDAccount.Is_Parent__c ='N';
            objCDAccount.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccount.Status__c = 'Activated';
            insert objCDAccount;
            
            Account objCDAccountnew = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','GONA CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccountnew.Service_By__c ='Dealer';
            objCDAccountnew.ParentId = objCDAccountparent.Id;
            objCDAccountnew.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO71';
            objCDAccountnew.Is_Parent__c ='N';
            objCDAccountnew.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccountnew.Status__c = 'Activated';
            insert objCDAccountnew;
            
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            
            VCPL_Dealer_Customer_Mapping__c objDCM = new VCPL_Dealer_Customer_Mapping__c(VCPL_Customer_Account__c = objCDAccountnew.id,VCPL_Dealer_Account__c = objaccDealer.Id);
            insert objDCM;
            VCPL_Dealer_Customer_Mapping__c objDCM2 = new VCPL_Dealer_Customer_Mapping__c(VCPL_Customer_Account__c = objCDAccount.id,VCPL_Dealer_Account__c = objaccDealer.Id);
            insert objDCM2;
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
                objprod = IDCumminsTestadataClass.returnTestProduct();
                insert objprod;
                CD_SKU_Mapping__c objCDSKU = new CD_SKU_Mapping__c();
                objCDSKU.Name ='123456';
                objCDSKU.VCPL_Product_SKU_Id__c = '123456';
                insert objCDSKU;
                
                VCPL_Differential_Pricing__c objDPnew = IDCumminsTestadataClass.returnDPData(objaccBranch, objCDAccountnew, objprod);
                objDPnew.VCPL_Dealer_Name__c = objaccDealer.Id;
                objDPnew.VCPL_DAM__c = objPortalHODUser.Id;
                objDPnew.VCPL_Alert_message_for_Branch_Head__c ='Test';
                objDPnew.VCPL_Discount_L__c = 101;
                objDPnew.VCPL_Validity_Start_Date__c = system.today().addDays(-1);
                objDPnew.VCPL_DP_Expiry_Date__c= system.today().addDays(180);
                objDPnew.VCPL_HOD__c = objPortalHODUser.Id;
                //objDPnew.VCPL_DP_Request_Status__c='Approved';
                insert objDPnew;
                
                objELPAssign = new VCPL_ELP_Assignment__c(); 
                objELPAssign.Name = 'TestELPASSIGN';
                objELPAssign.VCPL_Branch__c =objaccBranch.Id;
                objELPAssign.VCPL_User__c = objPortalUser.Id;
                objELPAssign.VCPL_isActive__c = true;
                insert objELPAssign;
                objDPnew.VCPL_DP_Request_Status__c='Approved';
                update objDPnew;
                              
                
                VCPL_Differential_Pricing__c objDP = IDCumminsTestadataClass.returnDPData(objaccBranch, objCDAccountnew, objprod);
                objDP.VCPL_Dealer_Name__c = objaccDealer.Id;
                objDP.VCPL_DAM__c = objPortalHODUser.Id;
                objDP.VCPL_Alert_message_for_Branch_Head__c ='Test';
                objDP.VCPL_Discount_L__c = 101;
                objDP.VCPL_Validity_Start_Date__c = system.today().addDays(181);
                objDP.VCPL_DP_Expiry_Date__c= system.today().addDays(360);
                objDP.VCPL_HOD__c = objPortalHODUser.Id;
                objDPnew.VCPL_DP_Request_Status__c='Approved';
                insert objDP;
                String oldata = objDPnew.VCPL_Customer_Code__c;
                objDPnew.VCPL_Customer_Code__c=oldata+'u';
                update objDPnew;  
            }
            test.startTest();
            System.runas(objPortalUser){ 
                VCPL_Customer_Plan__c objCusPlan;
                VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem;
                VCPL_Secondary_Sales__c objSecSale;
                Account objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.ShippingCity = 'RKL';
                if(objPortalUser != null && !string.isBlank(objPortalUser.AccountId))
                    objaccID.ParentId =objPortalUser.AccountId;
                insert objaccID;
                map<Integer,String> mapofMonth = VCPL_MonthlySalesPlanController.getMonthName();
                string strCurrentMonth = mapofMonth.get(system.today().month());
                System.runas(objOtherUser){
                    VCPL_Customer_Plan__c objCP = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Monthly_Plan',objaccID,10);
                    objCP.VCPL_Month__c = strCurrentMonth;
                    objCP.VCPL_Last_Year_Sales_Vol__c = 90;          
                    objCP.VCPL_Financial_Year__c = strFinacialYear;               
                    insert objCP;
                    
                    VCPL_Customer_Plan__c objCP2 = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Monthly_Plan',objaccID,10);
                    objCP2.VCPL_Month__c = strCurrentMonth;
                    objCP2.VCPL_Last_Year_Sales_Vol__c = 90;
                    objCP2.VCPL_Financial_Year__c = strFinacialYear;                   
                    insert objCP2;
                    objCusPlan =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,6);
                    objCusPlan.VCPL_CD_Customer__c = objCDAccountnew.Id;
                    objCusPlan.VCPL_Assignment_Classification__c = 'Others';
                    objCusPlan.VCPL_CD_Customer__c = objCDAccountnew.Id;
                    objCusPlan.VCPL_Last_Year_Sales_Vol__c =90;
                    objCusPlan.VCPL_Financial_Year__c = strFinacialYear;
                    insert objCusPlan; 
                    VCPL_Customer_Plan__c objCusPlanDea =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Dealer_Customer',objaccDealer,6);
                    objCusPlanDea.VCPL_CD_Customer__c = objCDAccount.Id;
                    objCusPlanDea.VCPL_Assignment_Classification__c = 'Others';
                    objCusPlanDea.VCPL_CD_Customer__c = objCDAccount.Id;
                    objCusPlanDea.VCPL_Potential__c = 90;
                    objCusPlanDea.VCPL_Last_Year_Sales_Vol__c =90;
                    objCusPlanDea.VCPL_Financial_Year__c = strFinacialYear;
                    insert objCusPlanDea;
                    VCPL_Customer_Plan__c objCusPlanDea2 =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Dealer_Customer',objaccDealer,6);
                    objCusPlanDea2.VCPL_CD_Customer__c = objCDAccountnew.Id;
                    objCusPlanDea2.VCPL_Assignment_Classification__c = 'Others';
                    objCusPlanDea2.VCPL_Last_Year_Sales_Vol__c =90;
                    objCusPlanDea2.VCPL_CD_Customer__c = objCDAccountnew.Id;
                    objCusPlanDea2.VCPL_Potential__c = 90;
                    objCusPlanDea2.VCPL_Financial_Year__c = strFinacialYear;
                    insert objCusPlanDea2;
                    // Monthly Plan
                    date objdate = Date.newInstance(Integer.valueOf(strActualFinYear), 10, 1);
                    objSecSale = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today(),objCusPlan.id);
                    objSecSale.VCPL_Branch_Customer__c = objCusPlan.Id;
                    objSecSale.Account__c = objCDAccountnew.Id;
                    objSecSale.VCPL_CDOS_Account_Id__c = objCDAccountnew.VCPL_CDOS_AccountId__c;
                    insert objSecSale;
                    objSecSaleLineItem = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale.Id);
                    objSecSaleLineItem.VCPL_Vol_in_Ltrs__c =90;                   
                    objSecSaleLineItem.VCPL_Product__c = objprod.Id;
                    objSecSaleLineItem.VCPL_CDOS_Classification__c ='CO';
                    objSecSaleLineItem.VCPL_CDOS_Classification__c ='CO';
                    insert objSecSaleLineItem;
                    update objSecSaleLineItem;
                    VCPL_Secondary_Sales__c objSecSale1 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addDays(3),objCusPlan.id);
                    objSecSale1.VCPL_Branch_Customer__c = objCusPlan.Id;                    
                    objSecSale1.VCPL_Dealer_Customer__c = objCusPlanDea.Id;
                    objSecSale1.Account__c = objCDAccountnew.Id;
                    objSecSale1.VCPL_CDOS_Account_Id__c = objCDAccountnew.VCPL_CDOS_AccountId__c;
                    insert objSecSale1;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem1 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale1.Id);
                    objSecSaleLineItem1.VCPL_Vol_in_Ltrs__c =90;                   
                    objSecSaleLineItem1.VCPL_Product__c = objprod.Id;
                    objSecSaleLineItem1.VCPL_CDOS_Classification__c ='IO';
                    insert objSecSaleLineItem1;
                    update objSecSale1;
                    
                    VCPL_Secondary_Sales__c objSecSale2 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(6),objCusPlan.id);
                    objSecSale2.VCPL_Branch_Customer__c = objCusPlan.Id;
                    objSecSale2.VCPL_Dealer_Customer__c = objCusPlanDea.Id;
                    insert objSecSale2;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem2 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale2.Id);
                    objSecSaleLineItem2.VCPL_Vol_in_Ltrs__c =90;                    
                    objSecSaleLineItem2.VCPL_Product__c = objprod.Id;
                    objSecSaleLineItem2.VCPL_CDOS_Classification__c ='IO';
                    //insert objSecSaleLineItem2;
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem21 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale2.Id);
                    objSecSaleLineItem21.VCPL_Vol_in_Ltrs__c =90;
                    objSecSaleLineItem21.VCPL_CDOS_Classification__c ='CO';                   
                    objSecSaleLineItem21.VCPL_Product__c = objprod.Id;
                    List<VCPL_Secondary_Sales_LineItem__c> lstSSLI = new List<VCPL_Secondary_Sales_LineItem__c>();
                    lstSSLI.add(objSecSaleLineItem21);
                    lstSSLI.add(objSecSaleLineItem2);
                    insert lstSSLI; 
                    VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem211 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale2.Id);
                    objSecSaleLineItem211.VCPL_Vol_in_Ltrs__c =90;                   
                    objSecSaleLineItem211.VCPL_Product__c = objprod.Id;
                    objSecSaleLineItem211.VCPL_CDOS_Classification__c ='CO';
                    insert objSecSaleLineItem211; 
                    
                }
            }
            test.stopTest();
        }
        
    }
}