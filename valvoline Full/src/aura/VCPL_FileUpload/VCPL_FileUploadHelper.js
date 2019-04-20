({
	getId : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
       
        return result.id;
    },
    openSingleFile: function(component, event, helper)
    { 
        var targetId =event.currentTarget.id;
        alert(targetId);
        debugger;
        var action=component.get("c.returnBlobValue");
        action.setParams({
            "attachmentIds":targetId
        });
        action.setCallback(this, function(actionresult) 
          {
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
                 
                
                //this.refreshview(component, event, helper);
            }
            else
            {
                console.log('==='+JSON.stringify(response.getError()));
            }
            
          });
         $A.enqueueAction(action);        
     }
})