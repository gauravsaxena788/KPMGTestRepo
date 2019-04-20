({
	doInit : function(component, event, helper) {
		// call the apex class method 
     	var action = component.get("c.shownotification");
      	// set param to method  
        action.setParams({
            'recordId': component.get("v.recordId")
        });
      	// set a callBack    
        action.setCallback(this, function(response) {
          var state = response.getState();
            if (state === "SUCCESS") {
              	var storeResponse = response.getReturnValue();
                if(storeResponse != ''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "mode": "sticky",
                        "type": "warning",
                        "message": storeResponse
                    });
                    toastEvent.fire();
            	}
            }
        });
        $A.enqueueAction(action);
	},
    
    refreshView : function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    }
})