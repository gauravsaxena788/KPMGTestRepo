({
    doInit : function(component, event, helper) {
        var recID = helper.getId();
        //alert(recID);
        var action=component.get("c.getOrderProducts");
        action.setParams({
            "OrderId":recID
        });
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if(state ==="SUCCESS")
            {
                var response = actionresult.getReturnValue();
               
                component.set("v.lstOrderProducts",response);
            }
        });
         $A.enqueueAction(action); 
    }
})