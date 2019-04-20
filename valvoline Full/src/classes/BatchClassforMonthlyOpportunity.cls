/**************************************************************
**** Class Name - BatchClassforMonthlyOpportunity 
**** Author - KPMG
**** Created Date - 05/12/2017
**** Description - Create new monthly opportunities for next financial year 
******************************************************************/

global class BatchClassforMonthlyOpportunity implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    List<Id> optyids = new List<Id>();
        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        Integer fyear = 0;
                
        String str = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        fyear = Integer.valueOf(str)-1; // calculate last fiscal year
        String fisYear = String.valueOf(fyear);
        if(Test.isRunningTest())
        {
            fisYear = '2016';
        }
            
        string query = 'Select Id, Owner.Email, AccountId, Account.Id, Account.OwnerId, OwnerId, Account.Ship_to_Code__c, CloseDate, Month__c, MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_Ltr_AUS__c, MTD_NSP_Ltr_Lubes__c, LY_AUS_Vol__c, LY_Lubes_Vol__c, LY_NSP_Ltr_AUS__c, LY_NSP_Ltr_Lubes__c, Actual_Month_Opposite__c, Financial_Year__c, IsCreatedfromVF__c, Latest_Est_GP__c, Latest_Est_GP_ltr__c, Latest_Est_Volume__c, LY_GP__c, LY_GP_ltr__c, LY_Volume__c, Opportunity_Id__c, MTD_GP__c, MTD_GP_Ltr__c, MTD_Volume__c, MTD_DSO__c, MTD_Focussed_Volume__c, Planned_GP_Ltr__c, Planned_Volume__c, Planned_GP__c, Opportunity_Code__c, Name, RecordTypeId, Opportunity_Type__c, StageName, Year__c From Opportunity Where Financial_Year__c=\''+fisYear+'\' AND Account.Status__c=\'Activated\' AND RecordType.DeveloperName=\'Monthly_Plan\' AND (Account.RecordType.DeveloperName=\'VCPL_Primary_Account\' OR Account.RecordType.DeveloperName=\'VCPL_Industrial_Distributor\' OR Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer\' OR Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer_Branch\')';
      
        system.debug('**query: '+query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> optyList)
    {
        // call helper class to create monthly opportunities
        system.debug('opty list: '+optyList);
        if(optyList.size()>0)
        {            
            AccountHelperClass acc = new AccountHelperClass();
            acc.CreateMonthlyOpportunity(optyList, new List<Account>());        
        }
    }

    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}