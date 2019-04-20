@isTest
public class OpportunityTriggerHelper_AOPLineTest {
    

    static testMethod void AOPTest(){        
        List<Opportunity> oppLst= new List<Opportunity>();        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='PM']; 
        List<User> userLst= new List<User>(); 
          
        User u1= new User();
            u1.FirstName ='Sagar1';
            u1.Username='Sagar83831@acme.com';
            u1.LastName='Sagar1';
            u1.Email='Sagar14334@abc.com';
            u1.Alias='Sag12ar';
            u1.CommunityNickname='mg1';
            u1.TimeZoneSidKey='America/Los_Angeles';
            u1.LocaleSidKey='en_US';
            u1.EmailEncodingKey='UTF-8';
            u1.ProfileId = p.Id;
            u1.LanguageLocaleKey='en_US';
            u1.Employee_Code__c = 'V1234';            
            insert u1;
        
         p = [SELECT Id FROM Profile WHERE Name='NKAM']; 
        User u= new User();
            u.FirstName ='Sagar';
            u.Username='Sagar3443@acme.com';
            u.LastName='Sagar';
            u.Email='Sagar343@abc.com';
            u.Alias='Sa1test';
            u.CommunityNickname='mg2';
            u.TimeZoneSidKey='America/Los_Angeles';
            u.LocaleSidKey='en_US';
            u.EmailEncodingKey='UTF-8';
            u.ProfileId = p.Id;
            u.LanguageLocaleKey='en_US';
            u.ManagerId=u1.Id;
            u.Employee_Code__c = 'V5678';
            insert u;
        
        p = [SELECT Id FROM Profile WHERE Name='SM']; 
        User um= new User();
            um.FirstName ='Sagar4';
            um.Username='Sagar3434@acme.com';
            um.LastName='Sagar34344';
            um.Email='Sagar4343@abc.com';
            um.Alias='Saga2r';
            um.CommunityNickname='mg3';
            um.TimeZoneSidKey='America/Los_Angeles';
            um.LocaleSidKey='en_US';
            um.EmailEncodingKey='UTF-8';
            um.ProfileId = p.Id;
            um.LanguageLocaleKey='en_US';
            um.ManagerId=u.Id;
            um.Employee_Code__c = 'V9089';
            insert um;
        
        p = [SELECT Id FROM Profile WHERE Name='TBM']; 
        User ut= new User();
            ut.FirstName ='Sagar243';
            ut.Username='Sagar23434@acme.com';
            ut.LastName='Saga334r';
            ut.Email='Sagar34342@abc.com';
            ut.Alias='Sagar234';
            ut.CommunityNickname='mg4';
            ut.TimeZoneSidKey='America/Los_Angeles';
            ut.LocaleSidKey='en_US';
            ut.EmailEncodingKey='UTF-8';
            ut.ProfileId = p.Id;
            ut.LanguageLocaleKey='en_US';
            ut.ManagerId=um.Id;
            ut.Employee_Code__c = 'V3344';
            insert ut;

        
        
        List<Account> accLst= new List<Account>();
        String recordTypeSAP  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
        
        Id primaryaccRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'VCPL_Primary_Account' AND sObjectType = 'Account'].Id;
        Account acc= new Account();
        
        acc.Name='Testclass acc1';
        acc.Is_Parent__c='N';
        acc.Type='Factory Fill';
        acc.Indutry_Segment__c='On-Highway';
        acc.Market_Segment__c='PowerGen';
        acc.Quote_allowed__c='Yes';
        acc.BU_Name__c='OEM';
        acc.Category__c='New';
        
        acc.Account_Type__c='Factory Fill';
        acc.Zone__c = 'North';
        acc.RecordTypeId = primaryaccRecordTypeId;
        
        accLst.add(acc);
        
        insert accLst;
        
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = recordTypeSAP;
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp SAP';
        opp.StageName='Open';   
        opp.Month__c='OCT';
        opp.Year__c='2017';
        opp.Financial_Year__c='2017';
        opp.Month_sap__c='OCT';
        opp.Calendar_Year__c ='2017';
        opp.closeDate = System.today();
        opp.ownerId = um.Id;
        insert opp;
        
        
        List<OpportunityTeamMember> oppTMLst= new List<OpportunityTeamMember>();    
        OpportunityTeamMember ptm= new OpportunityTeamMember();
        ptm.TeamMemberRole = 'Segment Manager';
        ptm.OpportunityId = opp.Id;
        ptm.OpportunityAccessLevel = 'Edit';
        ptm.UserId=um.Id;
        oppTMLst.add(ptm);
        
        OpportunityTeamMember ptm1= new OpportunityTeamMember();
        ptm1.TeamMemberRole = 'Product Manager';
        ptm1.OpportunityId = opp.Id;
        ptm1.OpportunityAccessLevel = 'Edit';
        ptm1.UserId=u1.Id;
        oppTMLst.add(ptm1);
        
        OpportunityTeamMember ptm2= new OpportunityTeamMember();
        ptm2.TeamMemberRole = 'NKAM';
        ptm2.OpportunityId = opp.Id;
        ptm2.OpportunityAccessLevel = 'Edit';
        ptm2.UserId=u.Id;
        oppTMLst.add(ptm2);
        
        OpportunityTeamMember ptm3= new OpportunityTeamMember();
        ptm3.TeamMemberRole = 'RKAM';
        ptm3.OpportunityId = opp.Id;
        ptm3.OpportunityAccessLevel = 'Edit';
        ptm3.UserId=ut.Id;
        oppTMLst.add(ptm3);
        
        insert oppTMLst;
      
        
        List<AOP__c> aopList = new List<AOP__c>();
        AOP__c aop = new AOP__c();
        aop.AOP_Plan_User__c = u.Id;
        aop.AOP_DSO__c = 52.00;
        aop.Valvoline_Financial_Year__c = '2017';
        aop.AOP_Regional_Vol_in_kL__c = 1.00;
        aop.AOP_National_Vol_in_kL__c = 2.00;
        aop.AOP_Focus_Vol_in_kL__c = 1.00;
        aop.AOP_Regional_GP__c = 1;
        aop.AOP_Forecast_Accuracy__c =10;
        aop.AOP_New_Win_in_kL__c = 3.00;
        aop.AOP_National_GP__c = 1.00;    
        aopList.add(aop);
        insert aopList;
       
       List<AOP_Line__c> AopLineList = new List<AOP_Line__c>();
       AOP_Line__c aopLine = new AOP_Line__c();
       aopLine.AOP__c = aop.Id;
       aopLine.AOP_Plan_User__c=u.Id;
       aopLine.AOP_Regional_Vol_in_kL__c = aop.AOP_Regional_Vol_in_kL__c;
       aopLine.AOP_New_Win_in_kL__c = aop.AOP_New_Win_in_kL__c;
       aopLine.AOP_DSO__c = aop.AOP_DSO__c;
       aopLine.AOP_Forecast_Accuracy__c = aop.AOP_Forecast_Accuracy__c;
       aopLine.AOP_National_Vol_in_kL__c = aop.AOP_National_Vol_in_kL__c;
       aopLine.AOP_Regional_GP__c = aop.AOP_Regional_GP__c;
       aopLine.AOP_National_GP__c = aop.AOP_National_GP__c;
       aopLine.AOP_Focus_Vol_in_kL__c = aop.AOP_Focus_Vol_in_kL__c;
       aopLine.Month__c = 'OCT';
       
       AopLineList.add(aopLine);
       
       AOP_Line__c aopLine1 = new AOP_Line__c();
       aopLine1.AOP__c = aop.Id;
       aopLine1.AOP_Plan_User__c=ut.Id;
       aopLine1.AOP_Regional_Vol_in_kL__c = aop.AOP_Regional_Vol_in_kL__c;
       aopLine1.AOP_New_Win_in_kL__c = aop.AOP_New_Win_in_kL__c;
       aopLine1.AOP_DSO__c = aop.AOP_DSO__c;
       aopLine1.AOP_Forecast_Accuracy__c = aop.AOP_Forecast_Accuracy__c;
       aopLine1.AOP_National_Vol_in_kL__c = aop.AOP_National_Vol_in_kL__c;
       aopLine1.AOP_Regional_GP__c = aop.AOP_Regional_GP__c;
       aopLine1.AOP_National_GP__c = aop.AOP_National_GP__c;
       aopLine1.AOP_Focus_Vol_in_kL__c = aop.AOP_Focus_Vol_in_kL__c;
       aopLine1.Month__c = 'OCT';
       
       AopLineList.add(aopLine1);
       
       AOP_Line__c aopLine2 = new AOP_Line__c();
       aopLine2.AOP__c = aop.Id;
       aopLine2.AOP_Plan_User__c=um.Id;
       aopLine2.AOP_Regional_Vol_in_kL__c = aop.AOP_Regional_Vol_in_kL__c;
       aopLine2.AOP_New_Win_in_kL__c = aop.AOP_New_Win_in_kL__c;
       aopLine2.AOP_DSO__c = aop.AOP_DSO__c;
       aopLine2.AOP_Forecast_Accuracy__c = aop.AOP_Forecast_Accuracy__c;
       aopLine2.AOP_National_Vol_in_kL__c = aop.AOP_National_Vol_in_kL__c;
       aopLine2.AOP_Regional_GP__c = aop.AOP_Regional_GP__c;
       aopLine2.AOP_National_GP__c = aop.AOP_National_GP__c;
       aopLine2.AOP_Focus_Vol_in_kL__c = aop.AOP_Focus_Vol_in_kL__c;
       aopLine2.Month__c = 'OCT';
       
       AopLineList.add(aopLine2);
       
       AOP_Line__c aopLine3 = new AOP_Line__c();
       aopLine3.AOP__c = aop.Id;
       aopLine3.AOP_Plan_User__c=u1.Id;
       aopLine3.AOP_Regional_Vol_in_kL__c = aop.AOP_Regional_Vol_in_kL__c;
       aopLine3.AOP_New_Win_in_kL__c = aop.AOP_New_Win_in_kL__c;
       aopLine3.AOP_DSO__c = aop.AOP_DSO__c;
       aopLine3.AOP_Forecast_Accuracy__c = aop.AOP_Forecast_Accuracy__c;
       aopLine3.AOP_National_Vol_in_kL__c = aop.AOP_National_Vol_in_kL__c;
       aopLine3.AOP_Regional_GP__c = aop.AOP_Regional_GP__c;
       aopLine3.AOP_National_GP__c = aop.AOP_National_GP__c;
       aopLine3.AOP_Focus_Vol_in_kL__c = aop.AOP_Focus_Vol_in_kL__c;
       aopLine3.Month__c = 'OCT';
       
       AopLineList.add(aopLine3);
       
       insert AopLineList;
       
       test.startTest();
           opp.StageName='Closed';
           update opp;       
       test.stopTest();
    }
        
}