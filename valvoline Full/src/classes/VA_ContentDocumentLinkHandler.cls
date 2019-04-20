public class VA_ContentDocumentLinkHandler{
    
    public static void afterInsertHandler(List<ContentDocumentLink> newList){
        
        String keyPrefix = VA_Invoice__c.SObjectType.getDescribe().getKeyPrefix();
        
        Map<Id, ContentVersion> contentDocMap = new Map<Id, ContentVersion>();
        Map<Id, VA_Invoice__c> invoiceDataMap = new Map<Id, VA_Invoice__c>();
        List<ContentDocumentLink> invoiceFileList = new List<ContentDocumentLink>();
        
        for(ContentDocumentLink each : newList){
            
            if(each.LinkedEntityId != null && String.valueOf(each.LinkedEntityId).startsWith(keyPrefix)){
                contentDocMap.put(each.ContentDocumentId, null);   
                invoiceDataMap.put(each.LinkedEntityId, null);
                invoiceFileList.add(each);   
            }
        }
        
        if(!contentDocMap.isEmpty() && !invoiceDataMap.isEmpty() && !invoiceFileList.isEmpty()){
            xmlGenerationUtil(contentDocMap, invoiceDataMap, invoiceFileList);
        }    
    }
    
    public static void xmlGenerationUtil(Map<Id, ContentVersion> contentDocMap, Map<Id, VA_Invoice__c> invoiceDataMap, List<ContentDocumentLink> invoiceFileList){
        Id Invid ;
        String FileName;
        for(ContentVersion each : [SELECT Id, Title, VersionData, isLatest, ContentDocumentId FROM ContentVersion WHERE isLatest = true AND ContentDocumentId IN: contentDocMap.keySet()]){
            contentDocMap.put(each.ContentDocumentId, each);
        }
        
        invoiceDataMap.putAll([SELECT Id, VA_Invoice__c.VA_Invoice_Number__c FROM VA_Invoice__c WHERE Id IN: invoiceDataMap.keySet()]);
        
        Map<String, InvFileDataWrapper> invFileDataMap = new Map<String, InvFileDataWrapper>();
        List<String> failureInfoList = new List<String>();
        
        for(ContentDocumentLink each : invoiceFileList){
            failureInfoList.add('Invoice Id: ' + each.LinkedEntityId + ', Content Document Link ID: ' + each.Id + ', Content Document ID: ' + each.ContentDocumentId + ', File Name: ' + contentDocMap.get(each.ContentDocumentId).Title); 
            FileName = contentDocMap.get(each.ContentDocumentId).Title;         
            InvFileDataWrapper temp = invFileDataMap.containsKey(each.Id) ? invFileDataMap.get(each.Id) : new InvFileDataWrapper();
            
            temp.invoice = invoiceDataMap.get(each.LinkedEntityId);
            temp.fileList = temp.fileList == null ? new List<ContentVersion>() : temp.fileList;
            temp.fileList.add(contentDocMap.get(each.ContentDocumentId));
            
            invFileDataMap.put(each.LinkedEntityId, temp);
        }
        
        if(!invFileDataMap.isEmpty()){
            
            DOM.Document doc = new DOM.Document();
            DOM.XmlNode requestNode = doc.createRootElement('request', null, null);
            DOM.XmlNode invoiceListNode = requestNode.addChildElement('invoiceList', null, null);
            
            for(InvFileDataWrapper each : invFileDataMap.values()){
                
                DOM.XmlNode invoiceStatusNode = invoiceListNode.addChildElement('invoiceStatusWrap', null, null);
                invoiceStatusNode.addChildElement('invoiceNumber', null, null).addTextNode(each.invoice.VA_Invoice_Number__c);
                Invid = each.invoice.Id;
                for(ContentVersion eachFile : each.fileList){
                    invoiceStatusNode.addChildElement('podImage', null, null).addTextNode(EncodingUtil.base64Encode(eachFile.VersionData));
                    invoiceStatusNode.addChildElement('imageName', null, null).addTextNode(eachFile.Title);
                }
            }
            
            system.debug('@@@xml'+doc.toXmlString());
            if(!System.isFuture() && !System.isBatch()){
                postXmlUtil(doc.toXmlString(), contentDocMap.keySet(), failureInfoList,Invid,FileName);
            }
        }
    }
    
    public static String returnAccessToken(){
    
        VA_IntegrationUtility__c intUtility = VA_IntegrationUtility__c.getOrgDefaults();
               
        Blob headerValue = Blob.valueOf(intUtility.VA_UserName__c + ':' + intUtility.VA_Password__c);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();        
        
        req.setMethod(intUtility.VA_MethodType__c);
        req.setEndpoint(intUtility.VA_EndPoint__c);
        
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','application/json'); 
        
        //HttpResponse res = h.send(req);
        HttpResponse res ; 
        if(Test.isrunningTest()){
            MockHttpResponseGenerator objmockres = new MockHttpResponseGenerator();
            res = objmockres.respond(req); 
        }
        else
            res = h.send(req); 
        
        Map<String, String> resp = (Map<String, String>)JSON.deserialize(res.getbody(), Map<String, String>.class);                
        return resp.get('access_token');
    }
    
    @future (callout = true)
    public static void postXmlUtil(String reqbody, Set<Id> contentToDeleteSet, List<String> failureInfoList, Id Invid, String FileName){
        try{
            VA_IntegrationUtility__c intUtility = VA_IntegrationUtility__c.getOrgDefaults();        
            String accessToken = returnAccessToken();
            String endPoint = intUtility.VA_FinalEndPoint__c;
            
            if(String.isNotBlank(accessToken)){
                
                Http h = new Http();
                
                HttpRequest req = new HttpRequest();
                
                req.setHeader('Authorization','Bearer ' + accessToken);
                req.setHeader('Content-Type','application/xml');
                
                req.setMethod('POST');
                req.setBody(reqbody);
                req.setEndpoint(endPoint);
                req.setTimeout(100000);
                
                //HttpResponse res = h.send(req);  
                HttpResponse res ; 
                if(Test.isrunningTest()){
                    MockHttpResponseGenerator objmockres = new MockHttpResponseGenerator();
                    res = objmockres.respond(req); 
                }
                else
                    res = h.send(req);                      
                String theResponse = res.getBody();
                system.debug('@@@resp'+theResponse);
                system.debug('@@@code'+res.getStatusCode());
                if(String.isNotBlank(theResponse)){
                    
                    //if(theResponse.contains('<Error></Error>')){
                        if(res.getStatusCode() == 200 ||res.getStatusCode()== 201 ){
                        delete [SELECT Id FROM ContentDocument WHERE Id IN: contentToDeleteSet];
                        
                        VA_POD_Image_History__c log = new VA_POD_Image_History__c();
                         log.Name= FileName;
                        log.VA_Stack_Trace__c = 'CLASS NAME: ContentDocumentLinkHandler';
                        log.VA_SFDC_Message__c = 'SUCCESSFULLY INSERTED FOLLOWING DOCUMENTS: ' + '\n' + String.join(failureInfoList, '\n');
                       log.VA_SAP_Message__c = res.getBody();
                        log.VA_Type__c = 'SUCCESS';  
                        log.VA_Invoice__c = Invid;
                        insert log;
                        
                    }
                    //else if(theResponse.contains('<Error>') && theResponse.contains('</Error>') && String.isNotBlank(theResponse.subStringBetween('<Error>', '</Error>'))){
                        else{
                        VA_POD_Image_History__c log = new VA_POD_Image_History__c();
                         log.Name= FileName;
                        log.VA_Stack_Trace__c = 'CLASS NAME: ContentDocumentLinkHandler';
                        log.VA_SFDC_Message__c = 'FAILED TO INSERT FOLLOWING DOCUMENTS: ' + '\n' + String.join(failureInfoList, '\n');
                       log.VA_SAP_Message__c = res.getBody();
                        log.VA_Type__c = 'ERROR';
                        log.VA_Invoice__c = Invid;
                        insert log;
                        
                    }
                }
            }
        }catch(exception e){
           VA_POD_Image_History__c log = new VA_POD_Image_History__c();
            log.Name= FileName;
            log.VA_Stack_Trace__c = e.getStackTraceString();
            log.VA_SFDC_Message__c = e.getMessage();
            log.VA_Cause__c = String.valueof(e.getCause());
            log.VA_Line_Number__c = e.getLineNumber();
            log.VA_Type__c = 'ERROR';
            log.VA_Invoice__c = Invid;
            insert log;
        }
    }
    
    public class InvFileDataWrapper{
        VA_Invoice__c invoice;
        List<ContentVersion> fileList;
    }   
      public static void updatePoAttached(list<ContentDocumentLink> triggerNew){
        try{
            list<Order> lstOrdertobeUpdated = new list<Order>(); 
            String keyPrefix = Order.SObjectType.getDescribe().getKeyPrefix();
            Set<ID> setOrderId= new Set<ID>();
            List<Order> lstOrder = new List<Order>();
            for(ContentDocumentLink objContent: triggerNew){
                if(objContent.LinkedEntityId != null && String.valueOf(objContent.LinkedEntityId).startsWith(keyPrefix))
                   setOrderId.add(objContent.LinkedEntityId);
                 
                 }
                 if(!setOrderId.isEmpty()){
                    lstOrder = [select id , VA_PO_Attached__c from Order where id in : setOrderId];
                    system.debug('@@lstOrder'+lstOrder);
                 }
                 if(!lstOrder.isEmpty()){
                    for(Order objOrder : lstOrder){
                        objOrder.VA_PO_Attached__c = true;
                        lstOrdertobeUpdated.add(objOrder);
                    }
                    
                 }
                   

                if(!lstOrdertobeUpdated.isempty())
                update lstOrdertobeUpdated;    
            }
            
        
        catch(Exception ex) {  
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;

        } 
    }
    
    public static void updateStatusInvoice(list<ContentDocumentLink> triggerNew){
        try{
            list<VA_Invoice__c> lstInvoicetobeUpdated = new list<VA_Invoice__c>(); 
            String keyPrefix = VA_Invoice__c.SObjectType.getDescribe().getKeyPrefix();
            Set<ID> setInvoiceId= new Set<ID>();
            List<VA_Invoice__c> lstInvoice = new List<VA_Invoice__c>();
            for(ContentDocumentLink objContent: triggerNew){
                if(objContent.LinkedEntityId != null && String.valueOf(objContent.LinkedEntityId).startsWith(keyPrefix))
                   setInvoiceId.add(objContent.LinkedEntityId);
                 
                 }
                 if(!setInvoiceId.isEmpty()){
                    lstInvoice = [select id ,VA_POD_Upload_Date__c,VA_Invoice_Status__c  from VA_Invoice__c where id in : setInvoiceId];
                    system.debug('@@lstInvoice '+lstInvoice );
                 }
                 if(!lstInvoice .isEmpty()){
                    for(VA_Invoice__c objInvoice : lstInvoice ){
                        objInvoice.VA_Invoice_Status__c  = 'Delivered';
                        objInvoice.VA_POD_Upload_Date__c= System.Now();
                        lstInvoicetobeUpdated.add(objInvoice);
                    }
                    
                 }
                   

                if(!lstInvoicetobeUpdated.isempty())
                update lstInvoicetobeUpdated;    
            }
            
        
        catch(Exception ex) {  
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;

        } 
    }
}