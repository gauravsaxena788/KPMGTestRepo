global class VCPL_ExpireDiffPricingBatchNotification implements Database.Batchable<sObject>{

    global Database.querylocator start(Database.BatchableContext bc)
  {
        List<String> lstOfdate = Label.VCPL_Differential_Pricing_Notification.split(';');
        Date firstDate = (System.Today()).addDays(Integer.valueof(lstOfdate[0]));
        Date seconddateDate = (System.Today()).addDays(Integer.valueof(lstOfdate[1]));
      	System.debug('====='+firstDate+'=====seconddateDate'+seconddateDate); 
      	System.debug('====='+[SELECT id, Name , Owner.Email, Owner.Name, VCPL_Dealer_Name__r.Name, VCPL_Customer_Name__r.Name, VCPL_Validity_Start_Date__c, VCPL_DP_Expiry_Reason__c , VCPL_DP_Expiry_Date__c, VCPL_DP_Request_Status__c 
                                         FROM VCPL_Differential_Pricing__c WHERE  (VCPL_DP_Expiry_Date__c = :firstDate 
                                         OR VCPL_DP_Expiry_Date__c = :seconddateDate) AND VCPL_DP_Request_Status__c = 'Approved']);
        return Database.getQueryLocator([SELECT id, Name , Owner.Email, Owner.Name, VCPL_Dealer_Name__r.Name, VCPL_Customer_Name__r.Name, VCPL_Validity_Start_Date__c, VCPL_DP_Expiry_Reason__c , VCPL_DP_Expiry_Date__c, VCPL_DP_Request_Status__c 
                                         FROM VCPL_Differential_Pricing__c WHERE  (VCPL_DP_Expiry_Date__c = :firstDate 
                                         OR VCPL_DP_Expiry_Date__c = :seconddateDate) AND VCPL_DP_Request_Status__c = 'Approved']);
  }
    global void execute(Database.BatchableContext BC, List<VCPL_Differential_Pricing__c> lstDiffPricing)
    {
        if(lstDiffPricing != NULL && !lstDiffPricing.isEmpty())
        {
            
        Map<String,String> mapuseridWithEmail = new Map<String,String>();
        Map<String,String> mapuseridWithUser = new Map<String,String>();
        Map<String,List<Account>> mapuserIdWithAccountlst = new Map<String,List<Account>>();
        List<Messaging.SingleEmailMessage> lstofSEM = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress orgwiseEmail = [SELECT ID, DisplayName FROM OrgWideEmailAddress WHERE DisplayName= 'VEdge' limit 1];
        
       
       EmailTemplate objEmailTemp = [SELECT id, HtmlValue, DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName = 'VCPL_Expire_DP_Notification']; 
       
       for(VCPL_Differential_Pricing__c objDP : lstDiffPricing){
           Messaging.SingleEmailMessage objSinEmailMessage = new Messaging.SingleEmailMessage();
           Integer noofdate = (System.Today()).daysBetween(objDP.VCPL_Validity_Start_Date__c);
           objEmailTemp.Subject = objEmailTemp.Subject.replace('$Days$',String.valueof(noofdate)); 
           objSinEmailMessage.setSubject(objEmailTemp.Subject);
           String strHTMLBody = objEmailTemp.HtmlValue;
           Integer count= 0;
           String strmessage ='';
           
           strHTMLBody = strHTMLBody.replace('$UserName$',objDP.Owner.Name);
           strHTMLBody = strHTMLBody.replace('$DifferentialName$',objDP.Name);
           strHTMLBody = strHTMLBody.replace('$DealerName$',objDP.VCPL_Dealer_Name__r.Name);
           strHTMLBody = strHTMLBody.replace('$CustomerName$',objDP.VCPL_Customer_Name__r.Name);
           strHTMLBody = strHTMLBody.replace('$Days$',String.valueof(noofdate));
           strHTMLBody = strHTMLBody.replace('$StartDate$',DateTime.newInstance(objDP.VCPL_Validity_Start_Date__c.Year(),objDP.VCPL_Validity_Start_Date__c.Month(),objDP.VCPL_Validity_Start_Date__c.Year()).format('dd-MM-yyyy'));
           strHTMLBody = strHTMLBody.replace('{!$Label.VA_Disclaimer_Message}',Label.VA_Disclaimer_Message);
           strHTMLBody = strHTMLBody.replace('{!$Label.VA_LogoDocumentId}',Label.VA_LogoDocumentId);
           objSinEmailMessage.setHtmlBody(strHTMLBody);
          List<String> toAddress = new List<String>();
          toAddress.add(objDP.Owner.Email);
          objSinEmailMessage.setToAddresses(toAddress);
          
          objSinEmailMessage.setOrgWideEmailAddressId(orgwiseEmail.Id);
          system.debug('objSinEmailMessage');
          lstofSEM.add(objSinEmailMessage); 
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
    }  
  global void finish(Database.BatchableContext BC)
  {
    
  }      

}