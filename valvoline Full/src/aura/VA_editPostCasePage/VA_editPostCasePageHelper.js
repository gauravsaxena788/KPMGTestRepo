({
    fetchlistPickListVal: function(component, myObjectMap) {
        var action = component.get("c.fetchlistPickListVals");

        action.setParams({
            //"objObject": component.get("v.newCase"),
            "mapfld": myObjectMap
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                  
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
    getAccountName: function(component, event) {
        var action = component.get("c.getAccountNameMethod");
        action.setCallback(this, function(actionresult) {

            var state = actionresult.getState();
            if (state === "SUCCESS") {
                var result = actionresult.getReturnValue();
                
                  
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


    getAccountName2 : function(component,event) {
        var action=component.get("c.getAccountNameMethod2");
        action.setParams({
            "accId": component.get("v.ifAccIdExist")
        });
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.selectedLookUpRecord",result);
                    console.log("In edtPstCasePgCmp-->H-->getAccName2-->ret val from Apex-->"+JSON.stringify(result));
                    var cmp = component.find("lookupComp");
                    cmp.set('v.SearchKeyWord',result.Name);
                }
            }
            
        }); 
        $A.enqueueAction(action);                    
        //} 
    },


    getContactName: function(component, event) {
          
        var action = component.get("c.getContactNameMethod");

        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if (state === "SUCCESS") {
                var result = actionresult.getReturnValue();
                  
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
    fetchExistingValues: function(component, event, recId) {
        if (!$A.util.isUndefinedOrNull(recId)) {
            var action = component.get("c.fetchExistingValuesMethod");
            action.setParams({
                "recId": recId
            });
            action.setCallback(this, function(actionresult) {
                var state = actionresult.getState();
                if (state === "SUCCESS") {
                      
                    var result = actionresult.getReturnValue();
                    if (!$A.util.isUndefinedOrNull(result)) {
                        var cmpContact = component.find("lookupContact");
                        var cmpAccount = component.find("lookupComp");
                        var cmpProject = component.find("lookupCompProject");
                        var cmpProduct = component.find("lookupCompProduct");
                        var cmpProductCategory = component.find("selectedProductCategoryRecord");
                        cmpContact.set('v.SearchKeyWord', result.Contact.Name);
                        cmpAccount.set('v.SearchKeyWord', result.Account.Name);
                        component.set('v.caseObj', result);
                        cmpProject.set('v.SearchKeyWord', result.VA_Project__r.Name);
                        cmpProduct.set('v.SearchKeyWord', result.VA_Product__r.Name);
                        cmpProductCategory.set('v.SearchKeyWord', result.VA_Product_Category__r.Name);
                    }


                }
            });
            $A.enqueueAction(action);
        }
    },
    setReqPurpose: function(component, event) {

        var reqPurpose = component.find("reqPurpose").get("v.value");
        if (reqPurpose == 'Project') {

            $A.util.removeClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("complaintNoDiv"), "slds-hide");
            component.find("complaintNumber").set("v.value", "");
            component.find("additionalComments").set("v.value", "");
            $A.util.addClass(component.find("additionalCommentsDiv"), "slds-hide");
        } else if (reqPurpose == 'Complaints') {
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.removeClass(component.find("complaintNoDiv"), "slds-hide");
            $A.util.addClass(component.find("additionalCommentsDiv"), "slds-hide");
            component.find("additionalComments").set("v.value", "");
            
             var cmp = component.find("lookupCompProject");
            var pillTarget = cmp.find("lookup-pill");
            var lookUpTarget = cmp.find("lookupField");
            
            cmp.set("v.SearchKeyWord",null);
            
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            cmp.set("v.listOfSearchRecords", null );
            cmp.set("v.selectedRecord", {} );  
            
        } else if (reqPurpose == 'Others') {
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("complaintNoDiv"), "slds-hide");
            $A.util.removeClass(component.find("additionalCommentsDiv"), "slds-hide");
            component.find("complaintNumber").set("v.value", "");
            
             var cmp = component.find("lookupCompProject");
            var pillTarget = cmp.find("lookup-pill");
            var lookUpTarget = cmp.find("lookupField");
            
            cmp.set("v.SearchKeyWord",null);
            
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            cmp.set("v.listOfSearchRecords", null );
            cmp.set("v.selectedRecord", {} );  
            
        } else {
            $A.util.addClass(component.find("additionalCommentsDiv"), "slds-hide");
            $A.util.addClass(component.find("projectdiv"), "slds-hide");
            $A.util.addClass(component.find("complaintNoDiv"), "slds-hide");
            component.find("complaintNumber").set("v.value", ""); 
            
             var cmp = component.find("lookupCompProject");
            var pillTarget = cmp.find("lookup-pill");
            var lookUpTarget = cmp.find("lookupField");
            
            cmp.set("v.SearchKeyWord",null);
            
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            cmp.set("v.listOfSearchRecords", null );
            cmp.set("v.selectedRecord", {} );  
        }
        var reqPurposeField = component.find("reqPurpose");
        reqPurposeField.set("v.errors", null);
    },
    setSampleType: function(component, event, helper) {

        var sampleType = component.find("sampleType").get("v.value");

        if (sampleType == 'Other') {
            $A.util.removeClass(component.find("otherSampleDiv"), "slds-hide");

        } else {
            $A.util.addClass(component.find("otherSampleDiv"), "slds-hide");
            component.find("otherSampleType").set("v.value", "");
        }
        var reqPurposeField = component.find("sampleType");
        reqPurposeField.set("v.errors", null);
    },
    showToast: function(cmp, title, message, type) {
        cmp.set("v.errormsg", message);
        cmp.set("v.title", title);
        //---- Setting up severity ----//
        if (type == 'info') {
            cmp.set("v.type", '');
            cmp.set("v.icon", 'utility:info');
        } else if (type == 'warning') {
            cmp.set("v.type", 'slds-theme--error');
            cmp.set("v.icon", 'utility:warning');
        } else if (type == 'error') {
            cmp.set("v.type", 'slds-theme--error');
            cmp.set("v.icon", 'utility:error');
        } else if (type == 'success') {
            cmp.set("v.type", 'slds-theme--success');
            cmp.set("v.icon", 'utility:success');
        }
        cmp.set("v.errormsg", message);
        window.setTimeout(function() {
            cmp.set("v.errormsg", '');
        }, 5000);
    },
    savePostCase: function(component, event, helper) {
        this.requiredFields(component, event, helper);
        var flag = component.get("v.RequiredField");
          
        if (flag) {
            var accountId = component.get("v.selectedLookUpRecord");
            var contactId = component.get("v.selectedLookUpContact");
            var productId = component.get("v.selectedProductrecord");
            var productCategoryId = component.get("v.selectedProductCategoryRecord");

            if ($A.util.isUndefinedOrNull(accountId) || accountId == '') {
                this.showToast(component, 'ERROR', "Account cannot be Blank .", 'error');
            } else if ($A.util.isUndefinedOrNull(contactId) || contactId == '') {
                this.showToast(component, 'ERROR', "Contact cannot be Blank .", 'error');
            } else if ($A.util.isUndefinedOrNull(productId) || productId == '') {
                this.showToast(component, 'ERROR', "Product cannot be Blank .", 'error');
            } else if ($A.util.isUndefinedOrNull(productCategoryId) || productCategoryId == '') {
                this.showToast(component, 'ERROR', "Product Category cannot be Blank .", 'error');
            } else {
                this.showToast(component, 'ERROR', "Please fill all mandatory fields in order to proceed .", 'error');
            }
        } else {
            var recId = component.get("v.recordId");
            component.set("v.caseObj.AccountId", component.get("v.selectedLookUpRecord.Id"));
            component.set("v.caseObj.VA_Project__c", component.get("v.selectedProjectrecord.Id"));
            component.set("v.caseObj.ContactId", component.get("v.selectedLookUpContact.Id"));
            component.set("v.caseObj.VA_Product__c", component.get("v.selectedProductrecord.Id"));
            component.set("v.caseObj.Product_Category__c", component.get("v.selectedProductCategoryRecord.Id"));
            component.set("v.caseObj.Product_Category__c", component.get("v.selectedProductCategoryRecord.Id"));


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

                    if (result.indexOf("500") > -1) {
                        this.showToast(component, 'SUCCESS', 'Case successfully created', 'success');
                        this.navigate(component, event, result);
                    } else {
                        var errorvalue = result.indexOf('Error:');
                        if (errorvalue != -1) {
                            if (result.includes("FIELD_CUSTOM_VALIDATION_EXCEPTION")) {
                                var stringtoDisplay = result.match("FIELD_CUSTOM_VALIDATION_EXCEPTION,(.*):");

                                this.showToast(component, 'ERROR', String(stringtoDisplay[1]), 'error');
                            } else {
                                var genericErrormsg = "An error has occurred.Please contact your system administrator if this problem persists.";
                                this.showToast(component, 'ERROR', genericErrormsg, 'error');
                            }
                        }
                    }
                }
                this.doneWaiting();
            });
            $A.enqueueAction(action);
        }
    },
    requiredFields: function(component, event, helper) {
          
        var reqPurposeField = component.find("reqPurpose");
        var reqPurposeValue = reqPurposeField.get("v.value");
        var projectId = component.get("v.selectedProjectrecord");
        var typeOfSampleField = component.find("sampleType");
        var typeOfSampleValue = typeOfSampleField.get("v.value");
        var otherSampleField = component.find("otherSampleType");
        var otherSampleValue = otherSampleField.get("v.value");
        var complaintField = component.find("complaintNumber");
        var complaintValue = complaintField.get("v.value");
        var accountId = component.get("v.selectedLookUpRecord");
        var contactId = component.get("v.selectedLookUpContact");
        var productId = component.get("v.selectedProductrecord");
        var productCategoryId = component.get("v.selectedProductCategoryRecord");
        var enginemakeModelField = component.find("engineMakeModelNo");
        var enginemakeModelValue = enginemakeModelField.get("v.value");
        var vehRegNoField = component.find("vehRegNo");
        var vehRegNoValue = vehRegNoField.get("v.value");
        var engineSerialNoField = component.find("engineSerialNo");
        var engineSerialNoValue = engineSerialNoField.get("v.value");
        var dateofSampleDrawnField = component.find("dateofSampleDrawn");
        var dateofSampleDrawnValue = dateofSampleDrawnField.get("v.value");
        var equipmentField = component.find("equipmentID");
        var equipmentValue = equipmentField.get("v.value");
        var totalEquipmentLifeField = component.find("totalEquipmentLife");
        var totalEquipmentLifeValue = totalEquipmentLifeField.get("v.value");
        var hoursKMSeenByOilField = component.find("hoursKMSeenByOil");
        var hoursKMSeenByOilValue = hoursKMSeenByOilField.get("v.value");
        var additionalCommentsField = component.find("additionalComments");
        var additionalCommentsValue = additionalCommentsField.get("v.value");
        
        if ($A.util.isUndefinedOrNull(accountId) || accountId == '') {
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Account cannot be Blank .", 'error');
        } else if ($A.util.isUndefinedOrNull(contactId) || contactId == '') {
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Contact cannot be Blank .", 'error');
            return;
        } else if ($A.util.isUndefinedOrNull(productId) || productId == '') {
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Product cannot be Blank .", 'error');
        } else if ($A.util.isUndefinedOrNull(productCategoryId) || productCategoryId == '') {
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Product Category cannot be Blank .", 'error');
        } else if ($A.util.isEmpty(reqPurposeValue) || $A.util.isUndefined(reqPurposeValue)) {
            reqPurposeField.set("v.errors", [{
                message: "Please enter Request Purpose."
            }]);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Request Purpose is mandatory.", 'error');

        } else if (!$A.util.isEmpty(reqPurposeValue) && !$A.util.isUndefined(reqPurposeValue) && reqPurposeValue == "Project" && $A.util.isEmpty(projectId)) {
            reqPurposeField.set("v.errors", [{
                message: "Please select a Project."
            }]);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Project is mandatory in case Request Purpose is Project.", 'error');

        } else if (!$A.util.isEmpty(reqPurposeValue) && !$A.util.isUndefined(reqPurposeValue) && reqPurposeValue == "Complaints" && $A.util.isUndefinedOrNull(complaintValue)) {
            reqPurposeField.set("v.errors", [{
                message: "Complaint Number is mandatory in case Request Purpose is Complaints."
            }]);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Complaint Number is mandatory in case Request Purpose is Complaints.", 'error');

        }
        else if(!$A.util.isEmpty(reqPurposeValue) && !$A.util.isUndefined(reqPurposeValue) && reqPurposeValue == "Others" && $A.util.isEmpty(additionalCommentsValue)){
        	reqPurposeField.set("v.errors", [{
                message: "Please mention Additional Comments."
            }]);
            component.set("v.RequiredField", true);
        }
         else if ($A.util.isEmpty(typeOfSampleValue) || $A.util.isUndefined(typeOfSampleValue)) {
            typeOfSampleField.set("v.errors", [{
                message: "Please enter Type of Sample ."
            }]);
            reqPurposeField.set("v.errors", null);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Sample Type is mandatory.", 'error');
        } else if (!$A.util.isEmpty(typeOfSampleValue) && !$A.util.isUndefined(typeOfSampleValue) && typeOfSampleValue == "Other" && $A.util.isUndefinedOrNull(otherSampleValue)) {
            typeOfSampleField.set("v.errors", [{
                message: "Please enter Other Sample."
            }]);
            reqPurposeField.set("v.errors", null);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Other Sample is mandatory.", 'error');
        } else if ($A.util.isEmpty(enginemakeModelValue) || $A.util.isUndefined(enginemakeModelValue)) {
            enginemakeModelField.set("v.errors", [{
                message: "Please enter Engine Make/Model."
            }]);
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Engine Make/Model is mandatory.", 'error');

        } else if ($A.util.isEmpty(vehRegNoValue) || $A.util.isUndefined(vehRegNoValue)) {
            vehRegNoField.set("v.errors", [{
                message: "Please enter Vehicle Reg. No."
            }]);
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Vehicle Reg. No. is mandatory.", 'error');

        } else if ($A.util.isEmpty(engineSerialNoValue) || $A.util.isUndefined(engineSerialNoValue)) {
            engineSerialNoField.set("v.errors", [{
                message: "Please enter Engine Serial No."
            }]);
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            vehRegNoField.set("v.errors", null);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Engine Serial No. is mandatory.", 'error');
            return;
        } else if ($A.util.isEmpty(dateofSampleDrawnValue) || $A.util.isUndefined(dateofSampleDrawnValue)) {
            dateofSampleDrawnField.set("v.errors", [{
                message: "Please enter Date of Sample Drawn ."
            }]);
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            vehRegNoField.set("v.errors", null);
            engineSerialNoField.set("v.errors", null);
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Date of Sample Drawn is mandatory.", 'error');
        }  else if ($A.util.isEmpty(totalEquipmentLifeValue) || $A.util.isUndefined(totalEquipmentLifeValue)) {
            totalEquipmentLifeField.set("v.errors", [{
                message: "Please enter Total Equipment Life ."
            }]);
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            vehRegNoField.set("v.errors", null);
            engineSerialNoField.set("v.errors", null);
            reqPurposeField.set("v.errors", null);
            equipmentField.set("v.errors", null);
            dateofSampleDrawnField.set("v.errors", null);
            
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Total Equipment Life is mandatory.", 'error');
        } else if ($A.util.isEmpty(hoursKMSeenByOilValue) || $A.util.isUndefined(hoursKMSeenByOilValue)) {
            hoursKMSeenByOilField.set("v.errors", [{
                message: "Please enter Hours/Km seen by Oil ."
            }]);
            
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            vehRegNoField.set("v.errors", null);
            engineSerialNoField.set("v.errors", null);
            reqPurposeField.set("v.errors", null);
            equipmentField.set("v.errors", null);
            totalEquipmentLifeField.set("v.errors", null);
            dateofSampleDrawnField.set("v.errors", null);
            
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Hours/Km seen by Oil is mandatory.", 'error');
        }
		else if ($A.util.isEmpty(equipmentValue) || $A.util.isUndefined(equipmentValue)) {
            equipmentField.set("v.errors", [{
                message: "Please enter Equipment Id ."
            }]);
            reqPurposeField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            vehRegNoField.set("v.errors", null);
            engineSerialNoField.set("v.errors", null);
            reqPurposeField.set("v.errors", null);
            dateofSampleDrawnField.set("v.errors", null);
			hoursKMSeenByOilField.set("v.errors", null);
            equipmentField.set("v.errors", null);
            
            component.set("v.RequiredField", true);
            //this.showToast(component, 'ERROR', "Equipment ID is mandatory.", 'error');
        }
		else {
            component.set("v.RequiredField", false);
            hoursKMSeenByOilField.set("v.errors", null);
            totalEquipmentLifeField.set("v.errors", null);
            equipmentField.set("v.errors", null);
            dateofSampleDrawnField.set("v.errors", null);
            engineSerialNoField.set("v.errors", null);
            vehRegNoField.set("v.errors", null);
            enginemakeModelField.set("v.errors", null);
            typeOfSampleField.set("v.errors", null);
            reqPurposeField.set("v.errors", null);

        }

    },
    navigate: function(component, event, recId) {
          
        if (recId.indexOf("500") > -1) {
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/case/' + recId
                //"url" : '/case-detail?id='+recId
            });
            urlEvent.fire();
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

    }
})