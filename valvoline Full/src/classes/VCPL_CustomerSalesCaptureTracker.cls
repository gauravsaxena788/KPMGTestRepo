@isTest(seeAllData=false)
public class VCPL_CustomerSalesCaptureTracker {
    public static testmethod void testCustomerSalesMethod(){
        User objOtherUsernew = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUsernew.Street ='Sector-58';
        objOtherUsernew.City ='Noida';
        objOtherUsernew.State ='Uttar Pradesh';
        objOtherUsernew.Country = 'India';
        objOtherUsernew.PostalCode = '201301';
        insert objOtherUsernew;
        System.runAs(objOtherUsernew){
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUsernew.id);
            insert objPortalUser;
            System.runas(objPortalUser){   
                User objUser = [SELECT id,AccountId FROM User WHERE Id=:Userinfo.getUserId()];
                Account objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.ShippingCity = 'RKL';
                if(objUser != null && !string.isBlank(objUser.AccountId))
                    objaccID.ParentId =objUser.AccountId;
                insert objaccID;
                List<account> lstAcc =[SELECT Parent.Name FROM Account WHERE Id=:objaccID.Id];
                system.debug('lstAcc'+lstAcc[0].Parent.Name);
                Contact conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                               MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
                insert conIDAcc; 
                VCPL_Customer_Plan__c objCP = IDCumminsTestadataClass.returnCustomerPlanTestData('VCPL_Monthly_Plan',objaccID,10);
                objCP.VCPL_Month__c = 'January';
                if(System.today().month() > 9){                    
                	objCP.VCPL_Financial_Year__c = String.valueof(System.today().Year()+1);                    
                }
                else                   
                	objCP.VCPL_Financial_Year__c = String.valueof(System.today().Year());               
                insert objCP;
                system.debug('===objCP==='+objCP);
                VCPL_CustomerSalesCaptureController.getDetails(); 
                List<VCPL_CustomerSalesCaptureController.detailsWrapper> lstWrap = VCPL_CustomerSalesCaptureController.getData('July','');
                VCPL_CustomerSalesCaptureController.saveOpportunity(JSON.serialize(lstWrap));
                VCPL_CustomerSalesCaptureController.getSearchResults('Test',JSON.serialize(lstWrap));
                lstWrap = VCPL_CustomerSalesCaptureController.getData('January',objUser.AccountId);
                VCPL_CustomerSalesCaptureController.saveOpportunity(JSON.serialize(lstWrap));
                VCPL_CustomerSalesCaptureController.getSearchResults('Test',JSON.serialize(lstWrap));
            }
        }
    }
}