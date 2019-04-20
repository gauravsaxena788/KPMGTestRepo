({
    doInit : function(component, event, helper) {
        debugger;
        helper.getAccountName(component, event);
        helper.getContactName(component, event);
        component.find("lab").set("v.value","Ambernath");
        $A.util.addClass(component.find("projectdiv"), "slds-hide");
        $A.util.addClass(component.find("reasonAdditionalDiv"), "slds-hide");
        $A.util.addClass(component.find("complaintDiv"), "slds-hide");
        $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
        $A.util.addClass(component.find("otherReasonDiv"), "slds-hide");
        $A.util.removeClass(component.find("mainDiv"), "slds-hide");
        var recId = component.get("v.recordId");
        var myObjectMap = { "VA_Request_Purpose__c": "reqPurpose",
                           "VA1_Lab__c":"lab",
                           "VA_Reason__c":"reasonAdditional"
                          };
        debugger;
        helper.fetchlistPickListVal(component, myObjectMap);
        if(!$A.util.isUndefinedOrNull(recId)){
            helper.fetchExistingValues(component, event, recId);
        }
        helper.getKitPrice(component, event);
        component.set("v.isDesktop", $A.get("$Browser.formFactor") == 'DESKTOP');
        if($A.get("$Browser.formFactor") == 'DESKTOP'){
             $A.util.removeClass(component.find("modelFooter"), "slds-hide");
             $A.util.addClass(component.find("modelFooterMobile"), "slds-hide");
            
        }
        else{
            $A.util.addClass(component.find("modelFooter"), "slds-hide");
            $A.util.removeClass(component.find("modelFooterMobile"), "slds-hide");
        }
    },
    getBottlesDataFromCustomer : function (component, event, helper){
        helper.getBottleData(component, event);
    },
    setReqPurpose : function(component, event, helper){
        debugger;
        var reqPurpose = component.find("reqPurpose").get("v.value");
        component.find("reqPurpose").set("v.errors", null);
        if(reqPurpose == 'Project'){
            component.find("complaint").set("v.value",null);
            component.find("AdditionalComments").set("v.value",null);
            $A.util.addClass(component.find("complaintDiv"), "slds-hide");
            //component.set("v.isComplaint",false);
            $A.util.removeClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
        }
        else if(reqPurpose == 'Complaints'){
            component.set("v.selectedProjectrecord",null);
            component.find("AdditionalComments").set("v.value",null);
            helper.clearLookup(component);
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.removeClass(component.find("complaintDiv"), "slds-hide");
            $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
        }
        else if(reqPurpose == 'Others'){
            	$A.util.removeClass(component.find("AdditionalCommentsDiv"), "slds-hide");
            	component.set("v.selectedProjectrecord",null);
                helper.clearLookup(component);
                component.find("complaint").set("v.value","");
                $A.util.addClass(component.find("projectdiv"), "slds-hide");
                $A.util.addClass(component.find("complaintDiv"), "slds-hide");
        }
            else {
                component.set("v.selectedProjectrecord",null);
                component.find("AdditionalComments").set("v.value",null);
                helper.clearLookup(component);
                component.find("complaint").set("v.value","");
                $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
                $A.util.addClass(component.find("projectdiv"), "slds-hide");
                $A.util.addClass(component.find("complaintDiv"), "slds-hide");
            }
    },
    
    showHideOtherReason : function(component, event){
        component.find("reasonAdditional").set("v.errors", null);
        var reasonAdditional = component.find("reasonAdditional").get("v.value");
        if(!$A.util.isUndefinedOrNull(reasonAdditional) && reasonAdditional == 'Other Reason'){
            $A.util.removeClass(component.find("otherReasonDiv"), "slds-hide");
            component.set("v.isAdditionalOtherReason",true);
        }
        else{
            component.find("otherReason").set("v.value", null);
            $A.util.addClass(component.find("otherReasonDiv"), "slds-hide");
           
        }
    },
    
    showHideReason : function (component, event, helper){
        component.find("numberKit").set("v.errors", null);
        var numberOfBottleRequested = component.get("v.caseObj.VA_No_Of_Bottles_Requested__c");
        var bottleBalanceWithCustomer = component.get("v.bottleBalanceWithCustomer"); 
        if(!$A.util.isUndefinedOrNull(numberOfBottleRequested) && !$A.util.isUndefinedOrNull(bottleBalanceWithCustomer) && numberOfBottleRequested > 0 && bottleBalanceWithCustomer > 0){
            $A.util.removeClass(component.find("reasonAdditionalDiv"), "slds-hide");
        }
        else{
            component.find("reasonAdditional").set("v.value", null);
            component.find("otherReason").set("v.value", null);
            $A.util.addClass(component.find("reasonAdditionalDiv"), "slds-hide");
            $A.util.addClass(component.find("otherReasonDiv"), "slds-hide");
        }
    },
    removeAdditionalError : function (component, event, helper){
       component.find("otherReason").set("v.errors", null); 
    },
    removeAdditionalCommentError : function (component, event, helper){
       component.find("AdditionalComments").set("v.errors", null); 
    },
    removeComplaintError : function (component, event, helper) {
        component.find("complaint").set("v.errors", null); 
    },
    
    saveData : function (component, event, helper){
        //helper.throwValidationErrors(component);
        helper.savePostKitData(component, event);
    },
    
    navigateToPreviousPage : function (component, event, helper){
        debugger;
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    },
    
    hidePopup : function (component, event, helper){
        var appEvent = $A.get("e.c:ClosePostKitEvent");
        appEvent.setParams({
            "showPopUp":false
        });
        appEvent.fire();
        // $A.util.addClass(component.find("mainDiv"), "slds-hide");
    },
    
})