trigger VCPL_CustomerPlanTrigger on VCPL_Customer_Plan__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    VCPL_CustomerPlanTriggerHandler obj = new VCPL_CustomerPlanTriggerHandler();
    obj.runTrigger(); 
}