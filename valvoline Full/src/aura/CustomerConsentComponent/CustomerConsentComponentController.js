({

    handleSaveCase: function(component, event, helper) {    
            
            // Prepare the action to update the Case
            var saveCaseAction = component.get("c.saveCase");  
            saveCaseAction.setParams({
                "objCase": component.get("v.caseObj"), 
                "caseId": component.get("v.recordId")
            });
        	

            // Configure the response handler for the action
            saveCaseAction.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS")
                {
                    helper.ShowToast(component, event,'dismissible','Thanks for providing closure Consnet.','Success!','success',20000);
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire();
                
                }
                else if(state === "ERROR")
                {
                    var errors = response.getError();   
                    if(errors[0] && errors[0].message)  
                    {
                        // System Errors
                        helper.ShowToast(component, event,'dismissible',errors[0].message,'','error',20000);
                        
                    	var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    	dismissActionPanel.fire();
                    }
                    else if (errors[0] && errors[0].pageErrors) 
                    {
                        // DML Error
                        helper.ShowToast(component, event,'dismissible',errors[0].pageErrors,errors[0].message,'error',20000);   
                    }
                }
            });
            // Send the request to update the case          
            $A.enqueueAction(saveCaseAction);
  
    },  

})