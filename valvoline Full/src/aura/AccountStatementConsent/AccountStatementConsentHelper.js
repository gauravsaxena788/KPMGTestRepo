({
    Already_Provided_Consent_Label: 'You have already provided Consent',
    
	updateCheck11_helper : function(component, event, helper) {
		debugger;
		var save_action = component.get("c.updateCheck");
    	save_action.setParams({
            parentId: component.get("v.recordId")
		});
		
        save_action.setCallback(this, function(response) {    
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
				//set response value in wrapperList attribute on component.
				//component.set('v.AccountStatementConsent', response.getReturnValue());
				if(response.getReturnValue()) {
                    this.ShowToast(component, event,'Consent Done','Success!','success');
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();

                } 
                else{
                     this.ShowToast(component, event, this.Already_Provided_Consent_Label, 'Error', 'error');
                     $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();

                }
            }
		});
        $A.enqueueAction(save_action);
        
	},
	ShowToast : function(component, event, varMessage,varTitle,varType) {
        var toastEvent = $A.get("e.force:showToast");
        
        
        toastEvent.setParams({
            message: varMessage,
            title:varTitle,
            type:varType/*,
            duration:varDuration*/
		});
        toastEvent.fire();
	}
})