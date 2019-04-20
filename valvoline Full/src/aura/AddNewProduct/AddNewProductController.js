({    
    doInit : function(component, event, helper) {
        var param =component.get("v.recordId");
        //console.log('ACC Rec ID : '+param);
        var action=component.get("c.findAllNew");
        action.setParams({
            "QuoteId" : param
        });
        action.setCallback(this, function(a){
            
            var resultLst=a.getReturnValue();
            //alert(resultLst);
            if(resultLst == false)
            {               
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message"," Products can be added in draft stage only.");
            }
            else
            {
                component.set("v.message", "Are you sure you want to proceed ?");
            }
                       
        });
        
        $A.enqueueAction(action);
    },
    
	myAction : function(component, event, helper) {
		var param =component.get("v.recordId");
        //window.open("/c/AddProduct.app?recordId="+param);
        window.open("/apex/Product_Page?recordId="+param);
        $A.get("e.force:closeQuickAction").fire();		
	}
})