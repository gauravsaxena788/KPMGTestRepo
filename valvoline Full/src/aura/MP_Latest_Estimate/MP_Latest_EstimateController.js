({
    doInit : function(component, event, helper) {
        var param =component.get("v.recordId");
        //console.log('ACC Rec ID : '+param);
        var action=component.get("c.findAllNew");
        action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){
            var resultLst=a.getReturnValue(); 
            console.log('resultLst : '+resultLst);
            if(resultLst == 'result1')
            {               
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message"," You cannot submit Latest Estimate");
                
            }
            else{
            if(resultLst == 'result2')
            {  
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-hide');
                $A.util.addClass(cmpTarget, 'slds-show');
                component.set("v.message"," Are you sure you want to proceed ? ");

            }
            else{     
                                
                var cmpTarget = component.find('btn');
                $A.util.removeClass(cmpTarget, 'slds-show');
                $A.util.addClass(cmpTarget, 'slds-hide');
                component.set("v.message","Monthly plans are not Added, First add monthly plans and then try for Latest estimate");                              

               }                   
            }
        });
        
        $A.enqueueAction(action);
    },
        
    myAction : function(component, event, helper) {
         var param =component.get("v.recordId");
       
        //window.open("/c/MP_Latest_EstimateApp.app?recordId="+param);
        window.open("/apex/LatestEstimate?recordId="+param);
        $A.get("e.force:closeQuickAction").fire();
 }
            
            
})