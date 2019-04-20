({
	ShowToast : function(component, event,varMode,varMessage,varTitle,varType,varDuration) {
        var toastEvent = $A.get("e.force:showToast");       
        toastEvent.setParams({    
            mode: varMode,
            message: varMessage,   
            title:varTitle,
            type:varType,
            duration:varDuration
        });
        toastEvent.fire();   
    }
})