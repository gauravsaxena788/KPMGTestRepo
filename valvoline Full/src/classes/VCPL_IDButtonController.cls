public without sharing class VCPL_IDButtonController 
{
	@AuraEnabled
	public static boolean checkVisibility()
	{
		Boolean isVisible = false;
		Id userId = userinfo.getuserId();
		
		 if(userId != NULL)
		 {
		 	list<VCPL_System_Configuration__mdt> lstMetaData = [select id,VCPL_ID_Profile_Name__c 
		 														from VCPL_System_Configuration__mdt 
                                                                where DeveloperName='VCPL_System_Configuration'];
                                                                
         	if(lstMetaData != NULL && !lstMetaData.isEmpty())
         	{
         		list<User> lstUser = [select id,AccountId,ProfileId,Profile.Name from User where Id=:userId];
         		
         		if(lstUser != NULL && !lstUser.isEmpty())
         		{
         			if(lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_ID_Profile_Name__c))
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