@isTest
public class VCPL_CustomerSalesPlanControllerTracker {
	public static testmethod void testCustomerPlanControllerMethod(){
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
           
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.Ship_to_Code__c = '787466';
            insert objaccDealer;
            
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUser.id);
            //objPortalUser.VCPL_ID_Head__c = objOtherUsernew.Id;
            insert objPortalUser;
            
            
            System.runas(objOtherUser){
            }
            test.startTest();
            System.runas(objPortalUser){ 
                
                VCPL_Customer_Plan__c objCusPlan;
                VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem;
                VCPL_Secondary_Sales__c objSecSale;
                Account objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona9', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.Account_Type__c='Secondary Customer through ID';
                objaccID.ShippingCity = 'RKL';
                objaccID.Ship_to_Code__c='997987';
                insert objaccID;
                Contact conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                               MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
                
                insert conIDAcc; 
                Map < Integer, String > mapofMonth = VCPL_CustomerSalesPlanController.getMonthName();
                string strCurrentMonth = mapofMonth.get(system.today().month());
                System.runas(objOtherUser){
                    /*
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
                    */
                    Account objaccIDnew = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona8', 'Industrial','Secondary Customer through ID','Compressor');
                    objaccIDnew.Account_Type__c='Secondary Customer through ID';
                    objaccIDnew.ShippingCity = 'RKL';
                    objaccIDnew.ParentId = objaccID.Id;
                    insert objaccIDnew;
                    VCPL_CustomerSalesPlanController.getAccountList(objaccID.id);
                    VCPL_CustomerSalesPlanController.getAccount(objaccID.id);
                    VCPL_CustomerSalesPlanController.getDetails(objaccID.id);
                    VCPL_CustomerSalesPlanController.getAccountNames(null);
                    List<VCPL_CustomerSalesPlanController.OpportunityWrapper> lstWrapOpp =  VCPL_CustomerSalesPlanController.getOpportunityWrapper(objaccIDnew.Name,objaccID.id);
                    VCPL_CustomerSalesPlanController.saveOpportunity(JSON.serialize(lstWrapOpp));
                }
            }
        	test.stopTest();
        }
   
    }
}