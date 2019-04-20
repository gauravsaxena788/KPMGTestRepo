({
     doInit : function(component, event, helper){    
        var strCaseId =component.get("v.recordId");
           //call apex class method
        var action = component.get('c.initMethod');    
        action.setParams({ strRecordId : strCaseId})   
        action.setCallback(this, function(response) {    
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
              //set response value in wrapperList attribute on component.
              component.set('v.wrapperList', response.getReturnValue());
               console.log(response.getReturnValue());     
    
            }
          });
          $A.enqueueAction(action);
        },  
    
   visibleModel: function(component, event, helper) {
      // for Display Model,set the "isVisible" attribute to "true"       
      component.set("v.isVisible", true);  
   },
    
    
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      
      component.set("v.isVisible", false);
      
   },  
 
})