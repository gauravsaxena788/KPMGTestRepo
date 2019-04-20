@isTest
public class VCPL_QuotePDFIDCustomerTracker {
    
    public static testmethod void testLeadMethod(){
        User objOtherUsernew = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUsernew.Street ='Sector-58';
		objOtherUsernew.City ='Noida';
        objOtherUsernew.State ='Uttar Pradesh';
        objOtherUsernew.Country = 'India';
        objOtherUsernew.PostalCode = '201301';
        insert objOtherUsernew;
        
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUser.Street ='Sector-58';
		objOtherUser.City ='Noida';
        objOtherUser.State ='Uttar Pradesh';
        objOtherUser.Country = 'India';
        objOtherUser.PostalCode = '201301';
        objOtherUser.VCPL_ID_Head__c = objOtherUsernew.id;
        insert objOtherUser;
        
        System.runas(objOtherUser){            
            Account objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
            objaccID.ShippingCity = 'RKL';
            insert objaccID;
            Contact conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                          MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
            
            insert conIDAcc;             
            Opportunity objOpp= IDCumminsTestadataClass.returnBDOpportunityTestdata('Business_Development','Test Gona Opport',objaccID);
            insert objOpp;
            Quote objQuote= IDCumminsTestadataClass.returnQuoteTestData('VCPL_ID_Customer',objOpp,conIDAcc);
            insert objQuote;
            ApexPages.currentPage().getParameters().put('recordId', objQuote.Id);
            VCPL_QuotePDFIDCustomerController objIDQuote = new VCPL_QuotePDFIDCustomerController();
            objQuote.Cash_Discount_Policy__c = 'For CIL Dealers';
            update objQuote;
            objIDQuote = new VCPL_QuotePDFIDCustomerController();
            objQuote.Cash_Discount_Policy__c ='For all direct customers (Excluding OEM)';
            update objQuote;
            objIDQuote = new VCPL_QuotePDFIDCustomerController();
            objQuote.Cash_Discount_Policy__c ='N/A';
            update objQuote;
            objIDQuote = new VCPL_QuotePDFIDCustomerController();
            objIDQuote.getDynamicFormatString();
            }
        }
}