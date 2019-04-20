@isTest
public class AddDeleteProductControllerTest {

    Static testMethod void TestProductControllerlHelper(){
    
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
        
        List<Quote> qtLst= new List<Quote>();
        Quote qt = new Quote();
        qt.Name='Testclass Qt1';
        qt.Status = 'In Review';
        qt.BU_Name__c = 'C&I';
        qt.Total_Vol__c=55;
        qt.OpportunityId = opp.id;
        qt.ContactId = con.Id;
        qt.Quote_Number__c= '12345';
        insert qt;
        
        
        Product2 prd2 = new Product2();
        
        prd2.Name = 'FLEET PLUS 15W40 CI4 PLUS 1/210 LTR';
        prd2.SKU_Id__c = 1234;
        prd2.Focus_Product_C_I__c = 'Yes';
        prd2.Focus_Product_OEM__c = 'Yes';
        prd2.Packsize__c = '2L';
        prd2.COGS__c = 20;
        prd2.Focus_Product_Fleet__c = 'Yes';
        prd2.PH1__c = 'Valvoline';
        prd2.PH2__c = 'Filters';
        prd2.PH3__c = 'Private Label';
        prd2.PH4__c = 'KPC';
        prd2.PH5__c = 'Everfresh';
        prd2.PH6_Qlikview__c = 'AMW';
        prd2.PH6_SAP__c = 'Car Care';
        prd2.PH7__c = 'Automotive';
        
        insert prd2;
        
        
        List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId()];
        
        List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
        List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
        
        opportunityTeamMember oppteam = new opportunityTeamMember();
        oppteam.opportunityId = opp.Id;
        oppteam.userId = OwnerList[0].Id;
        
        
        insert oppteam;
        
        String q =qt.Id ;
        
        /*List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE Product2Id =: prd2.Id AND PriceBook2.isStandard=true LIMIT 1];
        
        OpportunityLineItem optyLineItem = new OpportunityLineItem();
        
        optyLineItem.OpportunityId = opp.Id;
        optyLineItem.Basic_Amount__c = 150;
        optyLineItem.Quantity = 200;
        optyLineItem.Product2Id = prd2.Id;
        optyLineItem.TotalPrice = 200;
        optyLineItem.PricebookEntryId = priceBookList[0].Id;
        
        insert optyLineItem;*/
                
        
        PageReference pageRef = Page.Product_Page;
        pageRef.getParameters().put('recordId', q);
        pageRef.getParameters().put('productname', prd2.Name);
        pageRef.getParameters().put('index', '1');
        Test.setCurrentPage(pageRef);
        
        AddDeleteProductController prod = new AddDeleteProductController();
              
        prod.addQuoteLineItem();
        prod.getQuoteLineItem();
        prod.updateQuotePriceBook();        
        prod.CalculatePrice();
        prod.saveChanges();
        prod.removeQuoteLineItem();
      }

}