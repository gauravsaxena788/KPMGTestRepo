public without sharing class VCPL_UserTriggerHandler 
{
    
    public static id idBARecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    
    public void runTrigger()
    {        
         if(Trigger.isAfter && Trigger.isInsert)
         {
             onAfterInsert((List<User>) trigger.new);
         }
         if(Trigger.isAfter && Trigger.isUpdate)
         {
             onAfterUpdate((List<User>) trigger.new, (Map<Id, User>) trigger.OldMap); 
         }
     }
     public void onAfterInsert(List<User> lstTriggerNew)
     {
        shareBranches(lstTriggerNew,null);
     }
     public void onAfterUpdate(List<User> lstTriggerNew,map<id,User> triggeroldmap)
     {
        shareBranches(lstTriggerNew,triggeroldmap);
     }
     private static void shareBranches(List<User> lstTriggerNew,map<id,User> triggeroldmap)
     {
        Set<String> setofRecordType = new Set<String>();
        for(String objstr : Label.Record_type_to_be_shared.split(';')){
          setofRecordType.add(Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(objstr).getRecordTypeId());
        }
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<Id> setAccountId = new set<Id>();
            for(User objUser : lstTriggerNew)
            {
                if(objUser.AccountId != NULL && objUser.VCPL_Contact_Role__c != NULL && objUser.VCPL_Contact_Role__c.equalsIgnoreCase('HOD') && 
                    (triggeroldmap == NULL || (triggeroldmap != NULL && 
                    triggeroldmap.get(objUser.Id).VCPL_Contact_Role__c != objUser.VCPL_Contact_Role__c)))
                {
                    setAccountId.add(objUser.AccountId);    
                }
            }
            if(setAccountId != NULL && !setAccountId.isEmpty())
            {
                map<Id,list<Account>> mapofAccounts = new map<Id,list<Account>>();
                
                for(Account objBranchAcounts : [select id,parentID,RecordTypeId from Account where parentID in:setAccountId
                                                and RecordTypeId IN :setofRecordType])
                {
                    if(!mapofAccounts.containsKey(objBranchAcounts.parentID))
                        mapofAccounts.put(objBranchAcounts.parentID,new list<Account>());
                    mapofAccounts.get(objBranchAcounts.parentID).add(objBranchAcounts);                                     
                }
                if(mapofAccounts != NULL && !mapofAccounts.isEmpty())
                {
                    list<AccountShare> lstShare = new list<AccountShare>();
                    for(User objUser : lstTriggerNew)
                    {
                        if(objUser.AccountId != NULL && objUser.VCPL_Contact_Role__c != NULL 
                            && objUser.VCPL_Contact_Role__c.equalsIgnoreCase('HOD') 
                            && mapofAccounts.containsKey(objUser.AccountId) && mapofAccounts.get(objUser.AccountId) != NULL)
                        {
                            for(Account objAccount : mapofAccounts.get(objUser.AccountId))
                            {
                                AccountShare objAccountShare = new AccountShare();
                                objAccountShare.UserOrGroupId = objUser.ID;
                                objAccountShare.AccountAccessLevel = 'Read';
                                objAccountShare.AccountId = objAccount.Id;
                                objAccountShare.OpportunityAccessLevel = 'None';
                                
                                lstShare.add(objAccountShare);
                            }
                        }
                    }
                    if(lstShare != NULL && !lstShare.isEmpty())
                    {
                        try
                        {
                            Database.insert(lstShare,false);
                            //insert lstShare;
                        }
                        catch(exception e) {
                            system.debug('@@@@@'+e.getmessage());
                        }
                    }
                }
            }
        }   
     }    
}