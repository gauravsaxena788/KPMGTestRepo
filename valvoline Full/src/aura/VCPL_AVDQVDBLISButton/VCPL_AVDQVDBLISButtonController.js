({
	doInit : function(component, event, helper) {
		helper.checkVisibility(component);
	},
	navigatetoAVDQVD: function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/avd-qvd-io-co"
        });
        urlEvent.fire();
	},
    navigatetoBLIS: function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/blis-hod"
        });
        urlEvent.fire();
	}
})