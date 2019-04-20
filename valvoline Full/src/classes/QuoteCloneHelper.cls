public class QuoteCloneHelper {
    
    public Static Date sdate {get;set;}
    public Static Date edate {get;set;}
    
   /* @AuraEnabled 
    public static Account fetchUserAcc(){
     // query current user information  
      Account userAcc = [select id,Name,(Select Id, OwnerId, Name from Opportunities where recordtype.developername='Business_Development')
                 FROM Account Where OwnerId =:UserInfo.getUserID()];
        return userAcc;
    }*/
    
   @AuraEnabled
    public static Map<id,String> fetchUserAcc1(){
        List<string> primaryRecordTypeIds = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
        List<Account> userAcc=[select id,Name FROM Account Where OwnerId =:userInfo.getUserId() AND RecordTypeId IN: primaryRecordTypeIds AND ID IN (Select AccountId from Opportunity where recordtype.developername='Business_Development')];
        Map<id,String> accountMap= new Map<Id, String>();
        for (Account a:userAcc)
        {
            accountMap.put(a.id,a.name);
         }
        
        return accountMap;
    }
    
    @AuraEnabled
    public static Map<id,String> fetchopponload(String qtId)
    {
        Quote quoteList = [SELECT Id, Name, Status, Contract_Valid_from__c, Contract_Valid_till__c, Quote_Valid_till__c, Account.Id, OpportunityId, Account_Name__c, Opportunity.Name  FROM Quote WHERE Id=:qtId limit 1];
        List<Opportunity> opp= [Select Id, OwnerId, Name, Account.Id,Account.name from Opportunity where recordtype.developername='Business_Development' and Account.id=:quoteList.Account.Id];
        Map<id,String> oppMap= new Map<Id, String>();
        for (Opportunity a:opp )
        {
            oppMap.put(a.id, a.name)  ;
            
        }
        return oppMap;
        
    }
    
    @AuraEnabled
    public static Map<id,String> fetchopp(String accountId){
        List<Opportunity> opp= [Select Id, OwnerId, Name, Account.Id,Account.name from Opportunity where recordtype.developername='Business_Development' and Account.id=:accountId];
        Map<id,String> oppMap= new Map<Id, String>();
        for (Opportunity a:opp )
        {
            oppMap.put(a.id,a.name)  ;
            
        }
        return oppMap;
        
    }

    
    @AuraEnabled
    public static Quote getDetailsFromQuote(String qtId){
        
        String flag='Allow';
        String flag2 = '';
        Quote quoteList = [SELECT Id, Name, Status, Contract_Valid_from__c, Contract_Valid_till__c, Quote_Valid_till__c, Account.Id, OpportunityId, Account_Name__c, Opportunity.Name  FROM Quote WHERE Id=:qtId limit 1];
        
        return quoteList;
    }
    
    @AuraEnabled
    public static String createQuoteClone(String qtId, String qtname, String cvalidfrom, String cvalidtill, String qvalidtill, String aid, String oid){
        try{   
            system.debug('call create method');
            system.debug('qt: '+qtId+ 'convalidfrom: '+cvalidfrom+ 'contvalidtill: '+cvalidtill+ 'qotvalidtill: '+qvalidtill);
            system.debug('accountid: '+aid+' opportunityId: '+oid);            
            sdate = Date.valueOf(cvalidfrom);
            edate = Date.valueOf(cvalidtill);
            
            if(Date.valueOf(qvalidtill)<system.today())
            {
                return 'Invalid Date';
            }
            
            List<Contact> conList = [Select Id, AccountId from Contact where AccountId=:aId LIMIT 1];
            if(conList.size()==0)
            {
                return 'Please add contact on the selected account before cloning this quote.';
            }
            
            Quote quoteList = [SELECT Id, Name, Account_Name__c, AccountId, ContactId, Delivery_Term__c, Payment_term__c, PriceBook2Id, BU_Name__c, 
                               Annexures__c, BillingAddress, Cash_Discount_Policy__c, Description, Discount, Delivery_Time__c, Quote_Approved__c,  
                               GrandTotal, GST__c, MOQ__c, Net_GP_Ltr__c, QuoteToAddress, External_Remarks__c, PV_Clause_Applicable__c, 
                               Security_Instrument__c, ShippingAddress, Show_SKU_Code__c, Status, Total_Vol__c, Other_Terms_Conditions__c, 
                               OpportunityId, Quote_Number__c, Contract_Valid_from__c, Contract_Valid_till__c, Quote_Valid_till__c, Account.Id  
                               FROM Quote WHERE Id=:qtId limit 1];
            
            Quote qtClone = quoteList.clone(false,false,false,false);
                        
            qtClone.Name = qtname;
            qtClone.Contract_Valid_from__c = Date.valueOf(cvalidfrom);
            qtClone.Contract_Valid_till__c = Date.valueOf(cvalidtill);
            qtClone.Quote_Valid_till__c = Date.valueOf(qvalidtill);
            qtClone.Quote_Number__c = quoteCount(oid);
            qtClone.Status = 'Draft';
            qtClone.Quote_Approved__c = false;
            qtclone.Account.Id=aid;
            qtclone.OpportunityId=oid;
            qtClone.ContactId = conList[0].Id;
            system.debug('qtClone List: '+qtClone);
            insert qtClone;
            system.debug('inserted quote: '+qtClone);
            
            getupdateQuotePriceBook(qtClone.Id);
            getcloneChildRecords(qtId, qtClone.Id);
            
            system.debug('quote Clone: '+qtClone);
            
            return qtClone.Id;
        }
        catch(exception e)
        {
            return e.getMessage();
        }
    }
    
    @AuraEnabled
    public static String getcloneChildRecords(String quoteId, String clonedQuoteId)
    {
        Map<Id, Id> ProductandPriceBookMap = new Map<Id, Id>();
        
        List<PriceBookEntry> pbEntyList = [Select Id, PriceBook2.Name, Product2.Id, Product2.Name, Name 
                                        FROM PricebookEntry 
                                        WHERE  PriceBook2.Name = 'Standard Price Book' LIMIT 50000];
         for(PriceBookEntry pbeList: pbEntyList)
         {
             ProductandPriceBookMap.put(pbeList.Product2Id, pbeList.Id);
         }
        
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<AVD_Line_Item__c> avdList = new List<AVD_Line_Item__c>();
                    
        for(QuoteLineItem ql: [select Id, Discount, Freight_Term__c, GP1__c, Last_Invoiced_Price__c, Last_Quote_Price__c, 
                              Description, ListPrice, Most_Likely_Discount__c, Pack_Size__c, Product2Id, Quantity, QuoteId, 
                              UnitPrice, Segment_Recommended_Price__c, SKU_ID__c, Subtotal, TotalPrice from QuoteLineItem
                              Where QuoteId=:quoteId])
        {
            QuoteLineItem qtlItemClone = ql.clone(false,false,false,false);
            qtlItemClone.QuoteId = clonedQuoteId;
            qtlItemClone.UnitPrice = 0;
            qtlItemClone.Quantity = 1;
            qtlItemClone.PriceBookEntryId = ProductandPriceBookMap.get(qtlItemClone.Product2Id);
            
            qlList.add(qtlItemClone);
        }

        for(AVD_Line_Item__c avd: [Select Id, Quote__c, Quote__r.Contract_Valid_from__c, Volume_From__c, Volume_To__c, Slab_Discount__c, Most_Likely__c, 
                       Start_Date__c, End_Date__c from AVD_Line_Item__c where Quote__c=:quoteId])
        {
            AVD_Line_Item__c avdItem = avd.clone(false, false, false, false);
            avdItem.Quote__c = clonedQuoteId;
            avdItem.Start_Date__c = sdate;
            avdItem.End_Date__c = edate;
    
            avdList.add(avdItem);
        }
    
            
        if(qlList.size()>0)
        {
            insert qlList;
        }
        if(avdList.size()>0)
        {
            insert avdList;
        }
        
        return '';
    }
    
    // Update Standard price book for quote
    public static void getupdateQuotePriceBook(String qtId)
    {        
        List<PriceBook2> priceBookList = [select id from Pricebook2 where IsStandard = TRUE];
         system.debug('Price Book List: '+priceBookList);
         if(!priceBookList.isEmpty())
         {
              List<Quote> qtList = [select Id, PriceBook2Id from Quote where Id=:qtId];
              system.debug('Quote List: '+qtList);
              for(Quote qt: qtList)
              {
                  qt.PriceBook2Id = priceBookList[0].Id;
              }
              update qtList;
              system.debug('qt List: '+qtList);
         }
    }
    
    @AuraEnabled
    public static String quoteCount(String oppId){
        String newQuoteNumber='';
        Opportunity opp = [SELECT Id, AccountId, Opportunity_Number__c FROM Opportunity WHERE Id=:oppId limit 1];        
        Account acc = [SELECT Id, Quote_allowed__c, BU_Name__c FROM Account WHERE Id=:opp.AccountId limit 1];        
        List<Quote> qt = [SELECT Id, Quote_Number__c  FROM Quote WHERE OpportunityId = :oppId ORDER BY CreatedDate desc NULLS LAST];        
        
        newQuoteNumber=acc.BU_Name__c+'/';
        
        Date dateToday = Date.today();
        //String sToday = RIGHT(TEXT(YEAR( DATEVALUE(CreatedDate))),2) + "/" +LPAD(TEXT(MONTH( DATEVALUE(CreatedDate)   )),2,"0") + "/" +LPAD(TEXT(DAY( DATEVALUE(CreatedDate))),2,"0")
        String year= String.valueof(dateToday.year());
        system.debug('year '+year);
        
        system.debug('year.charAt(2) substring) '+year.substring(2));
        String mon='';
        String dy='';
        Integer d=dateToday.day(); 
        Integer mn=dateToday.month();        
        if(mn<10){
            //07
            mon = '0'+String.valueOf(mn);
        }else{ mon = String.valueOf(mn); }
         if(d<10){
            //07
            dy = '0'+String.valueOf(d);
        }else{ dy = String.valueOf(d); }
        
        
        String sToday = year.substring(2) + mon + dy;
        
        newQuoteNumber = newQuoteNumber + sToday + '/';
        newQuoteNumber = newQuoteNumber + opp.Opportunity_Number__c + '/';
        Integer num=0;
        String finalNum='';
         system.debug('qt.size() '+qt.size());
        if(qt.size()>0){
            String qtn=qt[0].Quote_Number__c;
            
            if(qtn!=null){
                String[] oldQuoteNumber =qtn.split('/');
                system.debug('oldQuoteNumber[] '+oldQuoteNumber);
                
                if(oldQuoteNumber.size()>3){
                    num=Integer.valueOf(oldQuoteNumber[3]);
                    num += 1;
                    system.debug('in IF [] ');
                    
                    if(num<10){
                        //056
                        finalNum = '00'+String.valueOf(num);
                    }else if(num<100 && num > 9){
                        finalNum = '0'+String.valueOf(num);
                    }else{
                        finalNum=String.valueOf(num);
                    }
                }}else{
                    system.debug('in else qtn[] ');
                    finalNum='001';
                }
        }else{
            system.debug('in else qt[] ');
            finalNum='001';
        }
        newQuoteNumber = newQuoteNumber + finalNum;
        
        system.debug('newQuoteNumber '+newQuoteNumber);
        
        return newQuoteNumber;
    }
    
}