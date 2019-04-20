({
	getCaseDetail: function(component, event, helper) { 
        var action = component.get('c.getServiceRequest');
        action.setCallback(this, function(actionResult) {
        
      if(actionResult.getState()=='SUCCESS') { 
           
        component.set('v.caseDetails', actionResult.getReturnValue());
       console.log('case+++',actionResult.getReturnValue());
       }
     });
        
        $A.enqueueAction(action);
    
	}  
})