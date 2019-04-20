trigger VCPL_trgOnSecondrySalesLineItem on VCPL_Secondary_Sales_LineItem__c (before insert,before update) {
    if(Trigger.isBefore && Trigger.isInsert)
        VCPL_trgOnSecondrySalesLineItemHandler.trgOnbeforeInsert(Trigger.new);
   if(Trigger.isBefore && Trigger.isUpdate)
       VCPL_trgOnSecondrySalesLineItemHandler.trgOnbeforeUpdate(Trigger.new,Trigger.OldMap);
}