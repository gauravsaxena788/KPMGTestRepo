trigger AccountTrigger on Account (after insert, after update) {
    List<Account> accountList= new List<Account>();
    //Id primaryaccRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'VCPL_Primary_Account' AND sObjectType = 'Account'].Id;
    
    List<string> primaryRecordTypeIds = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
    Set<String> primaryRecordTypes = new Set<String>(primaryRecordTypeIds);
    
    if(Trigger.isInsert || Trigger.isUpdate)
    {
                
        for(Account act: Trigger.New)
        { 
           if(((act.Status__c=='Activated' && Trigger.isInsert) || (act.Status__c=='Activated' && Trigger.isUpdate && act.Status__c != Trigger.oldMap.get(act.Id).Status__c)) && primaryRecordTypes.contains(act.RecordTypeId))
           {
               accountList.add(act);
           }
        }
        
        system.debug('Account List: '+accountList);
        // call helper class to create monthly opportunities
        if(accountList.size()>0)
        {
            AccountHelperClass acc = new AccountHelperClass();
            acc.CreateMonthlyOpportunity(new List<Opportunity>(), accountList); 
        }        
    }
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        AccountHelperClass achelper = new AccountHelperClass();
        achelper.Account_SM(Trigger.New);
    }
    
    // Change the owner of open monthly plan opportunities when account owner change
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        AccountHelperClass accHelper = new AccountHelperClass();
        accHelper.changeOpportunityOwnerofOpenMonthlyPlan(Trigger.New, Trigger.oldMap);
    }
}