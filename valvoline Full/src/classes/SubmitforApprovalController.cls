public with sharing class SubmitforApprovalController {

    public Static String isEligible{get;set;}
    //public Static String isUpdateGP{get;set;}
    public Static String quotesId{get;set;}
    public Static String userId{get;set;}

    @AuraEnabled    
    public static String findAllNew(String QuoteId)
    {        
        Decimal quoteOldGPperLtr = 0.0;
        Decimal quoteNewGPperLtr = 0.0;
        
        String uid = UserInfo.getUserId();
        userId = uid;
        quotesId = QuoteId;
                
        List<Quote> qt = [select Id, Status from Quote where Id=:QuoteId AND Status='Draft'];
        if(qt.size()>0)
        {            
            //// calculate new GP, if different from old GP then update GP on QLI
            Decimal totalgp=0.0;
            Decimal totalquantity = 0.0;
            Decimal gpperltr = 0.0;
            isEligible = 'Not Update';
            List<Quote> qtList = [Select Id, GP_Ltr__c from Quote where Id=:QuoteId];
            if(qtList.size()>0)
            {
                quoteOldGPperLtr = qtList[0].GP_Ltr__c;
                
                List<QuoteLineItem> quoteLineList = [Select Id, GP_Ltr__c, GP1__c, Product2.COGS__c, Other_Discount__c,  
                                    Most_Likely_Discount__c, UnitPrice, Quantity  
                                    from QuoteLineItem where QuoteId=:qtList[0].Id];
                
                Boolean flag = false;
                for(QuoteLineItem qtLineList: quoteLineList)
                {
                    Decimal gp = 0.0;
                    
                    gp = (qtLineList.Quantity * (qtLineList.UnitPrice - qtLineList.Product2.COGS__c - qtLineList.Most_Likely_Discount__c - qtLineList.Other_Discount__c) * 1000 ).setScale(2);
                    
                    totalgp = totalgp + (qtLineList.Quantity * (qtLineList.UnitPrice - qtLineList.Product2.COGS__c - qtLineList.Most_Likely_Discount__c - qtLineList.Other_Discount__c) * 1000 );
                    totalquantity = totalquantity + qtLineList.Quantity;
                                       
                    // check if gp update
                    if(qtLineList.GP1__c!=gp)
                    {
                        qtLineList.GP1__c = gp;
                        flag = true;                        
                    }
                    
                }
                
                if(totalquantity!=0.0)
                    gpperltr = (totalgp / (totalquantity*1000)).setScale(2);                
                
                //// update QLI List
                if(flag)
                {
                    isEligible = 'GP/Ltr is updated successfully! Old GP/Ltr was '+quoteOldGPperLtr+' and New GP/Ltr is '+gpperltr+'. Are you still want to submit for approval?';
                    update quoteLineList;
                }
                else
                {
                    isEligible = 'Not Update';
                }                             
            }
        }
        else
        {
            isEligible = 'Not in Draft';
        }
        
        return isEligible;
    }
        
    @AuraEnabled
    public static List<Quote> updateQuoteCall(String qt){
        //you can make your own update here.
        system.debug('Id: '+qt);
        List<Quote> qtList = [Select Id, Is_Submit_for_Approval__c, Status from Quote where Id=:qt];
        qtList[0].Is_Submit_for_Approval__c = True;
        //qtList[0].Status = 'In Review';
        update qtList;
        return qtList;
    }

}