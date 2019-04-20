@isTest
public class VCPLControllerDealerScoreCardTracker
{
    static VCPL_Score_Card__c objScoreCard;
    Static VCPL_Score_Card_Parameters__c objSCP;
    Static VCPL_Score_Card__c objDSC;
    Static VCPL_Score_Card_LineItem__c objSCLI ;
    static VCPL_Score_Card_LineItem__c LineItem1; 
    static VCPL_Score_Card_Parameters__c Parameter1;
    static VCPL_Score_Card_Parameters__c Parameter2;
    
    static List<VCPL_Score_Card_LineItem__c> ScoreCardlist;
    
    public static testmethod void TestControllerDealerScoreCard()
    {
        String strFinacialYear,strActualFinYear;
        if(System.today().month() > 9){                    
            strFinacialYear = String.valueof(System.today().Year()+1); 
            strActualFinYear = String.valueof(System.today().Year());
        }
        else{                   
            strFinacialYear = String.valueof(System.today().Year());
            strActualFinYear = String.valueof(System.today().Year()-1); 
        } 
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objOtherSMUser = IDCumminsTestadataClass.createUser('SM',False,'');
        insert objOtherSMUser;
        system.runAs(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VCPL_Cummins_Dealer').getRecordTypeId();
            Account ac = new Account(name ='Grazitti'+(math.random()*10).intValue()) ;
            ac.Indutry_Segment__c = 'Industrial';
            ac.RecordTypeId = accRecordTypeId; 
            ac.BU_Name__c = 'C&I';
            ac.Account_Type__c = 'Industrial Distributor';
            ac.Market_Segment__c = 'Industrial Distributor';
            ac.Zone__c = 'East';            
            ac.OwnerId = objOtherUser.Id;              
            insert ac;
            
            VCPL_AVD_QVD__c objAVD = new VCPL_AVD_QVD__c();           
            objAVD.VCPL_Fiscal_Year__c = strActualFinYear;
            objAVD.VCPL_Growth_Slab_1_In_Percentage__c = 90;
            objAVD.VCPL_Growth_Slab_2_In_Percentage__c = 90;
            objAVD.VCPL_Growth_Slab_3_In_Percentage__c = 90;
            objAVD.VCPL_Growth_Slab_4_In_Percentage__c = 90;
            objAVD.VCPL_Incentive_Slab_1_AVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_1_QVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_2_AVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_2_QVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_3_AVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_3_QVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_4_AVD_In_R_L__c = 90;
            objAVD.VCPL_Incentive_Slab_4_QVD_In_R_L__c = 90;
            objAVD.RecordTypeId = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
            insert objAVD;
            Product2 objprod = IDCumminsTestadataClass.returnTestProduct();
            objprod.PH6_Qlikview__c = 'Cummins Oil';
            insert objprod;
            Account objCDAccountnew = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','GONA CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccountnew.Service_By__c ='Dealer';
            objCDAccountnew.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO71';
            objCDAccountnew.Is_Parent__c ='Y';
            objCDAccountnew.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccountnew.Status__c = 'Activated';
            insert objCDAccountnew; 
            Account objCDAccount = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','GONA CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccount.Service_By__c ='Dealer';
            objCDAccount.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO73';
            objCDAccount.Is_Parent__c ='Y';
            objCDAccount.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccount.Status__c = 'Activated';
            insert objCDAccount; 
            VCPL_Customer_Plan__c objCusPlan =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,6);
            objCusPlan.VCPL_CD_Customer__c = objCDAccountnew.Id;
            objCusPlan.VCPL_Assignment_Classification__c = 'Target 20';
            //objCusPlan.VCPL_Assignment_Classification__c = 'Others';
            objCusPlan.VCPL_Last_Year_Sales_Vol__c =90;
            objCusPlan.VCPL_Financial_Year__c = strFinacialYear;
            insert objCusPlan; 
            VCPL_Customer_Plan__c objCusPlanDea =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Dealer_Customer',objaccDealer,6);
            objCusPlanDea.VCPL_CD_Customer__c = objCDAccount.Id;
            objCusPlan.VCPL_Assignment_Classification__c = 'Target 20';
            //objCusPlanDea.VCPL_Assignment_Classification__c = 'Others';
            objCusPlanDea.VCPL_Potential__c = 90;
            objCusPlanDea.VCPL_Last_Year_Sales_Vol__c =90;
            objCusPlanDea.VCPL_Financial_Year__c = strFinacialYear;
            insert objCusPlanDea;
            VCPL_Customer_Plan__c objCusPlanDea2 =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Dealer_Customer',objaccDealer,6);
            objCusPlanDea2.VCPL_CD_Customer__c = objCDAccountnew.Id;
            objCusPlan.VCPL_Assignment_Classification__c = 'Target 20';
            // objCusPlanDea2.VCPL_Assignment_Classification__c = 'Others';
            objCusPlanDea2.VCPL_Last_Year_Sales_Vol__c =90;
            objCusPlanDea2.VCPL_CD_Customer__c = objCDAccountnew.Id;
            objCusPlanDea2.VCPL_Potential__c = 90;
            objCusPlanDea2.VCPL_Financial_Year__c = strFinacialYear;
            insert objCusPlanDea2;
            // Monthly Plan
            date objdate = Date.newInstance((Integer.valueOf(strActualFinYear)-1), 10, 1);
            VCPL_Secondary_Sales__c objSecSale = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate,objCusPlan.id);
            objSecSale.VCPL_Branch_Customer__c = objCusPlan.Id;
            objSecSale.VCPL_Dealer_Customer__c = objCusPlanDea.Id;
            insert objSecSale;
            VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale.Id);
            objSecSaleLineItem.VCPL_Vol_in_Ltrs__c =90;
            objSecSaleLineItem.VCPL_CDOS_Classification__c ='CO';
            objSecSaleLineItem.VCPL_Product__c = objprod.Id;
            insert objSecSaleLineItem;
            
            VCPL_Secondary_Sales__c objSecSale1 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(3),objCusPlan.id);
            objSecSale1.VCPL_Branch_Customer__c = objCusPlan.Id;
            objSecSale1.VCPL_Dealer_Customer__c = objCusPlanDea.Id;
            insert objSecSale1;
            VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem1 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale1.Id);
            objSecSaleLineItem1.VCPL_Vol_in_Ltrs__c =90;
            objSecSaleLineItem1.VCPL_CDOS_Classification__c ='CO';
            objSecSaleLineItem1.VCPL_Product__c = objprod.Id;
            insert objSecSaleLineItem1;
            update objSecSale1;
            
            VCPL_Secondary_Sales__c objSecSale2 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',objdate.addMonths(6),objCusPlan.id);
            objSecSale2.VCPL_Branch_Customer__c = objCusPlan.Id;
            objSecSale2.VCPL_Dealer_Customer__c = objCusPlanDea.Id;
            insert objSecSale2;
            VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem2 = IDCumminsTestadataClass.createSecondarySalesItems(objSecSale2.Id);
            objSecSaleLineItem2.VCPL_Vol_in_Ltrs__c =90;
            objSecSaleLineItem2.VCPL_CDOS_Classification__c ='CO';
            objSecSaleLineItem2.VCPL_Product__c = objprod.Id;
            insert objSecSaleLineItem2;
            
            Set<String> setOfParam = new Set<String>{'nonDiscountedVolumeGrowth',
                'primaryGrowth',
                'secondaryGrowth',
                'dealerPenetration',
                'filterBuyPercentage',
                'dealerTop20Potential',
                'dealerTarget20Potential',
                'dealerTarget20CYSales',
                'dealerTop20CYSales',
                'dealerTop20CYEstimateSales',
                'dealerTarget20CYEstimateSales'};
                    
                    VCPL_Score_Card__c objDSC = new VCPL_Score_Card__c();
            objDSC.VCPL_Account__c = objaccDealer.Id;
            objDSC.VCPL_As_of__c = 'September';
            objDSC.VCPL_Financial_Year__c = strActualFinYear;
            objDSC.VCPL_Score_Card_Status__c = 'Approved';
            objDSC.VCPL_Segment_Manager__c = objOtherSMUser.Id; 
            insert objDSC; 
            VCPL_Score_Card_Parameters__c objSCP = new VCPL_Score_Card_Parameters__c();
            objSCP.VCPL_Active__c = true;
            objSCP.VCPL_Description__c ='Test';
            objSCP.VCPL_Max_Score__c = 6;
            objSCP.VCPL_Score_Scale__c = 'Teetrghgcgavjbhj';
            objSCP.VCPL_Value_Type__c = 'Manual';
            objSCP.VCPL_Calculation_Method_Name__c ='nonDiscountedVolumeGrowth';
            insert objSCP;
            VCPL_Score_Card_LineItem__c objSCLI = new VCPL_Score_Card_LineItem__c();
            objSCLI.VCPL_Comments__c = 'Testcomments';
            objSCLI.VCPL_Dealer_Score__c = 9;
            objSCLI.VCPL_Score_Card__c= objDSC.Id;
            objSCLI.VCPL_Score_Card_Parameter__c = objSCP.Id;
            objSCLI.VCPL_Value__c = 6;
            insert objSCLI;
            List<VCPL_Score_Card_LineItem__c> lstSCP = new List<VCPL_Score_Card_LineItem__c>();
            lstSCP.add(objSCLI);
            
            parameter1= new VCPL_Score_Card_Parameters__c();
            parameter1.name= 'test paramter';
            parameter1.VCPL_Value_Type__c='Calculated';
            parameter1.VCPL_Active__c= true;
            parameter1.VCPL_Description__c = 'sadsasdfghjk';
            parameter1.VCPL_Max_Score__c = 20;
            parameter1.VCPL_Score_Scale__c='asdf';
            parameter1.VCPL_Calculation_Method_Name__c= 'asdfghj';
               
            
            objDSC = new VCPL_Score_Card__c();
            objDSC.VCPL_Account__c = objaccDealer.Id;
            objDSC.VCPL_As_of__c = 'September';
            objDSC.VCPL_Financial_Year__c = strActualFinYear;
            objDSC.VCPL_Score_Card_Status__c = 'Approved';
            objDSC.VCPL_Segment_Manager__c = objOtherSMUser.Id; 
            insert objDSC; 
            objSCP = new VCPL_Score_Card_Parameters__c();
            objSCP.VCPL_Active__c = true;
            objSCP.VCPL_Description__c ='Test';
            objSCP.VCPL_Max_Score__c = 6;
            objSCP.VCPL_Score_Scale__c = 'Teetrghgcgavjbhj';
            objSCP.VCPL_Value_Type__c = 'Manual';
            objSCP.VCPL_Calculation_Method_Name__c ='nonDiscountedVolumeGrowth';
            insert objSCP;
            objSCLI = new VCPL_Score_Card_LineItem__c();
            objSCLI.VCPL_Comments__c = 'Testcomments';
            objSCLI.VCPL_Dealer_Score__c = 9;
            objSCLI.VCPL_Score_Card__c= objDSC.Id;
            objSCLI.VCPL_Score_Card_Parameter__c = objSCP.Id;
            objSCLI.VCPL_Value__c = 6;
            insert objSCLI; 
            ScoreCardlist = new List<VCPL_Score_Card_LineItem__c>();
            ScoreCardlist.add(objSCLI);
            new VCPLControllerDealerScoreCard();
            
            System.debug('Score Card : ' +objDSC);
            new VCPLControllerDealerScoreCard(objDSC);
            new VCPLControllerDealerScoreCard(objDSC.id);
            
            
            VCPLControllerDealerScoreCard objDSCController = new VCPLControllerDealerScoreCard(objDSC);
            System.debug('Score Card : ' +objDSC);
            objDSCController.getScoreCardMasterRecordData(objSCP.id);
            VCPLControllerDealerScoreCard objDSCControllernew = new VCPLControllerDealerScoreCard(objDSC.Id);
            objDSCControllernew.getScoreCardMasterRecordData(objSCP.id);
            System.debug('Score Card : ' +objDSC);
            objDSCControllernew.getScoreCardLineItems();
            System.debug('Score Card : ' +objDSC);
            objDSCController.upsertScoreCardLineItems();
            objDSCControllernew.setListUsingActiveScoreCardParameters();
            insert parameter1;
            new VCPLControllerDealerScoreCard(ScoreCardlist, objDSC.id);
        }
    }
}