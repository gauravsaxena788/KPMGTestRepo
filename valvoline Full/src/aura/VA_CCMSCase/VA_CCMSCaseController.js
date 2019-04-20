({
    init : function(component, event, helper) {
        
        /*component.find("ComplaintCategory").set("v.required", true);
        //$A.util.addClass(component.find("productError"), "slds-hide");
        
        $A.util.addClass(component.find("divBatchNumber"), "slds-hide");
        $A.util.addClass(component.find("divPackSize"), "slds-hide");
        $A.util.addClass(component.find("divLeakageDamageobservedat"), "slds-hide");
        $A.util.addClass(component.find("divLeakageDamagehappenedat"), "slds-hide");			 
        $A.util.addClass(component.find("divQuantityAffected"), "slds-hide");			
        $A.util.addClass(component.find("divStackingpattern"), "slds-hide");
        $A.util.addClass(component.find("divIsitacaseofpartloadtoRetailor"), "slds-hide");
        $A.util.addClass(component.find("divPhysicalPackSample"), "slds-hide");
        $A.util.addClass(component.find("divShortageduringreceiptfrom"), "slds-hide");
        $A.util.addClass(component.find("divComplaintLocation"), "slds-hide");
        $A.util.addClass(component.find("divWeightofPack"), "slds-hide");
		$A.util.addClass(component.find("divIsthesealingintactwithimage"), "slds-hide");
        $A.util.addClass(component.find("divDamageobservedduringDeliveryto"), "slds-hide");
        $A.util.addClass(component.find("divIsitacaseofpartload"), "slds-hide");
        $A.util.addClass(component.find("divPhysicalSample"), "slds-hide");
        $A.util.addClass(component.find("divProduct"), "slds-hide");
        $A.util.addClass(component.find("divPackSizeUnit"), "slds-hide");
        $A.util.addClass(component.find("divMouldNumber"), "slds-hide");
        $A.util.addClass(component.find("divWeightofPackUnit"), "slds-hide");
		$A.util.addClass(component.find("divShortPackInformation"), "slds-hide");
        $A.util.addClass(component.find("divShortProductQuantityInformation"), "slds-hide");
        $A.util.addClass(component.find("divTransitDamage"), "slds-hide");
        $A.util.addClass(component.find("divPackDamageInformation"), "slds-hide");
        $A.util.addClass(component.find("divAdditionalInformation"), "slds-hide");
        $A.util.addClass(component.find("divCommonInformation"), "slds-hide");
        $A.util.addClass(component.find("productError"), "slds-hide");
        $A.util.addClass(component.find("divOtherComplaints"), "slds-hide");
 
        
       var myObjectMap = { "VA_Complaint_Category__c": "ComplaintCategory",
                           "VA_Other_Complaints__c": "OtherComplaints", 
                           //"VA_Customer_Closure_Consent__c":"CustomerClosureConsent",
                           "VA_Physical_Sample__c":"PhysicalSample",
                           "VA_Pack_Size_Unit__c":"PackSizeUnit", 
                           "VA_Leakage_Damage_observed_at__c":"LeakageDamageobservedat",
                           "VA_Leakage_Damage_happened_at__c":"LeakageDamagehappenedat",
                           "VA_Physical_Pack_Sample__c":"PhysicalPackSample",
                           "VA_Shortage_during_receipt_from__c":"Shortageduringreceiptfrom",
                           "VA_Weight_of_Pack_Unit__c":"WeightofPackUnit",
                           "VA_Damage_observed_during_Delivery_to__c":"DamageobservedduringDeliveryto",
                           //"Origin":"CaseOrigin",
                           //"Status":"Status",
                           //"VA_On_Hold_Reason__c":"OnHoldReason",
                           //"Priority":"Priority",
                           //"VA_Root_Cause__c":"RootCause",
                          };  
        helper.getAccountName(component, event);
        helper.getContactName(component, event);
        helper.fetchlistPickListVal(component, myObjectMap);
        var recId = component.get("v.recordID");
        debugger;
        if(!$A.util.isUndefinedOrNull(recId))
        {
            helper.getCases(component, event,recId);
        }*/
        
        helper.init(component, event);
          
    },
	
    CompaintPicklistchange:function(component, event, helper) {
		helper.CompaintPicklistchange(component, event);
	},
    
	createCase : function(component, event, helper) {
		helper.createCase(component, event);
	},
    
    picklistchange:function(component,event,helper){
    	helper.picklistchange(component,event);
	},
    
    KeyPressHideError:function(component,event,helper){
        debugger;
        helper.KeyPressHideError(component,event);
    },
    
    navigateToPreviousPage : function (component, event, helper){
        //alert('hiii');
        var modalCloseEvt = component.getEvent("ModalCloseEvent");
 		modalCloseEvt.fire();
    },
    pickliststatuschange:function(component,event,helper){
    	helper.pickliststatuschange(component,event);
	}

})