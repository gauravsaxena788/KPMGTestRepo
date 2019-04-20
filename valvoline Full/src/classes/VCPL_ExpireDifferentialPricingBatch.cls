global class VCPL_ExpireDifferentialPricingBatch implements Database.Batchable<sObject>{

    global Database.querylocator start(Database.BatchableContext bc)
	{
        return Database.getQueryLocator([SELECT id, VCPL_DP_Expiry_Reason__c , VCPL_DP_Expiry_Date__c, VCPL_DP_Request_Status__c 
                                         FROM VCPL_Differential_Pricing__c WHERE  VCPL_DP_Expiry_Date__c =TODAY 
                                         AND VCPL_DP_Request_Status__c = 'Approved']);
	}
    global void execute(Database.BatchableContext BC, List<VCPL_Differential_Pricing__c> lstDiffPricing)
    {
        if(lstDiffPricing != NULL && !lstDiffPricing.isEmpty())
        {
            for(VCPL_Differential_Pricing__c objDiffPrc : lstDiffPricing)
            {
                objDiffPrc.VCPL_DP_Request_Status__c = 'Expired' ; 
                objDiffPrc.VCPL_DP_Expiry_Reason__c = Label.VCPL_Differential_Pricing_Expire_Message_Batch;
            }
            if(lstDiffPricing != NULL && !lstDiffPricing.isEmpty())
            {
                update lstDiffPricing;
            }
        }
    }	
	global void finish(Database.BatchableContext BC)
	{
		
	}	    

}