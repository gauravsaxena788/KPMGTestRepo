({
    getDataHelper: function(component, event, helper) {
        var action = component.get("c.getpicklistvalues");
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
                        component.set("v.lstAccount", response.lstAccounts);
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
						component.set("v.showSpinner", true);
                        action.setParams({
                            "strprimaryAccountID": response.lstAccounts[0].Id,
                            "configYear": response.lstConfigs[0]
                        });

                        action.setCallback(this, function(response) {
                            var state = response.getState();

                            if (state == "SUCCESS") {
                                var result = response.getReturnValue();

                                if (!$A.util.isUndefinedOrNull(result)) {
                                    component.set("v.DetailsWrapper", result);
                                }
                            }
                            component.set("v.showSpinner", false);
                        });
                        $A.enqueueAction(action);
                    }
                } else {
                    component.set("v.isPicklistVisible", true);
                    component.set("v.isAccountPicklistVisible", true);
                }

            }
             component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    getDataonPicklistChange: function(component,event,helper)
    {
        var acc= component.get("v.lstAccount")[component.get("v.acctId")];
        var config= component.find("config").get("v.value");
        var configFY;
        if($A.util.isUndefinedOrNull(acc))
        {
           acc =  component.get("v.lstAccount")[0];
        }
        
        if(config != "")
        {
            configFY = config;
        }
        else
        {
             configFY = component.get("v.configs")[0];
        }
        
        if(!$A.util.isUndefinedOrNull(acc.Id) && !$A.util.isUndefinedOrNull(configFY))
        {
            var action = component.get("c.getData");
            component.set("v.showSpinner", true);
            action.setParams({
                "strprimaryAccountID": acc.Id,
                "configYear": configFY
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
               
                if(state =="SUCCESS")
                {
                    var result = response.getReturnValue();
                    
                    if(!$A.util.isUndefinedOrNull(result))
                    {
                        component.set("v.DetailsWrapper", result);
                    }
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    }
})