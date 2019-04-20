({
    doInit : function(component, event,helper) {  
        var action = component.get("c.GetsObjectData");
        action.setParams({ "myId" : helper.getId() });
            
        action.setCallback(this, function(result) {
            var state = result.getState();  
            if (component.isValid() && state === "SUCCESS"){
                debugger;
                component.set("v.sobj", result.getReturnValue());
                console.log(component.get("v.sobj"));
                alert(component.get("v.sobj").recordtype.developername);
            } 
            
        });
        $A.enqueueAction(action);      
    }
})