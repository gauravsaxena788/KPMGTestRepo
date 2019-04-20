({
    getData: function(component, event, helper) {
        var recordID = component.get("v.recordId");
        var action = component.get("c.getBranches");

        if ($A.util.isUndefinedOrNull(recordID) || recordID == "") {
            action.setParams({
                "strCDealerAccountID": null
            });
        } else {
            action.setParams({
                "strCDealerAccountID": recordID
            });
        }
        component.set("v.showSpinner", true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (!$A.util.isUndefinedOrNull(response)) {
                    if (!$A.util.isUndefinedOrNull(response)) {
                        if (response.length > 1) {
                            component.set("v.isBranchPicklistVisible", false);
                        } else {

                            component.set("v.isBranchPicklistVisible", true);
                        }
                    }

                    component.set("v.lstAccounts", response);

                    if (!$A.util.isUndefinedOrNull(response[0].Id)) {
                        var action = component.get("c.getData");
                        component.set("v.showSpinner", true);

                        if (recordID == "") {
                            action.setParams({
                                "strBranchID": response[0].Id,
                                "parentID": null
                            });
                        } else {
                            action.setParams({
                                "strBranchID": response[0].Id,
                                "parentID": recordID
                            });
                        }

                        action.setCallback(this, function(response) {
                            var state = response.getState();

                            if (state === "SUCCESS") {
                                var response = response.getReturnValue();
                                debugger;
                                if (!$A.util.isUndefinedOrNull(response)) {
                                    component.set("v.dataWrapper", response);
                                    component.set("v.dataWrapperReference", response);
                                    component.set("v.showButtons", true);
                                    component.set("v.maxPage", Math.floor((response.length + 19) / 20));
                                    component.set("v.pageNumber", "1");
                                    this.renderPage(component);
                                } else {
                                    component.set("v.showButtons", false);
                                    component.set("v.dataWrapper", null);
                                    component.set("v.dataWrapperReference", null);
                                    component.set("v.paginationWrapper", null);
                                }
                            }
                            component.set("v.showSpinner", false);
                        });
                        $A.enqueueAction(action);
                    }
                } else {
                    component.set("v.isBranchPicklistVisible", true);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    renderPage: function(component) {
        var records = component.get("v.dataWrapper");
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber - 1) * 20, pageNumber * 20);
        component.set("v.paginationWrapper", pageRecords);

        if (!$A.util.isUndefinedOrNull(pageNumber) && pageNumber == 1) {
            component.set("v.disableFirstButton", true);
            component.set("v.disablePrevButton", true);
        } else if (!$A.util.isUndefinedOrNull(pageNumber) && pageNumber > 1) {
            component.set("v.disableFirstButton", false);
            component.set("v.disablePrevButton", false);
        }

        var maxpage = component.get("v.maxPage");

        if (!$A.util.isUndefinedOrNull(maxpage) && !$A.util.isUndefinedOrNull(pageNumber) && maxpage == pageNumber) {
            component.set("v.disableNextButton", true);
            component.set("v.disableLastButton", true);
        } else if (!$A.util.isUndefinedOrNull(maxpage) && !$A.util.isUndefinedOrNull(pageNumber) && maxpage != pageNumber) {
            component.set("v.disableNextButton", false);
            component.set("v.disableLastButton", false);
        }

    },
    sortListForField: function(component, dataWrapperReference, fieldNameToSort, isAscending) {
        dataWrapperReference = dataWrapperReference || [];
        dataWrapperReference.sort(function(option1, option2) {
            if (!$A.util.isEmpty(option1) && !$A.util.isEmpty(option1[fieldNameToSort]) && !$A.util.isEmpty(option2) && !$A.util.isEmpty(option2[fieldNameToSort])) {
                return isAscending == 'true' ? (option1[fieldNameToSort] - option2[fieldNameToSort]) : (option2[fieldNameToSort] - option1[fieldNameToSort]);
            } else {
                return 0;
            }
        });
        component.set("v.dataWrapperReference", dataWrapperReference);
        var sortingOrder = component.get("v.sortingOrder") || {};
        sortingOrder[fieldNameToSort] = isAscending == 'true' ? false : true;
        component.set("v.sortingOrder", sortingOrder);
        component.set("v.sortingOrderLYVolume", component.get("v.sortingOrder").lastYearVolume);
        component.set("v.sortingOrderPD", component.get("v.sortingOrder").potentialLYDifference);
        component.set("v.sortingOrderLYP", component.get("v.sortingOrder").potential);
    },
    filterList: function(component, event, helper) {
        var selectedValue = component.find("ClassificationFilter").get("v.value");
        var searchValue = component.get("v.searchString");

        var records = component.get("v.dataWrapperReference");

        if (!$A.util.isUndefinedOrNull(records)) {
            var action = component.get("c.getFilteredValues");
            component.set("v.showSpinner", true);

            action.setParams({
                "selectedClassification": selectedValue,
                "strResponse": JSON.stringify(records),
                "strSearchString": searchValue
            });

            action.setCallback(this, function(response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    var response = response.getReturnValue();

                    if (!$A.util.isUndefinedOrNull(response)) {
                        component.set("v.showButtons", true);
                        component.set("v.dataWrapper", response);
                        component.set("v.maxPage", Math.floor((response.length + 19) / 20));
                        component.set("v.pageNumber", 1);
                        this.renderPage(component);
                    } else {
                        component.set("v.dataWrapper", []);
                        this.renderPage(component);
                        component.set("v.showButtons", false);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },
    onChangeofBranch: function(component, event, helper) {
        var sortingOrder = {
            'lastYearVolume': true,
            'potentialLYDifference': true
        };
        component.set("v.sortingOrder", sortingOrder);
        var acc = component.get("v.lstAccounts")[component.get("v.acctId")];
        var accID = acc.Id;

        if (!$A.util.isUndefinedOrNull(accID)) {
            var recordID = component.get("v.recordId");
            var action = component.get("c.getData");
            component.set("v.showSpinner", true);

            if (recordID == "") {
                action.setParams({
                    "strBranchID": accID,
                    "parentID": null
                });
            } else {
                action.setParams({
                    "strBranchID": accID,
                    "parentID": recordID
                });
            }
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();

                    if (!$A.util.isUndefinedOrNull(response)) {
                        component.set("v.dataWrapper", response);
                        component.set("v.dataWrapperReference", response);
                        component.set("v.showButtons", true);
                        component.set("v.maxPage", Math.floor((response.length + 19) / 20));
                        component.set("v.pageNumber", "1");
                        this.renderPage(component);
                    } else {
                        component.set("v.showButtons", false);
                        component.set("v.dataWrapper", null);
                        component.set("v.dataWrapperReference", null);
                        component.set("v.paginationWrapper", null);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },
    saveData: function(component, event, helper) {
        var recordToSave = component.get("v.paginationWrapper");

        if (!$A.util.isUndefinedOrNull(recordToSave)) {
            var action = component.get("c.saveData");
            component.set("v.showSpinner", true);
            action.setParams({
                "strResponse": JSON.stringify(recordToSave)
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var response = response.getReturnValue();
                    if (response == "Processed") {
                        var toastEvent = $A.get("e.force:showToast");

                        toastEvent.setParams({
                            "title": "SUCCESS!",
                            "mode": "",
                            "type": "success",
                            "message": "Processed Successfully."
                        });

                        toastEvent.fire();

                        var acc = component.get("v.lstAccounts")[component.get("v.acctId")];
                        var accID;

                        if ($A.util.isUndefinedOrNull(acc)) {
                            var branch = component.get("v.lstAccounts");

                            accID = branch[0].Id;
                        } else {
                            accID = acc.Id;
                        }

                        if (!$A.util.isUndefinedOrNull(accID)) {
                            var recordID = component.get("v.recordId");
                            var action = component.get("c.getData");
                            component.set("v.showSpinner", true);

                            if (recordID == "") {
                                action.setParams({
                                    "strBranchID": accID,
                                    "parentID": null
                                });
                            } else {
                                action.setParams({
                                    "strBranchID": accID,
                                    "parentID": recordID
                                });
                            }
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    var response = response.getReturnValue();
                                    if (!$A.util.isUndefinedOrNull(response)) {
                                        component.set("v.dataWrapper", response);
                                        component.set("v.dataWrapperReference", response);
                                        component.set("v.showButtons", true);
                                        component.set("v.maxPage", Math.floor((response.length + 19) / 20));

                                        this.renderPage(component);
                                    } else {
                                        component.set("v.showButtons", false);
                                        component.set("v.dataWrapper", null);
                                        component.set("v.dataWrapperReference", null);
                                        component.set("v.paginationWrapper", null);
                                    }
                                }
                                component.set("v.showSpinner", false);
                            });
                            $A.enqueueAction(action);
                        }
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    }
})