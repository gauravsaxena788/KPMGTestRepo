trigger VCPL_QuoteTrigger on Quote (before insert) {
    VA_Trigger_Settings__c objTriggerSetting = VA_Trigger_Settings__c.getValues('QuoteTrigger');
    if(objTriggerSetting != null && !objTriggerSetting.VA_Is_Trigger_Disabled__c){ 
     VCPL_clsforIdCustomerQuote.approvalDetail(Trigger.New); 
     }
}