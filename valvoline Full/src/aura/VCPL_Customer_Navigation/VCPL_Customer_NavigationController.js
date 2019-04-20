({ 
    doInit : function(component, event, helper){    
       
           //call apex class method
        var action = component.get('c.initMethod');    
         
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
   
 postgotoList : function (component, event, helper) {
     		var navEvent = $A.get("e.force:navigateToURL");
            navEvent.setParams({
              "url": "/post-cases"
            });
            /*var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": '00B0x000000SE9M',    
                "listViewName": null,
                "scope": "Case"
            });*/
            navEvent.fire();    
            
            var cmpEventSM_RefreshComponent = $A.get("e.c:VA_RefreshComponent");
	cmpEventSM_RefreshComponent.fire();
},   
 
ordergotoList : function (component, event, helper) {  
            var navEvent = $A.get("e.force:navigateToList");  
            navEvent.setParams({
                "listViewId": '00B6A000001kQy3',         
                "listViewName": null,
                "scope": "Order"   
            });
            navEvent.fire();    
    
    var cmpEventSM_RefreshComponent = $A.get("e.c:VA_RefreshComponent");
	cmpEventSM_RefreshComponent.fire();
},   
    

accountstatementgotoList : function (component, event, helper) {
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": '00B6A000007qyjJUAQ',        
                "listViewName": 'All',
                "scope": "VA_AccountStatement__c"   
            });
            navEvent.fire();  
    
    var cmpEventSM_RefreshComponent = $A.get("e.c:VA_RefreshComponent");
    cmpEventSM_RefreshComponent.fire();
},   
   
createInsightRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.fire();   
},  
    
     
createVideosRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.fire();   
},

createSolutionRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.fire();     
},  
    
createPromoteRecord : function (component, event, helper) {  
    var createRecordEvent = $A.get("e.force:createRecord");  
    createRecordEvent.fire();   
}, 

})