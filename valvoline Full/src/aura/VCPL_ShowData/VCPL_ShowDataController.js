({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper);    
    }, 
    dogoToUrl : function(component, event, helper) {
        helper.goToUrl(component, event, helper);        
    },  
    eventHandler : function(component, event, helper) {
        component.set('v.Idaccount', 'ReturnToHome'); 
    }
})