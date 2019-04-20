({
    getData: function(component, event, helper) {
        var recordID = component.get("v.recordId");
        
        var action = component.get("c.getData");
        component.set("v.showSpinner", true);
        
        if (recordID == "" || $A.util.isUndefinedOrNull(recordID)) {
            action.setParams({
                "strPrimaryAccountID": null
            });
        } else {
            action.setParams({
                "strPrimaryAccountID": recordID
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
    saveData: function(component, event, helper) {
        var records = component.get("v.dataWrapperReference");
        
        if (!$A.util.isUndefinedOrNull(records)) {
            var countTop20 = 0;
            var countTarget20 = 0;
            
            for (var i = 0; i < records.length; i++) {
                if (records[i].strAssignmentClassification == "Top 20") {
                    countTop20 += 1;
                } else if (records[i].strAssignmentClassification == "Target 20") {
                    countTarget20 += 1;
                }
            }
            if (countTop20 > 20) {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "ERROR!",
                    "mode": "",
                    "type": "error",
                    "message": "There can be a maximum of 20 selected accounts in Top 20 category."
                });
                
                toastEvent.fire();
            } else if (countTarget20 > 20) {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "ERROR!",
                    "mode": "",
                    "type": "error",
                    "message": "There can be a maximum of 20 selected accounts in Target 20 category."
                });
                
                toastEvent.fire();
            } else {
                var recordToSave = component.get("v.paginationWrapper");
                
                if (!$A.util.isUndefinedOrNull(recordToSave)) {
                    var action = component.get("c.saveData");
                    //component.set("v.showSpinner", true);
                    
                    action.setParams({
                        "strResponse": JSON.stringify(recordToSave)
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state == "SUCCESS") {
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
                                
                                var recordID = component.get("v.recordId");
                                var action = component.get("c.getData");
                                
                                if(recordID =="")
                                {
                                    action.setParams({
                                        "strPrimaryAccountID": null
                                    });
                                }
                                else
                                {
                                    
                                    action.setParams({
                                        "strPrimaryAccountID": recordID
                                    });
                                }
                                action.setCallback(this, function(response) {
                                    var state = response.getState();
                                    
                                    if(state == "SUCCESS")
                                    {
                                        var response = response.getReturnValue();
                                        
                                        if(!$A.util.isUndefinedOrNull(response)) {
                                            component.set("v.dataWrapper", response);
                    						component.set("v.dataWrapperReference", response);
                                            component.set("v.showButtons", true);
                                            this.renderPage(component);
                                        }
                                    }
                                    component.set("v.showSpinner", false);
                                });
                                $A.enqueueAction(action);
                            } else {
                                var errorvalue = response.indexOf('error:');
                                if (errorvalue != -1) {
                                    if (response.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION")) {
                                        var stringtoDisplay = response.match("FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*):");
                                        
                                        var toastEvent = $A.get("e.force:showToast");
                                        
                                        toastEvent.setParams({
                                            "title": "ERROR!",
                                            "mode": "",
                                            "type": "error",
                                            "message": stringtoDisplay
                                        });
                                        
                                        toastEvent.fire();
                                    } else {
                                        var genericErrormsg = "An error has occurred.Please contact your system administrator if this problem persists.";
                                        var toastEvent = $A.get("e.force:showToast");
                                        
                                        toastEvent.setParams({
                                            "title": "ERROR!",
                                            "mode": "",
                                            "type": "error",
                                            "message": genericErrormsg
                                        });
                                        
                                        toastEvent.fire();
                                        
                                    }
                                }
                            }
                            //component.set("v.showSpinner", false);
                        }
                        component.set("v.showSpinner", false);
                    });
                    $A.enqueueAction(action);
                }
            }
        }
    },
    sortListForField:function(component,dataWrapperReference,fieldNameToSort,isAscending) {
        dataWrapperReference = dataWrapperReference || [];
            dataWrapperReference.sort(function(option1, option2) {
                if (!$A.util.isEmpty(option1) && !$A.util.isEmpty(option1[fieldNameToSort]) && !$A.util.isEmpty(option2) && !$A.util.isEmpty(option2[fieldNameToSort])) {
                    return isAscending == 'true' ?  (option1[fieldNameToSort] - option2[fieldNameToSort]) : (option2[fieldNameToSort] - option1[fieldNameToSort]);
                } else {
                    return 0;
                }
            });
            component.set("v.dataWrapperReference",dataWrapperReference);
            var sortingOrder  = component.get("v.sortingOrder") || {};
            sortingOrder[fieldNameToSort] = isAscending == 'true' ? false : true;
            component.set("v.sortingOrder",sortingOrder);
    }
})