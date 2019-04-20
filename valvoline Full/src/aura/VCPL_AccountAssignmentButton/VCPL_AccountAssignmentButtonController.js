({
	doInit : function(component, event, helper) {
		helper.checkVisibility(component);
	},
	navigate: function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/target"
        });
        urlEvent.fire();
        window.location.reload();
	},
})