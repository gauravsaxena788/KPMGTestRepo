({
    getDetailsWrapper: function(component, event, helper) {

        var action = component.get("c.getDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                component.set("v.basicDetails", response);
            }
        });
        $A.enqueueAction(action);
    },
    getOpportunityWrapper: function(component, event, helper) {
        var recordID = component.get("v.recordId");

        var todayDate = new Date();
        var month = new Array();
        month[0] = "January";
        month[1] = "February";
        month[2] = "March";
        month[3] = "April";
        month[4] = "May";
        month[5] = "June";
        month[6] = "July";
        month[7] = "August";
        month[8] = "September";
        month[9] = "October";
        month[10] = "November";
        month[11] = "December";
        var currentMonth = month[todayDate.getMonth()];

        var action = component.get("c.getData");
		component.set("v.showSpinner_Sales_capture", true);
        if (recordID == "" || $A.util.isUndefinedOrNull(recordID)) {
            action.setParams({
                "strMonth": currentMonth,
                "strAccountID": null
            });
        } else {
            action.setParams({
                "strMonth": currentMonth,
                "strAccountID": recordID
            });
        }

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.lstOpportunityWrapper", response);
                    component.set("v.lstOpportunityWrapper2", response);
                    component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                    var getAllOpportunities = component.get("v.lstOpportunityWrapper");
                    console.log(JSON.stringify(getAllOpportunities));
                    this.renderPage(component);
                    component.set("v.showButtons", true);

                } else {
                    component.set("v.showButtons", false);
                }
            }
            component.set("v.showSpinner_Sales_capture", false);

        });
        $A.enqueueAction(action);
    },
    renderPage: function(component) {
        var records = component.get("v.lstOpportunityWrapper");
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber - 1) * 10, pageNumber * 10);
        component.set("v.paginationOpportunityWrapper", pageRecords);

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
    onChangeofMonthHelper: function(component, event, helper) {
        var recordID = component.get("v.recordId");
        component.set("v.searchString", "");
        var month = component.find("month").get("v.value");

        component.set("v.showSpinner_Sales_capture", true);
        var action = component.get("c.getData");

        if (recordID == "" || $A.util.isUndefinedOrNull(recordID)) {
            action.setParams({
                "strMonth": month,
                "strAccountID": null
            });
        } else {
            action.setParams({
                "strMonth": month,
                "strAccountID": recordID
            });
        }
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.lstOpportunityWrapper", response);
                    component.set("v.lstOpportunityWrapper2", response);

                    var getAllOpportunities = component.get("v.lstOpportunityWrapper2");

                    if (!$A.util.isUndefinedOrNull(getAllOpportunities)) {
                        var countDisableSales = 0;
                        var countDisablePotential = 0;

                        for (var i = 0; i < getAllOpportunities.length; i++) {
                            if (getAllOpportunities[i].isDisableSamplePH6value == true) {
                                countDisableSales += 1;
                            }
                            if (getAllOpportunities[i].isDisablepotential == true) {
                                countDisablePotential += 1;
                            }
                        }
                        console.log(countDisableSales);
                        console.log(countDisablePotential);

                        if (countDisableSales == getAllOpportunities.length) {
                            component.set("v.showButtons", false);
                        } else {
                            component.set("v.showButtons", true);
                        }
                    }
                    component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                    component.set("v.pageNumber", "1");
                    this.renderPage(component);
                } else {
                    component.set("v.showButtons", false);
                    component.set("v.lstOpportunityWrapper", null);
                    component.set("v.paginationOpportunityWrapper", null);
                }
            }
            component.set("v.showSpinner_Sales_capture", false);
        });
        $A.enqueueAction(action);
    },

    saveOpportunity: function(component, event, helper) {
        var opportunityList = component.get("v.paginationOpportunityWrapper");

        if (!$A.util.isUndefinedOrNull(opportunityList)) {

            var countNegativePh61 = 0;
            var countNegativePh62 = 0;
            var countNegativePh63 = 0;
            var countNegativePh64 = 0;
            var countNegativePh65 = 0;
            var countNegativePh66 = 0;
            var countNegativePh67 = 0;
            for (var i = 0; i < opportunityList.length; i++) {
                if (opportunityList[i].samplePH6value1 < 0) {
                    countNegativePh61 += 1;
                }
                if (opportunityList[i].samplePH6value2 < 0) {
                    countNegativePh62 += 1;
                }
                if (opportunityList[i].samplePH6value3 < 0) {
                    countNegativePh63 += 1;
                }
                if (opportunityList[i].samplePH6value4 < 0) {
                    countNegativePh64 += 1;
                }
                if (opportunityList[i].samplePH6value5 < 0) {
                    countNegativePh65 += 1;
                }
                if (opportunityList[i].samplePH6value6 < 0) {
                    countNegativePh66 += 1;
                }
                if (opportunityList[i].samplePH6value7 < 0) {
                    countNegativePh67 += 1;
                }
            }

            if (countNegativePh61 > 0 || countNegativePh62 > 0 || countNegativePh63 > 0 || countNegativePh64 > 0 ||
                countNegativePh65 > 0 || countNegativePh66 > 0 || countNegativePh67 > 0) {
                this.showToast(component, 'ERROR', 'Entered sales values should not be a negative number .', 'error');
            } else {

                component.set("v.showSpinner_Sales_capture", true);
                var action = component.get("c.saveOpportunity");

                action.setParams({
                    "strResponse": JSON.stringify(opportunityList)
                });

                action.setCallback(this, function(response) {
                    var state = response.getState();

                    if (state === "SUCCESS") {
                        var response = response.getReturnValue();

                        if (response === "Processed successfully") {
                            //this.showToast(component, 'SUCCESS', 'Processed successfully', 'success');
                            ////////
                            var toastEvent = $A.get("e.force:showToast");

                            toastEvent.setParams({
                                "title": "SUCCESS!",
                                "mode": "",
                                "type": "success",
                                "message": "Processed successfully ."
                            });

                            toastEvent.fire();
                            ////////	
                        }
                    }
                    component.set("v.showSpinner_Sales_capture", false);
                });
                $A.enqueueAction(action);
            }
        }
    },
    searchUserHelper: function(component, searchString) {

        var records = component.get("v.lstOpportunityWrapper2");

        if (!$A.util.isUndefinedOrNull(records)) {
            component.set("v.showSpinner_Sales_capture", true);
            var action = component.get("c.getSearchResults");

            action.setParams({
                "strSearchString": searchString,
                "strResponse": JSON.stringify(records)
            });
            action.setCallback(this, function(response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    var response = response.getReturnValue();

                    if (!$A.util.isUndefinedOrNull(response)) {
                        component.set("v.showButtons", true);
                        component.set("v.lstOpportunityWrapper", response);
                        //////////////////////////////////////////
                        var getAllOpportunities = component.get("v.lstOpportunityWrapper");

                        var countDisableSales = 0;
                        for (var i = 0; i < getAllOpportunities.length; i++) {
                            if (getAllOpportunities[i].isDisableSamplePH6value == true) {
                                countDisableSales += 1;
                            }
                        }
                        if (countDisableSales == getAllOpportunities.length) {
                            component.set("v.showButtons", false);
                        } else {
                            component.set("v.showButtons", true);
                        }
                        //////////////////////////////////////////////
                        component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                        component.set("v.pageNumber", 1);
                        this.renderPage(component);
                    } else {
                        component.set("v.lstOpportunityWrapper", []);
                        this.renderPage(component);
                        component.set("v.showButtons", false);
                    }
                }
                component.set("v.showSpinner_Sales_capture", false);
            });
            $A.enqueueAction(action);
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