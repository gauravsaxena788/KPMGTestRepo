({
	navigateToMyPage : function(component, event, helper) {
        
		component.set("v.showMyComp",true);
	},
    navigateToPhonePage : function(component, event, helper){
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef:"c:VA_EditPostKitCasePageMobile"
        });
        evt.fire();
    },
    navigateToPhoneTestPage : function(component, event, helper) {
       var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef:"c:VA_EditPostCasePageMobile"
        });
        evt.fire();
    },
    closePostKit : function(component, event, helper){
       
        component.set("v.showMyComp",false);
    },
    navigateToTestPage : function(component, event, helper){
        component.set("v.showTestPage",true);
    },
    doInit : function(component, event, helper){
        //helper.getLoggedInUser(component,event);
        var caseType = component.get("v.passCaseType");
        if(! ($A.util.isUndefinedOrNull(caseType)  || caseType === "") && caseType ==="post"){
            if($A.get("$Browser.formFactor") == 'DESKTOP'){
                $A.util.removeClass(component.find("desktopDiv"), "slds-hide");
                $A.util.addClass(component.find("phoneDiv"), "slds-hide");
            }else {
                $A.util.addClass(component.find("desktopDiv"), "slds-hide");
                $A.util.removeClass(component.find("phoneDiv"), "slds-hide");
            }
        }else if(! ($A.util.isUndefinedOrNull(caseType)  || caseType === "") && caseType ==="ccms"){
            component.set("v.showCCMSComp",true);
            $A.util.addClass(component.find("desktopDiv"), "slds-hide");
            $A.util.addClass(component.find("phoneDiv"), "slds-hide");
        }else {
            $A.util.addClass(component.find("desktopDiv"), "slds-hide");
            $A.util.removeClass(component.find("phoneDiv"), "slds-hide");
        }
    }
})