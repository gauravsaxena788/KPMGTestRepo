@istest
public class QuoteCloneHelperTest {
    
    static testmethod void clonetest(){
        Account acc = VA_utilClass.createAccount();
        insert acc;       
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.AccountId = acc.Id;
        
        insert con;        
        
        Opportunity opp = new Opportunity();
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp';
        opp.StageName='Won';
        opp.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp.CloseDate= date.today();   
        opp.Opportunity_Type__c='Business Development - New Account';
        
        insert opp;
        
        Quote qt = new Quote();
        qt.Name='Testclass Qt1';
        qt.Total_Vol__c=55;
        qt.OpportunityId = opp.id;
        qt.ContactId = con.Id;
        qt.BU_Name__c='C&I';
        qt.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
        insert qt;
        
        AVD_Line_Item__c avdLine = new AVD_Line_Item__c();
        avdLine.Volume_From__c = 100;
        avdLine.Volume_To__c = 200;
        avdLine.Slab_Discount__c = '1';
        avdLine.Start_Date__c = system.today();
        avdLine.End_Date__c = system.today().addDays(30);
        avdLine.Quote__c = qt.Id;
        
        insert avdLine;
        
        Quote qt1 = new Quote();
        qt1.Name='Testclass Qt1';
        qt1.Total_Vol__c=55;
        qt1.OpportunityId = opp.id;
        qt1.ContactId = con.Id;
        qt1.BU_Name__c='C&I';
        qt1.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
        insert qt1;
        
       
        Date d1 = system.today();
        Date d2 = d1.addDays(30);
        String cvalidfrom = String.valueOf(d1);
        String cvalidtill = String.valueOf(d2);
        String qvalidtill = String.valueOf(d2);
        QuoteCloneHelper.createQuoteClone(qt.Id, qt.Name, cvalidfrom, cvalidtill, qvalidtill, acc.Id, opp.Id);
        QuoteCloneHelper.fetchUserAcc1();
        QuoteCloneHelper.fetchopp(acc.id);
        QuoteCloneHelper.fetchopponload(qt.Id);
        QuoteCloneHelper.getDetailsFromQuote(qt.Id);
        QuoteCloneHelper.getupdateQuotePriceBook(qt.Id);
        QuoteCloneHelper.quoteCount(opp.Id);
        QuoteCloneHelper.getcloneChildRecords(qt.Id, qt1.Id);
        
        
    }
}