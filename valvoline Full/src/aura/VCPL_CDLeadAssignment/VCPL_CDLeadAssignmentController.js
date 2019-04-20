({
    doInit: function(component, event, helper) {
        helper.getLoggedInUserRelatedDetails(component, event, helper);
    },
    branchChangeHandler: function(component, event, helper) {
        var leadRecord = component.get("v.leadRecord") || {};
        leadRecord.VCPL_ELP__c = '';
        leadRecord.VCPL_Branch_Head__c = '';
        component.set("v.leadRecord", leadRecord);
        helper.setBranchHeadList(component, helper);
        helper.setELPList(component, helper);
    },
    saveLeadAssignment: function(component, event, helper) {
        helper.saveAssignment(component, event, helper);
    },
    closeLeadAssignment: function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();
    }
})