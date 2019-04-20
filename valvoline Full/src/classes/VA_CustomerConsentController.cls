/**
--------------------------------------------------------------------------------------
Version#     Date                             Author                    Description
--------------------------------------------------------------------------------------
1.0        11-May-2018                    Manoj Jain             Initial Version
--------------------------------------------------------------------------------------
*/

public without sharing class VA_CustomerConsentController {     
    @AuraEnabled
    public static Case saveCase(Case objCase,string caseId) {                
        
        if(string.IsNotBlank(caseId))          
        {
            list<Case> lstcase= new list<Case>([select id,recordType.DeveloperName,Status,VA_Customer_Closure_Consent__c,Consent_Comment__c from Case where Id =:caseId]); 
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            if(lstcase != null && !lstcase.isEmpty())      
            { 
                
                try{
                    objCase.Id = caseId;      
                    update objCase;   
                }catch(exception e){
                    throw new AuraHandledException(e.getMessage());     
                }
            }  
            
        }
        return objCase;
        
    }
    
}