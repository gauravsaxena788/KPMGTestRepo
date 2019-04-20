({
    init : function(component, event, helper) {
        debugger;
        helper.init(component, event);       
    },
	
    
    CompaintPicklistchange:function(component, event, helper) {
		helper.CompaintPicklistchange(component, event);
	},
    
	createCase : function(component, event, helper) {
		helper.createCase(component, event);
	},
    
    picklistchange:function(component,event,helper){
    	helper.picklistchange(component,event);
	},
    
    KeyPressHideError:function(component,event,helper){
        debugger;
        helper.KeyPressHideError(component,event);
    },
    
    navigateToPreviousPage : function (component, event, helper){
        //alert('hiii');
        var modalCloseEvt = component.getEvent("ModalCloseEvent");
 		modalCloseEvt.fire();
    },
    pickliststatuschange:function(component,event,helper){
    	helper.pickliststatuschange(component,event);
	}

})