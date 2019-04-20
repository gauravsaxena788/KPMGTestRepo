({
    doInit: function(component, event, helper) {
        helper.getAccountName(component, event);
        helper.getContactName(component, event);
        component.find("lab").set("v.value", "Ambernath");
        $A.util.addClass(component.find("projectdiv"), "slds-hide");
        $A.util.addClass(component.find("reasonAdditionalDiv"), "slds-hide");
        $A.util.addClass(component.find("complaintDiv"), "slds-hide");
        $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
        $A.util.addClass(component.find("otherSampleDiv"), "slds-hide");
        $A.util.removeClass(component.find("mainDiv"), "slds-hide");
        var recId = component.get("v.recordId");
        var myObjectMap = {
            "VA1_Lab__c": "lab",
            "VA_Request_Purpose__c": "reqPurpose",
            "VA_Type_Of_Sample__c": "sampleType",
            "VA_Total_Engine_Hours__c": "totalEquipmentLife"
        };
        helper.fetchlistPickListVal(component, myObjectMap);
        if (!$A.util.isUndefinedOrNull(recId)) {
            helper.fetchExistingValues(component, event, recId);
        }
        component.set("v.isDesktop", $A.get("$Browser.formFactor") == 'DESKTOP');
        if ($A.get("$Browser.formFactor") == 'DESKTOP') {
            $A.util.addClass(component.find("modelFooterMobile"), "slds-hide");
        } else {
            $A.util.removeClass(component.find("modelFooterMobile"), "slds-hide");
        }
    },
    setReqPurpose: function(component, event, helper) {
        debugger;
        var reqPurpose = component.find("reqPurpose").get("v.value");
        component.find("reqPurpose").set("v.errors", null);
        if (reqPurpose == 'Project') {
            component.find("complaint").set("v.value", null);
            component.find("AdditionalComments").set("v.value", null);
            $A.util.addClass(component.find("complaintDiv"), "slds-hide");
            //component.set("v.isComplaint",false);
            $A.util.removeClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
        } else if (reqPurpose == 'Complaints') {
            component.set("v.selectedProjectrecord", null);
            component.find("AdditionalComments").set("v.value", null);
            helper.clearLookup(component);
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.removeClass(component.find("complaintDiv"), "slds-hide");
            $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
        } else if (reqPurpose == 'Others') {
            $A.util.removeClass(component.find("AdditionalCommentsDiv"), "slds-hide");
            component.set("v.selectedProjectrecord", null);
            helper.clearLookup(component);
            component.find("complaint").set("v.value", "");
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("complaintDiv"), "slds-hide");
        } else {
            component.set("v.selectedProjectrecord", null);
            component.find("AdditionalComments").set("v.value", null);
            helper.clearLookup(component);
            component.find("complaint").set("v.value", "");
            $A.util.addClass(component.find("AdditionalCommentsDiv"), "slds-hide");
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("complaintDiv"), "slds-hide");
        }
    },
    onSampleTypeChange: function(component, event, helper) {
    debugger;
        var sampleType = component.find("sampleType").get("v.value");
        if (sampleType == 'Other') {
            $A.util.removeClass(component.find("otherSampleDiv"), "slds-hide");

        } else {
            $A.util.addClass(component.find("otherSampleDiv"), "slds-hide");
            component.find("otherSampleType").set("v.value", "");
        }
        var sampleTypeField = component.find("sampleType").get("v.value");
        component.find("sampleType").set("v.errors", null);
    },
    removeAdditionalCommentError: function(component, event, helper) {
        component.find("AdditionalComments").set("v.errors", null);
    },
    removeComplaintError: function(component, event, helper) {
        component.find("complaint").set("v.errors", null);
    },
    removeOtherSampleTypeError: function(component, event, helper) {
        component.find("otherSampleType").set("v.errors", null);
    },
    removeEngineMakeModelNoError: function(component, event, helper) {
    	component.find("engineMakeModelNo").set("v.errors", null);
    },
    removeVehRegNoError: function(component, event, helper) {
    	component.find("vehRegNo").set("v.errors", null);
    },
    removeEngineSerialNoError: function(component, event, helper) {
    	component.find("engineSerialNo").set("v.errors", null);
    },
    removeEquipmentLifeError: function(component, event, helper) {
    	component.find("totalEquipmentLife").set("v.errors", null);
    },
    removeHoursKMSeenByOilError: function(component, event, helper) {
    	component.find("hoursKMSeenByOil").set("v.errors", null);
    },
    removeEquipmentIDError: function(component, event, helper) {
    	component.find("equipmentID").set("v.errors", null);
    },
    removeDateofSampleDrawnError: function(component, event, helper) {
        component.find("dateofSampleDrawn").set("v.errors", null);
    },
    removeTotalEquipmentLifeError : function(component, event, helper) {
        component.find("totalEquipmentLife").set("v.errors", null);
    },
    saveData: function(component, event, helper) {
    	helper.savePostData(component, event);
    }
    
})