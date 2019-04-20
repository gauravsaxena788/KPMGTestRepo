trigger VA_ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    try{
        VA_ContentDocumentLinkHandler.afterInsertHandler(Trigger.new);
        VA_ContentDocumentLinkHandler.updatePoAttached(Trigger.new);
        VA_ContentDocumentLinkHandler.updateStatusInvoice(Trigger.new);
    }catch(exception e){VA_POD_Image_History__c log = new VA_POD_Image_History__c (VA_Stack_Trace__c = e.getStackTraceString(),VA_SFDC_Message__c = e.getMessage(),VA_Cause__c = String.valueof(e.getCause()),VA_Line_Number__c = e.getLineNumber(), VA_Type__c = 'ERROR');insert log;}
}