({
	doInit : function(component, event, helper) {
		var recordID = component.get("v.recordId");	
        var action = component.get("c.gettheDiffdataonforExpire");
       
       
            action.setParams({
                "getdiffId": (recordID != null && recordID != '')?recordID:null
            });
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var objectres = response.getReturnValue();
                 if (!$A.util.isUndefinedOrNull(objectres)) {
                     var returnval = JSON.parse(objectres);
                     var returnsatatus = returnval.objectName;
                     var returnmessage = returnval.strId;
                     if(returnsatatus != null && returnsatatus != '' && returnsatatus == 'SUCCESS'){
                     	var todaydate = new Date();
                        var expirydatestr = todaydate.getFullYear()+'-'+(todaydate.getMonth()+1)+'-'+todaydate.getDate();
                        component.set("v.expiryDate",expirydatestr);
                     }
                     else if(returnsatatus != null && returnsatatus != '' && returnsatatus == 'ERROR'){
                         component.set("v.strmessage",returnmessage);
                         component.set("v.isOpen",false);
                     }
                 }
            }
            });
        $A.enqueueAction(action);
	},
    saverecords : function(component, event, helper) {
        var recordID = component.get("v.recordId");
        var expirydate = component.get("v.expiryDate");
        var reason = component.get("v.strexpiremessage");
        var returnstate = helper.validatecheckfield(component, event);
        if(returnstate){
           
            var action = component.get("c.gettheDiffdataonforupdate");
        
       
            action.setParams({
                "getdiffId": (recordID != null && recordID != '')?recordID:null,
                "expiryDate": expirydate,
                "expiryreason":reason
            });
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                        var recordID = component.get("v.recordId");
                        if(recordID != null && recordID != ''){
                        var navEvt = $A.get("e.force:navigateToSObject");
                                    navEvt.setParams({
                                      "recordId": recordID,
                                      "slideDevName": "related"
                                    });
                                    navEvt.fire();
                        }
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: '',
                            message: 'Successfully expired',
                            type : 'success',
                            duration:'2000'
                        });
                        toastEvent.fire();
            }
             if (state === "ERROR") {
             var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            mode: '',
                            message: 'Some error occured',
                            type : 'error',
                            duration:'2000'
                        });
                        toastEvent.fire();
             }
              });
        $A.enqueueAction(action);
        }
        
	},
    cancel : function(component, event, helper) {
        var recordID = component.get("v.recordId");
        if(recordID != null && recordID != ''){
        var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": recordID,
                      "slideDevName": "related"
                    });
                    navEvt.fire();
        }
        else{
            var recordIDtrue = component.get("v.objdiffPric.VCPL_Dealer_Name__c");;
            $A.get("e.force:navigateToSObject").setParams({ 
               "recordId": recordIDtrue 
           	 }).fire();
        }
         	
    }
    
})