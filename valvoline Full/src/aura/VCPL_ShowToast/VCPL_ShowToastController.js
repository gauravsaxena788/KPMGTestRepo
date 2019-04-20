({
    doInit : function(component, event, helper) {
        var recordID = component.get("v.recordId");        
        var action = component.get("c.ShowToastMessage");
        
        
        action.setParams({
            "strDPId": (recordID != null && recordID != '')?recordID:null
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objectresmessage = response.getReturnValue() ;
                if(objectresmessage != null && objectresmessage != ''){
                    var toastEventsucessnew = $A.get("e.force:showToast");
                    toastEventsucessnew.setParams({
                        mode: 'dismissible',
                        message: objectresmessage,
                        type : 'warning',
                        duration:'20000'
                    });
                    toastEventsucessnew.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})