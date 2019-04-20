({
    doInit: function(component,event,helper) {
        var recordId = component.get("v.recordId");
        
        helper.myprofile(component,event,helper)
        
        if(recordId!=undefined){
            
            var action = component.get("c.getDetailsFromOrder");
            action.setParams({
                orderId: recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var ord = response.getReturnValue();
                                        
                    document.getElementById("msgdiv").style.display="none";
                    document.getElementById("orderclone").style.display="block";
                                    
                    component.set("v.ponumber", ord.PoNumber);
                    component.set("v.posdate", ord.PoDate); 
                    component.set("v.effectivedate", ord.EffectiveDate);
                    component.set("v.deliveryaddress", ord.VA_Delivery_Address__c);                        
                }
                
            });
            
            $A.enqueueAction(action);
        }
    },
    
    
    
    myAction : function (component, event, helper) {
        var orderId =  component.get("v.recordId");
        
        var ponumber =  component.get("v.ponumber");
        var posdate =  component.get("v.posdate"); 
        var effectivedate = component.get("v.effectivedate"); 
        var deliveryaddress =  component.get("v.deliveryaddress");
        
        if(ponumber=='')
        {
            alert('Please specify PO Number.');
            return false;
        }
        if(posdate=='')
        {
            alert('Please specify PO Date.');
            return false;
        }
        if(effectivedate=='')
        {
            alert('Please specify Order Start Date.');
            return false;
        }
        if(deliveryaddress=='')
        {
            alert('Please specify delivery address.');
            return false;
        }
        var str = component.get("v.profilename");
        //alert("my action profile name: "+str);
        //return false;
        
        var action = component.get("c.createOrderClone");
       
        action.setParams({
            orderId: orderId,
            posdate: posdate,
            effectivedate: effectivedate,
            ponumber: ponumber,
            deliveryaddress: deliveryaddress
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var ord = response.getReturnValue();
                if(ord.length == 18)
                {
                    alert('Success! Order has been cloned successfully.');
                    if(component.get("v.profilename").includes("Community"))
                    {
                        window.open('/customers/s/order/'+ ord + '/detail', '_self');
                    }
                    else
                    {
                        window.open('/one/one.app?#/sObject/'+ ord + '/view', '_self');                        
                    }
                    
                   
                } 
                else
                {
                    alert(ord);
                }                
            }            
        });
        
        $A.enqueueAction(action);  
        //$A.get("e.force:closeQuickAction").fire();
    },
    
    closeModal : function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }    
})