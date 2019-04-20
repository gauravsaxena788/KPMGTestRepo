public without sharing class FileController {
    
    @AuraEnabled
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) { 
        
        system.debug('@@parentId'+parentId+'@@fileName'+fileName+'@@base64Data'+base64Data+'@@contentType'+contentType);
        
        string finalbase64Data = '';
        if(base64Data.contains(' ')){
            string[] strbase64Data = base64Data.split(' ');
            if(strbase64Data != null && !strbase64Data.isEmpty()){
                for(string strdata : strbase64Data){
                    finalbase64Data += strdata + '+';
                }
            }
        }

        
        if(!String.isBlank(finalbase64Data)){
            finalbase64Data = finalbase64Data.substring(0,finalbase64Data.length() - 1);
        }
        else{
            finalbase64Data = base64Data;
        }
        
        base64Data = EncodingUtil.urlDecode(finalbase64Data, 'UTF-8');
                
                
        //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion a=new ContentVersion(); 
                a.Title= fileName; 
                a.PathOnClient='/' + a.Title ;   
                a.VersionData = EncodingUtil.base64Decode(base64Data); 
                a.origin = 'H';
                a.IsMajorVersion = false;
                insert a;
        ContentDocumentLink contentlink    = new ContentDocumentLink();
                    contentlink.LinkedEntityId         = parentId;
                    contentlink.contentdocumentid      = [select id,contentdocumentid from contentversion where id =: a.id].contentdocumentid;
                    contentlink.ShareType              = 'V';
                    contentlink.Visibility             = 'AllUsers';
                    insert contentlink; 
        return a.Id;
    }
    
    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) { 
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
    
        string finalbase64Data = '';
        if(base64Data.contains(' ')){
            string[] strbase64Data = base64Data.split(' ');

            if(strbase64Data != null && !strbase64Data.isEmpty()){
                for(string strdata : strbase64Data){
                    finalbase64Data += strdata + '+';
                }
            }
        }
        
        if(!String.isBlank(finalbase64Data)){
            finalbase64Data = finalbase64Data.substring(0,finalbase64Data.length() - 1);
        }
        else{
            finalbase64Data = base64Data;
        }
        
        base64Data = EncodingUtil.urlDecode(finalbase64Data, 'UTF-8');
        //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        ContentVersion a = [SELECT Id, VersionData,ContentDocumentId FROM ContentVersion WHERE Id= :fileId LIMIT 1]; 
        
        String existingBody = EncodingUtil.base64Encode(a.VersionData);
        a.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);              
        update a;
    }
    
    @AuraEnabled
    public static void updateCheck(Id parentId){
        list<VA_Invoice__c> lstInvoicetobeupdated= new list<VA_Invoice__c>();
        list<VA_Invoice__c> lstInvoice= [select id,VA_POD_Upload_Date__c ,VA_Invoice_Status__c from VA_Invoice__c where id=:parentId Limit 1];
        system.debug('@@lstInvoice'+lstInvoice);
        for(VA_Invoice__c objInvoice : lstInvoice){
            objInvoice .VA_Invoice_Status__c = 'Delivered';
            system.debug('@@status'+objInvoice .VA_Invoice_Status__c);
            objInvoice .VA_POD_Upload_Date__c = System.Now();
            lstInvoicetobeupdated.add(objInvoice );
        }
        
        update lstInvoicetobeupdated;
    }
    
}