trigger VCPL_UserTrigger on User (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    VCPL_UserTriggerHandler obj = new VCPL_UserTriggerHandler();
    obj.runTrigger();
}