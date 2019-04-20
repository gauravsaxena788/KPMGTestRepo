@isTest
public class AVDHelperClassTest {

    Static testMethod void TestAVDHelper(){
    
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
        
        List<AVD_Line_Item__c> avdList = new List<AVD_Line_Item__c>();
        
        AVD_Line_Item__c avd = new AVD_Line_Item__c();
        AVD_Line_Item__c avd2 = new AVD_Line_Item__c();
        AVD_Line_Item__c avd3 = new AVD_Line_Item__c();
        
        avd.Quote__c = qt.Id;
        avd.Volume_From__c = 100;
        avd.Volume_To__c = 200;
        avd.Slab_Discount__c = '2';
        avd.Most_Likely__c = true;
        
        avd2.Quote__c = qt.Id;
        avd2.Volume_From__c = 100;
        avd2.Volume_To__c = 200;
        avd2.Slab_Discount__c = '2';
        avd2.Most_Likely__c = false;
        
        avd3.Quote__c = qt.Id;
        avd3.Volume_From__c = 100;
        avd3.Volume_To__c = 200;
        avd3.Slab_Discount__c = '';
        avd3.Most_Likely__c = false;
        
        avdList.add(avd);
        avdList.add(avd2);
        avdList.add(avd3);
        if(avdList.size()>0)
        {
            insert avdList;
        }
      
        
        List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId()];
        
        List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
        List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
        
        opportunityTeamMember oppteam = new opportunityTeamMember();
        oppteam.opportunityId = opp.Id;
        oppteam.userId = OwnerList[0].Id;
        
        
        insert oppteam;
        
        
        
        AVDHelperClass avdApp = new AVDHelperClass();
        AVDHelperClass.checkDuplicate(quoteId, avdList);      
        
      }

}