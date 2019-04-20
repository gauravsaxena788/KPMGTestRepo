({
myprofile : function(component,event,helper) {
	var action = component.get("c.currentloggedinUser");
          
    action.setCallback(this, function(response){
                var state = response.getState();
                
                if (state === "SUCCESS") 
                {
                    var pro = response.getReturnValue();
                    //alert(pro);
                    component.set("v.profilename", pro);             
                }
                
     });
            
            $A.enqueueAction(action);
}
})