({
    getAccountName: function(component, event) {
        console.log("In VA_createOrdPgCmp-->H-->getAccName-->showtstpg-->"+component.get("v.showTestPage"));
        //console.log("In VA_createOrdPgCmp-->H-->getAccName-->showtstpg-->"+component.get("v.showTestPage"));
       // console.log('VAL of showtstpg in createOrdPg-->init-->'+component.get("v.showTestPage"));
        var childAccId = component.get("v.passedChildAccId");
        console.log("In VA_createOrdPgCmp-->H-->getAccName-->passedID-->"+childAccId);
        if(! $A.util.isUndefinedOrNull(childAccId)){
             this.getAccountName2(component,event);
        }else{
            var action = component.get("c.getAccountNameMethod");
            action.setCallback(this, function(actionresult) {
                
                var state = actionresult.getState();
                if (state === "SUCCESS") {
                    var result = actionresult.getReturnValue();
                  
                    if (!$A.util.isUndefinedOrNull(result)) {
                        component.set("v.selectedLookUpRecord", result);
                        var cmp = component.find("lookupComp");
                        cmp.set('v.SearchKeyWord', result.Name);
                    }
                }
                
            });
            $A.enqueueAction(action);

        }

       
        //} 
    },

    getAccountName2 : function(component,event) {
        var action=component.get("c.getAccountNameMethod2");
        action.setParams({
            "accId": component.get("v.passedChildAccId")
        });
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.selectedLookUpRecord",result);
                    console.log("In VA_createOrdPgCmp-->H-->getAccName2-->ret val from Apex-->"+JSON.stringify(result));
                    var cmp = component.find("lookupComp");
                    cmp.set('v.SearchKeyWord',result.Name);
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
 
        
        
        
        var accountId = component.get("v.selectedLookUpRecord");
        var orderStartDateField = component.find("orderStartDate");
        var orderStartDateValue = orderStartDateField.get("v.value");
        
        if ($A.util.isUndefinedOrNull(accountId) || accountId == '') {
            this.showToast(component, 'ERROR', "Account cannot be blank .", 'error');
        } else if ($A.util.isEmpty(orderStartDateValue) && $A.util.isUndefined(orderStartDateValue)) {
            orderStartDateField.set("v.errors", [{
                message: "Order Start Date is mandatory ."
            }]);
            this.showToast(component, 'ERROR', "Order Start Date is mandatory .", 'error');
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
                    this.showToast(component, 'SUCCESS', 'Order Successfully Created', 'success');
                    this.navigate(component, event, result);
                } else {
                    var errorvalue = result.indexOf('Error:');
                    if (errorvalue != -1) {
                        if (result.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION")) {
                            var stringtoDisplay = result.match("FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*):");
                            
                            this.showToast(component, 'ERROR', String(stringtoDisplay[1]), 'error');
                        } else {
                            var genericErrormsg = "An error has occurred.Please contact your system administrator if this problem persists.";
                            this.showToast(component, 'ERROR', genericErrormsg, 'error');
                        }
                    }
                }
                this.doneWaiting();
            });
            $A.enqueueAction(action);
        }
        
    },
    requiredFields: function(component, event, helper) {
        var orderStartDateField = component.find("orderStartDate");
        var orderStartDateValue = orderStartDateField.get("v.value");
        var accountId = component.get("v.selectedLookUpRecord");
        debugger;
        if ($A.util.isUndefinedOrNull(accountId) || accountId == '') {
            component.set("v.RequiredField", true);
            orderStartDateField.set("v.errors", null);
        } else if (!$A.util.isEmpty(orderStartDateValue) && !$A.util.isUndefined(orderStartDateValue)) {
            orderStartDateField.set("v.errors", [{
                message: "Order Start Date is mandatory ."
            }]);
            component.set("v.RequiredField", true);
        } else {
            orderStartDateField.set("v.errors", null);
            component.set("v.RequiredField", false);
        }
    },
    navigate: function(component, event, recId) {
        
        if (recId.indexOf("801") > -1) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/order/' + recId
            });
            urlEvent.fire();
        }
        
    },
    waiting: function() {
        if (!$A.util.isUndefinedOrNull(document.getElementById("ORDER_PAGE"))) {
            document.getElementById("ORDER_PAGE").style.display = "block";
        }
    },
    doneWaiting: function() {
        
        
        if (!$A.util.isUndefinedOrNull(document.getElementById("ORDER_PAGE"))) {
            document.getElementById("ORDER_PAGE").style.display = "none";
        }
        
    }
})