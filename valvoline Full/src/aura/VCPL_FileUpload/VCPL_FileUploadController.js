({
	doInit : function(component, event,helper) {  
    var recID = helper.getId();
        
    var action =component.get("c.getFilelist");
    action.setParams({"RecordId" :recID});
        action.setCallback(this, function(actionresult) {
        	var state = actionresult.getState();    
            
            if(state === "SUCCESS")
            {
                var result =actionresult.getReturnValue();
                component.set("v.FileList",result);
            }
        });
        $A.enqueueAction(action);
    },
    onclickopenSingleFile : function(component, event,helper) {
        debugger;
        var targetId =event.currentTarget.id;
        var action=component.get("c.returnBlobValue");
         action.setParams({
            "attachmentIds":targetId
        });
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if(state === "SUCCESS")
            {
            	var result=actionresult.getReturnValue();
                var attachmentObjectBlob=result.encodeValue; 
                var url;
                if(result.fileType=='PDF')
                {
                     url='data:application/pdf;charset=utf-8;base64,'+attachmentObjectBlob;
                    component.set('v.downloadpopup',true);
                }
                else if(result.fileType=='JPG' || result.fileType=='JPEG')
                {
                    url='data:image/jpeg;charset=utf-8;base64,'+attachmentObjectBlob;
                    component.set('v.downloadpopup',true);
                }
                 else if(result.fileType=='JPG' || result.fileType=='JPEG')
                {
                   url='data:image/jpeg;charset=utf-8;base64,'+attachmentObjectBlob;
                    component.set('v.downloadpopup',true);
                }
               else if(result.fileType=='PNG')
                {
                   url='data:image/png;charset=utf-8;base64,'+attachmentObjectBlob;   
                    component.set('v.downloadpopup',true);
                }
               else if(result.fileType=='EXCEL_X')
                { 
                  url='data:application/x-msexcel;charset=utf-8;base64,'+attachmentObjectBlob;  
                    component.set('v.downloadpopup',true);
                }
                else if(result.fileType=='POWER_POINT_X')
                {
                  url='data:application/powerpoint;charset=utf-8;base64,'+attachmentObjectBlob;
                    component.set('v.downloadpopup',true);
                }
               else if(result.fileType=='WORD_X')
                { 
                  url='data:application/msword;charset=utf-8;base64,'+attachmentObjectBlob; 
                    component.set('v.downloadpopup',true);
                }
               else if(result.fileType=='GIF')
                {
                    url='data:image/gif;charset=utf-8;base64,'+attachmentObjectBlob; 
                    component.set('v.downloadpopup',true);
                }
                else
                {
                    alert('You can only download Image,Excel(XLSX),PDF,Word and Powerpoint files.');
                    component.set('v.downloadpopup',false);
                }
                component.set('v.hrefAtt',url);
                component.set('v.download',result.Name);
            }
        });
        $A.enqueueAction(action);      
    },
    onClickClosewindow: function(component, event, helper)
    {
        component.set('v.downloadpopup',false);  
    }
})