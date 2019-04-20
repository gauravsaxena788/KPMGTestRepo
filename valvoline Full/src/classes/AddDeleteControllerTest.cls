@isTest
public class AddDeleteControllerTest {

    Static testMethod void TestControllerlHelper(){
    
        ///////////
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'TBM' LIMIT 1];
        
        User usr = new User(LastName = 'TEST',
                           FirstName='JAI',
                           Alias = 'jda',
                           Email = 'jaitest@gmail.com',
                           Username = 'jaitest1298@gmail.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;                   
        //////////
    
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
        
        ///////////// another opty //////////
        Account acc2= new Account();
        acc2.Name='Testclass acc';
        acc2.Is_Parent__c='N';
        acc2.Type='Factory Fill';
        acc2.Indutry_Segment__c='On-Highway';
        acc2.Market_Segment__c='PowerGen';
        acc2.Quote_allowed__c='Yes';
        acc2.BU_Name__c='OEM';
        acc2.Category__c='New';
        acc2.Accound_Aprroved__c=true;
        acc2.Account_Type__c='Factory Fill';
        acc2.Owner = usr;
        acc2.Zone__c = 'North';
        
        insert acc2;
        
        Contact con2 = new Contact();
        con2.FirstName = 'Test';
        con2.LastName = 'Test';
        con2.AccountId = acc2.Id;
        
        insert con2;
        
        Opportunity opp2 = new Opportunity();
        opp2.AccountId=acc2.Id;
        opp2.Name='Testclass Opp';
        opp2.StageName='Won';
        opp2.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp2.CloseDate= date.today();   
        opp2.Opportunity_Type__c='Business Development - New Account';
        opp2.Owner = usr;
        
        insert opp2;
        
        List<Quote> qtLst2= new List<Quote>();
        Quote qt2 = new Quote();
        qt2.Name='Testclass Qt1';
        qt2.Status = 'In Review';
        qt2.BU_Name__c = 'C&I';
        qt2.Total_Vol__c=55;
        qt2.OpportunityId = opp2.id;
        qt2.ContactId = con2.Id;
        qt2.Quote_Number__c= '12345';
        //qt2.Owner.Id = usr.Id;
        insert qt2;
        ////////////////////////////////////
        
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
        
        //////////// another team for another opty
        opportunityTeamMember oppteam2 = new opportunityTeamMember();
        oppteam2.opportunityId = opp2.Id;
        oppteam2.userId = OwnerList1[0].Id;
        
        
        insert oppteam2;
        //////////////////////////////////////////
        
        String q =qt.Id;
        String q2 = qt2.Id;
                
        List<QuoteLineItem> quoteList = new List<QuoteLineItem>();
               
        
        addDeleteController prod = new addDeleteController();
              
        addDeleteController.saveQuoteLineItem(quoteList);
        addDeleteController.findAllNew(q);
        System.runAs(usr)
        {
            addDeleteController.findAllNew(q);
            addDeleteController.findAllNew(q2);
        }
      }

}