({
    doInit : function(component, event, helper) {
        helper.checkVisibility(component);
    },
    navigatetoSalesPlan: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/sales-plan"
        });
        urlEvent.fire();
    },
    navigatetoSalescapture: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/sales-capture"
        });
        urlEvent.fire();
    },
    navigatetoPotentialCapture: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/potential-capture"
        });
        urlEvent.fire();
    },
})