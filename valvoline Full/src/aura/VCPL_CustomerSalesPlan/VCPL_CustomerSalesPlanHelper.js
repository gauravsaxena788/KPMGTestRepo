({
    getDetailsWrapper: function(component, event, helper) {
        var action = component.get("c.getDetails");
        var recordID = component.get("v.recordId");
        if (recordID == "") {

            action.setParams({
                "strAccountID": null
            });
        } else {
            action.setParams({
                "strAccountID": recordID
            });
        }
        component.set("v.showSpinner", true);
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.basicDetails", response);

                    if (!$A.util.isUndefinedOrNull(response.lstAccountNames)) {
                        if (response.lstAccountNames.length == 1) {
                            component.set("v.isAccountPicklistVisible", true);
                        } else {
                            component.set("v.isAccountPicklistVisible", false);
                        }
                        var action = component.get("c.getOpportunityWrapper");
                        if (recordID == "") {
                            action.setParams({
                                "strAccount": response.lstAccountNames[0],
                                "parentAccountID": null
                            });
                        } else {
                            action.setParams({
                                "strAccount": response.lstAccountNames[0],
                                "parentAccountID": recordID
                            });
                        }
                        action.setCallback(this, function(actionresult) {
                            var state = actionresult.getState();

                            if (state === "SUCCESS") {
                                var opportunityResponse = actionresult.getReturnValue();
                                if (!$A.util.isUndefinedOrNull(opportunityResponse)) {
                                    component.set("v.lstOpportunityWrapper", opportunityResponse);

                                    var getAllOpportunities = component.get("v.lstOpportunityWrapper");
                                    var countisDisable = 0;
                                    var countisDisabledPlannedSales = 0;
                                    for (var i = 0; i < getAllOpportunities.length; i++) {
                                        if (getAllOpportunities[i].isDisable == true) {
                                            countisDisable += 1;
                                        }
                                        if (getAllOpportunities[i].isDisablePlannedSales == true) {
                                            countisDisabledPlannedSales += 1;
                                        }

                                    }
                                    if (countisDisable == getAllOpportunities.length && countisDisabledPlannedSales == getAllOpportunities.length) {
                                        component.set("v.showButtons", false);
                                    } else {
                                        component.set("v.showButtons", true);
                                    }
                                }
                            }
                            component.set("v.showSpinner", false);
                        });
                        $A.enqueueAction(action);
                    } else {
                        component.set("v.showButtons", false);
                        component.set("v.isAccountPicklistVisible", true);
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    onChangeofAccount: function(component, event, helper) {
        var selectedValue = component.find("accountName").get("v.value");

        var recordID = component.get("v.recordId");
        var action = component.get("c.getOpportunityWrapper");
        component.set("v.showSpinner", true);
        if (recordID == "") {
            action.setParams({
                "strAccount": selectedValue,
                "parentAccountID": null
            });
        } else {
            action.setParams({
                "strAccount": selectedValue,
                "parentAccountID": recordID
            });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var opportunityResponse = response.getReturnValue();
                console.log(JSON.stringify(opportunityResponse));

                if (!$A.util.isUndefinedOrNull(opportunityResponse)) {
                    component.set("v.lstOpportunityWrapper", opportunityResponse);
                    var getAllOpportunities = component.get("v.lstOpportunityWrapper");
                    var countisDisable = 0;
                    var countisDisabledPlannedSales = 0;
                    for (var i = 0; i < getAllOpportunities.length; i++) {
                        if (getAllOpportunities[i].isDisable == true) {
                            countisDisable += 1;
                        }
                        if (getAllOpportunities[i].isDisablePlannedSales == true) {
                            countisDisabledPlannedSales += 1;
                        }

                    }
                    if (countisDisable == getAllOpportunities.length && countisDisabledPlannedSales == getAllOpportunities.length) {
                        component.set("v.showButtons", false);
                    } else {
                        component.set("v.showButtons", true);
                    }
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    saveOpportunity: function(component, event, helper) {
        var wrapper = component.get("v.lstOpportunityWrapper");
        console.log(JSON.stringify(wrapper));

        if (!$A.util.isUndefinedOrNull(wrapper)) {
            var countNegativePlannedSales = 0;
            var countNegativeLatestEstSales = 0;

            for (var i = 0; i < wrapper.length; i++) {
                if (wrapper[i].plannedSales < 0)
                    countNegativePlannedSales += 1;
                if (wrapper[i].latestEstimatedSales < 0)
                    countNegativeLatestEstSales += 1;
            }
            if (countNegativePlannedSales > 0 || countNegativeLatestEstSales > 0) {
                this.showToast(component, 'ERROR', 'Entered sales values should not be a negative number .', 'error');
            } else {
                var action = component.get("c.saveOpportunity");
                component.set("v.showSpinner", true);
                action.setParams({
                    "strResponse": JSON.stringify(wrapper)
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();

                    if (state === "SUCCESS") {
                        var response = response.getReturnValue();

                        if (!$A.util.isUndefinedOrNull(response)) {
                            if (response === "Processed successfully") {

                                //this.showToast(component, 'SUCCESS', 'Processed successfully', 'success');
                                /////////////////
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "SUCCESS!",
                                    "mode": "",
                                    "type": "success",
                                    "message": "Processed successfully"
                                });
                                toastEvent.fire();
                                ////////
                                var selectedValue = component.find("accountName").get("v.value");

                                if (!$A.util.isUndefinedOrNull(selectedValue)) {
                                    var recordID = component.get("v.recordId");

                                    var action = component.get("c.getOpportunityWrapper");

                                    if (recordID == "") {
                                        action.setParams({
                                            "strAccount": selectedValue,
                                            "parentAccountID": null
                                        });
                                    } else {
                                        action.setParams({
                                            "strAccount": selectedValue,
                                            "parentAccountID": recordID
                                        });
                                    }
                                    action.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if (state === "SUCCESS") {
                                            var opportunityResponse = response.getReturnValue();

                                            if (!$A.util.isUndefinedOrNull(opportunityResponse)) {
                                                debugger;
                                                component.set("v.lstOpportunityWrapper", opportunityResponse);
                                                var getAllOpportunities = component.get("v.lstOpportunityWrapper");
                                                var countisDisable = 0;
                                                var countisDisabledPlannedSales = 0;
                                                for (var i = 0; i < getAllOpportunities.length; i++) {
                                                    if (getAllOpportunities[i].isDisable == true) {
                                                        countisDisable += 1;
                                                    }
                                                    if (getAllOpportunities[i].isDisablePlannedSales == true) {
                                                        countisDisabledPlannedSales += 1;
                                                    }

                                                }
                                                if (countisDisable == getAllOpportunities.length && countisDisabledPlannedSales == getAllOpportunities.length) {
                                                    component.set("v.showButtons", false);
                                                } else {
                                                    component.set("v.showButtons", true);
                                                }
                                            }
                                        }
                                    });
                                    $A.enqueueAction(action);
                                } else {
                                    component.callDoinit();
                                }
                            }
                        }
                    }
                    component.set("v.showSpinner", false);
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