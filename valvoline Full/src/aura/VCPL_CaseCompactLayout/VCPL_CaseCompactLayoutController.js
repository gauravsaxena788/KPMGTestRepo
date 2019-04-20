({
    doInit : function(component, event,helper) { 
                
        setTimeout(function(){ helper.fetchData(component, event,helper); }, 100);
    },
    
    goBackPostKit : function(component, event, helper) 
    {
        var rec = component.get("v.sobj.AccountId");


    	var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
          "url": "/show-child-data?id="+rec
        });
        urlEvent.fire();
    },
    
    goBackCCMS : function(component, event, helper) 
    {
        var rec = component.get("v.sobj.AccountId");


    	var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
          "url": "/show-child-data?id="+rec+"&tabset-9a9e5=2"
        });
        urlEvent.fire();
    },
    
    goBackPostTest : function(component, event, helper) 
    {
        var rec = component.get("v.sobj.AccountId");


    	var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
          "url": "/show-child-data?id="+rec
        });
        urlEvent.fire();
    }
    
    
})