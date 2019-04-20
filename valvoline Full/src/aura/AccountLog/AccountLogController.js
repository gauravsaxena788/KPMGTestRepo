({
    doInit : function(component, event, helper) {
        var param =component.get("v.recordId");
        var action=component.get("c.findAllNew");
        action.setParams({
            "QuoteId" : param
        });
        action.setCallback(this, function(a){
            
        });
        
       $A.enqueueAction(action);
    },
    
	myAction : function(component, event, helper) {
		var param =component.get("v.recordId");
        window.open("/apex/AccountLog?recordId="+param);
        $A.get("e.force:closeQuickAction").fire();
	}
})