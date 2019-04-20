({
    doInitHelper: function(component, event, helper) {
        var action = component.get("c.getPicklists");
        component.set("v.showSpinner", true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (!$A.util.isUndefinedOrNull(response)) {
                    if (!$A.util.isUndefinedOrNull(response.lstAccounts)) {

                        component.set("v.lstAccount", response.lstAccounts);

                    } else {
                        component.set("v.isAccountPicklistVisible", true);
                    }
                    if (!$A.util.isUndefinedOrNull(response.lstConfigs)) {

                        component.set("v.configs", response.lstConfigs);

                    } else {
                        component.set("v.isPicklistVisible", true);
                    }
                } else {
                    component.set("v.isAccountPicklistVisible", true);
                    component.set("v.isPicklistVisible", true);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getGroups: function(component, event, helper) {
        var acc = component.get("v.lstAccount")[component.get("v.acctId")];

        if (!$A.util.isUndefinedOrNull(acc)) {
            component.set("v.isGroupPicklistVisible", false);

            var action = component.get("c.getBLISgroups");
            component.set("v.showSpinner", true);
            action.setParams({
                "strDealerID": acc.Id
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("v.lstGroups", []);
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();

                    if (!$A.util.isUndefinedOrNull(response)) {
                        component.set("v.lstGroups", response);
                    } else {
                        component.set("v.isGroupPicklistVisible", true);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);

        } else {
            component.set("v.lstGroups", []);
            component.set("v.isGroupPicklistVisible", true);
        }
    },
    getBranches: function(component, event, helper) {
        var acc = component.get("v.lstAccount")[component.get("v.acctId")];

        if (!$A.util.isUndefinedOrNull(acc)) {
            component.set("v.isBranchAccountPicklistVisible", false);
            var action = component.get("c.getbranches");
            component.set("v.showSpinner", true);
            action.setParams({
                "strDealerID": acc.Id
            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("v.lstBranchAccount", []);
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (!$A.util.isUndefinedOrNull(response)) {
                        component.set("v.lstBranchAccount", response);
                    } else {
                        component.set("v.isBranchAccountPicklistVisible", true);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.lstBranchAccount", []);
            component.set("v.isBranchAccountPicklistVisible", true);
        }
    },
    getBLISData: function(component, event, helper) {
        var group = component.get("v.lstGroups")[component.get("v.groupID")];
        var config = component.get("v.configs")[component.get("v.configFY")];
        var branch = component.get("v.lstBranchAccount")[component.get("v.branchID")];
        var process = 0;
        if ($A.util.isUndefinedOrNull(group) && $A.util.isUndefinedOrNull(branch)) {

            process = 1;

            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "ERROR!",
                "mode": "",
                "type": "error",
                "message": "please select a BLIS group or a branch."
            });

            toastEvent.fire();
        }
        console.log(group);
        if (!$A.util.isUndefinedOrNull(group) && !$A.util.isUndefinedOrNull(branch)) {

            process = 1;
            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "ERROR!",
                "mode": "",
                "type": "error",
                "message": "BLIS Group and branch cannot be selected at same time ."
            });

            toastEvent.fire();
        }

        if ($A.util.isUndefinedOrNull(config)) {
            process = 1;
            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "ERROR!",
                "mode": "",
                "type": "error",
                "message": "please select a Financial year ."
            });

            toastEvent.fire();
        }
        if (process == 0) {
            if ((!$A.util.isUndefinedOrNull(group) || !$A.util.isUndefinedOrNull(branch)) &&
                !$A.util.isUndefinedOrNull(config)) {
                component.set("v.showBLISTable", true);




                var action = component.get("c.getData");
                component.set("v.showSpinner", true);

                if (!$A.util.isUndefinedOrNull(group) && $A.util.isUndefinedOrNull(branch)) {
                    action.setParams({
                        "strBlisGroupID": group.Id,
                        "strConfig": config.VCPL_Fiscal_Year__c,
                        "strBranchID": null
                    });
                }
                if (!$A.util.isUndefinedOrNull(branch) && $A.util.isUndefinedOrNull(group)) {
                    action.setParams({
                        "strBranchID": branch.Id,
                        "strConfig": config.VCPL_Fiscal_Year__c,
                        "strBlisGroupID": null
                    });
                }
                action.setCallback(this, function(response) {
                    var state = response.getState();

                    if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        if (!$A.util.isUndefinedOrNull(result)) {
                            component.set("v.DetailsWrapper", result);
                        }
                    }
                    component.set("v.showSpinner", false);
                });
                $A.enqueueAction(action);
            } else {
                component.set("v.showBLISTable", false);
            }
        }
    }
})