public without sharing class VA_ShowDataController {
    
    @AuraEnabled  
    public static List<Account> listAllAccount(){  
        List<Account> accountList = new List<Account>();  
        Set<Id> parentIds = new Set<Id>();   
        User userObj = [Select Id,ContactId From User Where Id=:UserInfo.getUserId()];     
		for(Contact contactObj:[Select Id,AccountId,Account.Name,Account.Is_Parent__c,Account.ParentId From Contact Where Id=:userObj.ContactId])
        {
            if(contactObj.AccountId!=null && contactObj.Account.Is_Parent__c=='Y' && contactObj.Account.ParentId==Null){   
                parentIds.add(contactObj.AccountId);  
			} 
            //if(contactObj.AccountId!=null){}
			//accountList.add(contactObj.Account);  
		}
        if(parentIds.size()>0){
			for(Account accountObj: [Select Id,Name, Ship_to_Code__c, Is_Parent__c,ParentId From Account Where ParentId=:parentIds]){
				if(accountObj.Ship_to_Code__c != null)
				{
					accountObj.Name += ' '+ accountObj.Ship_to_Code__c;
				}
				accountList.add(accountObj); 
			}
		}
        System.debug('accountList'+accountList);  
        return accountList;  
	} 
    
}