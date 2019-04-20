trigger VCPL_TriggerOpportunity on Opportunity (before insert, before update, after insert) {    
        VCPL_OpportunityTriggerHandler obj = new VCPL_OpportunityTriggerHandler();
        obj.runTrigger();
}