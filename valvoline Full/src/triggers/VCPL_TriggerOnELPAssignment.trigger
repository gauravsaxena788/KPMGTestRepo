trigger VCPL_TriggerOnELPAssignment on VCPL_ELP_Assignment__c (after insert,after update) {
    if(Trigger.isInsert && Trigger.isAfter)
    {
        VCPL_TriggerOnELPAssignmentHandler triggerHandler = new VCPL_TriggerOnELPAssignmentHandler();
        triggerHandler.afterInsert(Trigger.New);
    }
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        VCPL_TriggerOnELPAssignmentHandler triggerHandler = new VCPL_TriggerOnELPAssignmentHandler();
        triggerHandler.afterUpdate(Trigger.New,Trigger.oldmap);
    }
}