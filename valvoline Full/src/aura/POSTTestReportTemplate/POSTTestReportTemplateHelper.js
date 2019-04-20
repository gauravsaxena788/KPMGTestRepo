({
    callServer: function (component, event, sendOrNot) {  
        
        var recordId = component.get("v.recordId");
        var action = component.get("c.createAttachment");
        
        action.setParams(
            { 
                "CaseId" : recordId,
                "sendTemp" : sendOrNot
            }
        );
        
        action.setCallback(this, function(response) {            
            
            var state = response.getState();
            var msg = response.getReturnValue();             
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams(
                {
                    "title": state,
                    "message": msg,
                    "type": (msg.includes("successfully") ? "success" : "error")
                }
            );
            toastEvent.fire();
            
            $A.get("e.force:refreshView").fire();   
            $A.get("e.force:closeQuickAction").fire();                    
        }); 
        
        $A.enqueueAction(action);    
    }
})