@isTest
public class OpportunityLSTest {
    
    static testmethod void testLSOpp(){
        
        String recordTypeSAP  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
        List<Account> accLst= new List<Account>();
        
        Account acc= new Account();
        
        acc.Name='Testclass acc';
        acc.Is_Parent__c='N';
        acc.Type='Factory Fill';
        acc.Indutry_Segment__c='On-Highway';
        acc.Market_Segment__c='PowerGen';
        acc.Quote_allowed__c='Yes';
        acc.BU_Name__c='OEM';
        acc.Category__c='New';
        acc.Account_Type__c='Factory Fill';
        acc.Zone__c = 'North';
        
        accLst.add(acc);
        
        insert accLst;
        
        List<Opportunity> oppLst= new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = recordTypeSAP;
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp';
        opp.StageName='Won';
        opp.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp.CloseDate= date.today();   
        opp.Opportunity_Type__c='Business Development - New Account';
        
        oppLst.add(opp);
        Test.startTest();
        OpportunityHelper.findAll(acc.Id);
        OpportunityHelper.findAllNew(acc.Id);
        OpportunityHelper.findActualMonth();
        OpportunityHelper.account_Details(acc.Id);
        OpportunityHelper.saveLatestEstimate(oppLst);
        Test.stopTest();
    }
}