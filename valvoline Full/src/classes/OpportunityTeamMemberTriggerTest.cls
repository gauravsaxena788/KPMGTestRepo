@isTest
public class OpportunityTeamMemberTriggerTest{
  
   static testMethod void OppTeamMemberTest(){

       Profile profileId = [SELECT Id FROM Profile WHERE Name = 'NKAM' LIMIT 1];
       User usr = New User(
       LastName = 'LIVESTON',
                           FirstName='test',
                           Alias = 'testusr',
                           Email = 'xyzabc@sfdc.com',
                           Username = 'xyz123@sfdc.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US');
       insert usr;
       
       List<Opportunity> oppList= new List<Opportunity>();
       
       Opportunity Opp = New Opportunity(
       Name='TestOpp',StageName='Open',CloseDate=DAte.Today());
       oppList.add(Opp);
       insert oppList;
              
       OpportunityTeamMember Otm = New OpportunityTeamMember(
       OpportunityId = Opp.Id,UserId = usr.Id,TeamMemberRole='NKAM');
       Database.SaveResult value=Database.insert(Otm);
       
      //test.StartTest();
      //System.assertEquals(Otm.TeamMemberRole,'NKAM');
      
      //test.StopTest();
    }
    
}