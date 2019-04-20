({
    doInit: function(component, event, helper) { 
      helper.getCaseDetail(component); 
      
  },
     
   ccmsgotoList : function (component, event, helper) {   
       var navEvent = $A.get("e.force:navigateToURL");
            navEvent.setParams({
              "url": "/ccms-cases"
            });     
       /*var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": '00B0x000000Ra2O',    
                "listViewName": null,
                "scope": "Case"
            });*/
            navEvent.fire();  
},
    
PODgotoList : function (component, event, helper) {
            var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": '00B6A000007qz6tUAA',            
                "listViewName": 'All',
                "scope": "VA_Invoice__c"   
            });
            navEvent.fire();    
},    
    
    
 
  
    
})