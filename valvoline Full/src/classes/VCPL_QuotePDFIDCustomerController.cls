public class VCPL_QuotePDFIDCustomerController{

    public String getCompanyname() {
        return null;
    }

    
    public String toname{get;set;}  // contact name 
    public String fromname{get;set;}  // account name
    public String CustomerIDname{get;set;}  // account name
    
    public String customername{get;set;}
    public String customeremail{get;set;}
    public String customerphone{get;set;}
    public String customerdesignation{get;set;}
    public String customeraddress{get;set;}
        
    public String tbmname{get;set;}
    public String tbmdesignation{get;set;}
    public String tbmaddress{get;set;}
    public String tbmemail{get;set;}
    public String tbmphone{get;set;}
    public String regionalhead{get;set;}
    
    public String managername{get;set;}
    public String managerdesignation{get;set;}
    public String manageraddress{get;set;}
    public String manageremail{get;set;}
    public String managerphone{get;set;}
    
    public String quotenumber{get;set;}
    public String quotename{get;set;}
    
    public String accountname{get;set;}
    public String deliveryterm{get;set;}
    public String deliverytime{get;set;}
    public String paymentterm{get;set;}
    public Boolean pvclauseapplicable{get;set;}
    //public Boolean cashdiscount{get;set;}
    public String cashdiscountpolicy{get;set;}
    public Boolean volumetricdiscount{get;set;}
    public String CIDUserAdd{get;set;}
    
    public String industrysegment{get;set;}
    public String industrysegmentheading{get;set;}
    public String industrysegmentcontent{get;set;}
    
    public Date contractvalidfrom{get;set;}
    public Date contractvalidto{get;set;}
    public Date quotevalidtill{get;set;}
    
    public String othertermandcondition{get;set;}
    
    public String quotestatus{get;set;}
        
    public Boolean annexure1{get;set;}
    public Boolean annexure2{get;set;}
    public Boolean annexure3{get;set;}
    public Boolean annexure4{get;set;}
    
    public String moqvalue{get;set;}
    
    public Double cashdiscountvalue{get;set;}
    public Double gstvalue{get;set;}
    
    public List<QuoteLineItem> quoteLineItemList {get;set;}
    public List<AVD_Line_Item__c> avdlineitemList {get;set;}
    public List<String> annexureList = new List<String>();
    
    public VCPL_QuotePDFIDCustomerController(){
    
        String quoteId = ApexPages.currentPage().getParameters().get('recordId');
        system.debug('***quoteId'+quoteId);
        cashdiscountpolicy = '';
        
        List<Quote> lstqt= [SELECT id, Name, Status, Contact.Name, Contact.Title, Contact.Email, Contact.MobilePhone,Account.Indutry_Segment__c,  
                          Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingCountry, Other_Terms_Conditions__c, 
                          Contact.MailingPostalCode, Quote_Number__c, Opportunity.Owner.Name, Opportunity.Owner.MobilePhone, MOQ__c, Account.Parent.ShippingPostalCode,
                          Opportunity.Owner.Title, Opportunity.Owner.Street, Opportunity.Owner.City, Opportunity.Owner.State,Account.Parent.Name,
                          Account.Parent.ShippingCity, Account.Parent.ShippingState, Account.Parent.ShippingCountry,Account.Parent.ShippingStreet,
                          Opportunity.Owner.Country, Opportunity.Owner.PostalCode, Opportunity.Owner.Email, Account.Name, GST__c,  
                          Account.Regional_Head__r.Name, Delivery_Time__c, Payment_term__c, Contract_Valid_from__c, Quote_Valid_till__c, 
                          Contract_Valid_till__c, PV_Clause_Applicable__c, Annexures__c, Cash_Discount_Policy__c, Delivery_Term__c,  
                          Reporting_Manager__r.Name, Reporting_Manager__r.Email, Reporting_Manager__r.Street, Reporting_Manager__r.City, 
                          Reporting_Manager__r.State, Reporting_Manager__r.Country, Reporting_Manager__r.PostalCode, Account.Market_Segment__c,
                          Reporting_Manager__r.MobilePhone, Reporting_Manager__r.Title, VCPL_ID_Head__r.Name, VCPL_ID_Head__r.Email, VCPL_ID_Head__r.Street, VCPL_ID_Head__r.City, 
                          VCPL_ID_Head__r.State, VCPL_ID_Head__r.Country, VCPL_ID_Head__r.PostalCode, 
                          VCPL_ID_Head__r.MobilePhone, VCPL_ID_Head__r.Title FROM Quote WHERE id=:quoteId];
        if(lstqt.size()>0)
        {
            toname = String.valueOf(lstqt[0].Contact.Name);
            fromname = String.valueOf(lstqt[0].Account.Name);
            
            quotestatus = String.valueOf(lstqt[0].Status);
            
            
            customername = String.valueOf(lstqt[0].Contact.Name);
            customerdesignation = String.valueOf(lstqt[0].Contact.Title);
            customeremail = String.valueOf(lstqt[0].Contact.Email);
            customerphone = String.valueOf(lstqt[0].Contact.MobilePhone);
            CustomerIDname = String.valueOf(lstqt[0].Account.Parent.Name);
            CIDUserAdd = (!String.isBlank(lstqt[0].Account.Parent.ShippingStreet))?String.valueOf(lstqt[0].Account.Parent.ShippingStreet):'';
            CIDUserAdd = (!String.isBlank(lstqt[0].Account.Parent.ShippingCity))?CIDUserAdd +', '+String.valueOf(lstqt[0].Account.Parent.ShippingCity):'';
            CIDUserAdd = (!String.isBlank(lstqt[0].Account.Parent.ShippingPostalCode))?CIDUserAdd +'-'+String.valueOf(lstqt[0].Account.Parent.ShippingPostalCode):'';
            CIDUserAdd = (!String.isBlank(lstqt[0].Account.Parent.ShippingState))?CIDUserAdd +', '+String.valueOf(lstqt[0].Account.Parent.ShippingState):'';
            CIDUserAdd = (!String.isBlank(lstqt[0].Account.Parent.ShippingCountry))?CIDUserAdd +', '+String.valueOf(lstqt[0].Account.Parent.ShippingCountry):'';
            
            
            if(lstqt[0].Contact.MailingStreet!=null)
                customeraddress = String.valueOf(lstqt[0].Contact.MailingStreet)+', ';
                
            if(lstqt[0].Contact.MailingCity!=null)
                customeraddress = customeraddress + String.valueOf(lstqt[0].Contact.MailingCity)+', ';
                
            if(lstqt[0].Contact.MailingState!=null)
                customeraddress = customeraddress + String.valueOf(lstqt[0].Contact.MailingState)+', ';
                
            if(lstqt[0].Contact.MailingPostalCode!=null)
                customeraddress = customeraddress + String.valueOf(lstqt[0].Contact.MailingPostalCode);        
            
            tbmname = String.valueOf(lstqt[0].Opportunity.Owner.Name);
            tbmphone = String.valueOf(lstqt[0].Opportunity.Owner.MobilePhone);
            tbmemail = String.valueOf(lstqt[0].Opportunity.Owner.Email);
            
            if(lstqt[0].Opportunity.Owner.Street!=null)
                tbmaddress = String.valueOf(lstqt[0].Opportunity.Owner.Street)+', ';
            
            if(lstqt[0].Opportunity.Owner.City!=null)
                tbmaddress = tbmaddress + String.valueOf(lstqt[0].Opportunity.Owner.City)+', ';
                
            if(lstqt[0].Opportunity.Owner.State!=null)
                tbmaddress = tbmaddress + String.valueOf(lstqt[0].Opportunity.Owner.State)+', ';
            
            if(lstqt[0].Opportunity.Owner.Country!=null)
                tbmaddress = tbmaddress + String.valueOf(lstqt[0].Opportunity.Owner.Country)+', ';  
            
            if(lstqt[0].Opportunity.Owner.PostalCode!=null)
                tbmaddress = tbmaddress + String.valueOf(lstqt[0].Opportunity.Owner.PostalCode);           
            
            tbmdesignation = String.valueOf(lstqt[0].Opportunity.Owner.Title);
            regionalhead = String.valueOf(lstqt[0].Account.Regional_Head__r.Name);
            
            managername = String.valueOf(lstqt[0].VCPL_ID_Head__r.Name);
            managerphone = String.valueOf(lstqt[0].VCPL_ID_Head__r.MobilePhone);
            manageremail = String.valueOf(lstqt[0].VCPL_ID_Head__r.Email);
            
            if(lstqt[0].VCPL_ID_Head__r.Street!=null)
                manageraddress = String.valueOf(lstqt[0].VCPL_ID_Head__r.Street)+', ';
                
            if(lstqt[0].VCPL_ID_Head__r.City!=null)
                manageraddress = manageraddress + String.valueOf(lstqt[0].VCPL_ID_Head__r.City)+', ';    
            
            if(lstqt[0].VCPL_ID_Head__r.State!=null)
                manageraddress = manageraddress + String.valueOf(lstqt[0].VCPL_ID_Head__r.State)+', ';
                
            if(lstqt[0].VCPL_ID_Head__r.Country!=null)
                manageraddress = manageraddress + String.valueOf(lstqt[0].VCPL_ID_Head__r.Country)+', ';
                
            if(lstqt[0].VCPL_ID_Head__r.PostalCode!=null)
                manageraddress = manageraddress + String.valueOf(lstqt[0].VCPL_ID_Head__r.PostalCode);                
            
            managerdesignation = String.valueOf(lstqt[0].VCPL_ID_Head__r.Title);

            
            accountname = String.valueOf(lstqt[0].Account.Name);
            
            quotenumber = lstqt[0].Quote_Number__c;
            quotename = lstqt[0].Name;
            deliverytime =lstqt[0].Delivery_Time__c;
            paymentterm = lstqt[0].Payment_term__c;
            contractvalidfrom = Date.valueOf(lstqt[0].Contract_Valid_from__c);
            contractvalidto = Date.valueOf(lstqt[0].Contract_Valid_till__c);
            quotevalidtill = Date.valueOf(lstqt[0].Quote_Valid_till__c);
            
            if(lstqt[0].MOQ__c!=null)
            {
                moqvalue = lstqt[0].MOQ__c;
            }
            
            if(lstqt[0].Other_Terms_Conditions__c!=null)
                othertermandcondition = String.valueOf(lstqt[0].Other_Terms_Conditions__c);
            
            
            /// custom metadata for Industry Segment Images, Headings and Contents
            Boolean isDefault = true;
            VCPL_ID_Customer_Quote__mdt objOtherMDtype ;
            for(VCPL_ID_Customer_Quote__mdt objIDQ : [SELECT VCPL_Market_Segment__c, VCPL_Image_Name__c, VCPL_Industry_Segment_Heading__c, 
                                                        VCPL_Industry_Segment_Content__c FROM VCPL_ID_Customer_Quote__mdt])
            {
                if(String.valueOf(lstqt[0].Account.Market_Segment__c)== objIDQ.VCPL_Market_Segment__c)
                {
                    industrysegment = objIDQ.VCPL_Image_Name__c;
                    industrysegmentheading = objIDQ.VCPL_Industry_Segment_Heading__c;
                    industrysegmentcontent = objIDQ.VCPL_Industry_Segment_Content__c;
                    isDefault=false;
                }
                else if(!String.isBlank(objIDQ.VCPL_Market_Segment__c) && objIDQ.VCPL_Market_Segment__c == 'Others'){
                    objOtherMDtype = objIDQ ;
                }
            }
            if(isDefault && objOtherMDtype != null )
            {
                    industrysegment = objOtherMDtype.VCPL_Image_Name__c;
                    industrysegmentheading = objOtherMDtype.VCPL_Industry_Segment_Heading__c;
                    industrysegmentcontent = objOtherMDtype.VCPL_Industry_Segment_Content__c;
            }
            
            
            deliveryterm = String.valueOf(lstqt[0].Delivery_Term__c);
            
            if(lstqt[0].GST__c!=null)
                gstvalue = Double.valueOf(lstqt[0].GST__c);
            else
                gstvalue = 0.0;
            
            if(lstqt[0].Annexures__c!=null)
                annexureList.addAll(lstqt[0].Annexures__c.split(';'));
            
            annexure1 = false;
            annexure2 = false;
            annexure3 = false;
            annexure4 = false;
            
            for(String str: annexureList)
            {
                if(str=='Annexure-A101 - Technical Value Added Services')
                    annexure1 = true;
                    
                if(str=='Annexure-A201 - Strong OEM Relationship in India')
                    annexure2 = true;
                    
                if(str=='Annexure-A301 - Valvoline\'s Distribution Network')
                    annexure3 = true;
                    
                if(str=='Annexure-B101 - Key Products Specifications')
                    annexure4 = true;
            }
            
            system.debug('Annexure 1: '+annexure1);
            system.debug('Annexure 2: '+annexure2);
            system.debug('Annexure 3: '+annexure3);
            system.debug('Annexure 4: '+annexure4);
            
            if(lstqt[0].PV_Clause_Applicable__c=='Yes')
                pvclauseapplicable = true;
            else
                pvclauseapplicable = false;
            
            if(lstqt[0].Cash_Discount_Policy__c=='For all Distributors (Non-Cummins)')
            {
                cashdiscountpolicy = 'Discount Rates - For all Distributors (Non-Cummins)';
                cashdiscountvalue = 2.25;
            }
            else if(lstqt[0].Cash_Discount_Policy__c=='For CIL Dealers')
            {
                cashdiscountpolicy = 'Discount Rates - For CIL Dealers';    
                cashdiscountvalue = 2.00;
            }
            else if(lstqt[0].Cash_Discount_Policy__c=='For all direct customers (Excluding OEM)')
            {
                cashdiscountpolicy = 'Discount Rates - For all direct customers (Excluding OEM)';    
                cashdiscountvalue = 2.5;
            }            
            else if(lstqt[0].Cash_Discount_Policy__c=='N/A')
            {
                cashdiscountpolicy = 'N/A';    
                cashdiscountvalue = 0.0;
            }
        }
        
        avdlineitemList = [select Id, Volume_From__c, Volume_To__c, Slab_Discount__c, Most_Likely__c, Quote__c from AVD_Line_Item__c where Quote__r.Id =: quoteId];
        if(avdlineitemList.size()>0)
        {
            volumetricdiscount = true;
        }
        else
        {
            volumetricdiscount = false;
        }
        
        quoteLineItemList = [select id, Product2.Name, Pack_Size__c, UnitPrice, Product2.PH6_Qlikview__c, Product2.SKU_Id__c, Quantity, Subtotal, Sub_Total__c from QuoteLineItem where QuoteId =:quoteId];
        
    }
    
    
    public String getDynamicFormatString()
    {
        Decimal value = 1000.10;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
        String decimalSep = formattedValue.substring(5,6);
        return '{0,number,#'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'###'+thousandSep+'##0'+decimalSep+'00}';
    }
    
}