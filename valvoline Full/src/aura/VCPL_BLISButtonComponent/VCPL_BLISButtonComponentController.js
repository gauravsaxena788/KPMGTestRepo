({
	doInit : function(component, event, helper) {
		helper.checkVisibility(component);
	},
    navigatetoBLIS: function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/blis-bh"
        });
        urlEvent.fire();
	}
})