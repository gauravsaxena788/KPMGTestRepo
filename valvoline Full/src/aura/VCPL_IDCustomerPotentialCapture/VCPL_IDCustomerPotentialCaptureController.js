({
	doInit : function(component, event, helper) {
		helper.getDetailsWrapper(component, event, helper);
	},
	onSaveButtonClick:function(component, event, helper) {
		helper.savePotential(component, event, helper);
	},
	closeToast: function(component, event, helper) {
        component.set('v.errormsg', "");
    },
    onCloseButtonClick: function(component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();
    }
})