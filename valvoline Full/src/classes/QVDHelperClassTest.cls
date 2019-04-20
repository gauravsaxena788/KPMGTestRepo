@isTest
public class QVDHelperClassTest {
Static testMethod void TestQVDHelper(){
    
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
        
        Set<Id> quoteId = new Set<Id>();
        
        quoteId.add(qt.Id);
        
        List<QVD_Line_Item__c> uvdList = new List<QVD_Line_Item__c>();
        
        QVD_Line_Item__c uvd = new QVD_Line_Item__c();
        QVD_Line_Item__c uvd2 = new QVD_Line_Item__c();
        QVD_Line_Item__c uvd3 = new QVD_Line_Item__c();
        
        uvd.Quote__c = qt.Id;
        uvd.Volume_From__c = 100;
        uvd.Volume_To__c = 200;
        uvd.Slab_Discount__c = '2';
        uvd.Most_Likely__c = true;
        uvd.Start_Date__c=date.today();
        
        uvd2.Quote__c = qt.Id;
        uvd2.Volume_From__c = 100;
        uvd2.Volume_To__c = 200;
        uvd2.Slab_Discount__c = '2';
        uvd2.Most_Likely__c = false;
    
        uvd3.Quote__c = qt.Id;
        uvd3.Volume_From__c = 100;
        uvd3.Volume_To__c = 200;
        uvd3.Slab_Discount__c = '';
        uvd3.Most_Likely__c = false;
        
        uvdList.add(uvd);
        uvdList.add(uvd2);
        uvdList.add(uvd3);
    
        if(uvdList.size()>0)
        {
            insert uvdList;
        }        
        
        List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId()];
        
        List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
        List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
        
        opportunityTeamMember oppteam = new opportunityTeamMember();
        oppteam.opportunityId = opp.Id;
        oppteam.userId = OwnerList[0].Id;
        
        
        insert oppteam;
        
        
        
        QVDHelperClass uvdApp = new QVDHelperClass();
        QVDHelperClass.checkDuplicate(quoteId, uvdList);      
        
      }
}