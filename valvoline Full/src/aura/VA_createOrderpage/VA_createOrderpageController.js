({
	doInit : function(component, event, helper) {
         console.log('VAL of showtstpg in createOrdPg-->C-->init-->'+component.get("v.showTestPage"));
        console.log('VAL of Errormsg in createOrdPg-->C-->init-->'+JSON.stringify(component.get("v.errormsg")));
       
		 helper.getAccountName(component, event);
	},
	cancel : function(component, event, helper) {
        component.set('v.showTestPage',false);
    },
    closeToast : function(component, event, helper) {
        component.set('v.errormsg',"");
    },
    controllerSaveOrderDetails:function(component, event, helper) {
    	helper.SaveOrder(component, event, helper);
    }
})