@isTest(SeeAllData = true)
public class QuotePDFControllerTest{

    Static testMethod void TestQuotePDFController(){
    
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
        con.LastName = 'Test con';
        con.MailingStreet = 'New Indra Nagar';
        con.MailingCity = 'Gurgaon';
        con.MailingState = 'Haryana';
        con.MailingCountry = 'India';
        con.MailingPostalCode = '122001';
        con.AccountId = acc.Id;
        insert con;
        
        
        Opportunity opp = new Opportunity();
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp';
        opp.StageName='Won';
        opp.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp.CloseDate= date.today();   
        opp.Opportunity_Type__c='Business Development - New Account';
        opp.Ownerid = userinfo.getuserid();

        insert opp;
        
         List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId() Limit 1];
        
         List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
         List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
      
        List<Quote> qtLst= new List<Quote>();
            Quote qt = new Quote();
            qt.Name='Testclass Qt1';
            qt.Status = 'In Review';
            qt.Total_Vol__c=55;
            qt.OpportunityId = opp.id;
            qt.Quote_Number__c= '12345';
            qt.ContactId = con.Id;
            qt.Reporting_Manager__c = OwnerList[0].Id;
            qt.PV_Clause_Applicable__c = 'Yes';
            qt.Cash_Discount_Policy__c = 'For all Distributors (Non-Cummins)';
            qt.Contract_Valid_from__c= system.today();
      	    qt.Contract_Valid_till__c = system.today()+7;
        	qt.Delivery_Time__c = '5 to 7 Days';
        	qt.BU_Name__c='C&I';
        	qt.Annexures__c = 'Annexure CI-102 - OEM and Key Account';
       // qt.Annexures__c = 'Annexure CI-101 - Product Details;Annexure CI-102 - OEM and Key Account;Annexure CI-103 - POST;Annexure FLT-101 - Product Details';
        //qt.Annexures__c = 'Annexure-A101 - Technical Value Added Services;Annexure-A201 - Strong OEM Relationship in India;Annexure-A301 - Valvoline\'s Distribution Network;Annexure-B101 - Key Products Specifications;';
            
            insert qt;
        
       /* Quote_PDF_Setting__mdt qpdf=new Quote_PDF_Setting__mdt();
        qpdf.Industry_Segment__c='test';
        qpdf.Image_Name__c='test1';
        qpdf.Industry_Segment_Heading__c='test2';
        qpdf.Industry_Segment_Content__c='test3'; */
        
            
      
          
         opportunityTeamMember oppteam = new opportunityTeamMember();
         oppteam.opportunityId = opp.Id;
         oppteam.userId = OwnerList[0].Id;
         
        
         insert oppteam;
         
         String q =qt.Id ;
         
         PageReference pageRef = Page.Product_Page;
         pageRef.getParameters().put('recordId', q);
         Test.setCurrentPage(pageRef);
         
         QuotePDFController quotepdf = new QuotePDFController();
        quotepdf.getDynamicFormatString();
        
      }
      
      
      
   
}