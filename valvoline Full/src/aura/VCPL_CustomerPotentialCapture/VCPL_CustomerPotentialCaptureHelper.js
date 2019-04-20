({
    getDetailsWrapper: function(component, event, helper) {
        
        component.set("v.showSpinner_Potential", true);
        var action = component.get("c.getDetails");
        
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.basicDetails", response);

                    if (!$A.util.isUndefinedOrNull(response.strFinancialYear)) {
                        var recordID = component.get("v.recordId");
                        
                        component.set("v.showSpinner_Potential", true);
                        var action = component.get("c.getData");
						
                        if (recordID == "" || $A.util.isUndefinedOrNull(recordID)) {
                            action.setParams({
                                "strFinancialYear": response.strFinancialYear,
                                "strAccountID": null
                            });
                        } else {
                            action.setParams({
                                "strFinancialYear": response.strFinancialYear,
                                "strAccountID": recordID
                            });
                        }

                        action.setCallback(this, function(response) {
                            var state = response.getState();

                            if (state === "SUCCESS") {
                                var response = response.getReturnValue();
                                console.log(JSON.stringify(response));
                                if (!$A.util.isUndefinedOrNull(response)) {
                                    component.set("v.lstDetailsWrapper", response);
                                    component.set("v.lstDetailsWrapperReference", response);
                                    component.set("v.showButtons", true);
                                    component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                                    var getAllOpportunities = component.get("v.lstDetailsWrapperReference");
                                    this.renderPage(component);
                                } else {
                                	component.set("v.showButtons", false);
                                }
                            }
                            component.set("v.showSpinner_Potential", false);
                        });
                        $A.enqueueAction(action);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    renderPage: function(component) {
        var records = component.get("v.lstDetailsWrapper");
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber - 1) * 10, pageNumber * 10);
        component.set("v.lstPaginationDetailsWrapper", pageRecords);
        
        if(!$A.util.isUndefinedOrNull(pageNumber) && pageNumber == 1)
        {
        	component.set("v.disableFirstButton",true);
        	component.set("v.disablePrevButton",true);
        }
        else if(!$A.util.isUndefinedOrNull(pageNumber) && pageNumber > 1)
        {
        	component.set("v.disableFirstButton",false);
        	component.set("v.disablePrevButton",false);
        }
        
        var maxpage = component.get("v.maxPage");
        
        if(!$A.util.isUndefinedOrNull(maxpage) && !$A.util.isUndefinedOrNull(pageNumber) && maxpage == pageNumber)
        {
        	component.set("v.disableNextButton",true);
        	component.set("v.disableLastButton",true);
        }
        else if(!$A.util.isUndefinedOrNull(maxpage) && !$A.util.isUndefinedOrNull(pageNumber) && maxpage != pageNumber)
        {
        	component.set("v.disableNextButton",false);
        	component.set("v.disableLastButton",false);
        }
    },
    saveData: function(component, event, helper) {
        var data = component.get("v.lstPaginationDetailsWrapper");

        if (!$A.util.isUndefinedOrNull(data)) {

            var checkNegativesamplePH6Potentialvalue1 = 0;
            var checkNegativesamplePH6Potentialvalue2 = 0;
            var checkNegativesamplePH6Potentialvalue3 = 0;
            var checkNegativesamplePH6Potentialvalue4 = 0;
            var checkNegativesamplePH6Potentialvalue5 = 0;
            var checkNegativesamplePH6Potentialvalue6 = 0;
            var checkNegativesamplePH6Potentialvalue7 = 0;

            for (var i = 0; i < data.length; i++) {
                if (data[i].samplePH6Potentialvalue1 < 0)
                    checkNegativesamplePH6Potentialvalue1 += 1;

                if (data[i].samplePH6Potentialvalue2 < 0)
                    checkNegativesamplePH6Potentialvalue2 += 1;

                if (data[i].samplePH6Potentialvalue3 < 0)
                    checkNegativesamplePH6Potentialvalue3 += 1;

                if (data[i].samplePH6Potentialvalue4 < 0)
                    checkNegativesamplePH6Potentialvalue4 += 1;

                if (data[i].samplePH6Potentialvalue5 < 0)
                    checkNegativesamplePH6Potentialvalue5 += 1;

                if (data[i].samplePH6Potentialvalue6 < 0)
                    checkNegativesamplePH6Potentialvalue6 += 1;

                if (data[i].samplePH6Potentialvalue7 < 0)
                    checkNegativesamplePH6Potentialvalue7 += 1;
            }

            if (checkNegativesamplePH6Potentialvalue1 > 0 || checkNegativesamplePH6Potentialvalue2 > 0 ||
                checkNegativesamplePH6Potentialvalue3 > 0 || checkNegativesamplePH6Potentialvalue4 > 0 ||
                checkNegativesamplePH6Potentialvalue5 > 0 || checkNegativesamplePH6Potentialvalue6 > 0 ||
                checkNegativesamplePH6Potentialvalue7 > 0) {

                var toastEvent = $A.get("e.force:showToast");

                toastEvent.setParams({
                    "title": "ERROR!",
                    "mode": "",
                    "type": "error",
                    "message": "Entered Potential values should not be a negative number ."
                });
                toastEvent.fire();
            } else {
                var action = component.get("c.saveDate");
                component.set("v.showSpinner_Potential", true);
                action.setParams({
                    "strResponse": JSON.stringify(data)
                });

                action.setCallback(this, function(response) {
                    var state = response.getState();

                    if (state === "SUCCESS") {
                        var response = response.getReturnValue();
                        if (response === "Processed successfully") {
                            var toastEvent = $A.get("e.force:showToast");

                            toastEvent.setParams({
                                "title": "SUCCESS!",
                                "mode": "",
                                "type": "success",
                                "message": "Processed successfully ."
                            });
                            toastEvent.fire();
                        }
                    }
                    component.set("v.showSpinner_Potential", false);
                });
                $A.enqueueAction(action);
            }
        }
    },
    searchAccountHelper: function(component, searchString) {
        var records = component.get("v.lstDetailsWrapperReference");

        if (!$A.util.isUndefinedOrNull(records)) {
            var action = component.get("c.getSearchResults");
            component.set("v.showSpinner_Potential", true);
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
                        component.set("v.lstDetailsWrapper", response);
                        component.set("v.maxPage", Math.floor((response.length + 9) / 10));
                        component.set("v.pageNumber", 1);
                        this.renderPage(component);
                    } else {
                        component.set("v.lstDetailsWrapper", []);
                        this.renderPage(component);
                        component.set("v.showButtons", false);
                    }
                }
                component.set("v.showSpinner_Potential", false);
            });
            $A.enqueueAction(action);

        }
    }
})