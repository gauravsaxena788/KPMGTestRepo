trigger VA_InvoiceTrigger on VA_Invoice__c (after insert,after Update, after Delete) {
    try{
        VA_InvoiceTriggerHandler invTriggerHandler = new VA_InvoiceTriggerHandler();
        if(Trigger.isAfter && Trigger.isInsert){
            invTriggerHandler.updateOrderQuantities(trigger.new);
        }
        else if(Trigger.isAfter && Trigger.isUpdate){
            invTriggerHandler.updateOrderQuantitiesAfterChange(trigger.oldMap,trigger.new);
        }
        else if(Trigger.isAfter && Trigger.isDelete){invTriggerHandler.updateOrderQuantities(trigger.old);}
        
    }catch(exception e){VA_Error_Log__c log = new VA_Error_Log__c (VA_Stack_Trace__c =  e.getStackTraceString(), VA_Message__c = e.getMessage(), VA_Cause__c = String.valueof(e.getCause()), VA_Line_Number__c = e.getLineNumber(), VA_Type__c = 'ERROR'  );}
}