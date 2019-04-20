({
	
    navigateToTestPage : function(component, event, helper){
        //console.log('Clicked!!!');
        console.log('VAL of showtstpg-->'+component.get("v.showTestPage"));
        component.set("v.showTestPage",true);
        console.log('VAL of showtstpg After-->'+component.get("v.showTestPage"));
    },
    doInit : function(component, event, helper){
        //helper.getLoggedInUser(component,event);
        console.log("In VA_ordCretBtnCmp-->H-->Init-->passedID-->"+component.get("v.passRecIdToOrderCmp"));
        if($A.get("$Browser.formFactor") == 'DESKTOP'){
            $A.util.removeClass(component.find("desktopDiv"), "slds-hide");
            $A.util.addClass(component.find("phoneDiv"), "slds-hide");
        }
        else {
            $A.util.addClass(component.find("desktopDiv"), "slds-hide");
            $A.util.removeClass(component.find("phoneDiv"), "slds-hide");
        }
    },
     navigateToPhonePage :function(component, event, helper)
    {
        var evt = $A.get("e.force:navigateToComponent");
         evt.setParams({
            componentDef:"c:VA_CreateOrderPageMobile"
        });
        evt.fire();
    }
    
})