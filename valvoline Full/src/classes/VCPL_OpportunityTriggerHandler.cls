public without sharing class VCPL_OpportunityTriggerHandler {
   Id OpportunitySAPId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SAP_Order').getRecordTypeId();
   
    public void runTrigger() {
       if (Trigger.isBefore && Trigger.isInsert) {
            isBeforeInsertupdate((List < Opportunity > ) trigger.new,null);
        }
        if (Trigger.isBefore && Trigger.isUpdate) {
            isBeforeInsertupdate((List < Opportunity > ) trigger.new,(Map<Id,Opportunity>)Trigger.oldMap);
        }
        // Method will be called to handle After Insert events
        if (Trigger.isAfter && Trigger.isInsert) {
            onAfterInsert((List < Opportunity > ) trigger.new);
        }
 
    }
    public void isBeforeInsertupdate(List<Opportunity> lstOpp,Map<Id,Opportunity> mapofOldOpport) {
        for(Opportunity objOpp:lstOpp){
            if(objopp.RecordTypeId == OpportunitySAPId && (mapofOldOpport == Null || (objOpp.AccountId != mapofOldOpport.get(objOpp.Id).AccountId))){
                objOpp.VCPL_SAP_Opportunity__c = objOpp.AccountId;
            }
        }
    }
    
    
    public void onAfterInsert(List < Opportunity > lstTriggerNew) {
        new VCPLSharingService().shareBlanketOpportunities(lstTriggerNew);
    }

}