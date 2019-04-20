({
    doInit : function(component, event, helper) {
        helper.checkVisibility(component);
    },
    navigatetoCustomerCommunity: function(component, event, helper) {
        $A.get("e.force:navigateToURL").setParams({ 
       "url": "https://vcplselfservice.force.com/customers" 
    }).fire();
    }
})