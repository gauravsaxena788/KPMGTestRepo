({
    visibleModel: function(component, event, helper) {
      // for Display Model,set the "isVisible" attribute to "true"       
      component.set("v.isVisible", true);  
   },  
	closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      
      component.set("v.isVisible", false);
      
   }
})