({
	fetchStatusValues : function(component, event, recordId) {
        console.log(recordId);
        var action = component.get("c.getStatusValue");
        action.setParams({ recId : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if(state === 'SUCCESS'){
               var resp = response.getReturnValue();
                 console.log(resp);
                 //status = resp.status;
                
            }
        });
        $A.enqueueAction(action);
	}
})