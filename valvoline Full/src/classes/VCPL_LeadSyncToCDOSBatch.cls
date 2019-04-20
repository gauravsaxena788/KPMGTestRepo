global class VCPL_LeadSyncToCDOSBatch implements Database.Batchable<sObject>{

     global Database.QueryLocator start(Database.BatchableContext BC){
          
          String Accntrcdtype = 'Cummins Dealer';
          String query = 'SELECT Id,Name, VCPL_Account_ID__c,VCPL_Dealer_CDOS_Email__c FROM Account WHERE RecordType.Name = :Accntrcdtype';
          return Database.getQueryLocator(query);
        } 
        
     global void execute(Database.BatchableContext BC, List<Account> lstofAccnt){
        
        system.debug('====lstofAccnt====='+lstofAccnt);
        Map<String,Account> mapofAccIdwithAcc = new Map<String,Account>();
        Set<String> setOfAccId = new Set<String>();
        List<Messaging.SingleEmailMessage> lstofSEM = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress orgwiseEmail = [SELECT ID, DisplayName FROM OrgWideEmailAddress WHERE DisplayName= 'VEdge' limit 1];
        EmailTemplate objEmailTemp = [SELECT id, HtmlValue, DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName = 'VCPL_Dealer_Daily_Created_Lead_Email_Alert'];
        
        Map<String,Integer> mapofParentAccwithCount = new Map<String,Integer>(); 
        
        for(SObject objLead:[SELECT VCPL_Partner_Account__c , COUNT(Name) FROM Lead WHERE VCPL_Partner_Account__c != null AND VCPL_Sync_to_CDOS__c = 'True' AND VCPL_Sync_to_CDOS_Date__c = YESTERDAY
                                  GROUP BY VCPL_Partner_Account__c   ]){
                              mapofParentAccwithCount.put((String)objLead.get('VCPL_Partner_Account__c'),(Integer)objLead.get('expr0'));
                            
          }
         system.debug(mapofParentAccwithCount+'====');
        
        for(Account objAcc: lstofAccnt){
            setOfAccId.add(objAcc.Id);
            mapofAccIdwithAcc.put(objAcc.Id,objAcc);
        }
        system.debug('===setOfAccId===='+setOfAccId);
        for(String objStr : setOfAccId){
            if(mapofParentAccwithCount.get(objStr) != null & mapofParentAccwithCount.get(objStr) > 0 &&
                mapofAccIdwithAcc.get(objStr) != null && !String.isBlank(mapofAccIdwithAcc.get(objStr).VCPL_Dealer_CDOS_Email__c) ){
                    system.debug('===setOfAccId Inside===='+setOfAccId);
                    List<String> lstToaddress = (mapofAccIdwithAcc.get(objStr).VCPL_Dealer_CDOS_Email__c).split(';');
                    if(lstToaddress.size() > 0){
                        Messaging.SingleEmailMessage objSinEmailMessage = new Messaging.SingleEmailMessage();
                        objSinEmailMessage.setSubject(objEmailTemp.Subject);
                        String strHTMLBody = objEmailTemp.HtmlValue;
                        List<String> toAddress = new List<String>();
                        strHTMLBody = strHTMLBody.replace('$UserName$',mapofAccIdwithAcc.get(objStr).Name);
                        strHTMLBody = strHTMLBody.replace('{!$Label.VA_LogoDocumentId}',Label.VA_LogoDocumentId);
                        strHTMLBody = strHTMLBody.replace('{!$Label.VA_Disclaimer_Message}',Label.VA_Disclaimer_Message);
                        PageReference EmailExcel = Page.VCPL_Daily_Lead_Created;
                        EmailExcel.getParameters().put('dealerid',objStr);
                        Blob excelBlob;
                        if(!Test.isRunningTest())
                             excelBlob= EmailExcel.getContent();
                        else
                            excelBlob = Blob.valueOf('Testexcel');
                            
                        
                        //create a new attachment
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setFileName('DailyCreatedLead '+(System.now().addDays(-1)).format('dd-MM-yyyy')+'.xls');
                        attach.setBody(excelBlob);
                        objSinEmailMessage.setHtmlBody(strHTMLBody);
                        objSinEmailMessage.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                        
                        objSinEmailMessage.setToAddresses(lstToaddress);
                        objSinEmailMessage.setOrgWideEmailAddressId(orgwiseEmail.Id);
                        system.debug('objSinEmailMessage');
                        lstofSEM.add(objSinEmailMessage); 
                        }
                
            }
             
        }
        try
              {
                  if(lstofSEM!= null && lstofSEM.size() >0)
                  {
                    Messaging.SendEmail(lstofSEM);  
                    System.debug('lstemail'+lstofSEM); 
                    System.debug('lstemail.size()'+lstofSEM.size()); 
                  }
              }
              catch(Exception ex)
                {
                    system.debug('====='+ex.getMessage());
                    VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
                    insert errorLog;
                }
        }
     
     global void finish(Database.BatchableContext BC){
   
       }
}