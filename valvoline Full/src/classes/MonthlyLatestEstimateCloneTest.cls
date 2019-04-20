@isTest
public class MonthlyLatestEstimateCloneTest {
    static testmethod void testOpp(){
        
        String recordTypeSAP  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
        List<Account> accLst= new List<Account>();
        
        Account acc= new Account();
        
        acc.Name='Testclass acc';
        acc.Is_Parent__c='Y';
        acc.Type='Factory Fill';
        acc.Indutry_Segment__c='On-Highway';
        acc.Market_Segment__c='PowerGen';
        acc.Quote_allowed__c='Yes';
        acc.BU_Name__c='OEM';
        acc.OEM_Cust_Name__c='ESCORTS';
        acc.Category__c='New';
        acc.Account_Type__c='Factory Fill';
        acc.Zone__c = 'North';
        acc.Ship_to_Code__c = '111111';
        acc.Status__c = 'Activated';
        accLst.add(acc);
        
        insert accLst;
        
        List<Opportunity> oppLst= new List<Opportunity>();
        
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = recordTypeSAP;
        opp.AccountId=acc.Id;
        opp.Name='Testclass Opp';
        opp.StageName='Won';
        //opp.Sub_Stage__c='Material Delivered - Valvoline Invoice attached';
        opp.Month_sap__c = 'Oct';
        opp.Calendar_Year__c= '2017';
        opp.CloseDate= date.today();   
        opp.Opportunity_Type__c='Business Development - New Account';
        
        oppLst.add(opp);
        insert oppLst;
        
        List<Opportunity> opSAPLst = [Select id,Opportunity_Id__c from Opportunity where RecordTypeId=:recordTypeSAP AND Opportunity_Id__c!=null Limit 5];
        
        List<OpportunityLineItem> oliLst= new List<OpportunityLineItem>();
        
        List<PricebookEntry> prdLst= [SELECT Id FROM PricebookEntry Limit 2];
        for(Opportunity opSAP:opSAPLst){
            
            for(PricebookEntry prd:prdLst){
                OpportunityLineItem oLI = new OpportunityLineItem();
                oLI.OpportunityId=opSAP.id;
                // oLI.Product2Id=prd.Id;
                oLI.PricebookEntryId=prd.Id;
                oLI.Quantity=40.00;
                oLI.UnitPrice=200.00;
                oLI.Description='Data Load Testing';
                oLI.State_Name__c='MH';
                oLI.Vol_inltrs__c=55.00;
                oliLst.add(oLI);
                
            }
        }
        insert oliLst;
        
        MonthlyLatestEstimateClone monlatest = new MonthlyLatestEstimateClone();
        
        MonthlyLatestEstimateClone.findFiscalYearSettings();
        MonthlyLatestEstimateClone.getBasicDetails();
        monlatest.getOpportunityList();
        monlatest.getOpportunityMonthly();
        monlatest.getOpportunityMonthly2();
        monlatest.gettypelist();
        monlatest.getmonthlist(); 
        monlatest.updateopp();
        monlatest.updateopp2();
        monlatest.cancel();
        Date d1 = system.TODAY()-90;
        Date d2 = system.TODAY();
        set<Id> accid= new set<Id>();
        accid.add(acc.Id);
        
        monlatest.getLast3MonthsAverage(d1,d2,accid,'AUS');
        monlatest.getLast3MonthsAverage(d1,d2,accid,'Lubes');
        monlatest.checkListType();
        monlatest.selectedtype='Lubes';
        monlatest.checkListType();
        monlatest.selectedtype='AUS';
        monlatest.checkListType();
        
        Opportunity op1=new opportunity();
        MonthlyLatestEstimateClone.WrapperOpportunity wp = new MonthlyLatestEstimateClone.WrapperOpportunity(op1,true,200,50);
        
        MonthlyLatestEstimateClone.WrapperOpportunity2  wp1 = new MonthlyLatestEstimateClone.WrapperOpportunity2(op1,true,200,50);
        
        
    }
}