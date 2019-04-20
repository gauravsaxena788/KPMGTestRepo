trigger VCPL_SecondarySalesTrigger on VCPL_Secondary_Sales__c (before insert,before update,after insert,after update)
{
   VCPL_SecondarySalesTriggerHandler obj = new VCPL_SecondarySalesTriggerHandler();
     obj.runTrigger();
}