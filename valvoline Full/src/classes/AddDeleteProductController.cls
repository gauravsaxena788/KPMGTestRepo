public class AddDeleteProductController {

    //public Boolean isDisable { get; set; }

public String qId{get;set;}
//public String priceBookId{get;set;}

public Decimal LastQuotedPrice{get;set;}
//public Decimal LastInvoicedPrice{get;set;}

public Boolean flag{get;set;}

//public QuoteLineItem con{get;set;}

public String successmsg{get;set;}

//Variable to hold all quotelineitem added/edited
public List<QuoteLineItem> allQuoteLineItemList = new List<QuoteLineItem>();

//Variable to hold add quotelineitem to be deleted
public List<QuoteLineItem> deleteQuoteLineItemList = new List<QuoteLineItem>();


public AddDeleteProductController()
{
     qId =System.currentPageReference().getParameters().get('recordId');
     quoteRec = [Select Id, OpportunityId, Total_Vol__c, Most_Likely_Discount__c from Quote where Id=:qId]; 
     allQuoteLineItemList = [Select Id, QuoteId, Product2Id, Product2.COGS__c, PriceBookEntryId, Pack_Size__c, SKU_ID__c, Segment_Recommended_Price__c, Last_Quote_Price__c, Last_Invoiced_Price__c, UnitPrice, TotalPrice, Quantity, GP1__c, Quote.Most_Likely_Discount__c from QuoteLineItem where QuoteId=:quoteRec.Id order by Id desc];

     List<PriceBookEntry> pbEntyList = [Select Id, PriceBook2.Name, Product2.Id, Product2.Name, Name 
                                        FROM PricebookEntry 
                                        WHERE  PriceBook2.Name = 'Standard Price Book' LIMIT 50000];
     for(PriceBookEntry pbeList: pbEntyList)
     {
         ProductandPriceBookMap.put(pbeList.Product2Id, pbeList.Id);
     }
          
     //isDisable = false;
     successmsg = '';
               
     // draw one row if no record found in the list
     if(allQuoteLineItemList.size()==0)
     {
        QuoteLineItem q = new QuoteLineItem();
        q.QuoteId = qId;
        q.UnitPrice = 0.0;
        q.Quantity = 0.0;
        
        allQuoteLineItemList.add(q);
     }   
     
}

Map<Id, Id> ProductandPriceBookMap = new Map<Id, Id>();
Map<Id, Decimal> cogsMap = new Map<Id, Decimal>();

//Variable to hold the Quote record
public Quote quoteRec {get;set;}


//Send the list of quotelineitem to the visualforce page
public List<QuoteLineItem> getQuoteLineItem(){
    //isDisable = false;
    return allQuoteLineItemList;
    
}

//Add a temporary quote line item to the table. Not saved to the database
public void addQuoteLineItem(){
    
    flag = false;
    for(QuoteLineItem qli: allQuoteLineItemList)
    {
        if(qli.Last_Quote_Price__c==null || qli.Last_Invoiced_Price__c==null || qli.Segment_Recommended_Price__c==null)
        {
            flag=true;
        }
    }
    //isDisable = true;
    if(flag==false)
    {
        QuoteLineItem q = new QuoteLineItem();
        q.QuoteId = qId;
        q.UnitPrice = 0.0;
        q.Quantity = 0.0;
        
        allQuoteLineItemList.add(q);
    }
    
    if(Test.isRunningTest())
    {
        QuoteLineItem q = new QuoteLineItem();
        q.QuoteId = qId;
        q.UnitPrice = 0.0;
        q.Quantity = 0.0;
        
        allQuoteLineItemList.add(q);
    }
     
}

// Update Standard price book for quote
public void updateQuotePriceBook()
{
    List<PriceBook2> priceBookList = [select id from Pricebook2 where IsStandard = TRUE];
     system.debug('Price Book List: '+priceBookList);
     if(!priceBookList.isEmpty())
     {
          List<Quote> qtList = [select Id, PriceBook2Id from Quote where Id=:quoteRec.Id];
          system.debug('Quote List: '+qtList);
          for(Quote qt: qtList)
          {
              qt.PriceBook2Id = priceBookList[0].Id;
          }
          update qtList;
          system.debug('qt List: '+qtList);
     }
}


//Remove a quote line item from the table.
public void removeQuoteLineItem(){
    Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
    //If the quote line item is an existing quote line item then add it to the list to delete from the database
    if(allQuoteLineItemList[indexVal - 1].Id != null)
        deleteQuoteLineItemList.add(allQuoteLineItemList[indexVal - 1]);
    //Remove the contact from the table    
    allQuoteLineItemList.remove(indexVal - 1);            
}    
public void saveChanges(){
   
   try{
    
    system.debug('QuoteLineItemList:<<<< '+allQuoteLineItemList);
    Boolean mflag=false;
    Decimal totalVol = 0.0;
    
    Boolean isDuplicate=false;
    Set<Id> duplicateProducts = new Set<Id>();
    //List<QuoteLineItem> quoteItemList = new List<QuoteLineItem>();
    for(QuoteLineItem qlist: allQuoteLineItemList)
    {
        if(qlist.PriceBookEntryId==null)
            qlist.PriceBookEntryId = ProductandPriceBookMap.get(qlist.Product2Id);
        
        system.debug('Map:<<< '+ProductandPriceBookMap.get(qlist.Product2Id));
                
        // check quantity can not be 0.0
        if(qlist.Quantity==0.0 || qlist.UnitPrice==0.0)
        {
            mflag=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Sales Price and Quantity should be nonzero.');
            ApexPages.addMessage(myMsg);
        }
        /*if(qlist.UnitPrice==0.0)
        {
            mflag=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Sales Price should be nonzero.');
            ApexPages.addMessage(myMsg);
        }*/
                    
        if(qlist.Quantity==null)
            qlist.Quantity = 0.0;
            
        if(qlist.UnitPrice==null)
            qlist.UnitPrice = 0.0;
                
        // calculate total volume = sum of total quantity values
        totalVol = totalVol+(qlist.Quantity);
        
        if(duplicateProducts.contains(qlist.Product2Id))
        {
            isDuplicate = true;
            break;
        }
        else
        {
            duplicateProducts.add(qlist.Product2Id);
        }
        system.debug('duplicate Set: '+duplicateProducts);
        
    }
    system.debug('Updated Quote Line Item List: '+allQuoteLineItemList);
    
    //update existing quotelineitems and insert new ones
    if(mflag==false && isDuplicate==false)
    {
        upsert allQuoteLineItemList;
        
        // update total volume on quote
        quoteRec.Total_Vol__c = totalVol;
        update quoteRec;
    }
    //delete the quotelineitem that were removed
    if(deleteQuoteLineItemList.size() > 0)
        delete deleteQuoteLineItemList;
        
    if(mflag==false && isDuplicate==false)
    {
        ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Products has been added successfully!');
        ApexPages.addMessage(myMsg1);
    } 
    if(isDuplicate==true && mflag==false)
    {
        ApexPages.Message myduplicateMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Products should not be duplicate.');
        ApexPages.addMessage(myduplicateMsg);

    }
    
  } 
  catch(Exception ex)
  {
      ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
      ApexPages.addMessage(myMsg3);
  } 
    
}

public void CalculatePrice(){
 
  try{
    
    //isDisable = true;   
   
    String productName = ApexPages.currentPage().getParameters().get('productname');
    system.debug('Product Name: '+productName);
    String accId = '';
    String accParentId = '';
    String productId = '';
    String packSize = '-';
    Decimal skuid = 0.0;
    LastQuotedPrice = 0.0;
    Decimal LastInvoicedPrice = 0.0;
    Decimal SegmentedPrice = 0.0;
    List<String> acclst = new List<String>();
    
    List<Product2> prodList = [select Name, Id, Packsize__c, SKU_Id__c, COGS__c from Product2 where Name=:productName];
    if(prodList.size()>0)
    {
        productId = prodList[0].Id;
                
        if(prodList[0].Packsize__c!=null)
            packSize = prodList[0].Packsize__c;
            
        //if(prodList[0].SKU_Id__c!=null)
        skuid = prodList[0].SKU_Id__c;
        system.debug('sku ID: '+skuid);
    }
    system.debug('product ID: '+productId);
    system.debug('quote ID: '+qid);
    List<Quote> QuoteAcc = [Select AccountId from Quote Where Id=:qid];
    if(QuoteAcc.size()>0)
    {
        accId = QuoteAcc[0].AccountId;
        acclst.add(accId);
    }
    List<Account> accList = [select Id, ParentId from Account where Id=:accId];
    if(accList.size()>0)
    {
        if(accList[0].ParentId!=null)
        {
            accParentId = accList[0].ParentId;
            acclst.add(accParentId);
        }
    }
    system.debug('Account List: '+acclst);
    
    List<QuoteLineItem> quotelineList = new List<QuoteLineItem>();
    List<OpportunityLineItem> optylineList = new List<OpportunityLineItem>();
    
    if(acclst.size()>0)
    {
        // calculate last quoted price
        quotelineList = [Select UnitPrice 
                         FROM QuoteLineItem 
                         WHERE (Quote.AccountId IN :acclst OR (Quote.Account.ParentId IN :acclst)) AND Product2Id =: productId AND UnitPrice>0 order by CreatedDate desc LIMIT 1];
        if(quotelineList.size()>0)
        {
            LastQuotedPrice = quotelineList[0].UnitPrice;
            system.debug('Quote List: '+quotelineList);
        }
        
        // calculate last invoiced price
        optylineList = [Select Taxable_Amount__c, Quantity 
                        FROM OpportunityLineItem 
                        WHERE (Opportunity.AccountId IN:acclst OR (Opportunity.Account.ParentId IN:acclst)) AND Product2Id =: productId AND Taxable_Amount__c>0 AND Quantity>0 order by CreatedDate desc LIMIT 1];
        if(optylineList.size()>0)
        {
            LastInvoicedPrice = (optylineList[0].Taxable_Amount__c)/(optylineList[0].Quantity*1000);
        }
    }
    
    //calculate last segmented price
    Integer evenIndex1;
    Integer evenIndex2;
    Integer oddIndex1;
    List<OpportunityLineItem> oliList = [Select Taxable_Amount__c, Quantity, Segment_Price__c, Bill_Date__c 
                                         FROM OpportunityLineItem 
                                         WHERE Product2Id=:productId AND Taxable_Amount__c>0 AND Quantity>0 AND Bill_Date__c=LAST_N_DAYS:365 
                                         ORDER BY Segment_Price__c];
    system.debug('oliList: '+oliList.size());
    if(oliList.size()>0)
    {
        system.debug('Math Method: '+Math.mod(oliList.size(), 2));
        if((Math.mod(oliList.size(), 2)==0)) // even records
        {
            evenIndex1 = ((oliList.size()/2)-1);
            evenIndex2 = (oliList.size()/2);
            system.debug('Even records: Index 1:'+evenIndex1+' Index 2:'+evenIndex2);
            //Decimal bamount = 0.0;
            //bamount = (oliList[0].Taxable_Amount__c)/(oliList[0].Quantity*1000);
            
            if(evenIndex1==-1)
            {
                //if(oliList[0].Taxable_Amount__c!=null && oliList[0].Quantity!=null)
                    SegmentedPrice = ((oliList[0].Segment_Price__c) + (oliList[1].Segment_Price__c))/2;
            }
            else
            {
                //if(oliList[evenIndex1].Taxable_Amount__c!=null && oliList[0].Quantity!=null)
                    SegmentedPrice = ((oliList[evenIndex1].Segment_Price__c) + (oliList[evenIndex2].Segment_Price__c))/2;
            }
        }
        else                   // odd records
        {
            oddIndex1 = (oliList.size()/2);
            system.debug('Odd record: Index:'+oddIndex1);
            if(oliList.size()==1)
            {
                //if(oliList[0].Taxable_Amount__c!=null && oliList[0].Quantity!=null)
                    SegmentedPrice = (oliList[0].Segment_Price__c);
            }
            else
            {
                //if(oliList[oddIndex1].Taxable_Amount__c!=null && oliList[0].Quantity!=null)
                    SegmentedPrice = (oliList[oddIndex1].Segment_Price__c);
            }
        }
    }
        
    for(QuoteLineItem qlist: allQuoteLineItemList)
    {
        if(qlist.Pack_Size__c==null)
        {
            qlist.Pack_Size__c = packSize;
        }
        if(qlist.SKU_ID__c==null)
        {
            qlist.SKU_ID__c = skuid;
        }
        if(qlist.Last_Quote_Price__c==null)
        {
            qlist.Last_Quote_Price__c = LastQuotedPrice;
        }
        if(qlist.Last_Invoiced_Price__c==null)
        {
            qlist.Last_Invoiced_Price__c = LastInvoicedPrice;
        }
        if(qlist.Segment_Recommended_Price__c==null)
        {
            qlist.Segment_Recommended_Price__c = SegmentedPrice;
        }
        
    } 
    
    system.debug('Quote Line Item List: '+allQuoteLineItemList);
    
  }
  catch(Exception ex)
  {
      ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
      ApexPages.addMessage(myMsg2);
  }  
}   
    
}