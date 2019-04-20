/**
--------------------------------------------------------------------------------------
Version#     Date                             Author                    Description
--------------------------------------------------------------------------------------
1.0        15-May-2018                    Manoj Jain             Initial Version
--------------------------------------------------------------------------------------
*/

public class VA_CustomCaseController {
    
    @AuraEnabled
    // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
    public static wrapperClass initMethod(string strRecordId,Id profileId){       
        wrapperClass returnwrapperClass = new  wrapperClass ();        
        returnwrapperClass.lstCase = [SELECT Id,Status FROM Case WHERE Id=:strRecordId];  
        profileId=userinfo.getProfileId();
        String Profile = [Select Id,Name from Profile where Id=:profileId].Name;      
        if(Profile=='Helpdesk Admin') {      
            returnwrapperClass.isrendered = true;  
        }  
        else{
           returnwrapperClass.isrendered = false; 
        }
        if((Profile=='OLT' || Profile=='TBM' || Profile=='NSH' || returnwrapperClass.lstCase[0].Status=='Action Taken' || returnwrapperClass.lstCase[0].Status=='Ready for Closure' || returnwrapperClass.lstCase[0].Status=='Closed')) {      
           returnwrapperClass.isVisible = false;
        }
        else{
           returnwrapperClass.isVisible = true; 
        }
        return returnwrapperClass;  
    }       
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperClass{
        @AuraEnabled public List<Case> lstCase{get;set;}
        @AuraEnabled public String Status{get;set;}
        @AuraEnabled public boolean isrendered{get;set;}
        @AuraEnabled public boolean isVisible{get;set;}

    }
}