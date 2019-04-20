global class VCPL_ClearRollUpsField implements Database.Batchable<sObject>
{
    global Database.querylocator start(Database.BatchableContext bc)
    {
        String strAccountQuery ='';
        String strAccountFields ='';
        
        Set<String> fieldSet = new Set<String>();
        for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Update_value_of_rollup').getFields())
        {
            fieldSet.add(fields.getFieldPath());
        }
        for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Update_value_of_rollup_Yearly').getFields())
        {
            fieldSet.add(fields.getFieldPath());
        }
        if(fieldSet != NULL && !fieldSet.isEmpty()){
            for(String strValue :fieldSet)
                strAccountFields +=  strValue+' ,';
        }
            strAccountQuery = 'SELECT '+strAccountFields +' Id,RecordTypeID,RecordType.Name FROM Account';
        
        //Check for Record Types having Number Type Fields and add below//
        //strAccountQuery += ' where RecordType.Name ='+
        return Database.getQueryLocator(strAccountQuery); 
    }
    global void execute(Database.BatchableContext BC, List<Account> lstOwnership)
    {
        Set<String> fieldSetMonthly = new Set<String>();
        Set<String> fieldSetYearly = new Set<String>();
        for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Update_value_of_rollup').getFields())
        {
        	if(string.valueof(fields.getType()).equalsIgnoreCase('DOUBLE'))
            fieldSetMonthly.add(fields.getFieldPath());
        }
        for(Schema.FieldSetMember fields :Schema.SObjectType.Account.fieldSets.getMap().get('VCPL_Update_value_of_rollup_Yearly').getFields())
        {
        	if(string.valueof(fields.getType()).equalsIgnoreCase('DOUBLE'))
        	{
            	fieldSetYearly.add(fields.getFieldPath());
        	}
        }
        for(Account objAcc:lstOwnership){
            for(String objMonthly : fieldSetMonthly){
                objAcc.put(objMonthly,0);
            }
            if(System.today().month() == 10)
            for(String objYearly : fieldSetYearly){
                objAcc.put(objYearly,0);
            }
        }
        
        if(lstOwnership.size() > 0)
            update lstOwnership;
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}