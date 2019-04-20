trigger VA_OrdeItemTrigger on OrderItem (after insert) {
    try{
        VA_OrdeLineItemHandler lineItemObj = new VA_OrdeLineItemHandler();
        lineItemObj.afterConfirmedItemChanges(Trigger.new);
        
    }catch(exception e){VA_Error_Log__c log = new VA_Error_Log__c(VA_Stack_Trace__c = e.getStackTraceString(),VA_Message__c = e.getMessage(),VA_Cause__c = String.valueOf(e.getCause()),VA_Line_Number__c = e.getLineNumber(),VA_Type__c = 'ERROR');insert log;}
}