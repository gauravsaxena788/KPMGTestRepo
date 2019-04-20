({
  getCases: function(component,event,recId) {
      debugger;
        var action = component.get("c.getCases");
      	action.setParams({ "Caseid" : recId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.objCase", result);
                var cmpContact = component.find("lookupContact");
                var cmpAccount = component.find("lookupAccount");
                var cmpProduct = component.find("Product");
                
                if (result.Contact.Name != null)
                cmpContact.set('v.SearchKeyWord',result.Contact.Name);
                if (result.Account.Name != null)
                cmpAccount.set('v.SearchKeyWord',result.Account.Name);
                if (result.VA_Product__r.Name != null)
                cmpProduct.set('v.SearchKeyWord',result.VA_Product__r.Name);
                this.picklistchange(component,event);
                this.pickliststatuschange(component,event);
            }
            else if(state === "ERROR")
            {
                var errors = response.getError();
                if(errors[0] && errors[0].message)
                {
                    // System Errors
                     component.set("v.errorMessage",errors[0].message);
                }
                else if (errors[0] && errors[0].pageErrors) 
                {
                    // DML Error
                     component.set("v.errorMessage",errors[0].pageErrors);
                }
            }
        });
        $A.enqueueAction(action);
  },
    
    init : function(component, event) {
        debugger;
        
        
        
        component.find("ComplaintCategory").set("v.required", true);
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
        $A.util.addClass(component.find("divManufacturingDate"), "slds-hide");
        
 
        
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
        this.getAccountName(component, event);
        this.getContactName(component, event);
        this.fetchlistPickListVal(component, myObjectMap);
        var recId = component.get("v.recordID");
        debugger;
        if(!$A.util.isUndefinedOrNull(recId))
        {
            this.getCases(component, event,recId);
        }
        
    },

     getAccountName : function(component,event) {
        debugger;
        var recordId=component.get("v.recordId");
        var action=component.get("c.getAccountNameMethod");
        if(recordId){
            action.setParams({"strRecordId" :recordId});
        }
        else
        {
            action.setParams({"strRecordId" :""});
        }
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                debugger;
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.selectedLookUpRecord",result);
                    var cmp = component.find("lookupAccount");
                    cmp.set('v.SearchKeyWord',result.Name);
                }
            }
            
        }); 
        $A.enqueueAction(action);                    
        //} 
    },
    
    
    getContactName : function(component,event) {
        debugger;
        var action=component.get("c.getContactNameMethod");
        
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                debugger;
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.selectedLookUpRecordcon",result);
                    var cmp = component.find("lookupContact");
                    var name = result.FirstName + ' '+result.LastName;
                    cmp.set('v.SearchKeyWord',name);
                }
            }
            
        }); 
        $A.enqueueAction(action);                     
    },
    
    
      

	 /* createCase: function(component, objcase) {
	    this.upsertCase(component, objcase, function(a) {
	        var cases = component.get("v.cases");
	        cases.push(a.getReturnValue());
	        component.set("v.cases", cases);
	      });
	},

	upsertCase : function(component, objcase, callback) {
	    var action = component.get("c.saveCase");
	    action.setParams({ 
	        "case": objcase
	    });
	    if (callback) {
	      action.setCallback(this, callback);
	    }
	    $A.enqueueAction(action);

	},*/
    
    pickliststatuschange:function(component,event){
    	var cmpstaus = component.find("Status");
         var stausValue =	cmpstaus.get("v.value");
        
        if (stausValue == "On-Hold")
        {
            component.find("OnHoldReason").set("v.disabled", false); 
        }
        else
        {
            component.find("OnHoldReason").set("v.disabled", true); 
        }
    },
    
    
     waiting: function() {
        if (!$A.util.isUndefinedOrNull(document.getElementById("EDIT_CASE_PAGE"))) {
            document.getElementById("EDIT_CASE_PAGE").style.display = "block";
        }
    },
    doneWaiting: function() {


        if (!$A.util.isUndefinedOrNull(document.getElementById("EDIT_CASE_PAGE"))) {
            document.getElementById("EDIT_CASE_PAGE").style.display = "none";
        }

    },
    
    KeyPressHideError:function(component,event){
        debugger;
        var FieldName = event.getSource().getLocalId();
        this.HideErrormessage(component,FieldName);
    },
    
    
    CompaintPicklistchange:function(component, event)
    {
    	var FieldName = event.getSource().getLocalId();
        this.HideErrormessage(component,FieldName);
    	
    	 var sel = component.find("OtherComplaints");
         var nav =	sel.get("v.value");	
    
        this.HideErrormessage(component,"ComplaintDescription");
        this.HideErrormessage(component,"BatchNumber");
        this.HideErrormessage(component,"ManufacturingDate");
        
        component.set("v.objCase.VA_Complaint_Description__c","");
        component.set("v.objCase.Batch_No__c","");
        component.set("v.objCase.VA_Manufacturing_Date__c","");
        
        
    if (nav != "Statement of Account required" && nav != "TDS Certificate related query / complaint" && nav != "Debit / Credit Note pending, or wrong DN / CN released or DN / CN copy not received"  )
    {
    	$A.util.removeClass(component.find("divBatchNumber"), "slds-hide");
        $A.util.removeClass(component.find("divOtherComplaints"), "slds-hide");
        $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
    	
    	component.find("ComplaintDescription").set("v.required", true);
        component.find("BatchNumber").set("v.required", true);     
        component.find("ManufacturingDate").set("v.required", true);
    	
	}
    else
    {	
    	$A.util.addClass(component.find("divBatchNumber"), "slds-hide");
    	$A.util.addClass(component.find("divManufacturingDate"), "slds-hide");
    	$A.util.removeClass(component.find("divOtherComplaints"), "slds-hide");
    
        component.find("ComplaintDescription").set("v.required", true);
        component.find("BatchNumber").set("v.required", false);     
        component.find("ManufacturingDate").set("v.required", false);
	}
    	
	},
    
    
    picklistchange:function(component,event){
        var sel = component.find("ComplaintCategory");
        var nav =	sel.get("v.value");
         
        
        
        
       // this.init(component, event);
        
        //component.set(nav);
        
        debugger;
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
       // $A.util.addClass(component.find("productError"), "slds-hide");
        $A.util.addClass(component.find("divOtherComplaints"), "slds-hide");
        $A.util.addClass(component.find("divManufacturingDate"), "slds-hide");
		

        //var PackSize = component.find("PackSize");
        //PackSize.set("v.errors", false);
		
        component.find("Product").set("v.required", false);
        component.find("BatchNumber").set("v.required", false);
        component.find("PackSize").set("v.required", false);
        component.find("LeakageDamageobservedat").set("v.required", false);
        component.find("LeakageDamagehappenedat").set("v.required", false);
        component.find("QuantityAffected").set("v.required", false);
        component.find("Stackingpattern").set("v.required", false);
        //component.find("IsitacaseofpartloadtoRetailor").set("v.required", false);
        component.find("PhysicalSample").set("v.required", false);
        component.find("PhysicalPackSample").set("v.required", false);
        component.find("Shortageduringreceiptfrom").set("v.required", false);
        component.find("ComplaintLocation").set("v.required", false);
        component.find("WeightofPack").set("v.required", false);
        //component.find("Isthesealingintactwithimage").set("v.required", false);
        component.find("DamageobservedduringDeliveryto").set("v.required", false);
       // component.find("Isitacaseofpartload").set("v.required", false);
        component.find("MouldNumber").set("v.required", false);
        component.find("PackSizeUnit").set("v.required", false);
        component.find("WeightofPackUnit").set("v.required", false);
        component.find("ComplaintDescription").set("v.required", false);
        component.find("OtherComplaints").set("v.required", false);
        component.find("ManufacturingDate").set("v.required", false);
        
        
        this.HideErrormessage(component,"ComplaintCategory");
        this.HideErrormessage(component,"PackSize");
        //this.HideErrormessage(component,"Product");
		this.HideErrormessage(component,"BatchNumber");
		this.HideErrormessage(component,"LeakageDamageobservedat");
		this.HideErrormessage(component,"LeakageDamagehappenedat");
		this.HideErrormessage(component,"QuantityAffected");
		this.HideErrormessage(component,"Stackingpattern");
		//this.HideErrormessage(component,"IsitacaseofpartloadtoRetailor");
		this.HideErrormessage(component,"PhysicalSample");
		this.HideErrormessage(component,"PhysicalPackSample");
		this.HideErrormessage(component,"Shortageduringreceiptfrom");
		this.HideErrormessage(component,"ComplaintLocation");
		this.HideErrormessage(component,"WeightofPack");
		//this.HideErrormessage(component,"Isthesealingintactwithimage");
		this.HideErrormessage(component,"DamageobservedduringDeliveryto");
		//this.HideErrormessage(component,"Isitacaseofpartload");
		this.HideErrormessage(component,"MouldNumber");
		this.HideErrormessage(component,"PackSizeUnit");
		this.HideErrormessage(component,"WeightofPackUnit");
        this.HideErrormessage(component,"ComplaintDescription");
        this.HideErrormessage(component,"OtherComplaints");
        this.HideErrormessage(component,"ManufacturingDate");
        
        
        
        var project = component.find("Product").find("textValue");
        project.set("v.errors", null);
        
        component.set("v.objCase.VA_Complaint_Description__c","");
        component.set("v.objCase.VA_Pack_Size__c","");
        component.set("v.objCase.Batch_No__c","");
        
        component.set("v.objCase.VA_Leakage_Damage_observed_at__c","---None---");
        
        component.set("v.objCase.VA_Leakage_Damage_happened_at__c","---None---");
        component.set("v.objCase.VA_Quantity_Affected__c","");
        component.set("v.objCase.VA_Stacking_pattern__c","");
        component.set("v.objCase.VA_Is_it_a_case_of_part_load_to_Retailor__c",false);
        component.set("v.objCase.VA_Physical_Sample__c","");
        component.set("v.objCase.VA_Physical_Pack_Sample__c","");
        component.set("v.objCase.VA_Shortage_during_receipt_from__c","---None---");
		component.set("v.objCase.VA_Complaint_Location__c","");
		component.set("v.objCase.VA_Weight_of_Pack__c","");
		component.set("v.objCase.VA_Is_the_sealing_intact_with_image__c",false);
		component.set("v.objCase.VA_Damage_observed_during_Delivery_to__c","---None---");        
        component.set("v.objCase.VA_Is_it_a_case_of_part_load__c",false);        
        component.set("v.objCase.VA_Mould_Number__c","");
        component.set("v.objCase.VA_Pack_Size_Unit__c","---None---");
        component.set("v.objCase.VA_Weight_of_Pack_Unit__c","---None---");
        component.set("v.objCase.VA_Complaint_Description__c","");
        component.set("v.objCase.VA_Other_Complaints__c","---None---");
        component.set("v.objCase.VA_Manufacturing_Date__c","");
        
        var cmp = component.find("Product");
        cmp.set("v.listOfSearchRecords", null );
        cmp.set("v.selectedRecord", {} );
        cmp.set("v.SearchKeyWord",null);
        
        //component.set("v.objCase.VA_Is_it_a_case_of_part_load_to_Retailor__c","");
        
		/*this.HideErrormessage(component,"QuantityAffected");
		this.HideErrormessage(component,"Stackingpattern");
		this.HideErrormessage(component,"IsitacaseofpartloadtoRetailor");
		this.HideErrormessage(component,"PhysicalSample");
		this.HideErrormessage(component,"PhysicalPackSample");
		this.HideErrormessage(component,"Shortageduringreceiptfrom");
		this.HideErrormessage(component,"ComplaintLocation");
		this.HideErrormessage(component,"WeightofPack");
		this.HideErrormessage(component,"Isthesealingintactwithimage");
		this.HideErrormessage(component,"DamageobservedduringDeliveryto");
		this.HideErrormessage(component,"Isitacaseofpartload");
		this.HideErrormessage(component,"MouldNumber");
		this.HideErrormessage(component,"PackSizeUnit");
		this.HideErrormessage(component,"WeightofPackUnit");
        this.HideErrormessage(component,"ComplaintDescription");
        this.HideErrormessage(component,"OtherComplaints");*/
        


        if (nav == "Leak From Pack - Hdpe Bottle /Pail/Ppcp Buckets/Carbuoy/Barrels" || nav == "Pack Damage During Storage & Handling") 
		{    
             $A.util.removeClass(component.find("divProduct"), "slds-hide");
             $A.util.removeClass(component.find("divBatchNumber"), "slds-hide");
			 $A.util.removeClass(component.find("divPackSize"), "slds-hide");
			 $A.util.removeClass(component.find("divLeakageDamageobservedat"), "slds-hide");			 
			 $A.util.removeClass(component.find("divLeakageDamagehappenedat"), "slds-hide");			 
			 $A.util.removeClass(component.find("divQuantityAffected"), "slds-hide");			
			 $A.util.removeClass(component.find("divStackingpattern"), "slds-hide");			 
			 $A.util.removeClass(component.find("divIsitacaseofpartloadtoRetailor"), "slds-hide");
			 $A.util.removeClass(component.find("divPhysicalSample"), "slds-hide");
             $A.util.removeClass(component.find("divPhysicalPackSample"), "slds-hide");
            $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            $A.util.removeClass(component.find("divMouldNumber"), "slds-hide");
            $A.util.removeClass(component.find("divPackDamageInformation"), "slds-hide");
            $A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
        	
       	    component.find("BatchNumber").set("v.required", true);
            component.find("PackSize").set("v.required", true);
            component.find("LeakageDamageobservedat").set("v.required", true);
            component.find("LeakageDamagehappenedat").set("v.required", true);
            component.find("QuantityAffected").set("v.required", true);
            component.find("Stackingpattern").set("v.required", true);
           // component.find("IsitacaseofpartloadtoRetailor").set("v.required", true);
            component.find("PhysicalSample").set("v.required", true);
            component.find("PhysicalPackSample").set("v.required", true);
            component.find("Product").set("v.required", true);
            component.find("MouldNumber").set("v.required", true);
            component.find("PackSizeUnit").set("v.required", true);
            component.find("ManufacturingDate").set("v.required", true);
         }
        
		if (nav == "Short pack")
		{
			 $A.util.removeClass(component.find("divProduct"), "slds-hide");
        	 $A.util.removeClass(component.find("divBatchNumber"), "slds-hide")
             $A.util.removeClass(component.find("divPackSize"), "slds-hide");
             $A.util.removeClass(component.find("divShortageduringreceiptfrom"), "slds-hide");
             $A.util.removeClass(component.find("divComplaintLocation"), "slds-hide");
             $A.util.removeClass(component.find("divQuantityAffected"), "slds-hide");
             $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            
           $A.util.removeClass(component.find("divShortPackInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            
             component.find("BatchNumber").set("v.required", true);
             component.find("PackSize").set("v.required", true);
             component.find("Shortageduringreceiptfrom").set("v.required", true);
             component.find("ComplaintLocation").set("v.required", true);
             component.find("QuantityAffected").set("v.required", true);
			 component.find("Product").set("v.required", true);
			 component.find("PackSizeUnit").set("v.required", true);            
			 component.find("ManufacturingDate").set("v.required", true);	            
		}
		
		
		if (nav == "Short Product Quantity")
		{
			$A.util.removeClass(component.find("divProduct"), "slds-hide");
			$A.util.removeClass(component.find("divBatchNumber"), "slds-hide")
			$A.util.removeClass(component.find("divPackSize"), "slds-hide");
			$A.util.removeClass(component.find("divWeightofPack"), "slds-hide");
			$A.util.removeClass(component.find("divIsthesealingintactwithimage"), "slds-hide");
            $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            $A.util.removeClass(component.find("divWeightofPackUnit"), "slds-hide");
        	$A.util.removeClass(component.find("divShortProductQuantityInformation"), "slds-hide");
        	//$A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            component.find("BatchNumber").set("v.required", true); 
            component.find("PackSize").set("v.required", true); 
            component.find("WeightofPack").set("v.required", true); 
            //component.find("Isthesealingintactwithimage").set("v.required", true);
            component.find("Product").set("v.required", true);
            component.find("PackSizeUnit").set("v.required", true);
            component.find("WeightofPackUnit").set("v.required", true);
            component.find("ManufacturingDate").set("v.required", true);
		}
		
		
		if (nav == "Coupon Defect")
		{
			$A.util.removeClass(component.find("divProduct"), "slds-hide");
			$A.util.removeClass(component.find("divBatchNumber"), "slds-hide")
			$A.util.removeClass(component.find("divPackSize"), "slds-hide");
			$A.util.removeClass(component.find("divQuantityAffected"), "slds-hide");
            $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            $A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            component.find("BatchNumber").set("v.required", true); 
            component.find("PackSize").set("v.required", true); 
            component.find("QuantityAffected").set("v.required", true); 
			component.find("Product").set("v.required", true);
            component.find("PackSizeUnit").set("v.required", true); 
            component.find("ManufacturingDate").set("v.required", true);
		}
		
		
		if (nav == "Transit Damage")
		{
			$A.util.removeClass(component.find("divProduct"), "slds-hide");
			$A.util.removeClass(component.find("divBatchNumber"), "slds-hide")
			$A.util.removeClass(component.find("divPackSize"), "slds-hide");
			$A.util.removeClass(component.find("divQuantityAffected"), "slds-hide");
			$A.util.removeClass(component.find("divStackingpattern"), "slds-hide");
			$A.util.removeClass(component.find("divDamageobservedduringDeliveryto"), "slds-hide");
			$A.util.removeClass(component.find("divIsitacaseofpartload"), "slds-hide");
            $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            $A.util.removeClass(component.find("divTransitDamage"), "slds-hide");
            $A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            component.find("BatchNumber").set("v.required", true); 
            component.find("PackSize").set("v.required", true); 
            component.find("QuantityAffected").set("v.required", true); 
            component.find("Stackingpattern").set("v.required", true); 
            component.find("DamageobservedduringDeliveryto").set("v.required", true); 
            //component.find("Isitacaseofpartload").set("v.required", true); 
            component.find("Product").set("v.required", true);
            component.find("PackSizeUnit").set("v.required", true);   
            component.find("ManufacturingDate").set("v.required", true);
            
		}
		
		if (nav == "Foul Smell/ Color")
		{
			$A.util.removeClass(component.find("divProduct"), "slds-hide");
			$A.util.removeClass(component.find("divBatchNumber"), "slds-hide")
			$A.util.removeClass(component.find("divPackSize"), "slds-hide");
			$A.util.removeClass(component.find("divPhysicalSample"), "slds-hide");	
            $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            $A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            component.find("BatchNumber").set("v.required", true); 
            component.find("PackSize").set("v.required", true); 
            component.find("PhysicalSample").set("v.required", true);
            component.find("Product").set("v.required", true);
            component.find("PackSizeUnit").set("v.required", true); 
            component.find("ManufacturingDate").set("v.required", true);
		}
		
		if (nav == "Engine Seizure" || nav == "High Oil Consumption" || nav == "Engine Wear & Tear" || nav == "Engine Abnormal Sounds" )
		{	
            $A.util.removeClass(component.find("divProduct"), "slds-hide");
			$A.util.removeClass(component.find("divBatchNumber"), "slds-hide")
			$A.util.removeClass(component.find("divPackSize"), "slds-hide");
			$A.util.removeClass(component.find("divPhysicalSample"), "slds-hide");	
            $A.util.removeClass(component.find("divPackSizeUnit"), "slds-hide");
            $A.util.removeClass(component.find("divAdditionalInformation"), "slds-hide");
        	$A.util.removeClass(component.find("divCommonInformation"), "slds-hide");
            $A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            component.find("BatchNumber").set("v.required", true); 
            component.find("PackSize").set("v.required", true); 
            component.find("PhysicalSample").set("v.required", true); 
            component.find("Product").set("v.required", true);
            component.find("PackSizeUnit").set("v.required", true);  
            component.find("ManufacturingDate").set("v.required", true);
		}
        
        if (nav == "Other Complaints")
        {
			//$A.util.removeClass(component.find("divBatchNumber"), "slds-hide");
            $A.util.removeClass(component.find("divOtherComplaints"), "slds-hide");
            //$A.util.removeClass(component.find("divManufacturingDate"), "slds-hide");
            
            component.find("ComplaintDescription").set("v.required", true);
        	component.find("OtherComplaints").set("v.disabled", false); 
            //component.find("BatchNumber").set("v.required", true); 
            component.find("OtherComplaints").set("v.required", true); 
           // component.find("ManufacturingDate").set("v.required", true);
        }
        else
        {
            component.find("OtherComplaints").set("v.disabled", true); 
        }
        
        
         
		
    },
    
	
    FireErrormessage:function(component,FieldName,ErrorMesage){        
        //sErrorMsg = 'Complaint Category is reuired.\n ' ;
        
            var Field = component.find(FieldName);
            Field.set("v.errors", [{
                message: ErrorMesage
            }]);
        },
		
		HideErrormessage:function(component,FieldName){        
        //sErrorMsg = 'Complaint Category is reuired.\n ' ;
        
            var Field = component.find(FieldName);
            Field.set("v.errors", null);
            
        },
    
    OutputtextColorChange : function(component) {
        debugger;
        var outtext = component.find("productError");
        $A.util.removeClass(component.find("productError"), "slds-hide");
        //$A.util.addClass(outtext, "textClass");
        
    },

    createCase : function(component, event) {
        debugger;
        component.set("v.objCase.AccountId",component.get("v.selectedLookUpRecord.Id"));
        component.set("v.objCase.ContactId",component.get("v.selectedLookUpRecordcon.Id"));
        component.set("v.objCase.VA_Product__c",component.get("v.selectedLookUpRecordpro.Id"));
        
        var newCase = component.get('v.objCase');
        var isValid=true;
        var sErrorMsg ="";
        //sErrorMsg = "Please fill all the required field";
		
        if (!newCase.VA_Complaint_Category__c)
        {
            isValid = false;
            this.FireErrormessage(component,"ComplaintCategory","Please enter Complaint Category.");
        }

        if  (newCase.VA_Complaint_Category__c == "Leak From Pack - Hdpe Bottle /Pail/Ppcp Buckets/Carbuoy/Barrels" || newCase.VA_Complaint_Category__c =="Pack Damage During Storage & Handling")
        {
           if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Leakage_Damage_observed_at__c || !newCase.VA_Leakage_Damage_happened_at__c || !newCase.VA_Quantity_Affected__c || !newCase.VA_Stacking_pattern__c || !newCase.VA_Physical_Sample__c || !newCase.VA_Physical_Pack_Sample__c || ! newCase.VA_Product__c || !newCase.VA_Mould_Number__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Manufacturing_Date__c)
        	{				
                isValid = false;  
                
        	}   
			
           if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
            
        	if (!newCase.Batch_No__c )
        	{				
                
				this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
           
                
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
            
             if (!newCase.VA_Leakage_Damage_observed_at__c)
            {
           
				this.FireErrormessage(component,"LeakageDamageobservedat","Please enter Leakage Damage observed at.");
            }
            
            if (!newCase.VA_Leakage_Damage_happened_at__c)
            {
				this.FireErrormessage(component,"LeakageDamagehappenedat","Please enter Leakage Damage happened at.");
            }
            
            if (!newCase.VA_Quantity_Affected__c)
            {
                this.FireErrormessage(component,"QuantityAffected","Please enter Quantity Affected.");										  
            }
            
            if (!newCase.VA_Stacking_pattern__c)
            {
				this.FireErrormessage(component,"Stackingpattern","Please enter Stacking pattern.");
            }
            
            //if (!newCase.VA_Is_it_a_case_of_part_load_to_Retailor__c)
            //{
               // sErrorMsg +=  'Is it a case of part load to Retailor is reuired. \n ';
     
			//	this.FireErrormessage(component,"IsitacaseofpartloadtoRetailor","Please enter Is it a case of part load to Retailor.");
                                                         
            //}
            
            if (!newCase.VA_Physical_Sample__c)
            {
                //sErrorMsg +=  'Physical Sample is reuired. \n ';
				this.FireErrormessage(component,"PhysicalSample","Please enter Physical Sample.");
            }
            
            if (!newCase.VA_Product__c)
            {
                //sErrorMsg +=  'Product is reuired. \n ';
				//this.FireErrormessage(component,"Product","Please enter Product.");
                //this.OutputtextColorChange(component);
                var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
                                                         
            }
            
            if (!newCase.VA_Mould_Number__c)
            {
                //sErrorMsg +=   'Mould Number is reuired. \n ';
				this.FireErrormessage(component,"MouldNumber","Please enter Mould Number.");
            }
            
            if (!newCase.VA_Pack_Size_Unit__c)
            {
                //sErrorMsg +=  'Pack Size Unit is reuired. \n ';
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
            }
            if (!newCase.VA_Physical_Pack_Sample__c)
            {
                //sErrorMsg +=  'Pack Size Unit is reuired. \n ';
				this.FireErrormessage(component,"PhysicalPackSample","Please enter Physical Pack Sample.");
            }
            
            
        }
        
        if  (newCase.VA_Complaint_Category__c == "Short pack")
        {
            if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Shortage_during_receipt_from__c || !newCase.VA_Complaint_Location__c || !newCase.VA_Quantity_Affected__c || !newCase.VA_Product__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Manufacturing_Date__c )
        	{	
                isValid = false;  
        	}   
            
            if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
            
            if (!newCase.Batch_No__c )
        	{				
                this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size is reuired. \n ";
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
            
            if (!newCase.VA_Shortage_during_receipt_from__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Shortage during receipt from is reuired. \n ";
				this.FireErrormessage(component,"Shortageduringreceiptfrom","Please enter Shortage during receipt from.");
            }
            
            if (!newCase.VA_Complaint_Location__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Complaint Location is reuired. \n ";
				this.FireErrormessage(component,"ComplaintLocation","Please enter Complaint Location.");
            }
            
            if (!newCase.VA_Quantity_Affected__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Quantity Affected is reuired. \n ";
				this.FireErrormessage(component,"QuantityAffected","Please enter Quantity Affected.");

            }
            
            if (!newCase.VA_Product__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Product is reuired. \n ";
				//this.FireErrormessage(component,"Product","Please enter Product.");
				//this.OutputtextColorChange(component);
				var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
            }
            
            if (!newCase.VA_Pack_Size_Unit__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size Unit is reuired. \n ";
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
            }
        }
        
        if  (newCase.VA_Complaint_Category__c == "Short Product Quantity")
        {
        	if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Weight_of_Pack__c  || !newCase.VA_Product__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Weight_of_Pack_Unit__c || !newCase.VA_Manufacturing_Date__c)
        	{
				
                isValid = false;
                
        	}   
            
            
            if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
            
             if (!newCase.Batch_No__c )
        	{				
                //sErrorMsg = "Please fill the Batch No. in the form of {Batch No.- MM/YY}. \n " ;
				this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size is reuired. \n ";
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
            
            if (!newCase.VA_Weight_of_Pack__c)
            {
                //sErrorMsg = sErrorMsg + "Weight of Pack is reuired. \n "; 
				this.FireErrormessage(component,"WeightofPack","Please enter Weight of Pack.");
            }
            
            /*if(!newCase.VA_Is_the_sealing_intact_with_image__c)
            {
                //sErrorMsg = sErrorMsg + "Is the sealing intact with image is reuired. \n ";
				this.FireErrormessage(component,"Isthesealingintactwithimage","Please enter Is the sealing intact with image.");
            }*/
            
            
            if(!newCase.VA_Product__c)
            { 
				//sErrorMsg = sErrorMsg + "Product is reuired. \n ";                
				//this.FireErrormessage(component,"Product","Please enter Product.");
				//this.OutputtextColorChange(component);
				var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
            }
            
            if (!newCase.VA_Pack_Size_Unit__c)
            {
                //sErrorMsg = sErrorMsg + "Pack Size Unit is reuired. \n ";
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
            }
            
            if(!newCase.VA_Weight_of_Pack_Unit__c)
            {
                //sErrorMsg = sErrorMsg + "Weight of Pack Unit is reuired. \n ";
				this.FireErrormessage(component,"WeightofPackUnit","Please enter Weight of Pack Unit.");
				
            }
			
            
        }
        
		if  (newCase.VA_Complaint_Category__c == "Coupon Defect")
		{
			if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Quantity_Affected__c || !newCase.VA_Product__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Manufacturing_Date__c)
        	{
				
                isValid = false;
                
        	}
            
            if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
			
			 if (!newCase.Batch_No__c )
        	{				
                //sErrorMsg = "Please fill the Batch No. in the form of {Batch No.- MM/YY}. \n " ;
				this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size is reuired. \n ";
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
			
			if (!newCase.VA_Quantity_Affected__c)
            {
                 
                sErrorMsg = sErrorMsg + "Quantity Affected is reuired. \n ";
				this.FireErrormessage(component,"QuantityAffected","Please enter Quantity Affected.");
            }
			
			 if(!newCase.VA_Product__c)
            { 
				//sErrorMsg = sErrorMsg + "Product is reuired. \n ";                
				//this.FireErrormessage(component,"Product","Please enter Product.");
				//this.OutputtextColorChange(component);
				var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
            }
            
            if (!newCase.VA_Pack_Size_Unit__c)
            {
                //sErrorMsg = sErrorMsg + "Pack Size Unit is reuired. \n ";
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
            }
			
			
		
		}
		
		if  (newCase.VA_Complaint_Category__c == "Transit Damage")
		{
			if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Quantity_Affected__c  || !newCase.VA_Stacking_pattern__c || !newCase.VA_Damage_observed_during_Delivery_to__c  || !newCase.VA_Product__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Manufacturing_Date__c)
        	{
				
                isValid = false;
                
        	} 
			
            if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
            
			 if (!newCase.Batch_No__c )
        	{				
                //sErrorMsg = "Please fill the Batch No. in the form of {Batch No.- MM/YY}. \n " ;
				this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size is reuired. \n ";
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
			
			if (!newCase.VA_Quantity_Affected__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Quantity Affected is reuired. \n ";
				this.FireErrormessage(component,"QuantityAffected","Please enter Quantity Affected.");

            }
			
			if (!newCase.VA_Stacking_pattern__c)
			{
				//sErrorMsg = sErrorMsg + "Stacking pattern is reuired. \n ";
				this.FireErrormessage(component,"Stackingpattern","Please enter Stacking pattern.");
			}
			
			if (!newCase.VA_Damage_observed_during_Delivery_to__c)
			{
				//sErrorMsg = sErrorMsg + "Damage observed during Delivery to is reuired. \n ";
				this.FireErrormessage(component,"DamageobservedduringDeliveryto","Please enter Damage observed during Delivery to.");
			}
			
			/*if (!newCase.VA_Is_it_a_case_of_part_load__c)
			{
				//sErrorMsg = sErrorMsg + "Is it a case of part load is reuired. \n ";
				this.FireErrormessage(component,"Isitacaseofpartload","Please enter Is it a case of part load.");
			}*/
			
			if(!newCase.VA_Product__c)
			{
				//sErrorMsg = sErrorMsg + "Product is reuired. \n";
				//this.FireErrormessage(component,"Product","Please enter Product.");
				//this.OutputtextColorChange(component);
                var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
			}
			
			if (!newCase.VA_Pack_Size_Unit__c)
			{
				//sErrorMsg = sErrorMsg + "Pack_Size_Unit is reuired. \n";
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
			}			
		
		}
		
		
		if  (newCase.VA_Complaint_Category__c == "Foul Smell/ Color")
		{
			if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Physical_Sample__c  || !newCase.VA_Product__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Manufacturing_Date__c)
        	{
				
                isValid = false;
                
        	} 
			
            if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
            
			 if (!newCase.Batch_No__c )
        	{				
                //sErrorMsg = "Please fill the Batch No. in the form of {Batch No.- MM/YY}. \n " ;
				this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size is reuired. \n ";
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
			
			if (!newCase.VA_Physical_Sample__c)
			{
				//sErrorMsg = sErrorMsg + "Physical Sample is reuired. \n";
				this.FireErrormessage(component,"PhysicalSample","Please enter Physical Sample.");
			}
			
			if(!newCase.VA_Product__c)
			{
				//sErrorMsg = sErrorMsg + "Product is reuired. \n";
				//this.FireErrormessage(component,"Product","Please enter Product.");
				//this.OutputtextColorChange(component);
                var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
			}
			
			if (!newCase.VA_Pack_Size_Unit__c)
			{
				//sErrorMsg = sErrorMsg + "Pack_Size_Unit is reuired. \n";
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
			}			
			
			
		
		}
        
		if (newCase.VA_Complaint_Category__c == "Engine Seizure" || newCase.VA_Complaint_Category__c == "High Oil Consumption" || newCase.VA_Complaint_Category__c == "Engine Wear & Tear" || newCase.VA_Complaint_Category__c == "Engine Abnormal Sounds" )
        {
		if (!newCase.Batch_No__c || !newCase.VA_Pack_Size__c || !newCase.VA_Physical_Sample__c  || !newCase.VA_Product__c || !newCase.VA_Pack_Size_Unit__c || !newCase.VA_Manufacturing_Date__c)
        	{
                isValid = false;
        	}  
            
            if (!newCase.VA_Manufacturing_Date__c)
           {
               this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
           }
			
			if (!newCase.Batch_No__c )
        	{				
                //sErrorMsg = "Please fill the Batch No. in the form of {Batch No.- MM/YY}. \n " ;
				this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
        	}   
            
            if (!newCase.VA_Pack_Size__c)
            {
                 
                //sErrorMsg = sErrorMsg + "Pack Size is reuired. \n ";
				this.FireErrormessage(component,"PackSize","Please enter PackSize.");
            }
			
			if (!newCase.VA_Physical_Sample__c)
			{
				//sErrorMsg = sErrorMsg + "Physical Sample is reuired. \n";
				this.FireErrormessage(component,"PhysicalSample","Please enter Physical Sample.");
			}
			
			if(!newCase.VA_Product__c)
			{
				//sErrorMsg = sErrorMsg + "Product is reuired. \n";
				//this.FireErrormessage(component,"Product","Please enter Product.");
				//this.OutputtextColorChange(component);
				var project = component.find("Product").find("textValue");
                project.set("v.errors", [{message: 'Please select a Product'}]);
			}
			
			if (!newCase.VA_Pack_Size_Unit__c)
			{
				//sErrorMsg = sErrorMsg + "Pack_Size_Unit is reuired. \n";
				this.FireErrormessage(component,"PackSizeUnit","Please enter Pack Size Unit.");
			}					
		}
 
        if (newCase.VA_Complaint_Category__c == "Other Complaints")
        {  
            if (newCase.VA_Other_Complaints__c)
            {
                if (newCase.VA_Other_Complaints__c != "Statement of Account required" && newCase.VA_Other_Complaints__c != "TDS Certificate related query / complaint" && newCase.VA_Other_Complaints__c != "Debit / Credit Note pending, or wrong DN / CN released or DN / CN copy not received"  )
                {    
                    if (!newCase.Batch_No__c || !newCase.VA_Complaint_Description__c || !newCase.VA_Manufacturing_Date__c  )
                    {
                        isValid = false;               
                    }
                    
                    if (!newCase.VA_Manufacturing_Date__c)
                    {
                        this.FireErrormessage(component,"ManufacturingDate","Please fill the Manufacturing Date.");
                    }
                    if (!newCase.Batch_No__c)
                    {
                        this.FireErrormessage(component,"BatchNumber","Please fill the Batch No. in the form of {Batch No.- MM/YY}.");
                    }
                    
                    if (!newCase.VA_Complaint_Description__c)
                    {
                        this.FireErrormessage(component,"ComplaintDescription","Please fill the Complaint Description.");
                    }  
            }
            else
            {
                if (!newCase.VA_Complaint_Description__c)
                {
                    isValid = false;
                }
              
                if (!newCase.VA_Complaint_Description__c)
                {
                    this.FireErrormessage(component,"ComplaintDescription","Please fill the Complaint Description.");
                }   
          	}
           
        	}
         else
           {
			isValid = false;
            this.FireErrormessage(component,"VA_Other_Complaints__c","Please fill the Other Complaints.");               
           }     
       }
        
                    if(!isValid){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "ERROR",
                message: "Please fill all mandatory field in order to proceed.",
               // mode : 'sticky',
                type : 'error'
                
                
            });
            toastEvent.fire(); 
        return;	    
        }
        
        this.waiting();
        console.log(newCase);
        console.log(component.get("v.selectedLookUpRecordpro.Id"));
	    var action = component.get("c.saveCase");
      
	    action.setParams({ 
	        "objCase": newCase
	    });
	    action.setCallback(this, function(actionresult) {
            debugger;
            var state = actionresult.getState();
            if(state === "SUCCESS")
            {
                var result =actionresult.getReturnValue();
                
                if (result.indexOf("500") >-1)
                {
                     var toastEvent = $A.get("e.force:showToast");
                    	toastEvent.setParams({
                        tittle:"SUCCESS",
                        message: "Case Successfully Created.",
                        //mode : 'sticky',
                        type : 'SUCCESS'
                            });
                    toastEvent.fire(); 
                }
                
                else
                    {
                        var errorvalue = result.indexOf('Error:');
                        if (errorvalue != -1) 
                        {
                            if(result.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION"))
                            {
                                var stringtoDisplay = result.match("FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*):");
                                 var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                    tittle:"Error",
                                    message: String(stringtoDisplay[1]),   
                                    type : 'ERROR'
                                        });
                    toastEvent.fire(); 
                                //this.showToast(component, 'ERROR', String(stringtoDisplay[1]), 'error');
                                this.doneWaiting();
                                return;
                            }
                            else
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                tittle:"Error",
                                message: "An error has occurred.Please contact your system administrator if this problem persists.",
                                //mode : 'sticky',
                                type : 'error'
                                });
                                toastEvent.fire(); 
                                this.doneWaiting();
                                return;	    
                            }
                        }
                    }

                console.log(result);
                component.set("v.recordId",result);
                
                var navigationSObject = $A.get("e.force:navigateToSObject");
                navigationSObject.setParams({
                    "recordId": result,
                    "slideDevName": "detail"
                });
                navigationSObject.fire(); 
                
                //component.set("v.recordId",result);
                //this.navigate(component, event, result);
                
            }
            else if(state === "ERROR")
            {
                var errors = actionresult.getError();
                
                if(!isValid)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Required Field Missing.. !",
                        message: errors,
                        //mode : 'sticky',
                        type : 'error'
                        
                    });
                    toastEvent.fire(); 
                    this.doneWaiting();
                    return;	    
        		}
                
            }
            this.doneWaiting();
        }); 
	    $A.enqueueAction(action);
	},
        
        
    
    
    navigate: function(component, event, recId) {
        debugger;
        if (recId.indexOf("500") >-1) { //Note 500 is prefix for Case Record
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/case/'+recId
            });
            urlEvent.fire();
        }
    },
    
    
    getId : function () {
        var query = location.search.substr(1);
        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });
       
        return result.id;
    },
    
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        alert('<<hi>>');
        action.setParams({
            //"objObject": component.get("v.newCase"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                debugger;
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },

    
    
    fetchlistPickListVal: function(component, myObjectMap) {
        var action = component.get("c.fetchlistPickListVals");
        debugger;
        action.setParams({
            //"objObject": component.get("v.newCase"),
            "mapfld": myObjectMap
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 				debugger;
                for (var p in allValues) {
                 	opts = [];
                if (allValues[p] != undefined && allValues[p].length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                
                    
                for (var i = 0; i < allValues[p].length; i++) {
                    var value = allValues[p][i];
                    opts.push({
                        class: "optionClass",
                        label: allValues[p][i],
                        value: allValues[p][i]
                    });
                }
                    component.find(p).set("v.options", opts);     
                }
                
            }
        });
        $A.enqueueAction(action);
    }
    
    

})