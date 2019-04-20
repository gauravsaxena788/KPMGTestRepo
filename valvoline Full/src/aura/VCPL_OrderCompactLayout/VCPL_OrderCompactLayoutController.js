({
	doInit : function(component, event, helper) {
        var action = component.get("c.GetsObjectData");
        action.setParams({ "myId" : helper.getId() });
        action.setCallback(this, function(result) {
            var state = result.getState();  
            if (state === "SUCCESS"){
                
                component.set("v.objOrder", result.getReturnValue());
            }  
        });
        $A.enqueueAction(action);  
		
	},
    goBack : function(component, event, helper) 
    {
        var rec = component.get("v.objOrder.AccountId");

        //alert(rec);
    	var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
          "url": "/show-child-data?id="+rec+"&tabset-9a9e5=3"
        });
        urlEvent.fire();
    }
})