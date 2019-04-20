trigger VCPL_BLISGroupTrigger on VCPL_BLIS_Group__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
	VCPL_BLISGroupTriggerHandler obj = new VCPL_BLISGroupTriggerHandler();
	obj.runTrigger();    
}