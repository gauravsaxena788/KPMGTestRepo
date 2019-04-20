Public class VA_POSTController{
     @AuraEnabled
    // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
    public static wrapperClass initMethod(string strRecordId,Id profileId){       
        wrapperClass returnwrapperClass = new  wrapperClass ();        
        returnwrapperClass.lstCase = [SELECT Id,Status,VA_Request_Purpose__c FROM Case WHERE Id=:strRecordId];  
        profileId=userinfo.getProfileId();
        String Profile = [Select Id,Name from Profile where Id=:profileId].Name;      
        if(Profile=='Customer Community User Login'|| Profile=='Customer Community User Login_Post') {      
            returnwrapperClass.isrendered = true;
        }  
        else{
           returnwrapperClass.isrendered = false;   
        }
        return returnwrapperClass;  
    }       
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperClass{
        @AuraEnabled public List<Case> lstCase{get;set;}
        @AuraEnabled public boolean isrendered{get;set;}
    }
     
     }