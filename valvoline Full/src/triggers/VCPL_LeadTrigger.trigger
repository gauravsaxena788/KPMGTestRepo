trigger VCPL_LeadTrigger on Lead (before insert,before update, after update,after insert) {
    
    if(Trigger.isBefore && Trigger.isinsert)
        VCPL_LeadTriggerHandler.onBeforeInsert(Trigger.new);
        
    if(Trigger.isBefore && Trigger.isupdate)
        VCPL_LeadTriggerHandler.onBeforeUpdate(Trigger.new,Trigger.OldMap);
    
    if(Trigger.isAfter && Trigger.isUpdate)
        VCPL_LeadTriggerHandler.onAfterUpdate(Trigger.new,Trigger.OldMap);
    
    if(Trigger.isAfter && Trigger.isInsert)
        VCPL_LeadTriggerHandler.onAfterInsert(Trigger.new);
}