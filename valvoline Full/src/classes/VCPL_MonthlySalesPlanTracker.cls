@isTest(seeAllData=false)
public class VCPL_MonthlySalesPlanTracker {
    static testMethod void testMonthalyPlanMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUser.Street ='Sector-58';
        objOtherUser.City ='Noida';
        objOtherUser.State ='Uttar Pradesh';
        objOtherUser.Country = 'India';
        objOtherUser.PostalCode = '201301';
        insert objOtherUser;
        System.runas(objOtherUser){ 
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUser.id);
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
                String strReturndate = VCPL_MonthlySalesPlanController.getFinancialYear(System.today(),10);
                strReturndate = VCPL_MonthlySalesPlanController.getFinancialYear(System.today(),12);
                strReturndate = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
                VCPL_MonthlySalesPlanController.getMonthName();
                VCPL_MonthlySalesPlanController.getMonthNo();
                VCPL_MonthlySalesPlanController.getMonthSequence();
                VCPL_MonthlySalesPlanController.getMonthNames(); 
                VCPL_MonthlySalesPlanController.getParentAccount();
                VCPL_MonthlySalesPlanController.getChildAccounts();
                VCPL_MonthlySalesPlanController.getDetails();
                VCPL_MonthlySalesPlanController.getAccountList();
                VCPL_MonthlySalesPlanController.getloggedInUsername();
                VCPL_MonthlySalesPlanController.getDetails();
                VCPL_MonthlySalesPlanController.getYear('October');
                List<VCPL_MonthlySalesPlanController.OpportunityWrapper> newdata = VCPL_MonthlySalesPlanController.getData('October',objUser.AccountId);
                VCPL_MonthlySalesPlanController.saveOpportunity(JSON.serialize(newdata));
                VCPL_MonthlySalesPlanController.getSearchResults('test',JSON.serialize(newdata));
            }
        }
    }
}