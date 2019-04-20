({
	doInit : function(component, event, helper) {
          var param =component.get("v.recordId");
        console.log('Quote Rec ID : '+param);
        
      var action=component.get("c.getStepone");
        action.setParams({
            "quoteId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.stepone",a.getReturnValue());
        });
        $A.enqueueAction(action);
       
        
        var action=component.get("c.getSteptwo");
         action.setParams({
            "quoteId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.steptwo",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getStepthree");
         action.setParams({
            "quoteId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.stepthree",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getStepfour");
         action.setParams({
            "quoteId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.stepfour",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getOne");
        action.setCallback(this, function(a){    
        	component.set("v.one",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var action=component.get("c.getTwo");
        action.setCallback(this, function(a){    
        	component.set("v.two",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getThree");
        action.setCallback(this, function(a){    
        	component.set("v.three",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getFour");
        action.setCallback(this, function(a){    
        	component.set("v.four",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        
         var action=component.get("c.getApprovalone");
        action.setCallback(this, function(a){    
        	component.set("v.approvalone",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var action=component.get("c.getApprovaltwo");
        action.setCallback(this, function(a){    
        	component.set("v.approvaltwo",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getApprovalthree");
        action.setCallback(this, function(a){    
        	component.set("v.approvalthree",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         var action=component.get("c.getApprovalfour");
        action.setCallback(this, function(a){    
        	component.set("v.approvalfour",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        
       
       
        
      
        
         var action=component.get("c.getStatus");
         action.setParams({
            "quoteId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.status",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var action=component.get("c.getStatus1");
         action.setParams({
            "quoteId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.status1",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        }
})