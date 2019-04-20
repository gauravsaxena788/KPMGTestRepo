({
    
    save: function (component, event, helper) {        	
        helper.callServer(component, event, 'false');     
    },
    
    doInit : function(component, event, helper){  
        
        var base_url = window.location.origin;
		var label = $A.get("$Label.c.VA_postReportTemplateUrl");
        
        if(base_url== label)
        {
            base_url =label+'/Sfapp';
        }
        component.set("v.parentURL",base_url);
    }
})