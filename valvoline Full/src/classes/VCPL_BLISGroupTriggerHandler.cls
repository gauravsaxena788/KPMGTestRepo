public without sharing class VCPL_BLISGroupTriggerHandler 
{
    public void runTrigger()
    {
        if(Trigger.isBefore && Trigger.isInsert)
        {
            onBeforeInsert((List<VCPL_BLIS_Group__c>) trigger.new);
        }
        if(Trigger.isBefore && Trigger.isUpdate)
        {
            onBeforeUpdate((List<VCPL_BLIS_Group__c>) trigger.new, (Map<Id, VCPL_BLIS_Group__c>) trigger.OldMap);
        }
    }
    public void onBeforeInsert(List<VCPL_BLIS_Group__c> lstTriggerNew)   
    {
        updateApprover(lstTriggerNew,null);
    }
    public void onBeforeUpdate(List<VCPL_BLIS_Group__c> lstTriggerNew,map<id,VCPL_BLIS_Group__c> triggeroldmap) 
    {
        updateApprover(lstTriggerNew,triggeroldmap);
    }
    private static void updateApprover(list<VCPL_BLIS_Group__c> lstTriggerNew,map<id,VCPL_BLIS_Group__c> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<Id> setDealerID = new set<Id>();
            for(VCPL_BLIS_Group__c objBG : lstTriggerNew)
            {
                if(objBG.VCPL_Dealer__c != NULL && (triggeroldmap == NULL 
                    || (triggeroldmap != NULL && triggeroldmap.get(objBG.Id).VCPL_Dealer__c != objBG.VCPL_Dealer__c)))
                {
                    setDealerID.add(objBG.VCPL_Dealer__c);      
                }
            }
            if(setDealerID != NULL && !setDealerID.isEmpty())
            {
                map<ID,AccountTeamMember> mapofTeamMember = new map<ID,AccountTeamMember>();
                for(AccountTeamMember objTeamMember : [select id,AccountId,UserId,Account.BU_Name__c ,TeamMemberRole ,
                                                                Account.Indutry_Segment__c,Account.Market_Segment__c from 
                                                                AccountTeamMember where AccountId in:setDealerID])
                {
                    if(!mapofTeamMember.containsKey(objTeamMember.AccountId))
                        mapofTeamMember.put(objTeamMember.AccountId,objTeamMember); 
                }
                if(mapofTeamMember != NULL && !mapofTeamMember.isEmpty())
                {
                    for(VCPL_BLIS_Group__c objBG : lstTriggerNew)
                    {
                        if(objBG.VCPL_Dealer__c != NULL)
                        {
                            if(mapofTeamMember.containsKey(objBG.VCPL_Dealer__c) &&  
                                mapofTeamMember.get(objBG.VCPL_Dealer__c).UserId != NULL &&  mapofTeamMember.get(objBG.VCPL_Dealer__c).TeamMemberRole =='Segment Manager')
                            {
                                objBG.VCPL_Approver__c = mapofTeamMember.get(objBG.VCPL_Dealer__c).UserId;  
                            } 
                        }
                    }
                }
            }
        }
    }
}