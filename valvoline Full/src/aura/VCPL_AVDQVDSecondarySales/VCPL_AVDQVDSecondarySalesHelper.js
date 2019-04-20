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
                        if (response.lstAccounts.length > 1) {
                            component.set("v.isAccountPicklistVisible", false);
                        } else {
                            component.set("v.isAccountPicklistVisible", true);
                        }
                        component.set("v.lstDealerAccount", response.lstAccounts);
                    } else {
                        component.set("v.isAccountPicklistVisible", true);
                    }
                    
                    if (!$A.util.isUndefinedOrNull(response.lstConfigs)) {
                        if (response.lstConfigs.length > 1) {
                            component.set("v.isPicklistVisible", false);
                        } else {
                            component.set("v.isPicklistVisible", true);
                        }
                        component.set("v.configs", response.lstConfigs);
                    } else {
                        component.set("v.isPicklistVisible", true);
                    }
                    
                    if (!$A.util.isUndefinedOrNull(response.lstAccounts) && !$A.util.isUndefinedOrNull(response.lstConfigs)) {
                        var action = component.get("c.getData");
                        
                        action.setParams({
                            "strDealerId": response.lstAccounts[0].Id,
                            "strConfig": response.lstConfigs[0].VCPL_Fiscal_Year__c
                        });
                        
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state == "SUCCESS") {
                                var result = response.getReturnValue();
                                if (!$A.util.isUndefinedOrNull(result)) {
                                    component.set("v.DetailsWrapper", result);
                                    component.set("v.DetailsWrapperReference", result);
                                    component.set("v.maxPage", Math.floor((result.length + 9) / 10));
                                    this.renderPage(component);
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
    },
    renderPage: function(component) {
        var records = component.get("v.DetailsWrapper");
        var pageNumber = component.get("v.pageNumber");
        var pageRecords = records.slice((pageNumber - 1) * 10, pageNumber * 10);
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
    onchangeofPicklistHelper: function(component, event, helper) {
        var config = component.get("v.configs")[component.get("v.configFY")];
        var acct = component.get("v.lstDealerAccount")[component.get("v.acctId")];
        
        var accountID;
        if (!$A.util.isUndefinedOrNull(acct)) {
            accountID = acct.Id;

        } else {
            accountID = component.get("v.lstDealerAccount")[0].Id;

        }
        
        var configYear;
        if (!$A.util.isUndefinedOrNull(config)) {
            configYear = config.VCPL_Fiscal_Year__c;
            
        } else {
            configYear = component.get("v.configs")[0].VCPL_Fiscal_Year__c;

        }
        
        if (!$A.util.isUndefinedOrNull(accountID) && !$A.util.isUndefinedOrNull(configYear)) {
            var action = component.get("c.getData");
            component.set("v.showSpinner", true);
            action.setParams({
                "strDealerId": accountID,
                "strConfig": configYear
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var result = response.getReturnValue();
                   
                    if(!$A.util.isUndefinedOrNull(result)) {
                        component.set("v.DetailsWrapper", result);
                        component.set("v.DetailsWrapperReference", result);
                        component.set("v.maxPage", Math.floor((result.length + 9) / 10));
                        this.renderPage(component);
                    }
                    else {
                    component.set("v.DetailsWrapper", null);
                    component.set("v.DetailsWrapperReference", null);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    }
})