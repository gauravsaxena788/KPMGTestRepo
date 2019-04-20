@isTest
public class BatchClassforCreatetCustomerplanTracker {
    static testMethod void testBatchForCreateTopTwentyMethod() 
    {
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
            system.debug('===strFinacialYear==='+strFinacialYear+'===strActualFinYear===='+strActualFinYear);
            
            
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
            objCDAccountnew.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO71';
            objCDAccountnew.Is_Parent__c ='Y';
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
            System.runas(objOtherUser){               
                VCPL_Customer_Plan__c objCusPlanDea =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,6);
                objCusPlanDea.VCPL_CD_Customer__c = objCDAccount.Id;
                objCusPlanDea.VCPL_Customer_Account__c = objaccBranch.Id;
                objCusPlanDea.VCPL_Assignment_Classification__c = 'Others';
                objCusPlanDea.VCPL_Potential__c = 90;
                objCusPlanDea.VCPL_Last_Year_Sales_Vol__c =90;
                objCusPlanDea.VCPL_Financial_Year__c = strActualFinYear;
                objCusPlanDea.VCPL_Last_Financial_Year__c = true;
                insert objCusPlanDea;
                VCPL_Customer_Plan__c objCusPlan =  IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Branch_Customer',objaccBranch,6);
                objCusPlan.VCPL_CD_Customer__c = objCDAccountnew.Id;
                objCusPlan.VCPL_Customer_Account__c = objaccBranch.Id;
                objCusPlan.VCPL_Assignment_Classification__c = 'Others';
                objCusPlan.VCPL_Potential__c = 90;
                objCusPlan.VCPL_Last_Year_Sales_Vol__c =90;
                objCusPlan.VCPL_Financial_Year__c = strActualFinYear;
                objCusPlan.VCPL_Last_Financial_Year__c = true;
                insert objCusPlan;
                
                Test.startTest();
                BatchForCreateTopTwentyCustomerPlan batchUpdatenoti = new BatchForCreateTopTwentyCustomerPlan();
                DataBase.executeBatch(batchUpdatenoti); 
                Test.stopTest();
            }
        }
    }
}