({
	doInit : function(component, event, helper) {
		 helper.getAccountName(component, event);
	},
	cancel : function(component, event, helper) {
        component.set('v.showTestPage',false);
    },
    closeToast : function(component, event, helper) {
        component.set('v.errormsg',"");
    },
    saveData:function(component, event, helper) {
    	helper.SaveOrder(component, event, helper);
    }
})