public without sharing class VCPL_FilesListViewController 
{
	@AuraEnabled
    public static list<ContentVersion> getFilelist(string RecordId)
    {
      
         list<ContentVersion>originalAttachment =new list<ContentVersion>();
         List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId 
                                          FROM ContentDocumentLink 
                                          WHERE LinkedEntityId = :RecordId limit 999];
        system.debug('@@@@'+documentLinks);                                  
        Set<Id> documentIds = new Set<Id>();

        for(ContentDocumentLink dl : documentLinks) 
        {
            documentIds.add(dl.ContentDocumentId);
        }
         return [SELECT Id, Title, ContentUrl, Description, FileType, ContentDocumentId, ContentModifiedDate 
             FROM ContentVersion 
             WHERE ContentDocumentId IN :documentIds];   
    } 
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
     @AuraEnabled
    public static VA_WrapperofImage returnBlobValue(string attachmentIds) 
    {
       ContentVersion objContentVersion= [SELECT Id, Title, ContentUrl, Description,VersionData,FileType, 
                                           ContentDocumentId, ContentModifiedDate  FROM ContentVersion 
             WHERE Id =:attachmentIds limit 1];  
        system.debug('objContentVersion================'+objContentVersion);
       
            VA_WrapperofImage objWrapper =New VA_WrapperofImage();
            objWrapper.fileType=objContentVersion.FileType;
            objWrapper.Name=objContentVersion.Title;
            objWrapper.encodeValue=Encodingutil.base64encode(objContentVersion.VersionData);
        return objWrapper;
     
    }
}