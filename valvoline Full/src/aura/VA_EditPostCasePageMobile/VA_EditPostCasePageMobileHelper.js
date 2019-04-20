({
    getAccountName: function(component, event) {
        var action = component.get("c.getAccountNameMethod");
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if (state === "SUCCESS") {
                var result = actionresult.getReturnValue();
                debugger;
                if (!$A.util.isUndefinedOrNull(result)) {
                    component.set("v.selectedLookUpRecord", result);
                    var cmp = component.find("lookupComp");
                    cmp.set('v.SearchKeyWord', result.Name);
                }
            }
            
        });
        $A.enqueueAction(action);
        //} 
    },
    
    getContactName: function(component, event) {
        debugger;
        var action = component.get("c.getContactNameMethod");
        
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if (state === "SUCCESS") {
                var result = actionresult.getReturnValue();
                debugger;
                if (!$A.util.isUndefinedOrNull(result)) {
                    component.set("v.selectedLookUpContact", result);
                    var cmp = component.find("lookupContact");
                    var name = result.FirstName + ' ' + result.LastName;
                    cmp.set('v.SearchKeyWord', name);
                }
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
    },
    fetchExistingValues: function(component, event, recId) {
        if (!$A.util.isUndefinedOrNull(recId)) {
            var action = component.get("c.fetchExistingValuesMethod");
            action.setParams({
                "recId": recId
            });
            action.setCallback(this, function(actionresult) {
                var state = actionresult.getState();
                if (state === "SUCCESS") {
                    debugger;
                    var result = actionresult.getReturnValue();
                    if (!$A.util.isUndefinedOrNull(result)) {
                        var cmpContact = component.find("lookupContact");
                        var cmpAccount = component.find("lookupComp");
                        var cmpProject = component.find("lookupCompProject");
                        var cmpProduct = component.find("lookupCompProduct");
                        var cmpProductCategory = component.find("lookupCompProductCategory");
                        cmpContact.set('v.SearchKeyWord', result.Contact.Name);
                        cmpAccount.set('v.SearchKeyWord', result.Account.Name);
                        component.set('v.caseObj', result);
                        cmpProject.set('v.SearchKeyWord', result.VA_Project__r.Name);
                        cmpProduct.set('v.SearchKeyWord', result.VA_Product__r.Name);
                        cmpProductCategory.set('v.SearchKeyWord', result.VA_Product_Category__r.Name);
                    }
                    
                    //component.set("v.recordId",result);
                }
            });
            $A.enqueueAction(action);
        }
    },
    clearLookup: function(component) {
        var cmp = component.find("lookupCompProject");
        var pillTarget = cmp.find("lookup-pill");
        var lookUpTarget = cmp.find("lookupField");
        cmp.set("v.SearchKeyWord", null);
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        cmp.set("v.listOfSearchRecords", null);
        cmp.set("v.selectedRecord", {});
    },
    savePostData: function(component, event) {
        var recId = component.get("v.recordId");
        component.set("v.caseObj.AccountId", component.get("v.selectedLookUpRecord.Id"));
        component.set("v.caseObj.VA_Project__c", component.get("v.selectedProjectrecord.Id"));
        component.set("v.caseObj.ContactId", component.get("v.selectedLookUpContact.Id"));
        component.set("v.caseObj.VA_Product__c", component.get("v.selectedProductrecord.Id"));
        component.set("v.caseObj.VA_Product_Category__c", component.get("v.selectedProductCategoryRecord.Id"));
        //component.set("v.caseObj.Id", recId);
        var caseObj = component.get("v.caseObj");
        var reqPurpose = component.find("reqPurpose");
        var typeofSample = component.find("sampleType");
        var otherSample = component.find("otherSampleType");
        var project = component.find("lookupCompProject").find("textValue");
        var compNumber = component.find("complaint");
        var additionalComent = component.find("AdditionalComments");
        var otherSampleType = component.find("otherSampleType");
        var engineMakeModel = component.find("engineMakeModelNo");
        var vehicleregNo = component.find("vehRegNo");
        var engineSerialNo = component.find("engineSerialNo");
        var dateOfSampleDrawn = component.find("dateofSampleDrawn");
        var totalEquipmentLife = component.find("totalEquipmentLife");
        var hourKmSeenByOil = component.find("hoursKMSeenByOil");
        var equipmentField = component.find("equipmentID");
        var equipmentValue = equipmentField.get("v.value");
        
        var projectRecord = component.get("v.selectedProjectrecord");
        var productRecord = component.get("v.selectedProductrecord");
        var productCategoryRecord = component.get("v.selectedProductCategoryRecord");
        var isValid = true;
        var sErrorMsg = "";
        sErrorMsg = "";
        if (caseObj.VA_Request_Purpose__c == '') {
            isValid = false;
            sErrorMsg = 'Please select a Request Purpose';
            reqPurpose.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if (caseObj.VA_Request_Purpose__c == 'Project' && $A.util.isUndefinedOrNull(projectRecord.Name)) {
            isValid = false;
            sErrorMsg = 'Please select a Project';
            reqPurpose.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if (caseObj.VA_Request_Purpose__c == 'Complaints' && $A.util.isUndefinedOrNull(caseObj.VA_Complaint_Number__c)) {
            isValid = false;
            sErrorMsg = 'Please enter a valid Complaint Number.';
            compNumber.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if (caseObj.VA_Request_Purpose__c == 'Others' && $A.util.isUndefinedOrNull(caseObj.VA_Additional_Comments__c)) {
            isValid = false;
            sErrorMsg = 'Please enter Additional Comments';
            additionalComent.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if (caseObj.VA_Type_Of_Sample__c == '') {
            isValid = false;
            sErrorMsg = 'Please select Type of Sample .';
            typeofSample.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if (caseObj.VA_Type_Of_Sample__c == 'Other' && $A.util.isUndefinedOrNull(caseObj.VA_Other_Sample__c)) {
            isValid = false;
            sErrorMsg = 'Please select Other Sample .';
            otherSample.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if ($A.util.isUndefinedOrNull(productRecord)) {
            isValid = false;
            sErrorMsg = 'Please select a Product';
            
        } else if ($A.util.isUndefinedOrNull(caseObj.VA_Engine_Make_Model__c)) {
            isValid = false;
            sErrorMsg = 'Please enter Engine Make/Model';
            engineMakeModel.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if ($A.util.isUndefinedOrNull(productCategoryRecord)) {
            isValid = false;
            sErrorMsg = 'Please select a Product Category';
            
        } else if ($A.util.isUndefinedOrNull(caseObj.VA_Veh_Reg_No__c)) {
            isValid = false;
            sErrorMsg = 'Please enter Vehicle Reg. No.';
            vehicleregNo.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if ($A.util.isUndefinedOrNull(caseObj.Va_Engine_Serial_No__c )) {
            isValid = false;
            sErrorMsg = 'Please enter Engine Serial No.';
            engineSerialNo.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if ($A.util.isUndefinedOrNull(caseObj.VA_Date_of_Sample_Drawn__c)) {
            isValid = false;
            sErrorMsg = 'Please enter Date of Sample Drawn';
            dateOfSampleDrawn.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if (caseObj.VA_Total_Engine_Hours__c =='') {
            isValid = false;
            sErrorMsg = 'Please enter Total Equipment Life.';
            totalEquipmentLife.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if ($A.util.isUndefinedOrNull(caseObj.VA_Hours_Km_seen_by_Oil__c)) {
            isValid = false;
            sErrorMsg = 'Please enter Hours/Km Seen by Oil.';
            hourKmSeenByOil.set("v.errors", [{
                message: sErrorMsg
            }]);
        } else if ($A.util.isUndefinedOrNull(caseObj.VA_Equipment_ID__c)) {
            isValid = false;
            sErrorMsg = 'Please enter Equipment Id.';
            equipmentField.set("v.errors", [{
                message: sErrorMsg
            }]);
        }
        if (!isValid) {
            this.showToast(component, event, sErrorMsg);
            return;
        }
        
        var caseObj = component.get("v.caseObj");
        this.waiting();
        
        var action = component.get("c.savePostCase");
        action.setParams({
            "objCase": caseObj
        });
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if (state === "SUCCESS") {
                
                var result = actionresult.getReturnValue();
                if (result.indexOf("500") > -1)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: "Case successfully created!",
                        type: 'success'
                        
                    });
                    toastEvent.fire();
                    component.set("v.recordId", result);
                    this.navigate(component, event, result);
                }
                else
                {
                    var errorvalue = result.indexOf('Error:');
                    if (errorvalue != -1)
                    {
                        if (result.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION"))
                        {
                            var stringtoDisplay = result.match("FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*):");
                            var toastEvent = $A.get("e.force:showToast")
                            toastEvent.setParams({
                                message: String(stringtoDisplay[1]),
                                type: 'error'
                            });
                            toastEvent.fire();
                        }
                        else
                        {
                            var toastEvent = $A.get("e.force:showToast")
                            toastEvent.setParams({
                                message: "An error has occurred.Please contact your system administrator if this problem persists.",
                                type: 'error'
                            });
                            toastEvent.fire();
                            
                        }
                    }
                }
            }
            this.doneWaiting();
        });
        $A.enqueueAction(action);
    },
    navigate: function(component, event, recId) {
        debugger;
        if ($A.get("$Browser.formFactor") == 'DESKTOP') {
            if (recId.indexOf("500") > -1) { //Note 500 is prefix for Case Record
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/case/' + recId
                });
                urlEvent.fire();
            }
        } else {
            if (recId.indexOf("500") > -1) { //Note 500 is prefix for Case Record
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/' + recId
                });
                urlEvent.fire();
            }
        }
    },
    waiting: function() {
        if (!$A.util.isUndefinedOrNull(document.getElementById("EDIT_CASE_PAGE_MOBILE"))) {
            document.getElementById("EDIT_CASE_PAGE_MOBILE").style.display = "block";
        }
    },
    doneWaiting: function() {
        
        
        if (!$A.util.isUndefinedOrNull(document.getElementById("EDIT_CASE_PAGE_MOBILE"))) {
            document.getElementById("EDIT_CASE_PAGE_MOBILE").style.display = "none";
        }
        
    },
    showToast: function (component,event,sErrorMsg){
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "An Error Occured.. !",
            "message": sErrorMsg,
            "type" : 'error'
            
        });
        toastEvent.fire(); 
    }
})