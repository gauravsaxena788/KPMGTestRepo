@isTest
public class QuoteHelperTest {
    
    Static testMethod void TestCreateQuote(){
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
        acc.Accound_Aprroved__c=true;
        acc.Account_Type__c='Factory Fill';
        acc.Zone__c = 'North';
        accLst.add(acc);
        insert accLst;
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.AccountId = acc.Id;
        
        insert con;
        
        List<Opportunity> oppLst= new List<Opportunity>();
        Opportunity opp = new Opportunity();
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp';
        opp.StageName='Won';
        opp.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp.CloseDate= date.today();   
        opp.Opportunity_Type__c='Business Development - New Account';
        oppLst.add(opp);
        insert oppLst;
        
        QuoteHelper.getAccountId(oppLst[0].Id);
        
        String flag=String.valueof(QuoteHelper.findAllowed(opp.id));
        
        if( flag =='In Review' ){
            List<Quote> qtLst= new List<Quote>();
            Quote qt = new Quote();
            qt.Name='Testclass Qt1';
            qt.BU_Name__c = 'C&I';
            qt.Total_Vol__c=55;
            qt.OpportunityId = opp.id;
            qt.ContactId = con.Id;
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = true;
            //qt.Net_GP_Ltr__c = 20;
            qt.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
            insert qt;
            qt = new Quote();
            
            qt.Name='Testclass Qt2';
            qt.Total_Vol__c=65;
            qt.BU_Name__c = 'C&I';
            qt.OpportunityId = opp.id;
            qt.ContactId = con.Id;
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = true;
           // qt.Net_GP_Ltr__c = 25;
            qt.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
            qtLst.add(qt);
            insert(qtLst);
        }
        else{
            List<Quote> qtLst= new List<Quote>();
            Quote qt = new Quote();
            qt.Name='Testclass Qt1';
            qt.BU_Name__c = 'C&I';
            qt.Total_Vol__c=55;
            qt.OpportunityId = opp.id;
            qt.ContactId = con.Id;
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = true;
           // qt.Net_GP_Ltr__c = 20;
            qt.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
            insert qt;
            qt = new Quote();
            
            qt.Name='Testclass Qt2';
            qt.BU_Name__c = 'C&I';
            qt.Total_Vol__c=65;
            qt.OpportunityId = opp.id;
            qt.ContactId = con.Id;
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = true;
           // qt.Net_GP_Ltr__c = 25;
            qt.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
            qtLst.add(qt);
            insert(qtLst);
        }
        
        
    }
}