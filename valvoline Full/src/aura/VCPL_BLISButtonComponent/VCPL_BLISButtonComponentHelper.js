({
    checkVisibility: function(component) {
        var action = component.get("c.checkVisibilityBLIS");

        action.setCallback(this, function(response) {
        	var state= response.getState();
        	if(state === "SUCCESS")
        	{
        		var response = response.getReturnValue();
        		
        		if(response == true)
        		{
        			component.set("v.show",true);
        		}
        		else
        		{
        			component.set("v.show",false);
        		}
        	}
        });
        $A.enqueueAction(action);
    }
})