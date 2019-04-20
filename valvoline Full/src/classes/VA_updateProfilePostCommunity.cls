public class VA_updateProfilePostCommunity{

    @future(callout=true)
    public static void updateProfile(Set<Id> AccountId){
        try{
            List<User> lstUsertobeUpdated = new List<User>();
            List<user>  lstUser = [SELECT profileId, profile.name,ContactId, contact.Account.VA_POST_Allowed__c FROM User WHERE Contact.AccountId IN:AccountId];
            Map<String,id> mapProfile = new Map<String,id>();
            for(Profile objProfile:[Select Id,name From Profile])
            {
                if(!mapProfile.containskey(objProfile.Name)){
                    mapProfile.put(objProfile.Name,objProfile.Id);
                }
            }
            if(mapProfile!=null && mapProfile.size()>0){
                for(User objUser :lstUser ){
                    if(objUser.contact.Account.VA_POST_Allowed__c== 'Yes'){
                        system.debug('@@Profile'+mapProfile.get('Customer Community User Login_Post'));
                        objUser.profileId = mapProfile.get('Customer Community User Login_Post');
                        lstUsertobeUpdated.add(objUser);
         
                    }
                    else{
                        system.debug('@@Profile'+ mapProfile.get('Customer Community User Login'));
                        objUser.profileId = mapProfile.get('Customer Community User Login');
                        lstUsertobeUpdated.add(objUser);
                    }
                }
               
            }
            system.debug('@@lstUsertobeUpdated'+lstUsertobeUpdated);
            if(!lstUsertobeUpdated.isEmpty()){
                update lstUsertobeUpdated;
            }
        }
        catch(Exception ex){
              VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
              insert errorLog;
        }
    }
    
     @future(callout=true)
    public static void updatePermissionset(Set<Id> AccountId){
        try{
            List<User> lstUsertobeUpdated = new List<User>();
            set<id> setUserId = new set<id>();
            list<PermissionsetAssignment> lstPermissionsetAssignment = new list<PermissionsetAssignment>();
            List<user>  lstUser = [SELECT profileId, profile.name,ContactId, contact.Account.VA_POST_Allowed__c FROM User WHERE Contact.AccountId IN:AccountId];
            Map<String,id> mapPermissionset = new Map<String,id>();
            for(permissionset objPermission:[SELECT Id,Name FROM PermissionSet WHERE IsCustom = True AND Name = 'VCPL_Post_Cases'])
            {
                if(!mapPermissionset.containskey(objPermission.Name)){
                    mapPermissionset.put(objPermission.Name,objPermission.Id);
                }
            }
            
            if(mapPermissionset!=null && mapPermissionset.size()>0){
                for(User objUser :lstUser ){
                    if(objUser.contact.Account.VA_POST_Allowed__c == 'Yes'){
                        PermissionSetAssignment objPermissionsetAssignment = new PermissionSetAssignment();
						objPermissionsetAssignment.PermissionSetId = mapPermissionset.get('VCPL_Post_Cases');
                        objPermissionsetAssignment.AssigneeId = objUser.id;
                        lstPermissionsetAssignment.add(objPermissionsetAssignment);            
                    }
                    else
                    {
						setUserId.add(objUser.id);                       
                    }
                }
               
            }
            system.debug('@@lstUsertobeUpdated'+lstPermissionsetAssignment);
            if(!lstPermissionsetAssignment.isEmpty()){
                insert lstPermissionsetAssignment;
            }
            
            if (setUserId.size() > 0){
                list<PermissionsetAssignment> lstPerRecToBeDeleted = [select id from PermissionsetAssignment where AssigneeId IN:setUserId and PermissionSetId IN:mapPermissionset.values()];
                if (!lstPerRecToBeDeleted.isempty()){
                    delete lstPerRecToBeDeleted;
                }
            }
            
        }
        catch(Exception ex){
            try
            {
              VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
              insert errorLog;
            }
            catch(exception e)
            {
                
            }
        }
    }
}