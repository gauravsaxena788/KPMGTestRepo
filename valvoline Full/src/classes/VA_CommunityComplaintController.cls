/**
--------------------------------------------------------------------------------------
Version#     Date                             Author                    Description
--------------------------------------------------------------------------------------
1.0        15-May-2018                    Manoj Jain             Initial Version
--------------------------------------------------------------------------------------
*/

public class VA_CommunityComplaintController {

@AuraEnabled
    // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
public static wrapperClass initMethod(string strRecordId,Id profileId){  
 wrapperClass returnwrapperClass = new  wrapperClass ();    
 returnwrapperClass.lstCase = [SELECT Id,Status FROM Case WHERE Id=:strRecordId];
   return returnwrapperClass;       
}       

// wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperClass{
        @AuraEnabled public List<Case> lstCase{get;set;}
    }
}