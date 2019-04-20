({
    CloneDPRequestHelper : function(component){
        var recordID = component.get("v.recordId");
        component.set("v.previousDP",recordID);
       
        var action = component.get("c.RenewDPRequest");
        
        
        action.setParams({
            "DPRecord": (recordID != null && recordID != '' && recordID != undefined) ? recordID : null
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objectres = response.getReturnValue();
                if(objectres.strResType == "success"){
                    
                    component.set("v.isOpen",true);
                    //var cmpcloneDPRequest = component.find("cloneDPRequestcmp");
                    //if(!$A.util.isUndefinedOrNull(cmpcloneDPRequest)){                        
                        //cmpcloneDPRequest.set("v.IsCloneRequestresponse",objectres.strMessage);
                        //cmpcloneDPRequest.clonemethod();
                        
                    //}   
                    //$A.get("e.force:closeQuickAction").fire();
                }
                else if(objectres.strResType == "error"){
                    $A.get("e.force:closeQuickAction").fire();
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "title" : "Renew DP Request",
                        "message" : objectres.strMessage
                    });
                    resultsToast.fire();
                }
            }});
        $A.enqueueAction(action);
    }
})