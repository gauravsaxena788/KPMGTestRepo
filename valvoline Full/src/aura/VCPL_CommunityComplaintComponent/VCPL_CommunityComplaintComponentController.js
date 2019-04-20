({
   doInit : function(component, event, helper){  
    var strCaseId =component.get("v.recordId");
       //call apex class method
    var action = component.get("c.initMethod");
    action.setParams({ strRecordId : strCaseId})   
    action.setCallback(this, function(response) {
        //store state of response   
        var state = response.getState();
        if (state === "SUCCESS") {
          //set response value in wrapperList attribute on component.
          component.set('v.wrapperList', response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
    },
 
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"     
      component.set("v.isOpen", true);     
   },
    
   visibleModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"     
      component.set("v.isVisible", true);    
   
   },
    
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
      component.set("v.isVisible", false);  
   },  
    
})