({
    doInit : function(component, event, helper) {
        var param =component.get("v.recordId");
        // console.log('ACC Rec ID : '+param);
        var action=component.get("c.findAllowed");
        action.setParams({
            "oppId" : param
        });
        action.setCallback(this, function(a){
            var resultLst=a.getReturnValue(); 
            console.log(' **resultLst: '+resultLst);
            
            if(resultLst=='Allow')
            {    
                helper.upsertDet(component);           
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-hide');
                $A.util.addClass(cmpTarget, 'slds-show');
                component.set("v.message"," Are you sure you want to proceed ? ");
                
            }
            else if(resultLst=='In Review'){
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message","One of the Quote on this Opportunity is already In Review." );                              
            }                   
            else if(resultLst=='Not SM'){
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message","SM is not created.");                              
            }   
            
            else{
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message","Account is either not approved or Quote is not allowed, Please contact your Segment Manager/Reporting Manager." );                              
            }                   
            
        });
       
        $A.enqueueAction(action);
    },
    
    myAction : function(component, event, helper) {
        
       
        var param =component.get("v.recordId");
        
        var createRecordEvent = $A.get("e.force:createRecord");
            var qtnm=component.get("v.qtn");
        	var acid=component.get("v.accId");
            //alert('New Quote Number is eee : '+qtnm);
            //console.log('New Quote Number is : '+qtnm);
            createRecordEvent.setParams({
                "entityApiName": "Quote",
                "defaultFieldValues": {
                    'OpportunityId' : param,
                    'Quote_Number__c' : qtnm,
                    'AccountId' : acid
                }
            });
            createRecordEvent.fire(); 
        $A.get("e.force:closeQuickAction").fire();
        
    }
    
})