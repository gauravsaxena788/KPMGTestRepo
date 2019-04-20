({

	save: function (component, event, helper) {        	
        helper.callServer(component, event, 'false');     
    },
    doInit : function(component, event, helper){
        
        var base_url = window.location.origin;
       
		if(base_url== 'https://vcpl--partialcpy.cs95.my.salesforce.com')
        {
            base_url ='https://partialcpy-vcpl.cs95.force.com/Customer';
        }
        component.set("v.parentURL",base_url);
    }
    
})