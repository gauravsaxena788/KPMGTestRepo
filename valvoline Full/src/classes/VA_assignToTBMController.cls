/**
--------------------------------------------------------------------------------------
Version#     Date                             Author                    Description
--------------------------------------------------------------------------------------
1.0        01-May-2018                    Manoj Jain             Initial Version
--------------------------------------------------------------------------------------
*/


public class VA_assignToTBMController {
    @AuraEnabled
    public static string assignToTBM(string strRecordId)
    {
        if(string.IsNotBlank(strRecordId))   
        {
            list<Case> lstcase= new list<Case>([select id,caseNumber,VA_Assign_to_Owner__c from Case where Id =:strRecordId]); 
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            if(lstcase != null && !lstcase.isEmpty())
            {

                Case objCase = lstcase[0];   
                if(objCase.VA_Assign_to_Owner__c == false)
                objCase.VA_Assign_to_Owner__c = true;
               else
              {
                throw new AuraHandledException(Label.ComplaintAlreadyAssignedToTBM);    
              }      
                try{
                    update objCase;
                    System.debug('Case updated is' +objCase);
                }catch(exception e){
                    throw new AuraHandledException(e.getMessage());     
                } 
      
            }  
       
        }
        return null;    
    }

}