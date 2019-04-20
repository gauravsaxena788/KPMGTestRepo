@isTest
public class QuoteApprovalHelperTest {

    Static testMethod void TestQuoteApprovalHelper(){
    
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
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = False;
            //qt.Net_GP_Ltr__c = 20;
            qt.Quote_Number__c= '12345';
            insert qt;
            
          //List<Quote> qtLst= new List<Quote>();
            Quote qt1 = new Quote();
            qt1.Name='Testclass Qt1';
            qt1.Status = 'Draft';
            qt1.BU_Name__c = 'C&I';
            qt1.Total_Vol__c=255;
            //qt1.GP_Ltr__c = 2;
            qt1.OpportunityId = opp.id;
            qt1.ContactId = con.Id;
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = False;
            //qt.Net_GP_Ltr__c = 20;
            qt1.Quote_Number__c= '12345';
            insert qt1;  
            
         /*   Quote qt = new Quote();
            
            qt.Name='Testclass Qt2';
            qt.Status = 'In Review';
            qt.Total_Vol__c=65;
            qt.OpportunityId = opp.id;
            //qt.I_Confirm_that_no_SKU_has_GP_Ltr_0__c = false;
            qt.Net_GP_Ltr__c = 25;
            qt.Quote_Number__c=QuoteHelper.quoteCount(opp.id);
          
            
            qtLst.add(qt);
            insert(qtLst);*/
           
            
    
         List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId()];
        
         List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
         List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
        
         opportunityTeamMember oppteam = new opportunityTeamMember();
         oppteam.opportunityId = opp.Id;
         oppteam.userId = OwnerList[0].Id;
         
        
         insert oppteam;
         
          // List<Quote> q= [select id,name from Quote where id =:qt.id LIMIT 1];
        // String quoteid = q[0].id;  
         String q =qt.Id ;
         String q1 = qt1.Id;
         
        QuoteApprovalHelper quoteapp = new QuoteApprovalHelper();
       
        QuoteApprovalHelper.getOne(q);
        QuoteApprovalHelper.getTwo(q);
        QuoteApprovalHelper.getThree(q);
        QuoteApprovalHelper.getFour(q);
        QuoteApprovalHelper.getApprovalone(q);
        QuoteApprovalHelper.getApprovaltwo(q);
        QuoteApprovalHelper.getApprovalthree(q);
        QuoteApprovalHelper.getApprovalfour(q);
        QuoteApprovalHelper.getStepone(q);
        QuoteApprovalHelper.getSteptwo(q);
        QuoteApprovalHelper.getStepthree(q);
        QuoteApprovalHelper.getStepfour(q);
        QuoteApprovalHelper.getStepfour(q1);
        QuoteApprovalHelper.getStatus(q);
        QuoteApprovalHelper.getStatus1(q1);
       
       
        
      }

}