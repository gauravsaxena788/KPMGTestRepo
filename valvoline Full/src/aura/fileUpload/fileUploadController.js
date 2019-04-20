({  
    save : function(component, event, helper) {
        helper.save(component);
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = helper.FILE_NOT_SELECTED_ERROR_LABEL;
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        if (component.find("fileId").get("v.files").length > 0) {
            helper.save(component, event);
			helper.updateCheck11_helper(component, event,helper);            
        } else {
            helper.showToast('Error', 'error', helper.INVALID_FILE_SELECTED_ERROR_LABEL);
        }
    },
    waiting: function(component, event, helper) {
    	$A.util.addClass(component.find("uploading").getElement(), "uploading");
    	$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },
    
    handleClick: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      "url": 'https://phase2-vcpl.cs19.force.com/Customer/apex/VA_UploadFile'
    });
    urlEvent.fire();
    },
    
    doneWaiting: function(component, event, helper) {
    	$A.util.removeClass(component.find("uploading").getElement(), "uploading");
    	$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },
    
    goBack : function(component, event, helper) {
        var rec = component.get("v.recordId");
		//alert(window.location.href);
        //alert(rec);
    	var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({
         
          "url": window.location.href
        });
        urlEvent.fire();
    }
})