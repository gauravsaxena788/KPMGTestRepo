({
    doInit :function(component,event,helper){
		var action = component.get("c.getloginuserProfile");
       
            
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnvar = response.getReturnValue();
                if(returnvar == 'CD HOD Partner User' || returnvar == 'CD HOD Partner & Customer User')
                	component.set("v.buttondisabled",false);
            }
       });
         $A.enqueueAction(action);
	},
	closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
    },
    openModel : function(component, event, helper) {
		 var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        
       // component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index: 0;} .forceStyle.desktop .viewport{overflow:hidden;}")
	}
})