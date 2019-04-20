public without sharing class DynamicObjectDetail
{
    @AuraEnabled
    public static sObject GetsObjectData(id myId){
        String objectName = myId.getSObjectType().getDescribe().getName();
      
        // Create Dynamic Query Start ..
        String theQuery = 'SELECT ';
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = sObjectName.getDescribe().fields.getMap();
        For(Schema.SObjectField field : mfields.values()){
            If(field.getDescribe().isAccessible() && !field.getDescribe().getName().EndsWith('Id')
               && field.getDescribe().getName()!='CreatedDate' && field.getDescribe().getName()!='LastModifiedDate'
               && field.getDescribe().getName()!='LastReferencedDate' && field.getDescribe().getName()!='LastReferencedDate'
               && field.getDescribe().getName()!='LastActivityDate' && field.getDescribe().getName()!='LastViewedDate'
               && field.getDescribe().getName()!='IsDeleted'){
               theQuery += field.getDescribe().getName() + ',' ;
           } 
        }
        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);
        // Finalize query string
        if(objectName == 'Case')
            theQuery += ' ,recordtype.developername,Account.Name,Contact.Name,VA_Product__r.Name,Owner.Name,VA_Project__r.Name ';    
        if(objectName == 'VA_Invoice__c')  
            theQuery += ' ,VA_Order__r.OrderNumber,VA_Order__r.AccountId ';  
        if(objectName == 'Order')  
            theQuery += ' ,Account.Name ';          
        theQuery += ' FROM '+objectName+' where id =\'' + myId + '\'';   
            
        //ID =:' + myId ;
        // Query End ..
        System.debug('#### theQuery = '+theQuery);
        
        sObject objectData = Database.Query(theQuery);
		
		return objectData;
    }
}