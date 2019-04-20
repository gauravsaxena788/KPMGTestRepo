//Batch Test Method

@isTest

public class BatchUpdateMPOppTest{
    
     static testMethod void testBatchMethod() 
    {    
        String recId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
        Date prevDay = Date.today()-1;
        List<Opportunity> OppListin = new List<Opportunity>();
        List<Opportunity> OppListup = new List<Opportunity>();
        
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
        acc.ship_to_code__c = '11111';
        acc.Zone__c = 'North';
        
        insert acc;
             
        for(Integer i=0 ;i<200;i++)
        {
           Opportunity opp = new Opportunity();
            opp.RecordTypeId = recId;
            opp.AccountId=acc.Id;
            opp.Name='Testclass Opp';
            opp.StageName='Open';
            opp.CloseDate= date.today()-1;   
            opp.Opportunity_Type__c='Business Development - New Account';
            OppListin.add(opp);
                     
        }
            insert OppListin;
        
        for(Opportunity op : OppListin)
        {
            for(Integer j=0;j<200;j++)
            {   
                if(op.CloseDate == prevDay){
                 op.StageName = 'Closed';
                 op.CloseDate = date.today();
                 OppListup.add(op);   
                }
                
            }   
        }
        update OppListup;
                     
     // start test
        
        Test.startTest();

        BatchUpdateMPOpp batchUpdate = new BatchUpdateMPOpp();
        DataBase.executeBatch(batchUpdate);
        /* Database.BatchableContext BC;
        
        AsyncApexJob a = [SELECT Id,Status,JobType,NumberOfErrors,JobItemsProcessed,TotalJobItems,CompletedDate,ExtendedStatus
          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
          
        Database.QueryLocator ql = batchUpdate.start(BC);
        batchUpdate.execute(BC,OppListin);
        batchUpdate.Finish(BC); */
        Test.stopTest();
    }
}