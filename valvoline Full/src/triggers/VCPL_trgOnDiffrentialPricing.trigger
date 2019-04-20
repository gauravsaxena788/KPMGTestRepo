trigger VCPL_trgOnDiffrentialPricing on VCPL_Differential_Pricing__c (before insert, before update, after insert, after update) {
    VA_Trigger_Settings__c objTriggerSetting = VA_Trigger_Settings__c.getValues('DifferentialPricing');
    if(objTriggerSetting != null && !objTriggerSetting.VA_Is_Trigger_Disabled__c){        
        if(trigger.isbefore && trigger.isinsert)
            VCPL_trgOnDiffrentialPricingcls.trgonbeforeinsert(Trigger.new);
        
        if(trigger.isbefore && trigger.isupdate)
            VCPL_trgOnDiffrentialPricingcls.trgonbeforeupdate(Trigger.new,Trigger.oldMap);
        
        if(trigger.isafter && trigger.isinsert)
            VCPL_trgOnDiffrentialPricingcls.trgonAfterinsert(Trigger.new);
        
        if(trigger.isafter && trigger.isupdate)
            VCPL_trgOnDiffrentialPricingcls.trgonAfterupdate(Trigger.new,Trigger.oldMap);
    }
}