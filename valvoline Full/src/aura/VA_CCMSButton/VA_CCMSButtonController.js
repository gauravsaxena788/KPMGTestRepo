({
    navigateToLightningComponent:function(component,event,helper){
    	component.set("v.show",true);
    },
     closeAction: function(cmp){
         //alert("hit");
      cmp.set("v.show", false);
    },
    
    navigateToPhonePage : function(component, event, helper) {
       var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef:"c:VA_VCCMSCaseMobile"
        });
        evt.fire();
    },
    
    doInit : function(component, event, helper){
        //helper.getLoggedInUser(component,event);
   
        if($A.get("$Browser.formFactor") == 'DESKTOP'){
            $A.util.removeClass(component.find("desktopDiv"), "slds-hide");
            $A.util.addClass(component.find("phoneDiv"), "slds-hide");
        }
        else {
            $A.util.addClass(component.find("desktopDiv"), "slds-hide");
            $A.util.removeClass(component.find("phoneDiv"), "slds-hide");
        }
    }
    
})