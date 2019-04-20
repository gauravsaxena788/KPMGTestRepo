trigger QuoteTrigger on Quote (before insert) { 
    if(Trigger.isBefore && Trigger.isInsert){  
        QuoteHelper.approvalDetail(Trigger.New); 
    } 
}