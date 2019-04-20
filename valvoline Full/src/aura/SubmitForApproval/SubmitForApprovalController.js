({
    doInit : function(component, event, helper) {
        //get quote record Id
        //var action = component.get("c.getQuote");
        var param =component.get("v.recordId");
        //console.log('ACC Rec ID : '+param);
        var action=component.get("c.findAllNew");
        
        action.setParams({
            "QuoteId" : param
        });
        
        //configure action handler
        action.setCallback(this, function(response){
            
            var resultLst=response.getReturnValue();
            //alert(resultLst);
            if(resultLst == 'Not in Draft')
            {
                var cmpTarget = component.find('btn1');
                
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message"," You can submit the quote only in draft stage.");
            }
            else if(resultLst == 'Not Update')
            {               
                var cmpTarget = component.find('btn');
                component.set("v.message"," Are you sure you want to submit for approval?");
                $A.util.addClass(cmpTarget, 'slds-show');
            }
            else
            {
                var cmpTarget = component.find('btn');
                component.set("v.message", resultLst);
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
            var state = response.getState();
            if(state === "SUCCESS"){
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title" : "Submitted for approval",
                    "message" : "A quote has been requested."
                });
 
                //Update the UI: closePanel, show toast, refresh page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();
                $A.get("e.force:refreshView").fire();
                location.reload();
            }else if(state === "ERROR"){
                console.log('Problem updating quote, response state '+state);
            }else{
                console.log('Unknown problem: '+state);
            }
        });
        //send the request to updateCall
        $A.enqueueAction(updateCall);
 
 
    },
    cancelCall: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        location.reload();
    }
})