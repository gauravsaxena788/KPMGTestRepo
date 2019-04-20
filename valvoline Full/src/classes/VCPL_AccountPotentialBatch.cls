global class VCPL_AccountPotentialBatch implements Database.Batchable<sObject>
{
	final Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
	
	global Database.querylocator start(Database.BatchableContext bc)
	{
        Integer MonthInteger;
        if(!Test.isrunningTest())
           MonthInteger = system.today().month() ;
        else
            MonthInteger = 10;
		if(MonthInteger == 10)
		{
			string strPotentialQuery = 'select id,Valvoline_Financial_Year__c,Account__c,Account__r.RecordTypeID from Account_Potential__c';
			strPotentialQuery += ' where Valvoline_Financial_Year__c != NULL';
			strPotentialQuery += ' and Account__r.RecordTypeID=:idCustomerRecordType';
			strPotentialQuery += ' order by lastmodifiedDate desc';
		
			return Database.getQueryLocator(strPotentialQuery); 
		}
		else
		{
			return NULL;
		}
	}
	global void execute(Database.BatchableContext BC, List<Account_Potential__c> lstPotential)
	{
		if(lstPotential != NULL && !lstPotential.isEmpty())
		{
			string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
			for(Account_Potential__c objPotential : lstPotential)
			{
				if(objPotential.Valvoline_Financial_Year__c.equalsignoreCase(strFinancialYear))
				{
					objPotential.VCPL_Is_Current_Financial_Year__c = true;
				}
				else
				{
					objPotential.VCPL_Is_Current_Financial_Year__c = false;
				}
			}
			update lstPotential;
		}
	}
	global void finish(Database.BatchableContext BC)
	{
		
	}    
}