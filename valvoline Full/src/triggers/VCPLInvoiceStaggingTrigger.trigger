trigger VCPLInvoiceStaggingTrigger on VCPL_Invoice_Stagging__c (before insert,after insert) {


    try{
        VCPL_InvoiceStaggingHandler invTriggerHandler = new VCPL_InvoiceStaggingHandler();
        
        if(Trigger.isBefore && Trigger.IsInsert){
            Map<String, Schema.SObjectField> mapSchemaWithFieldNew = Schema.SObjectType.VCPL_Invoice_Stagging__c .fields.getMap();
            Schema.SObjectType mapSchemaWithField = Schema.getGlobalDescribe().get('VCPL_Invoice_Stagging__c');
            Schema.DescribeSObjectResult schemaDescribe = mapSchemaWithField.getDescribe();
            Set<String> setofFieldName = new Set<String>();
            for(String fieldName : mapSchemaWithFieldNew.keySet()) {
                if(schemaDescribe.fields.getMap().get(fieldName).getDescribe().getType() == Schema.DisplayType.String)
                    setofFieldName.add(fieldName);    
            }
           
           if(setofFieldName.size() > 0)
            for(Sobject objAccSt :trigger.new){                
                for(String objStr :setofFieldName){
                    if( string.isNotBlank((String)objAccSt.get(objStr)) && ((String)objAccSt.get(objStr)).contains('dblquote;'))
                        objAccSt.put(objStr, ((String)objAccSt.get(objStr)).replaceAll('dblquote;','\"'));
               }
            }
            
        }
        
        if(Trigger.isAfter && Trigger.isInsert){
            invTriggerHandler.InsertInvoices(trigger.new);
        }
        
    }
    catch(exception e){
        VA_Error_Log__c log = new VA_Error_Log__c ();
        log.VA_Stack_Trace__c = e.getStackTraceString();
        log.VA_Message__c = e.getMessage();
        log.VA_Cause__c = String.valueof(e.getCause());
        log.VA_Line_Number__c = e.getLineNumber();
        log.VA_Type__c = 'ERROR';
        insert log;
    }



}