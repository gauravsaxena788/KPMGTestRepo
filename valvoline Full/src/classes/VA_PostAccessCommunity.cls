Public class VA_PostAccessCommunity{
     @AuraEnabled
    // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
    public static wrapperClass initMethod(string userId){  
       // try{
             
            wrapperClass returnwrapperClass = new  wrapperClass ();     
            userId = UserInfo.getUserId() ;
            returnwrapperClass.lstUser= [SELECT profileId, profile.name,ContactId, contact.Account.VA_POST_Allowed__c FROM User WHERE Id=:userId ];  
            system.debug('@@post'+returnwrapperClass.lstUser);
            system.debug('@@account'+returnwrapperClass.lstUser[0].contact.Account.VA_POST_Allowed__c);
            for(User objUser : returnwrapperClass.lstUser){
                if(objUser.contact.Account.VA_POST_Allowed__c=='Yes') {      
                    returnwrapperClass.isrendered = true;
                } 
                else{
                   returnwrapperClass.isrendered = false;   
                } 
            }
    
            return returnwrapperClass;  
        //}
        /*catch(Exception ex) {  
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog; return null;
        } */
    }       
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperClass{
        @AuraEnabled public List<User> lstUser{get;set;}
        @AuraEnabled public boolean isrendered{get;set;}
    }
     
     }