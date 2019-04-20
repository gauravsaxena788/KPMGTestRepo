({
    doInit : function(component, event, helper) {
        //get quote record Id
        
        var param = component.get("v.recordId");
        var action=component.get("c.findAllNew");
        
        action.setParams({
            "QuoteId" : param
        });
        
        //configure action handler
        action.setCallback(this, function(response){
            
            var resultLst = response.getReturnValue();
            //alert(resultLst);
            component.set("v.objWrapCase",resultLst);
            var responseres = component.get("v.objWrapCase");
            if(responseres.strResType == 'success')
            {
                var cmpTarget = component.find('btn1');
                
                $A.util.removeClass(cmpTarget, 'slds-show');
                component.set("v.message"," You can submit the quote only in draft stage.");
            }
            else if(responseres.strResType == 'error')
            {               
                var cmpTarget = component.find('btn1');
                component.set("v.message",responseres.strMessage);
                $A.util.addClass(cmpTarget, 'slds-hide');
                $A.util.addClass(cmpTarget, 'slds-show');
            }
            else
            {
                var cmpTarget = component.find('btn1');
                component.set("v.message", responseres);
                $A.util.addClass(cmpTarget, 'slds-hide');
                $A.util.addClass(cmpTarget, 'slds-show');
            }
            
        });
        $A.enqueueAction(action);
        
    },
    requestCall: function(component, event, helper) {
        //prepare action for update quote
        
        var updateCall = component.get("c.updateQuoteCall");
        updateCall.setParams({
            "qt" : component.get("v.recordId")
        });
        //configure response handler for this action
        updateCall.setCallback(this, function(response){
            var resultLst = response.getReturnValue();
            //alert(resultLst);
            component.set("v.objWrapCase",resultLst);
            var responseres = component.get("v.objWrapCase");
            var resultsToast = $A.get("e.force:showToast");
            if(responseres.strResType == 'success')
            {
                resultsToast.setParams({
                    "type": "success",
                    "title" : "Submitted for approval",
                    "message" : responseres.strMessage
                });
            }
            else if(responseres.strResType == 'error')
            { 
                resultsToast.setParams({
                    "type": "error",
                    "title" : "Submitted for approval",
                    "message" : responseres.strMessage
                });
            }
            $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
           
        });
        //send the request to updateCall
        $A.enqueueAction(updateCall);
 
 
    },
    cancelCall: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
    }
})