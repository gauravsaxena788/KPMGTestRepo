({
	showSuccessToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success!!!',
            message: 'Quote has been cloned successfully!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    getaccounts: function(component, event, helper) {
        var action = component.get("c.fetchUserAcc1");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.accInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);
        
        
        
    },
    
       loadAccountoptions: function(component, event) {
        var action = component.get("c.fetchUserAcc1");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                var acclist = [];
                var index = 0;
                for (var key in resp) {
                    var obj = {
                        value: resp[key],
                        key: key
                    };
                    if (index === 0) {
                        //obj.selected = true;
                        acclist.push({value: '--None--', key: 'none'});
                        //if(key) component.find("AccountId").set("v.value", key);
                    }
                    acclist.push(obj);
                    index++;
                }
                component.set("v.accountOptions", acclist);
            }
        });
        $A.enqueueAction(action);
    },
    
    loadOpportunityoptions: function(component, event) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.fetchopponload");
        action.setParams({
            qtId: recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                var opplist = [];
                var index = 0;
                for (var key in resp) {
                    var obj = {
                        value: resp[key],
                        key: key
                    };
                    if (index === 0) {
                        //obj.selected = false;
                        if(key) component.find("OpportunityId").set("v.value", key);
                    }
                    opplist.push(obj);
                    index++;
                }
                //alert(opplist);
                component.set("v.oppOptions", opplist);
            }
        });
        $A.enqueueAction(action);
    },
    
     onloadoppchange: function(component, event, helper) {
        var Accid = event.getSource().get("v.value");
        //alert(component.find("AccountId").get("v.value"));
        //alert(Accid);
        
        var action = component.get("c.fetchopp");
        action.setParams({
            accountId: Accid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                var opplist = [];
                var index = 0;
                for (var key in resp) {
                    var obj = {
                        value: resp[key],
                        key: key
                    };
                    if (index === 0) {
                        //obj.selected = false;
                        if(key) component.find("OpportunityId").set("v.value", key);
                    }
                    opplist.push(obj);
                    index++;
                }
                //alert(opplist);
                component.set("v.oppOptions", opplist);
            }
        });
        $A.enqueueAction(action);
    }
  
})