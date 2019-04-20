({
	doInit : function(component, event, helper) {
		var objectAPIName = component.get("v.objectAPIName");
        var fieldAPIName = component.get("v.fieldAPIName");
        
        var action = component.get("c.getPickListValues");
        action.setParams({ 
            "objectAPIName" : objectAPIName,
            "fieldAPIName" : fieldAPIName
        });
        
        action.setCallback(this,function(response){
	        var state = response.getState();
			if(state === 'SUCCESS'){
		
				var returnVal = response.getReturnValue();
                
                component.set("v.pickValues",returnVal);
			}
		});
        $A.enqueueAction(action);
	},
	
})