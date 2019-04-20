public class QuotePDFController{

    public String getCompanyname() {
        return null;
    }

    
    public String toname{get;set;}  // contact name 
    public String fromname{get;set;}  // account name
    
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
    
    public String industrysegment{get;set;}
    public String industrysegmentheading{get;set;}
    public String industrysegmentcontent{get;set;}
    
    public Date contractvalidfrom{get;set;}
    public Date contractvalidto{get;set;}
    public Decimal contractperiod{get;set;}
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
    
    public Boolean skucode{get;set;}
    
    public String attId{get;set;}
    //public String attLogo{get;set;}
    
    //public String attachmentid{get;set;}
    
    public List<QuoteLineItem> quoteLineItemList {get;set;}
    public List<AVD_Line_Item__c> avdlineitemList {get;set;}
    public List<QVD_Line_Item__c> qvdlineitemList {get;set;}
    public List<String> annexureList = new List<String>();
    
    public List<Annexure_Setting__mdt> annexureSettingList {get;set;}
    
    public QuotePDFController(){
    
        String quoteId = ApexPages.currentPage().getParameters().get('recordId');
        system.debug('***quoteId'+quoteId);
        attId = '';
        cashdiscountpolicy = '';
        
        skucode = false;
        
        List<Quote> qt = [select id, Name, Status, Contact.Name, Contact.Title, Contact.Email, Contact.MobilePhone,Account.Indutry_Segment__c,  
                          Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingCountry, Other_Terms_Conditions__c, 
                          Contact.MailingPostalCode, Quote_Number__c, Opportunity.Owner.Name, Opportunity.Owner.MobilePhone, MOQ__c, Opportunity.Account.Logo__c, 
                          Opportunity.Owner.Title, Opportunity.Owner.Street, Opportunity.Owner.City, Opportunity.Owner.State, Opportunity.Account.attachment_id__c, 
                          Opportunity.Owner.Country, Opportunity.Owner.PostalCode, Opportunity.Owner.Email, AccountId, Account.Name, GST__c, Contract_Period__c,  
                          Account.Regional_Head__r.Name, Delivery_Time__c, Payment_term__c, Contract_Valid_from__c, Quote_Valid_till__c, 
                          Contract_Valid_till__c, PV_Clause_Applicable__c, Annexures__c, Cash_Discount_Policy__c, Delivery_Term__c,  
                          Reporting_Manager__r.Name, Reporting_Manager__r.Email, Reporting_Manager__r.Street, Reporting_Manager__r.City, 
                          Reporting_Manager__r.State, Reporting_Manager__r.Country, Reporting_Manager__r.PostalCode, Show_SKU_Code__c,  
                          Reporting_Manager__r.MobilePhone, Reporting_Manager__r.Title from Quote where id=:quoteId];
        if(qt.size()>0)
        {
            toname = String.valueOf(qt[0].Contact.Name);
            fromname = String.valueOf(qt[0].Account.Name);
            
            quotestatus = String.valueOf(qt[0].Status);
            
            customername = String.valueOf(qt[0].Contact.Name);
            customerdesignation = String.valueOf(qt[0].Contact.Title);
            customeremail = String.valueOf(qt[0].Contact.Email);
            customerphone = String.valueOf(qt[0].Contact.MobilePhone);
            
            if(qt[0].Contact.MailingStreet!=null)
                customeraddress = String.valueOf(qt[0].Contact.MailingStreet)+', ';
                
            if(qt[0].Contact.MailingCity!=null)
                customeraddress = customeraddress + String.valueOf(qt[0].Contact.MailingCity)+', ';
                
            if(qt[0].Contact.MailingState!=null)
                customeraddress = customeraddress + String.valueOf(qt[0].Contact.MailingState)+', ';
                
            if(qt[0].Contact.MailingPostalCode!=null)
                customeraddress = customeraddress + String.valueOf(qt[0].Contact.MailingPostalCode);        
            
            tbmname = String.valueOf(qt[0].Opportunity.Owner.Name);
            tbmphone = String.valueOf(qt[0].Opportunity.Owner.MobilePhone);
            tbmemail = String.valueOf(qt[0].Opportunity.Owner.Email);
            
            if(qt[0].Opportunity.Owner.Street!=null)
                tbmaddress = String.valueOf(qt[0].Opportunity.Owner.Street)+', ';
            
            if(qt[0].Opportunity.Owner.City!=null)
                tbmaddress = tbmaddress + String.valueOf(qt[0].Opportunity.Owner.City)+', ';
                
            if(qt[0].Opportunity.Owner.State!=null)
                tbmaddress = tbmaddress + String.valueOf(qt[0].Opportunity.Owner.State)+', ';
                
            if(qt[0].Opportunity.Owner.PostalCode!=null)
                tbmaddress = tbmaddress + String.valueOf(qt[0].Opportunity.Owner.PostalCode);           
            
            tbmdesignation = String.valueOf(qt[0].Opportunity.Owner.Title);
            regionalhead = String.valueOf(qt[0].Account.Regional_Head__r.Name);
            
            managername = String.valueOf(qt[0].Reporting_Manager__r.Name);
            managerphone = String.valueOf(qt[0].Reporting_Manager__r.MobilePhone);
            manageremail = String.valueOf(qt[0].Reporting_Manager__r.Email);
            
            if(qt[0].Reporting_Manager__r.Street!=null)
                manageraddress = String.valueOf(qt[0].Reporting_Manager__r.Street)+', ';
                
            if(qt[0].Reporting_Manager__r.City!=null)
                manageraddress = manageraddress + String.valueOf(qt[0].Reporting_Manager__r.City)+', ';    
            
            if(qt[0].Reporting_Manager__r.State!=null)
                manageraddress = manageraddress + String.valueOf(qt[0].Reporting_Manager__r.State)+', ';
                
            if(qt[0].Reporting_Manager__r.Country!=null)
                manageraddress = manageraddress + String.valueOf(qt[0].Reporting_Manager__r.Country)+', ';
                
            if(qt[0].Reporting_Manager__r.PostalCode!=null)
                manageraddress = manageraddress + String.valueOf(qt[0].Reporting_Manager__r.PostalCode);                
            
            managerdesignation = String.valueOf(qt[0].Reporting_Manager__r.Title);

            
            accountname = String.valueOf(qt[0].Account.Name);
            
            quotenumber = qt[0].Quote_Number__c;
            quotename = qt[0].Name;
            deliverytime =qt[0].Delivery_Time__c;
            paymentterm = qt[0].Payment_term__c;
            contractvalidfrom = Date.valueOf(qt[0].Contract_Valid_from__c);
            contractvalidto = Date.valueOf(qt[0].Contract_Valid_till__c);
            quotevalidtill = Date.valueOf(qt[0].Quote_Valid_till__c);
            contractperiod = (qt[0].Contract_Period__c);
            
            if(qt[0].MOQ__c!=null)
            {
                moqvalue = qt[0].MOQ__c;
            }
            
            if(qt[0].Other_Terms_Conditions__c!=null)
                othertermandcondition = String.valueOf(qt[0].Other_Terms_Conditions__c);
            
            
            /// custom metadata for Industry Segment Images, Headings and Contents
            Boolean isDefault = true;
            for(Quote_PDF_Setting__mdt pdfSetting: [SELECT Industry_Segment__c, Image_Name__c, Industry_Segment_Heading__c, Industry_Segment_Content__c FROM Quote_PDF_Setting__mdt])
            {
                if(String.valueOf(qt[0].Account.Indutry_Segment__c)==pdfSetting.Industry_Segment__c)
                {
                    industrysegment = pdfSetting.Image_Name__c;
                    industrysegmentheading = pdfSetting.Industry_Segment_Heading__c;
                    industrysegmentcontent = pdfSetting.Industry_Segment_Content__c;
                    isDefault=false;
                }
            }
            if(isDefault)
            {
                List<Quote_PDF_Setting__mdt> pdfSettings = [SELECT Industry_Segment__c, Image_Name__c, 
                                                            Industry_Segment_Heading__c, Industry_Segment_Content__c 
                                                            FROM Quote_PDF_Setting__mdt where Industry_Segment__c='default'];
                if(pdfSettings.size()>0)
                {
                    industrysegment = pdfSettings[0].Image_Name__c;
                    industrysegmentheading = pdfSettings[0].Industry_Segment_Heading__c;
                    industrysegmentcontent = pdfSettings[0].Industry_Segment_Content__c;
                }
            }
            
            
            deliveryterm = String.valueOf(qt[0].Delivery_Term__c);
            
            if(qt[0].GST__c!=null)
                gstvalue = Double.valueOf(qt[0].GST__c);
            else
                gstvalue = 0.0;
            
            if(qt[0].Annexures__c!=null)
            {
                annexureList.addAll(qt[0].Annexures__c.split(';'));
                system.debug('Annexure list: '+annexureList);
                annexureSettingList = [Select Quote_Annexure_Name__c, Annexure_Heading__c, Folder_Name__c, Image_URL__c, Order__c from Annexure_Setting__mdt where Quote_Annexure_Name__c IN: annexureList ORDER BY Order__c];
            }
            
            
            /////////////////// Add above new custom metadata settings for Annexure images dynamically //////////
           system.debug('Annexure Setting List: '+annexureSettingList);
           
            
            if(qt[0].PV_Clause_Applicable__c=='Yes')
                pvclauseapplicable = true;
            else
                pvclauseapplicable = false;
            
            if(qt[0].Cash_Discount_Policy__c=='For all Distributors (Non-Cummins)')
            {
                cashdiscountpolicy = 'Discount Rates - For all Distributors (Non-Cummins)';
                cashdiscountvalue = 2.25;
            }
            else if(qt[0].Cash_Discount_Policy__c=='For CIL Dealers')
            {
                cashdiscountpolicy = 'Discount Rates - For CIL Dealers';    
                cashdiscountvalue = 2.00;
            }
            else if(qt[0].Cash_Discount_Policy__c=='For all direct customers (Excluding OEM)')
            {
                cashdiscountpolicy = 'Discount Rates - For all direct customers (Excluding OEM)';    
                cashdiscountvalue = 2.5;
            }
            else if(qt[0].Cash_Discount_Policy__c=='For Direct Customer (OEM)')
            {
                cashdiscountpolicy = 'Discount Rates - For Direct Customer (OEM)';    
                cashdiscountvalue = 2.25;
            }
            else if(qt[0].Cash_Discount_Policy__c=='N/A')
            {
                cashdiscountpolicy = 'N/A';    
                cashdiscountvalue = 0.0;
            }
        }
        
        skucode = qt[0].Show_SKU_Code__c;
        avdlineitemList = new List<AVD_Line_Item__c>();
        qvdlineitemList = new List<QVD_Line_Item__c>();
        
        avdlineitemList = [select Id, Volume_From__c, Volume_To__c, Slab_Discount__c, Most_Likely__c, Quote__c, Start_Date__c, End_Date__c from AVD_Line_Item__c where Quote__r.Id =: quoteId AND Most_Likely__c=TRUE];
        qvdlineitemList = [select Id, Volume_From__c, Volume_To__c, Slab_Discount__c, Most_Likely__c, Quote__c, Start_Date__c, End_Date__c from QVD_Line_Item__c where Quote__r.Id =: quoteId AND Most_Likely__c=TRUE];
        if(avdlineitemList.size()>0 || qvdlineitemList.size()>0)
        {
            volumetricdiscount = true;
        }
        else
        {
            volumetricdiscount = false;
        }
        
        /*List<ContentDocumentLink> contDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :qt[0].AccountId LIMIT 1];
        
        if(contDocLink.size()>0)
        {
            List<ContentDocument> contDoc = [Select Id ,Title from ContentDocument Where ID =: contDocLink[0].ContentDocumentId AND Title='customer_logo' LIMIT 1];
            if(contDoc.size()>0)
                attachmentid = '/sfc/servlet.shepherd/version/download/'+contDoc[0].Id;
        }*/
        
        quoteLineItemList = [select id, Product2.Name, Pack_Size__c, UnitPrice, Product2.PH6_Qlikview__c, Product2.SKU_Id__c, Quantity, Subtotal, Sub_Total__c from QuoteLineItem where QuoteId =:quoteId];
        
        ///////////// fetch attachment for customer logo //////////
        if(qt[0].Opportunity.Account.attachment_id__c!=null)
        {
            attId = qt[0].Opportunity.Account.attachment_id__c;
            //attLogo = qt[0].Opportunity.Account.Logo__c;
        }
        
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