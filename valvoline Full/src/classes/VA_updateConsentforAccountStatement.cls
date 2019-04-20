public without sharing class VA_updateConsentforAccountStatement{
    

    
    @AuraEnabled
    public static boolean updateCheck(Id parentId){
     try{
        wrapperClass returnwrapperClass = new  wrapperClass (); 
        list<VA_AccountStatement__c> lstAccountSttobeupdated= new list<VA_AccountStatement__c>();
        VA_AccountStatement__c AccountStatementConsent= [select id ,VA_IsConsent__c, VA_Month__c, VA_Year__c,VA_Account__r.Ship_to_Code__c,VA_Frequency__c from VA_AccountStatement__c where id=:parentId Limit 1];
        
        system.debug('@@lstAccountSt'+returnwrapperClass.lstAccountStatement);
        
         if(AccountStatementConsent.VA_IsConsent__c== false){
            AccountStatementConsent.VA_IsConsent__c= true; 
         }
         else {
             return false;
         }
            
            
            lstAccountSttobeupdated.add(AccountStatementConsent);
        
        
        if(!lstAccountSttobeupdated.isEmpty())
            update lstAccountSttobeupdated;
            
            return true;
        
        }
         catch(Exception ex) {  
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;
            return null;
        }
         
    }
     public class wrapperClass{
        @AuraEnabled public List<VA_AccountStatement__c> lstAccountStatement{get;set;}
        
    }
    
}