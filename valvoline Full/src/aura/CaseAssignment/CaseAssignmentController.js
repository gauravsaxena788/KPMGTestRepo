({   
    acceptCaseJS : function(component, event, helper) {
        
        var strCaseId =component.get("v.recordId");  
        if(strCaseId)  
        {
            var action = component.get("c.acceptCase");
            action.setParams({ strRecordId : strCaseId})
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS")
                {
                    helper.ShowToast(component, event,'dismissible','Case Assigned to You','Success!','success',20000);
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
                    dismissActionPanel.fire();
                    
                    component.set("v.isOpen", false);
                      component.set("v.isVisible", false);
                      component.set("v.isAvailable", false);
                
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
            $A.enqueueAction(action);          
        }
        else     
        {
            helper.ShowToast(component, event,'dismissible','Case id is not availbale. Please contact System Administrator','System Exception','error',20000);
        }   
    }    
})