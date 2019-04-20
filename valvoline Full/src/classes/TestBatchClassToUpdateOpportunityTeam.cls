@isTest
public class TestBatchClassToUpdateOpportunityTeam
    {

     public static testmethod void testBatchClassUpdateOpportunityTeam()
    { 
    
     List<Opportunity> oppList= new List<Opportunity>();
     
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
     
     Id monthly_plan = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
     
     Account sobj = new Account(
  Zone__c = 'North',                           // Zone
  Account_Type__c = 'Distributor',               // Account Type
  Is_Parent__c = 'Y',                            // Is Parent
  Indutry_Segment__c = 'Infra',  // Industry Segment
  Market_Segment__c = 'HD',              // Market Segment
  BU_Name__c = 'FLEET',                          // BU Name
  Category__c = 'New',                           // Category
  Accound_Aprroved__c = true,                    // Account Aprroved
  Quote_allowed__c = 'Yes',                      // Quote allowed
  Top_Account_Segment__c = false,                // Top Account - Segment
  Top_Accounts_NKAM__c = false,                  // Top Accounts- NKAM
  Top_Account_Zone__c = false,                   // Top Account - Zone
  Top_Accounts_TBM__c = true,                    // Top Accounts- TBM
  Top_Account_BU__c = false,                     // Top Account - BU
  Phone = '9213611313',                          // Phone
  Ship_to_Code__c = '',                    // Ship-to Code
  Payer_code__c = '',                      // Payer code
  Customer_code__c = '',                   // Customer code
  Sold_to_code__c = '',                    // Sold-to code
  Account_Tenure__c = 2,                         // Account Tenure
  Status__c = 'Draft',                       // Status
  OwnerId=usr.Id,
  Name='test acc'
);
insert sobj;

     
     Opportunity opt= new Opportunity(Name='monthly test', AccountId=sobj.Id, StageName = 'Open', CloseDate = system.today(), RecordtypeId=monthly_plan);
     insert opt;
     
     Opportunity opt1= new Opportunity(Name='month oppty', AccountId=sobj.Id, StageName = 'Open', CloseDate = system.today(), RecordtypeId=monthly_plan);
     insert opt1;
     
     
     AccountTeamMember Teammemberad = new AccountTeamMember();
     Teammemberad.AccountId=sobj.id;
     Teammemberad.UserId=usr.id;
     Teammemberad.TeamMemberRole = 'NKAM';
    
     insert Teammemberad;

          
     BatchClassToUpdateOpportunityTeam  bco = new BatchClassToUpdateOpportunityTeam();
     
     
    Test.startTest();
     
    try
    { 
       Database.executeBatch(bco);
    }
    catch( System.DmlException e)
    {
        system.assert(e.getMessage().contains('System.LimitException: Too many SOQL queries: 101, System.LimitException: Too many SOQL queries: 101'),e.getMessage());
    }
    
    Test.stopTest();
       
    }
}