({
    MAX_FILE_SIZE: 4300000 , //Max file size 5 MB 
    CHUNK_SIZE:300000 , //Chunk Max size 750Kb 
    FILE_NOT_SELECTED_ERROR_LABEL: 'No File Selected.',
    INVALID_FILE_SELECTED_ERROR_LABEL: 'Please Select a Valid File',
    FILE_SIZE_ERROR_LABEL: 'Alert : File size cannot exceed',
    UNSUPPORTED_FILE_FORMAT_ERROR_LABEL: 'Alert : Unsupported File Format',
    
    save : function(component) {
        debugger;
        component.set("v.showLoadingSpinner", true);
        var self = this;
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        
        var fileName = file.name;
        var fileType = file.type;
        
        if (file.size > this.MAX_FILE_SIZE) {
            var errorMessage = self.FILE_SIZE_ERROR_LABEL;
            errorMessage += ' '+ (self.MAX_FILE_SIZE/1024000).toFixed(2) + ' MB \n';
            errorMessage += ' Selected file size: ' + (file.size/1024000).toFixed(2) + ' MB';

            
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", errorMessage);
            return;
            
        }
        if (fileType !== "image/jpg" && fileType !== "image/tif" && fileType !== "image/gif" && fileType !== "image/png" && fileType !== "image/jpeg" ) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", self.UNSUPPORTED_FILE_FORMAT_ERROR_LABEL);
            return;
        }
        var fr = new FileReader();
        console.log('v.recordId=='+component.get("v.recordId"));
        
        fr.onload = $A.getCallback(function() {
            var fileContents = fr.result;
            console.log(fileContents);
            //alert(fileContents);
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            
            console.log(dataStart); 
            fileContents = fileContents.substring(dataStart);
            //alert('file content length'+fileContents.length);
            self.upload(component, file, fileContents);
        });
        
        fr.readAsDataURL(file);
        
        debugger;
        
    },
    
    upload: function(component, file, fileContents) {
        debugger;
        var fromPos = 0;
        
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        
        
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');  
        //var action = component.get("c.saveTheFile"); 
    },
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachId) {
        
        var action = component.get("c.saveTheChunk"); 
        var chunk = fileContents.substring(fromPos, toPos);
        action.setParams({
            parentId: component.get("v.recordId"),
            
            fileName: file.name,
            
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachId
        });
        
        action.setCallback(this, function(a) {
            
            
            var attachid = a.getReturnValue();
            //alert(attachid);
            
            var msg = a.getState();  
            if (msg === "SUCCESS") 
            {
                fromPos = toPos;
                toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
                
                if (fromPos < toPos) {
                    this.uploadChunk(component, file, fileContents, fromPos, toPos, attachid);  
                    
                }
                else{
                    this.ShowToast(component, event,'dismissible','Uploaded successfully','Success!','success',20000000);
                    component.set("v.showLoadingSpinner", false);
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                 
                
                
            }
            else if(a.getState() === 'ERROR'){
                alert(action.getError());
                var errors = action.getError();
                if (errors) {    
                    if (errors[0] && errors[0].message) {  
                        component.set("v.errorMessage",errors[0].message);
                    }    
                }
                $A.get('e.force:refreshView').fire();
            }
            
        });
        
        
        $A.enqueueAction(action); 
        debugger;
        
    },
    updateCheck11_helper : function(component, event, helper) {
        
        var save_action = component.get("c.updateCheck");
        save_action.setParams({
            parentId: component.get("v.recordId"),
        });
        $A.enqueueAction(save_action);
    },
    ShowToast : function(component, event,varMode,varMessage,varTitle,varType,varDuration) {
        var toastEvent = $A.get("e.force:showToast");
        
        
        toastEvent.setParams({
            mode: varMode,
            message: varMessage,
            title:varTitle,
            type:varType,
            duration:varDuration
        });
        toastEvent.fire();
    }
})