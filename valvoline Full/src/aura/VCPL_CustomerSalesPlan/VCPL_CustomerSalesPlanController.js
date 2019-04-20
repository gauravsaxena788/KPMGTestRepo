({
    doInit: function(component, event, helper) {
        helper.getDetailsWrapper(component, event, helper);
    },
    onChangeofAccountController: function(component, event, helper) {
        helper.onChangeofAccount(component, event, helper);
    },
    saveController: function(component, event, helper) {
        helper.saveOpportunity(component, event, helper);
    },
    closeToast: function(component, event, helper) {
        component.set('v.errormsg', "");
    },
    refreshView: function(component, event, helper) {
        component.callDoinit();
    },
    doInitonSaveButtonClick: function(component, event, helper) {
        var selectedValue = component.find("accountName").get("v.value");

        if ($A.util.isUndefinedOrNull(selectedValue)) {
            component.callDoinit();
        } else {
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
                    }
                }
            });
            $A.enqueueAction(action);
        }
    }
})