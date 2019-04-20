({
    getAccountName: function(component, event) {
        var action = component.get("c.getAccountNameMethod");
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if (state === "SUCCESS") {
                var result = actionresult.getReturnValue();
                debugger;
                if (!$A.util.isUndefinedOrNull(result)) {
                    component.set("v.selectedLookUpRecord", result);
                    var cmp = component.find("lookupComp");
                    cmp.set('v.SearchKeyWord', result.Name);
                }
            }
            
        });
        $A.enqueueAction(action);
        //} 
    },
    showToast: function(cmp, title, message, type) {
        cmp.set("v.errormsg", message);
        cmp.set("v.title", title);
        //---- Setting up severity ----//
        if (type == 'info') {
            cmp.set("v.type", '');
            cmp.set("v.icon", 'utility:info');
        } else if (type == 'warning') {
            cmp.set("v.type", 'slds-theme--error');
            cmp.set("v.icon", 'utility:warning');
        } else if (type == 'error') {
            cmp.set("v.type", 'slds-theme--error');
            cmp.set("v.icon", 'utility:error');
        } else if (type == 'success') {
            cmp.set("v.type", 'slds-theme--success');
            cmp.set("v.icon", 'utility:success');
        }
        cmp.set("v.errormsg", message);
        window.setTimeout(function() {
            cmp.set("v.errormsg", '');
        }, 3000);
    },
    SaveOrder: function(component, event) {
        debugger;
        
        
        
        var accountId = component.get("v.selectedLookUpRecord");
        var orderStartDateField = component.find("orderStartDate");
        var orderStartDateValue = orderStartDateField.get("v.value");
        
        if ($A.util.isUndefinedOrNull(accountId) || accountId == '') {
            this.showToast(component, 'ERROR', "Account cannot be blank .", 'error');
        } else if ($A.util.isEmpty(orderStartDateValue) && $A.util.isUndefined(orderStartDateValue)) {
            orderStartDateField.set("v.errors", [{
                message: "Order Start Date is mandatory ."
            }]);
            //this.showToast(component, 'ERROR', "Order Start Date is mandatory .", 'error');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "An Error Occured.. !",
                "message": "Order Start Date is mandatory .",
                "type" : 'error'
            });
            toastEvent.fire(); 
        } else {
            orderStartDateField.set("v.errors", null);
            component.set("v.orderObj.AccountId", component.get("v.selectedLookUpRecord.Id"));
            var objOrder = component.get("v.orderObj");
            
            this.waiting();
            var action = component.get("c.saveOrder");
            
            action.setParams({
                "objOrder": objOrder
            });
            action.setCallback(this, function(actionresult) {
                var state = actionresult.getState();
                if (state === "SUCCESS") {
                    var result = actionresult.getReturnValue();
                }
                if (result.indexOf("801") > -1) {
                    //this.showToast(component, 'SUCCESS', 'Order Successfully Created', 'success');
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: "Order successfully created!",
                        type: 'success'
                        
                    });
                    toastEvent.fire();
                    
                    this.navigate(component, event, result);
                } else {
                    var errorvalue = result.indexOf('Error:');
                    if (errorvalue != -1) {
                        if (result.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION")) {
                            var stringtoDisplay = result.match("FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*):");
                            
                            //this.showToast(component, 'ERROR', String(stringtoDisplay[1]), 'error');
                            var toastEvent = $A.get("e.force:showToast")
                            toastEvent.setParams({
                                message: String(stringtoDisplay[1]),
                                type: 'error'
                            });
                            toastEvent.fire();
                        } else {
                            var genericErrormsg = "An error has occurred.Please contact your system administrator if this problem persists.";
                            //this.showToast(component, 'ERROR', genericErrormsg, 'error');
                            var toastEvent = $A.get("e.force:showToast")
                            toastEvent.setParams({
                                message: "An error has occurred.Please contact your system administrator if this problem persists.",
                                type: 'error'
                            });
                            toastEvent.fire();
                        }
                    }
                }
                this.doneWaiting();
            });
            $A.enqueueAction(action);
        }
        
    },
    
    navigate: function(component, event, recId) {
        debugger;
        if ($A.get("$Browser.formFactor") == 'DESKTOP')
        {
            if (recId.indexOf("801") > -1) {
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/order/' + recId
                });
                urlEvent.fire();
            }
        }
        else
        {
            if (recId.indexOf("801") > -1) { //Note 500 is prefix for Case Record
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + recId
                });
                urlEvent.fire();
            }
        }
        
    }, 
    waiting: function() {
        if (!$A.util.isUndefinedOrNull(document.getElementById("ORDER_PAGE_MOBILE"))) {
            document.getElementById("ORDER_PAGE_MOBILE").style.display = "block";
        }
    },
    doneWaiting: function() {
        
        
        if (!$A.util.isUndefinedOrNull(document.getElementById("ORDER_PAGE_MOBILE"))) {
            document.getElementById("ORDER_PAGE_MOBILE").style.display = "none";
        }
        
    },
    showToast: function (component,event,sErrorMsg){
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "An Error Occured.. !",
            "message": sErrorMsg,
            "type" : 'error'
            
        });
        toastEvent.fire(); 
    }
})