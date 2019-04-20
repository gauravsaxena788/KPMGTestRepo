({
	doInit : function(component, event, helper) {
		
        var param =component.get("v.recordId");
        var device = $A.get("$Browser.formFactor");
        if(device == 'DESKTOP'){
            var action=component.get("c.checkQuoteAllowed");
        action.setParams({
            "strOppId" : param
        });
        action.setCallback(this, function(a){
            var resultLst=a.getReturnValue(); 
            console.log(' **resultLst: '+resultLst);
            
            if(resultLst=='Allow')
            {    
                helper.upsertDet(component); 
                var cmpmessage = component.find('strmessage');
                var cmpTarget = component.find('btn');
                var cmpcloseTarget = component.find('btntoclose');
                $A.util.removeClass(cmpmessage, 'slds-text-color_error');
                $A.util.addClass(cmpmessage, 'slds-text-color_success');
                $A.util.removeClass(cmpcloseTarget, 'slds-hide');
                $A.util.addClass(cmpcloseTarget, 'slds-show');
                $A.util.removeClass(cmpTarget, 'slds-hide');
                $A.util.addClass(cmpTarget, 'slds-show');
                component.set("v.message"," Are you sure you want to proceed ? ");
                
            }
            else if(resultLst=='In Review'){
                var cmpmessage = component.find('strmessage');
                var cmpTarget = component.find('btn');
                var cmpcloseTarget = component.find('btntoclose');
                $A.util.removeClass(cmpmessage, 'slds-text-color_success');
                $A.util.addClass(cmpmessage, 'slds-text-color_error');
                $A.util.removeClass(cmpcloseTarget,'slds-hide');
                $A.util.addClass(cmpcloseTarget,  'slds-show');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message","One of the Quote on this Opportunity is already In Review." );                              
            } 
        });
       
        $A.enqueueAction(action);
        }
        else{
            	var cmpmessage = component.find('strmessage');
                var cmpTarget = component.find('btn');
                var cmpcloseTarget = component.find('btntoclose');
                $A.util.removeClass(cmpmessage, 'slds-text-color_success');
                $A.util.addClass(cmpmessage, 'slds-text-color_error');
                $A.util.removeClass(cmpcloseTarget,'slds-hide');
                $A.util.addClass(cmpcloseTarget,  'slds-show');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message","You cannot create quote in mobile/tab." );                              
            
        }
        
	},
    
    openNewQuote : function(component, event, helper) {
		 var param =component.get("v.recordId");
         $A.get("e.force:closeQuickAction").fire();
        	var createRecordEvent = $A.get("e.force:createRecord");
            var qtdetailswrap = component.get("v.objWrapCase");
        	
            //console.log('New Quote Number is : '+qtnm);
            createRecordEvent.setParams({
                "entityApiName": "Quote",
                "defaultFieldValues": {
                    'OpportunityId' : param,
                    'Quote_Number__c' : qtdetailswrap.strQuoteNumber,
                    'AccountId' : qtdetailswrap.strAccntId,
                    'RecordTypeId' : qtdetailswrap.strRecordTypeId,
                    'BU_Name__c' : qtdetailswrap.strBUName,
                    'ContactId' : qtdetailswrap.contactId
                }
            });
            createRecordEvent.fire(); 
       
	},
    Closeapp : function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();
    }
})