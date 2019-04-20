@isTest
public class VCPL_clsforIdCustomerQuoteTracker {

    public static testmethod void testQuoteMethod(){
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
                 objTriggerSetting.Name ='QuoteTrigger';
                 objTriggerSetting.VA_Is_Trigger_Disabled__c = false;
                 insert objTriggerSetting;
                objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.ShippingCity = 'RKL';
                insert objaccID;
                conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                               MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
                
                insert conIDAcc;             
                objOpp= IDCumminsTestadataClass.returnBDOpportunityTestdata('Business_Development','Test Gona Opport',objaccID);
                insert objOpp;
                objQuote= IDCumminsTestadataClass.returnQuoteTestData('VCPL_ID_Customer',objOpp,conIDAcc);
                insert objQuote;
                objQuote.Status = 'Draft';
                update objQuote;
                String idQuote = VCPL_clsforIdCustomerQuote.checkQuoteAllowed(objOpp.Id);
                VCPL_clsforIdCustomerQuote.Wrapobj getQuoteval = VCPL_clsforIdCustomerQuote.quotefieldsget(objOpp.Id);
                VCPL_clsforIdCustomerQuote.WrapobjError geterrorSucess = VCPL_clsforIdCustomerQuote.findAllNew(objQuote.id);
                System.runas(objOtherUser){
                objQuote.Status = 'In Review';
                update objQuote;
                }
                geterrorSucess = VCPL_clsforIdCustomerQuote.findAllNew(objQuote.id);
                System.runas(objOtherUser){
                    objQuote.Status = 'Draft';
                    update objQuote;
                }
                geterrorSucess = VCPL_clsforIdCustomerQuote.updateQuoteCall(objQuote.id);
                geterrorSucess = VCPL_clsforIdCustomerQuote.findAllNew(objQuote.id);
            }
            System.runas(objOtherUser){
                    objQuote.Status = 'Draft';
                    system.debug('===objQuote====;'+objQuote);
                    objQuote.VCPL_ID_Head__c = null;
                    update objQuote;
                    VCPL_clsforIdCustomerQuote.WrapobjError geterrorSucessnew = VCPL_clsforIdCustomerQuote.findAllNew(objQuote.id);
             }
             System.runas(objPortalUser){
                   VCPL_clsforIdCustomerQuote.WrapobjError geterrorSucessnew = VCPL_clsforIdCustomerQuote.updateQuoteCall(objQuote.id);
                 }
        }
    }
}