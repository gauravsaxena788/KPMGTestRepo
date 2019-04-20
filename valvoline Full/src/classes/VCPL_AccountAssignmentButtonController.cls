public without sharing class VCPL_AccountAssignmentButtonController 
{
	@AuraEnabled
	public static boolean checkVisibility()
	{
		Boolean isVisible = false;
		Id userId = userinfo.getuserId();
		
		 if(userId != NULL)
		 {
		 	list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
	                                                                VCPL_CD_ELP_Profile_Name__c,VCPL_CD_BH_Contact_Role_Name__c,
	                                                                VCPL_CD_ELP_Contact_Role_Name__c,VCPL_CD_HOD_Contact_Role_Name__c,VCPL_CD_HOD_Profile_Name__c 
	                                                                from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
                                                                
         	if(lstMetaData != NULL && !lstMetaData.isEmpty())
         	{
         		list<User> lstUser = [select id,ProfileID,Profile.Name,AccountID,VCPL_Contact_Role__c 
                                      from User where id=:userID];
         		
         		if(lstUser != NULL && !lstUser.isEmpty())
         		{
         			if((!String.isBlank(lstUser[0].VCPL_Contact_Role__c) && lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Contact_Role_Name__c)) || 
                      (lstUser[0].Profile.Name.equalsIgnoreCase('System Administrator')))
                     {
                 		isVisible = true;  		
                     }
                     else
                     {
                     	isVisible = false;
                     }
         		}
         	}		 	
		 }
		 return isVisible;
	}    
}