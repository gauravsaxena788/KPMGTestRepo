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
        component.set("v.showSpinner", true);
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
                console.log(JSON.stringify(response));
                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.lstOpportunityWrapper", response);
                    component.set("v.lstOpportunityReferenceWrapper", response);
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
                    component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                    this.renderPage(component);
                } else {
                    component.set("v.showButtons", false);
                }
            }
            component.set("v.showSpinner", false);


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



        var month = component.find("month").get("v.value");



        component.set("v.showSpinner", true);
        var action = component.get("c.getData");

        if ($A.util.isUndefinedOrNull(recordID)) {
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
                    component.set("v.lstOpportunityReferenceWrapper", response);
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
                    component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                    component.set("v.pageNumber", "1");
                    this.renderPage(component);
                } else {
                    component.set("v.showButtons", false);
                    component.set("v.lstOpportunityWrapper", null);
                    component.set("v.paginationOpportunityWrapper", null);
                }

            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    saveOpportunity: function(component, event, helper) {
        var opportunityList = component.get("v.paginationOpportunityWrapper");

        component.set("v.sameComponent", false);
        var countNegativePlannedSales = 0;
        var countNegativeLatestEstSales = 0;
        for (var i = 0; i < opportunityList.length; i++) {
            if (opportunityList[i].plannedSales < 0) {
                countNegativePlannedSales += 1;
            }
            if (opportunityList[i].latestEstimatedSales < 0) {
                countNegativeLatestEstSales += 1;
            }
        }
        if (countNegativePlannedSales > 0 || countNegativeLatestEstSales > 0) {


            /*var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "ERROR!",
                "mode": "",
                "type": "error",
                "message": "Entered sales values should not be a negative number ."
            });

            toastEvent.fire();*/
            this.showToast(component, 'ERROR', 'Entered sales values should not be a negative number .', 'error');

        } else {
            component.set("v.showSpinner", true);
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
                        var toastEvent = $A.get("e.force:showToast");

                        toastEvent.setParams({
                            "title": "SUCCESS!",
                            "mode": "",
                            "type": "success",
                            "message": "Processed successfully ."
                        });

                        toastEvent.fire();
                        /////////////////////////////////////////////////////////

                        /////////////////////////////////////////////////////////
                        var searchString = component.get("v.searchString");


                        if ($A.util.isUndefinedOrNull(searchString) || $A.util.isEmpty(searchString)) {
                            component.callDoinit();
                            var Selectedmonth = component.find("month").get("v.value");

                            /////
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
                            ////


                            if ($A.util.isUndefinedOrNull(Selectedmonth)) {
                                Selectedmonth = month[todayDate.getMonth()];
                            }

                            var action = component.get("c.getData");

                            var recordID = component.get("v.recordId");
                            debugger;
                            if ($A.util.isUndefinedOrNull(recordID)) {
                                action.setParams({
                                    "strMonth": Selectedmonth,
                                    "strAccountID": null
                                });
                            } else {
                                action.setParams({
                                    "strMonth": Selectedmonth,
                                    "strAccountID": recordID
                                });
                            }
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    var response = response.getReturnValue();

                                    if (!$A.util.isUndefinedOrNull(response)) {
                                        component.set("v.lstOpportunityWrapper", response);
                                        component.set("v.lstOpportunityReferenceWrapper", response);
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

                                        component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                                        //component.set("v.pageNumber", "1");
                                        this.renderPage(component);
                                    } else {
                                        component.set("v.lstOpportunityWrapper", null);
                                        component.set("v.lstOpportunityReferenceWrapper", null);
                                        component.set("v.paginationOpportunityWrapper", null);
                                    }

                                }
                            });
                            $A.enqueueAction(action);
                        }
                    }
                }
                component.set("v.showSpinner", false);
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
        }, 4000);
    },
    searchUserHelper: function(component, searchString) {
        var records = component.get("v.lstOpportunityReferenceWrapper");

        if (!$A.util.isUndefinedOrNull(records)) {
            component.set("v.showSpinner", true);
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
                        ////
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
                        component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                        component.set("v.pageNumber", 1);
                        this.renderPage(component);
                    } else {
                        component.set("v.lstOpportunityWrapper", []);
                        this.renderPage(component);
                        component.set("v.showButtons", false);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    }

})