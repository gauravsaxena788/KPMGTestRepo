@isTest
public class OLITriggerHandlerTest
{
    static testmethod void OLITriggerMethod()
    {
        String recordTypeSAP  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
        List<Account> accLst= new List<Account>();
        
        Account acc= new Account();
        
        acc.Name='Testclass acc';
        acc.Is_Parent__c='N';
        acc.Type='Factory Fill';
        acc.Indutry_Segment__c='On-Highway';
        acc.Market_Segment__c='PowerGen';
        acc.Quote_allowed__c='Yes';
        acc.BU_Name__c='OEM';
        acc.Category__c='New';
        acc.Account_Type__c='Factory Fill';
        acc.Zone__c = 'North';
        accLst.add(acc);
        
        insert accLst;
       
        List<Account_Potential__c> accpotLst= new List<Account_Potential__c>();
        
        Account_Potential__c accpot= new Account_Potential__c();
        accpot.Account__c = acc.Id;
        accpot.BU_Name__c = 'C&I';
        accpot.PH6_Qlikview__c = 'Borilo';
        accpot.Valvoline_Financial_Year__c  = '2018';
        accpot.Potential_Volume_in_kL__c = 25;
        accpot.YTD_in_volume__c = 100;       
        accpotLst.add(accpot);
        insert accpotLst;
        
             Id monthly_plan = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
        Opportunity opt= new Opportunity(Name='monthly test', Financial_Year__c='2018',AccountId=acc.Id, StageName = 'Open', CloseDate = system.today(), RecordtypeId=monthly_plan);
     insert opt;
     
        List<Opportunity> oppLst= new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = recordTypeSAP;
        opp.Opportunity_Id__c=opt.id;
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp';
        opp.StageName='Won';
        opp.Month_sap__c = 'Oct';
        opp.Calendar_Year__c= '2017';
        opp.CloseDate= date.today();   
        opp.Opportunity_Type__c='Business Development - New Account';
        
        oppLst.add(opp);
        insert oppLst;
        

      
        

       
      Product2 p = new product2();
      p.name='x';
      p.Focus_Product_C_I__c ='Yes';
      p.Focus_Product_Fleet__c='Yes';
      p.Focus_Product_OEM__c ='Yes';
      p.PH1__c = 'Valvoline';
      p.PH2__c ='Filters';
      p.PH3__c='Co-Branded';
      p.PH4__c ='Tectyl';
      p.PH5__c = 'Ready to use';
      p.PH6_Qlikview__c='Borilo';
      p.PH6_SAP__c ='Cummins Oil';
      p.PH7__c ='Glass Cleaner';
      p.Packsize__c = '20';
      p.SKU_Id__c = 123456;
      insert p;

// Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
      
      
      Pricebook2 pb = new pricebook2(name='test');
      insert pb;

      PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p.id,unitprice=1.0, isActive=true);
      insert pbe;

         OpportunityLineItem oLI = new OpportunityLineItem();
          oLI.OpportunityId=opp.id;
          oLI.Product2Id=p.Id;
          oLI.PricebookEntryId=pbe.Id;
          oLI.Quantity=40.00;
          oLI.UnitPrice=200.00;
          oLI.Description='Data Load Testing';
          oLI.State_Name__c='MH';
          oLI.Vol_inltrs__c=55.00;
          oLI.Invoice_Line_Unique_ID__c = '123';
          insert oLI;  
          
          oli.quantity=11;
          update oli;
          delete oli; 
    
    }

}