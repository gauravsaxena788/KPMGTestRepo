trigger VCPL_trgOnSKUMapping on CD_SKU_Mapping__c (before insert,before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        VCPL_SKUMappingTriggerHandler.beforeInsert(trigger.new); 
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        VCPL_SKUMappingTriggerHandler.beforeUpdate(trigger.new,trigger.oldMap); 
    }
}