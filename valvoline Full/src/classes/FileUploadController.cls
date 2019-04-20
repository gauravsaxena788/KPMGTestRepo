public with sharing class FileUploadController {
    
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, string aid) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks  
       system.debug('File Name: '+fileName);
       system.debug('File Id Starting: '+fileId); 
       /*if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType, aid);
        } else {  
            system.debug('Print fileId: '+fileId);
            appendToFile(fileId, base64Data);
        }*/
        
        fileId = saveTheFile(parentId, fileName, base64Data, contentType, aid);

        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType, string aid) {
        
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Account acc1=[SELECT Id, attachment_id__c, HasLogo__c, SFDC_Account_ID__c FROM Account WHERE Id =: aid];
        
        string fname=acc1.SFDC_Account_ID__c+fileName;
              
        if(acc1.attachment_id__c!=NULL)
        {
            //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
            Attachment a = [
                SELECT Id, Body
                FROM Attachment
                WHERE Id =: acc1.attachment_id__c
            ];
            system.debug('record of attachment.......... '+a);
            //String existingBody = EncodingUtil.base64Encode(a.Body);
            
            a.Body = EncodingUtil.base64Decode(base64Data);
            system.debug('@@@'+a);
            update a;
            
            return a.Id;
        }
        else
        {
            Attachment oAttachment = new Attachment();
            oAttachment.parentId = parentId;
            
            oAttachment.Body = EncodingUtil.base64Decode(base64Data);
            oAttachment.Name = fname;
            oAttachment.ContentType = contentType;
            
            insert oAttachment;
            
            acc1.HasLogo__c = TRUE;
            
            String str = oAttachment.Id;
            str = str.substring(0,str.length()-3);
            
            acc1.attachment_id__c = str;
            
            update acc1;
            
            return oAttachment.Id;
        }      
    }
    
    /*private static void appendToFile(Id fileId, String base64Data) {
        system.debug('apend method called.........');
        //base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        system.debug('record of attachment.......... '+a);
        //String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(base64Data);
        system.debug('@@@'+a);
        update a;
    } */
}