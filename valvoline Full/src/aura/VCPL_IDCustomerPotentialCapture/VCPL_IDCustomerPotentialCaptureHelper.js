({
    getDetailsWrapper: function(component, event, helper) {
        var action = component.get("c.getDetails");
        this.waiting();
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.basicDetails", response);

                    if (!$A.util.isUndefinedOrNull(response.strFinancialYear)) {
                        var recordID = component.get("v.recordId");

                        var action = component.get("c.getData");
                        this.waiting();
                        if (!$A.util.isUndefinedOrNull(recordID)) {
                            action.setParams({
                                "strFinancialYear": response.strFinancialYear,
                                "strAccountID": recordID
                            });

                            action.setCallback(this, function(response) {
                                var state = response.getState();

                                if (state === "SUCCESS") {
                                    var response = response.getReturnValue();

                                    if (!$A.util.isUndefinedOrNull(response)) {
                                        component.set("v.DetailsWrapper", response);
                                    }
                                }
                                this.doneWaiting();
                            });
                            $A.enqueueAction(action);
                        }
                    }
                }
            }
            this.doneWaiting();
        });
        $A.enqueueAction(action);
    },
    waiting: function() {
        if (!$A.util.isUndefinedOrNull(document.getElementById("CUSTOMER_SALES_ID_POTENTIAL"))) {
            document.getElementById("CUSTOMER_SALES_ID_POTENTIAL").style.display = "block";
        }
    },
    doneWaiting: function() {
        if (!$A.util.isUndefinedOrNull(document.getElementById("CUSTOMER_SALES_ID_POTENTIAL"))) {
            document.getElementById("CUSTOMER_SALES_ID_POTENTIAL").style.display = "none";
        }
    },
    savePotential: function(component, event, helper) {
        var strReasult = component.get("v.DetailsWrapper");

        if (!$A.util.isUndefinedOrNull(strReasult)) {

            if (strReasult.samplePH6Potentialvalue1 < 0 || strReasult.samplePH6Potentialvalue2 < 0 ||
                strReasult.samplePH6Potentialvalue3 < 0 || strReasult.samplePH6Potentialvalue4 < 0 || 
                strReasult.samplePH6Potentialvalue5 < 0 || strReasult.samplePH6Potentialvalue6 < 0 || 
                strReasult.samplePH6Potentialvalue7 < 0) {
            
            	this.showToast(component, 'ERROR', 'Entered Potential values should not be a negative number .', 'error');
            } else {
                var action = component.get("c.savePotential");
                this.waiting();
                action.setParams({
                    "strResponse": JSON.stringify(strReasult)
                });

                action.setCallback(this, function(response) {
                    var state = response.getState();

                    if (state === "SUCCESS") {
                        var response = response.getReturnValue();

                        if (!$A.util.isUndefinedOrNull(response)) {
                            if (response === "Processed successfully") {

                                this.showToast(component, 'SUCCESS', 'Processed successfully', 'success');
                                $A.get('e.force:refreshView').fire();
                                component.callDoinit();
                                $A.get("e.force:closeQuickAction").fire();
                            }
                        }
                    }
                    this.doneWaiting();
                });
                $A.enqueueAction(action);
            }
        }
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
    }
})