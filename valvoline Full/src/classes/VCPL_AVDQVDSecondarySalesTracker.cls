@isTest(seeAllData=false)
public class VCPL_AVDQVDSecondarySalesTracker {
    
    public static testMethod void getDealersTest() 
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            Account objaccBranch2 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objPortalUser.Id,True,objaccDealer.id);
            insert objaccBranch2;
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
                VCPL_AVDQVDSecondarySales.getDealers();
            }
            System.runas(objPortalBHUser){  
                VCPL_AVDQVDSecondarySales.getDealers();
                
            }
            System.runas(objOtherUser){
                VCPL_AVDQVDSecondarySales.getDealers();
            }
            test.stopTest();
        } 
    }
    
    public static testMethod void getBLISgroupsTest()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            VCPL_BLIS_Group__c blisRecord = IDCumminsTestadataClass.createBlisGroupRecords(objOtherUser,objaccDealer,'Approved');
            insert blisRecord;
            VCPL_AVDQVDSecondarySales.getBLISgroups(String.valueOf(objaccDealer.Id));
            VCPL_AVDQVDSecondarySales.getBLISgroups(null);
        }
    }
    
    public static testMethod void getBranchesTest()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            
            VCPL_BLIS_Group__c blisRecord = IDCumminsTestadataClass.createBlisGroupRecords(objOtherUser,objaccDealer,'Approved');
            insert blisRecord;
            
            Account objaccDealer2 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,False,'');
            objaccDealer2.parentId = objaccDealer.Id;
            insert objaccDealer2;
            
            Account objaccDealer3 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,False,'');
            objaccDealer3.ParentId= objaccDealer.Id;
            insert objaccDealer3;
            
            VCPL_Group_Branch__c groupBranch = IDCumminsTestadataClass.createBlisGroupRecords(blisRecord,objaccDealer3);
            insert groupBranch;
            
            VCPL_AVDQVDSecondarySales.getbranches(String.valueOf(objaccDealer.Id));
            VCPL_AVDQVDSecondarySales.getbranches(null);
        }
    }
    
    public static testMethod void getConfigsTest()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){
            Id avdRecordTypeId = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
            VCPL_AVD_QVD__c avdqvd = new VCPL_AVD_QVD__c();
            avdqvd.RecordTypeId = avdRecordTypeId;
            avdqvd.VCPL_Fiscal_Year__c = null;
            insert avdqvd;
            VCPL_AVDQVDSecondarySales.getConfigs();
            avdqvd.VCPL_Fiscal_Year__c = '2019';
            update avdqvd;
            VCPL_AVDQVDSecondarySales.getConfigs();
        }
    }
    
    public static testMethod void getPicklistsTest()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            Id avdRecordTypeId = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
            VCPL_AVD_QVD__c avdqvd = new VCPL_AVD_QVD__c();
            avdqvd.RecordTypeId = avdRecordTypeId;
            avdqvd.VCPL_Fiscal_Year__c = '2019';
            insert avdqvd;
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            Account objaccBranch2 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objPortalUser.Id,True,objaccDealer.id);
            insert objaccBranch2;
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
                VCPL_AVDQVDSecondarySales.getPicklists();
            }
            System.runas(objPortalBHUser){  
                VCPL_AVDQVDSecondarySales.getPicklists();
                
            }
            System.runas(objOtherUser){
                VCPL_AVDQVDSecondarySales.getPicklists();
            }
            test.stopTest();
        } 
    }
    
    public static testMethod void getDataTest()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        System.runas(objOtherUser){
            
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            
            Account objaccDealer2 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,False,'');
            objaccDealer2.parentId = objaccDealer.Id;
            insert objaccDealer2;
            
            Account objaccDealer3 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,False,'');
            objaccDealer3.ParentId= objaccDealer.Id;
            insert objaccDealer3;
            
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
            
            VCPL_AVDQVDSecondarySales.getData(String.valueOf(objaccDealer.Id),'2019');
            VCPL_AVDQVDSecondarySales.getData(String.valueOf(objaccDealer.Id),'2020');
        }
    }
}