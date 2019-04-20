({
    doInit : function(component, event,helper) {  
        var action = component.get("c.GetsObjectData");
        action.setParams({ "myId" : helper.getId() });            
        action.setCallback(this, function(result) {
            var state = result.getState();  
            if (component.isValid() && state === "SUCCESS"){
                var response = result.getReturnValue();

                component.set("v.objInvoice", result.getReturnValue());    
            }  
        });
        $A.enqueueAction(action);      
    }
     
})