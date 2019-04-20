({
    doInit: function(component, event, helper) {
        helper.getDetailsWrapper(component, event, helper);
        helper.getOpportunityWrapper(component, event, helper);
    },
    onSaveButtonClick: function(component, event, helper) {
        helper.saveOpportunity(component, event, helper);
    },
    onChangeofMonth: function(component, event, helper) {
        helper.onChangeofMonthHelper(component, event, helper);
    },
    closeToast: function(component, event, helper) {
        component.set('v.errormsg', "");
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    doInitonSaveButtonClickController: function(component, event, helper) {
        var month = component.find("month").get("v.value");
        var sameComponent = component.get("v.sameComponent");
        var searchString = component.get("v.searchString");
        if (searchString == "") {
            component.callDoinit();
            var month = component.find("month").get("v.value");

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

            if ($A.util.isUndefinedOrNull(month)) {
                month = month[todayDate.getMonth()];
            }
            var action = component.get("c.getData");

            var recordID = component.get("v.recordId");

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
                        for (var i = 0; i < getAllOpportunities.length; i++) {
                            if (getAllOpportunities[i].isDisable == true) {
                                countisDisable += 1;
                            }
                        }

                        component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                        component.set("v.pageNumber", "1");
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
        component.set("v.sameComponent", true);
    },
    onSearchStringChange: function(component, event, helper) {
        var searchString = component.get("v.searchString");
        helper.searchUserHelper(component, searchString);
    }
})