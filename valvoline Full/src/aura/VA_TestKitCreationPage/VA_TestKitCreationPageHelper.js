({
	getLoggedInUser : function(component, event) {
        debugger;
		var action=component.get("c.getLoggedInUserId");
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                if(result == '0050x000001AcbZAAS'){
                    component.set("v.userId",true);
                }
                else{
                    component.set("v.userId",false);
                }
            }
            
        }); 
        $A.enqueueAction(action);        
	}
})