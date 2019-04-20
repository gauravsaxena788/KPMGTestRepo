({
	getId : function (component, event,helper) {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
       
        return result.id;
    },
    
    fetchData : function(component, event,helper) { 
        debugger;
        var action1 = component.get("c.GetsObjectData");
        var rec = helper.getId();
        
        action1.setParams({ "myId" : rec });
            
        action1.setCallback(this, function(result) {
            var state = result.getState();  
            
            if (component.isValid() && state === "SUCCESS"){
				component.set("v.sobj", result.getReturnValue());
                console.log(component.get("v.sobj"));
                alert(component.get("v.sobj").recordtype.developername);
            } 
            
        });
        $A.enqueueAction(action1);
    },
})