({
		upsertDet : function(component) {
        var param =component.get("v.recordId");
      
        var action=component.get("c.quotefieldsget");
        
        action.setParams({
            "strOppId" : param
        });
        
        //alert('opp ID : '+param);
        action.setCallback(this, function(a){
           // alert('New Quote Number is : '+a.getReturnValue());
            
            var qtn = a.getReturnValue(); 
            component.set("v.objWrapCase",qtn);
            
        });
         $A.enqueueAction(action);
        
    }
})