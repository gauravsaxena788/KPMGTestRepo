@isTest
public class VCPL_InvoiceStaggingHandlerTracker {
    private static TestMethod void InvoiceInsert(){
        Id AccBranchRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
        Id CDCustomerRecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
        Id AccDelarRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer').getRecordTypeId();
        
        Account objAccDealer = new Account();
        objAccDealer.RecordTypeId = AccDelarRecordTypeId ; 
        objAccDealer.Indutry_Segment__c = 'Cummins Dealer';
        objAccDealer.Market_Segment__c = 'Cummins Rental';
        objAccDealer.Account_Type__c = 'Cummins Dealer';
        objAccDealer.BU_Name__c = 'C&I';
        objAccDealer.name='Cummins Dealership A';
        objAccDealer.Zone__c = 'All';
        insert objAccDealer;
        
        Account objAccBranch = new Account();
        objAccBranch.RecordTypeId = AccBranchRecordTypeId;
        objAccBranch.Indutry_Segment__c = 'Cummins Dealer';
        objAccBranch.Market_Segment__c = 'Cummins Rental';
        objAccBranch.Account_Type__c = 'Cummins Dealer';
        objAccBranch.BU_Name__c = 'C&I';
        objAccBranch.ParentId = objAccDealer.id;
        objAccBranch.name = 'Branch(12-9-18)';
        objAccBranch.Zone__c = 'All';
        insert objAccBranch;
        
        Account objAccCustomer = new Account();
        objAccCustomer.RecordTypeId = CDCustomerRecordTypeid;
        objAccCustomer.Indutry_Segment__c = 'Cummins Dealer Secondary customer';
        objAccCustomer.Market_Segment__c = 'Automotive/Anciliary';
        objAccCustomer.Account_Type__c = 'Secondary Customer through Channel';
        objAccCustomer.BU_Name__c = 'C&I';
        objAccCustomer.VCPL_CDOS_AccountId__c = '1-15L-2182';
        objAccCustomer.Zone__c = 'All';
        objAccCustomer.Name = 'Test 19-9-18 CD Customer';
        insert objAccCustomer;
        
        VCPL_Dealer_Mapping__c objDealerMapping = new VCPL_Dealer_Mapping__c();
        objDealerMapping.VCPL_City__c = 'NEW DELHI';
        objDealerMapping.VCPL_State__c = 'DELHI';
        objDealerMapping.VCPL_StateCity__c = 'NEW DELHIDELHI';
        insert objDealerMapping;
        
        product2 objProduct = new product2();
        objProduct.ProductCode = 'X505080';
        objproduct.Description = 'oil tank';
        objproduct.StockKeepingUnit = 'X505080';
        objproduct.Name = 'oil tank';
        objproduct.Focus_Product_C_I__c = 'No';
        objproduct.Focus_Product_Fleet__c ='No';
        objproduct.Focus_Product_OEM__c ='No';
        objproduct.PH1__c ='Valvoline';
        objproduct.PH2__c ='Lubricants';
        objproduct.PH3__c ='Private Label';
        objproduct.PH4__c ='Valvoline';
        objproduct.PH5__c ='Other';
        objproduct.PH6_Qlikview__c ='Rakshak';
        objproduct.PH6_SAP__c= 'Rakshak';
        objproduct.PH7__c='OEM';
        objproduct.Packsize__c='8 L';
        objproduct.SKU_Id__c = 505080;     
        insert objProduct;  
        
        CD_SKU_Mapping__c objCDSKUMapping = new CD_SKU_Mapping__c();
        objCDSKUMapping.name = 'X505080';
        objCDSKUMapping.Product__c =  objProduct.id;
        insert objCDSKUMapping;
        
        list<VCPL_Invoice_Stagging__c> lstVCPL_Invoice_Stagging = new list<VCPL_Invoice_Stagging__c>();
        
        VCPL_Invoice_Stagging__c objInvoiceStagging = new VCPL_Invoice_Stagging__c();
        objInvoiceStagging.Bill_To_Account_Id__c =  '1-15L-2182';
        objInvoiceStagging.AccountID__c =  '1-15L-2182';
        objInvoiceStagging.Division_Name__c = 'Branch(12-9-18)';
        objInvoiceStagging.Invoice_Date__c = '08-09-2018';
        objInvoiceStagging.Order_Date__c = '08-09-2018';
        objInvoiceStagging.Created__c = '08-09-2018';
        objInvoicestagging.Invoice_Number__c = 'OPCCH1819000005';
        objInvoicestagging.Item_Name__c = 'X505080'; 
        objInvoicestagging.Invoice_Line_Number__c = '1';
        objInvoicestagging.ACCOUNT_ADDR_ID__c ='1-15L-2182';
        //objInvoicestagging.Status__c ='Processed';   
        objInvoicestagging.Unique_Row_Id__c = 'OPCCH1819000005_3_1-3BTL0UL';
        lstVCPL_Invoice_Stagging.add(objInvoicestagging);
        
        VCPL_Invoice_Stagging__c objInvoiceStagging2 = new VCPL_Invoice_Stagging__c();
        objInvoiceStagging2.Bill_To_Account_Id__c =  '1-15L-2182';
        objInvoiceStagging2.AccountID__c =  '1-15L-2182';
        objInvoiceStagging2.Division_Name__c = 'Branch(12-9-18)';
        objInvoiceStagging2.Invoice_Date__c = '08-09-2017';
        objInvoiceStagging2.Order_Date__c = '08-09-2017';
        objInvoiceStagging2.Created__c = '08-09-2017';
        objInvoicestagging2.Invoice_Number__c = 'OPCCH1819000004';
        objInvoicestagging2.Status__c = 'Processed';
        objInvoicestagging2.IsResultProcessd__c = false;
        objInvoicestagging2.Item_Name__c = 'X505080'; 
        objInvoicestagging2.Invoice_Line_Number__c = '1';
        objInvoicestagging2.ACCOUNT_ADDR_ID__c ='1-15L-2182';
        objInvoicestagging2.Unique_Row_Id__c = 'OPCCH1819000005_3_1-3BTL0UL';
        insert objInvoicestagging2;  
        objInvoicestagging2.Status__c = 'Processed';
        update objInvoicestagging2;
        
        VCPL_Invoice_Stagging__c objInvoiceStagging1 = new VCPL_Invoice_Stagging__c();
        objInvoiceStagging1.AccountID__c =  '1-15L-2182';
        objInvoiceStagging1.Order_Date__c = '08-09-2018';
        objInvoiceStagging1.Created__c = '08-09-2018';
        objInvoicestagging1.Invoice_Line_Number__c = '1';
        lstVCPL_Invoice_Stagging.add(objInvoicestagging1);
        insert lstVCPL_Invoice_Stagging ;
    }
}