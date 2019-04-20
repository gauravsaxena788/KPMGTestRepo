global class VCPL_ClearRollUpFieldBatch implements Database.Batchable<sObject>
{
    global Database.querylocator start(Database.BatchableContext bc)
    {
    	final Id branchAccRTID= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
        String strAccountQuery ='';
        
        strAccountQuery = 'SELECT Id,RecordTypeID,RecordType.Name FROM Account';
        strAccountQuery += ' where RecordTypeId !=:branchAccRTID';
    
    	return Database.getQueryLocator(strAccountQuery); 
    }
    global void execute(Database.BatchableContext BC, List<Account> lstAccounts)
    {
        Set<String> fieldSetMonthly = new Set<String>();
        Set<String> fieldSetYearly = new Set<String>();
        for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Update_value_of_rollup').getFields())
        {
        	if(string.valueof(fields.getType()).equalsIgnoreCase('DOUBLE'))
        	{
            	fieldSetMonthly.add(fields.getFieldPath());
        	}
        }
        for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Update_value_of_rollup_Yearly').getFields())
        {
        	if(string.valueof(fields.getType()).equalsIgnoreCase('DOUBLE'))
        	{
            	fieldSetYearly.add(fields.getFieldPath());
        	}
        }
        for(Account objAcc:lstAccounts){
            for(String objMonthly : fieldSetMonthly){
                objAcc.put(objMonthly,0);
            }
            if(System.today().month() == 10)
            {
	            for(String objYearly : fieldSetYearly){
	                objAcc.put(objYearly,0);
	            }
            }
        }
        
        if(lstAccounts.size() > 0)
        {
            update lstAccounts;
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}