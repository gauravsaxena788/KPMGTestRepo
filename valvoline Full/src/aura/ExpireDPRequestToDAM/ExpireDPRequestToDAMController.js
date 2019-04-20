({
    doInit : function(component, event, helper) {
        
        var recordID = component.get("v.recordId");
        var action = component.get("c.ExpireDPRequest");        
        action.setParams({
            "DPRecord": recordID
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseres = response.getReturnValue();
                //component.set("v.objWrapCase",resultLst);
                //var responseres = component.get("v.objWrapCase");
                var resultsToast = $A.get("e.force:showToast");
                if(responseres.strResType == 'success')
                {
                    resultsToast.setParams({
                        "type": "success",
                        "title" : "Expire request raised",
                        "message" : responseres.strMessage
                    });
                    resultsToast.fire();
                }
                else if(responseres.strResType == 'error')
                { 
                    resultsToast.setParams({
                        "type": "error",
                        "title" : "Expire request raised",
                        "message" : responseres.strMessage
                    });
                    resultsToast.fire();
                } 
                 $A.get("e.force:closeQuickAction").fire();
            }
        }) ;      
         $A.enqueueAction(action);
         $A.get("e.force:closeQuickAction").fire();
    }
})