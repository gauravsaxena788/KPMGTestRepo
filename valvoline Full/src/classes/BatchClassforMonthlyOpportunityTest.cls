@isTest
public class BatchClassforMonthlyOpportunityTest {

    Static testMethod void TestBatchClassforMonthlyOpportunity(){
        Id primaryaccRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'VCPL_Primary_Account' AND sObjectType = 'Account'].Id;

        Account acc= new Account();
        acc.Name='Testclass acc';
        acc.Is_Parent__c='Y';
        acc.Type='Factory Fill';
        acc.Indutry_Segment__c='On-Highway';
        acc.Market_Segment__c='PowerGen';
        acc.Quote_allowed__c='Yes';
        acc.BU_Name__c='OEM';
        acc.Category__c='New';
        acc.Accound_Aprroved__c=true;
        acc.Account_Type__c='Factory Fill';
        acc.Status__c = 'Draft';
        acc.ship_to_code__c = '111111';
        acc.Zone__c = 'North';
        acc.RecordTypeId = primaryaccRecordTypeId;
        
        insert acc;
        
                
        List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
        
        AccountTeamMember act2 = new AccountTeamMember();
        act2.AccountId = acc.Id;
        act2.UserId = OwnerList2[0].Id;
        act2.TeamMemberRole = OwnerList2[0].manager.userrole.name;
        
        insert act2;
                
        acc.Status__c = 'Activated';
        update acc;
        
        Account acc2= new Account();
        acc2.Name='Test acc';
        acc2.Is_Parent__c='Y';
        acc2.Type='Factory Fill';
        acc2.Indutry_Segment__c='On-Highway';
        acc2.Market_Segment__c='PowerGen';
        acc2.Quote_allowed__c='Yes';
        acc2.BU_Name__c='OEM';
        acc2.Category__c='New';
        acc2.Accound_Aprroved__c=true;
        acc2.Account_Type__c='Factory Fill';
        acc2.Status__c = 'Draft';
        acc2.ship_to_code__c = '222222';
        acc2.Zone__c = 'North';
        acc2.RecordTypeId = primaryaccRecordTypeId;
        
        insert acc2;
        
        List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
        AccountTeamMember act = new AccountTeamMember();
        act.AccountId = acc2.Id;
        act.UserId = OwnerList1[0].Id;
        act.TeamMemberRole = OwnerList1[0].manager.userrole.name;
        
        insert act;
                
        acc2.Status__c = 'Activated';
        update acc2;
        
        Id monthlyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
                
        Opportunity opp = new Opportunity();
        opp.AccountId=acc2.Id;
        opp.RecordTypeId = monthlyRecordTypeId;
        opp.Name='Testclass Opp';
        opp.StageName='Open';
        opp.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp.CloseDate= date.today(); 
        opp.Financial_Year__c = '2016';
        opp.Year__c = '2016';
        opp.Month__c = 'Jan';  
        opp.Opportunity_Type__c = 'Business Development - New Account';        
        opp.Opportunity_Code__c = '000000';
        
        insert opp;
      
                
        List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId()];
        
        //List<User> OwnerList1=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Sandeep Kalia' limit 1];
        
        //List<User> OwnerList2=[select id,name,managerid, manager.name,manager.userrole.name from user where Name = 'Jugvinder Bhatia' limit 1];
        
        AccountTeamMember accteam = new AccountTeamMember();
        accteam.AccountId = acc.Id;
        accteam.userId = OwnerList[0].Id;
         
        insert accteam;
                   
        Database.executeBatch(new BatchClassforMonthlyOpportunity(), 200);
        
        Database.executeBatch(new BatchClassforLastYearMonthlyOpportunity(), 200);
        
        Database.executeBatch(new BatchClassforCreateOpportunityTeam(), 200);
        
                       
      }

}