@isTest
public class VA_AccountTriggerHandlerTracker {
    public static testmethod void testAcountTriggerMethod(){
        User objOtherUsernew = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUsernew.Street ='Sector-58';
        objOtherUsernew.City ='Noida';
        objOtherUsernew.State ='Uttar Pradesh';
        objOtherUsernew.Country = 'India';
        objOtherUsernew.PostalCode = '201301';
        insert objOtherUsernew;
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        Account objaccID ;
        Contact conIDAcc ;
        Opportunity objOpp;
        Quote objQuote;
        
        System.runas(objOtherUser){
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUser.id);
            objPortalUser.VCPL_ID_Head__c = objOtherUsernew.Id;
            insert objPortalUser;
            System.runas(objPortalUser){
                VA_Trigger_Settings__c objTriggerSetting = new VA_Trigger_Settings__c();
                objTriggerSetting.Name ='AccountTrigger';
                objTriggerSetting.VA_Is_Trigger_Disabled__c = false;
                insert objTriggerSetting;
                objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.BillingCity='KLD';
                objaccID.Is_Parent__c = 'N';
                insert objaccID;
                conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                               MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
                
                insert conIDAcc;             
                objOpp= IDCumminsTestadataClass.returnBDOpportunityTestdata('Business_Development','Test Gona Opport',objaccID);
                insert objOpp;
                
                objaccID.VCPL_Current_Month_Engine_Oil_Sales__c = 20000;
                update objaccID;
                
                objaccID.VCPL_Current_Month_Engine_Oil_Sales__c = 60000;
                update objaccID;
                
                System.runas(objOtherUser){
                }
               
                System.runas(objOtherUser){
                    
                }
            }
            System.runas(objOtherUser){
              }
             System.runas(objPortalUser){
                  
                }
        }
    }

    public static testMethod void getDataTest()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        
        
        System.runas(objOtherUser){
            VA_Trigger_Settings__c objTriggerSetting = new VA_Trigger_Settings__c();
            objTriggerSetting.Name ='AccountTrigger';
            objTriggerSetting.VA_Is_Trigger_Disabled__c = false;
            insert objTriggerSetting;
        
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            
            Account objacc2Dealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objacc2Dealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objacc2Dealer;
            
            Account objaccDealer2 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,False,'');
            objaccDealer2.parentId = objaccDealer.Id;
            insert objaccDealer2;
            
            Account objaccDealer3 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,False,'');
            objaccDealer3.ParentId= objaccDealer.Id;
            insert objaccDealer3;
            
            Contact HOD1 = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert HOD1;
            
            User HOD1User = IDCumminsTestadataClass.createUser('CD HOD Partner User',True,objOtherUser.Id);
            HOD1User.Contactid = HOD1.Id;
            HOD1User.VCPL_Contact_Role__c = 'HOD';
            insert HOD1User;
            
            Contact HOD2 = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objacc2Dealer.Id);
            insert HOD2;
            
            User HOD2User = IDCumminsTestadataClass.createUser('CD HOD Partner User',True,objOtherUser.Id);
            HOD2User.Contactid = HOD2.Id;
            HOD2User.VCPL_Contact_Role__c = 'HOD';
            insert HOD2User;
            
            VCPL_AVD_QVD__c avdqvd = IDCumminsTestadataClass.createAVDQVD('BLIS','2019');
            insert avdqvd;
            
            VCPL_AVD_QVD__c avdqvd1 = IDCumminsTestadataClass.createAVDQVD('BLIS','2020');
            insert avdqvd1;
            
            VCPL_Customer_Plan__c customerPlan = IDCumminsTestadataClass.createCustomerPlan(objaccDealer2.Id);
            insert customerPlan;
            
            VCPL_Secondary_Sales__c secondarySales = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today(),customerPlan.Id);
            insert secondarySales;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales.Id);
            insert secondarySaleItem;
            
            VCPL_Customer_Plan__c customerPlan2 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer2.Id);
            insert customerPlan2;
            
            VCPL_Secondary_Sales__c secondarySales2 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(10),customerPlan2.Id);
            insert secondarySales2;

            VCPL_Secondary_Sales_LineItem__c secondarySaleItem2 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales2.Id);
            insert secondarySaleItem2;
            
            VCPL_Customer_Plan__c customerPlan3 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer2.Id);
            insert customerPlan3;
            
             VCPL_Secondary_Sales__c secondarySales3 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(91),customerPlan3.Id);
            insert secondarySales3;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem3 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales3.Id);
            insert secondarySaleItem3;
            
            VCPL_Customer_Plan__c customerPlan4 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer2.Id);
            insert customerPlan4;
            
            VCPL_Secondary_Sales__c secondarySales4 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(195),customerPlan4.Id);
            insert secondarySales4;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem4 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales4.Id);
            insert secondarySaleItem4;
            
            VCPL_Customer_Plan__c customerPlan5 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer2.Id);
            insert customerPlan5;
            
            VCPL_Secondary_Sales__c secondarySales5 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(290),customerPlan5.Id);
            insert secondarySales5;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem5 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales5.Id);
            insert secondarySaleItem5;
            
            VCPL_BLIS_Group__c blisRecord = IDCumminsTestadataClass.createBlisGroupRecords(objOtherUser,objaccDealer,'Approved');
            insert blisRecord;
            
            VCPL_Group_Branch__c groupBranch = IDCumminsTestadataClass.createBlisGroupRecords(blisRecord,objaccDealer3);
            insert groupBranch;
            
            VCPL_Customer_Plan__c customerPlan6 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer3.Id);
            insert customerPlan6;
            
            VCPL_Secondary_Sales__c secondarySales6 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today(),customerPlan6.Id);
            insert secondarySales6;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem6 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales6.Id);
            insert secondarySaleItem6;
            
            VCPL_Customer_Plan__c customerPlan7 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer3.Id);
            insert customerPlan7;
            
            VCPL_Secondary_Sales__c secondarySales7 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(10),customerPlan7.Id);
            insert secondarySales7;

            VCPL_Secondary_Sales_LineItem__c secondarySaleItem7 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales7.Id);
            insert secondarySaleItem7;
            
            VCPL_Customer_Plan__c customerPlan8 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer3.Id);
            insert customerPlan8;
            
             VCPL_Secondary_Sales__c secondarySales8 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(91),customerPlan8.Id);
            insert secondarySales8;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem8 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales8.Id);
            insert secondarySaleItem8;
            
            VCPL_Customer_Plan__c customerPlan9 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer3.Id);
            insert customerPlan9;
            
            VCPL_Secondary_Sales__c secondarySales9 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(195),customerPlan9.Id);
            insert secondarySales9;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem9 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales9.Id);
            insert secondarySaleItem9;
            
            VCPL_Customer_Plan__c customerPlan10 = IDCumminsTestadataClass.createCustomerPlan(objaccDealer3.Id);
            insert customerPlan10;
            
            VCPL_Secondary_Sales__c secondarySales10 = IDCumminsTestadataClass.createSecondarySales('CD Secondary Sales',System.today().addDays(290),customerPlan10.Id);
            insert secondarySales10;
            
            VCPL_Secondary_Sales_LineItem__c secondarySaleItem10 = IDCumminsTestadataClass.createSecondarySalesItems(secondarySales10.Id);
            insert secondarySaleItem10;
            
            objaccDealer3.VCPL_Current_Month_Engine_Oil_Sales__c = 60000;
            update objaccDealer3;
            
            objaccDealer3.parentId = objacc2Dealer.Id;
            update objaccDealer3;
        }
    }
}