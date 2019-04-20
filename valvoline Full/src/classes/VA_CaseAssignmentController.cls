/**
--------------------------------------------------------------------------------------
Version#     Date                             Author                    Description
--------------------------------------------------------------------------------------
1.0        05-May-2018                    Manoj Jain             Initial Version
--------------------------------------------------------------------------------------
*/
public class VA_CaseAssignmentController {
    
    @AuraEnabled
    public static string acceptCase(string strRecordId)     
    {
        if(string.IsNotBlank(strRecordId))   
        {
            list<Case> lstcase= new list<Case>([select id,ownerId,caseNumber from Case where Id =:strRecordId]); 
            Id userId=userinfo.getuserId();
            if(lstcase != null && !lstcase.isEmpty())
            {
                
                Case objCase = lstcase[0];
                objCase.ownerId = userId; 
                if(objCase.VA_Date_of_complaint_accepted__c==null){
                    objCase.VA_Date_of_complaint_accepted__c = Date.Today(); 
                    
                    
                }  
                
                try{
                    update objCase;
                    
                    
                }catch(exception e){
                    throw new AuraHandledException(e.getMessage());     
                }    
                
            }  
            
            
            
            
        }
        return null;    
    }
}