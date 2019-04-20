({
	upsertDet : function(component) {
        
        var param =component.get("v.recordId");
        
        var action=component.get("c.quoteCount");
        var action1 = component.get("c.getAccountId");
        
        action.setParams({
            "oppId" : param
        });
        
        action1.setParams({
            "oppId" : param
        });
        
        //alert('opp ID : '+param);
        action.setCallback(this, function(a){
            //alert('New Quote Number is : '+a.getReturnValue());
            var qtn=a.getReturnValue();  
            component.set("v.qtn",qtn);
            
        });
         $A.enqueueAction(action);
        
        action1.setCallback(this, function(a){
            //alert('AccountId : '+a.getReturnValue());
            var accId=a.getReturnValue();  
            component.set("v.accId",accId);
            
        });
         $A.enqueueAction(action1);
        
    }
})