({    
    doInit : function(component, event, helper) {
        var param =component.get("v.recordId");
        var device = $A.get("$Browser.formFactor");
        
        var action=component.get("c.findAllNew");
        action.setParams({
            "QuoteId" : param
        });
        action.setCallback(this, function(a){
            if(device == 'DESKTOP'){
            var resultLst=a.getReturnValue();
            //alert(resultLst);
            if(resultLst == false)
            {               
                var cmpTarget = component.find('btn');
                var cmpclosebuttonTarget = component.find('btnclose');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                $A.util.removeClass(cmpclosebuttonTarget, 'slds-hide');
                $A.util.addClass(cmpclosebuttonTarget, 'slds-show');
                component.set("v.message","Products can be added in draft stage only.");
            }
            else
            {
                component.set("v.message", "Are you sure you want to proceed ?");
            }
            }
            else{
            	var cmpTarget = component.find('btn');
                var cmpclosebuttonTarget = component.find('btnclose');
                //$A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                $A.util.removeClass(cmpclosebuttonTarget, 'slds-hide');
                $A.util.addClass(cmpclosebuttonTarget, 'slds-show');
                component.set("v.message","Products can't be added from mobile/tablet.");
        }
                       
        });
        
        $A.enqueueAction(action);
        
        
    },
    
	myAction : function(component, event, helper) {
		var param = component.get("v.recordId");
         var device = $A.get("$Browser.formFactor");
        if(device == 'DESKTOP'){
            if(component.get("v.message") != 'Products can be added in draft stage only.')
                window.open("/ID/apex/VCPL_ProductAddPage?recordId="+param);
        }
        $A.get("e.force:closeQuickAction").fire();		
	}
})