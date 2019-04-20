({
    doInit : function(component, event, helper) {
        
        var recordID = component.get("v.recordId");
        helper.getPicklistValue(component);
        var action;
        if(!component.get("v.IsCloneRequestresponse") && (component.get("v.previousDP") == null ||
                                                          component.get("v.previousDP") == '' || component.get("v.previousDP") == undefined)){
            action = component.get("c.getvaluesforDiffrentailPricing");        
            
            action.setParams({
                "parentId": (recordID != null && recordID != '' && recordID != undefined) ? recordID : null
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var objectres = response.getReturnValue() || {};
                    if (!$A.util.isUndefinedOrNull(objectres)) {
                        component.set("v.objdiffPric", objectres);
                        var objdata = component.get("v.objdiffPric");
                        if(objdata != null && objdata != '' && objdata.VCPL_DP_Request_Status__c != 'Draft'){
                            component.set("v.NonEditingMessage","You cannot edit at this stage.");
                            component.set("v.edit",false);
                        }
                        
                        component.set("v.objwrapObjectwithName", JSON.parse(objectres.VCPL_Remark__c));
                        var wrapclassname = component.get("v.objwrapObjectwithName");
                        if(wrapclassname != null && wrapclassname != ''){  
                            if(objdata != null && objdata != ''){                          
                                component.set("v.AccountName",objdata.VCPL_Customer_Name__c);
                                console.log('==== firstinsidebase'+objdata.VCPL_Customer_Name__c);                                
                            }
                            component.set("v.DAMName", wrapclassname.DAMName);
                            component.set("v.DealerName", wrapclassname.DealerName);
                            component.set("v.BranchName", wrapclassname.BranchName);
                            component.set("v.TextName",wrapclassname.BranchName);
                            console.log('=====wrapclassname.LoginUserProfile'+wrapclassname.LoginUserProfile);
                            if(wrapclassname.LoginUserProfile == 'ELP')
                                component.set("v.isLoginAsELP",true);
                            if(!wrapclassname.IsLoginUserisOwner){
                                component.set("v.NonEditingMessage","Only owner and System Administrator has authority to edit the records.<br/> Please contact Owner or administrator.");
                                component.set("v.edit",false);                        
                            }
                        }
                        
                        if(objectres.Id != null && objectres.Id != ''){
                            
                            component.set("v.AccountName",objdata.VCPL_Customer_Name__c);
                            console.log('==== firstinsidebase'+objdata.VCPL_Customer_Name__c);
                            component.set("v.DAMName", wrapclassname.DAMName);
                            component.set("v.DealerName", wrapclassname.DealerName);
                            component.set("v.BranchName", wrapclassname.BranchName);
                            var cmpAccountlookup = component.find("AccountLookupauraid");
                            
                            // component.set("v.objdiffPric.VCPL_Customer_Name__r.Name",wrapclassname.CustomerName);
                            cmpAccountlookup.initMethod();
                            
                            component.set("v.TextName", objdata.VCPL_Customer_Name__c);
                            component.set("v.AccountName", wrapclassname.CustomerName);
                            
                            var cmpBranchlookup = component.find("BranchLookupauraid");
                            if(!$A.util.isUndefinedOrNull(cmpBranchlookup))
                                cmpBranchlookup.initMethod();
                            
                            //var cmpContactlookup = component.find("CustomerContactauraid");
                            //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name",wrapclassname.CustomerContactName);
                            //cmpContactlookup.initMethod();  
                            
                            var cmpProductlookup = component.find("ProductLookupauraid"); 
                            cmpProductlookup.set("v.SelectedItemId",objdata.VCPL_Product__c);
                            if(objdata.VCPL_Product__c != null && objdata.VCPL_Product__c != '' 
                               && objdata.VCPL_Product__r.Name != null && objdata.VCPL_Product__r.Name != ''){
                                component.set("v.objdiffPric.VCPL_Product__r.Name",objdata.VCPL_Product__r.Name);
                                cmpProductlookup.initMethod();
                                //component.set("v.objdiffPric.VCPL_Product__r.Name",null);
                                //cmpProductlookup.set("v.searchString",objdata.VCPL_Product__r.Name);
                            }
                        }
                        else if( (objectres.Id == null || objectres.Id == '') &&
                                objectres.VCPL_Customer_Name__c != null &&  objectres.VCPL_Customer_Name__c != ''){
                            var cmpBranchlookup = component.find("BranchLookupauraid");
                            if(!$A.util.isUndefinedOrNull(cmpBranchlookup))
                                cmpBranchlookup.initMethod();
                            var cmpAccountlookup = component.find("AccountLookupauraid");
                            component.set("v.objdiffPric.VCPL_Customer_Name__c", objectres.VCPL_Customer_Name__c);
                            component.set("v.objdiffPric.VCPL_Customer_Name__r.Name",wrapclassname.CustomerName);
                            cmpAccountlookup.initMethod();
                            component.set("v.objdiffPric.VCPL_Customer_Name__r.Name",null);
                            /*
                        if(objectres.VCPL_Customer_Contact_Person__c != null &&  objectres.VCPL_Customer_Contact_Person__c != ''){
                            var cmpContactlookup = component.find("CustomerContactauraid");
                            component.set("v.objdiffPric.VCPL_Customer_Contact_Person__c", objectres.VCPL_Customer_Contact_Person__c);
                            component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name",wrapclassname.CustomerContactName);
                            cmpContactlookup.initMethod(); 
                            component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name",null);
                        }*/
                            
                        }
                        
                        var confignatureofbusiness = objectres.VCPL_Customer_nature_of_business__c;
                        if(!$A.util.isUndefinedOrNull(confignatureofbusiness)){
                            if(confignatureofbusiness == 'Other'){
                                component.set("v.isNatureofBusinessOther",true);
                            }
                            else{
                                component.set("v.isNatureofBusinessOther",false);                            
                            }
                        }
                        component.set("v.objdiffPric.VCPL_Remark__c", '');
                        
                        
                    }
                    if(objdata != null && objdata.VCPL_DP_Request_Status__c != 'Draft'){
                        component.set("v.NonEditingMessage","You cannot edit at this stage.");
                        component.set("v.edit",false);
                    }
                }
                // component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else if(component.get("v.IsCloneRequestresponse") && (component.get("v.previousDP") != null &&
                                                              component.get("v.previousDP") != '' && component.get("v.previousDP") != undefined)){
            var DPrecordtypeid = component.get("v.previousDP");
            
            action = component.get("c.RenewDPRequest");
            action.setParams({
                "DPRecord": (DPrecordtypeid != null && DPrecordtypeid != '' && DPrecordtypeid != undefined) ? DPrecordtypeid : null
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var objectres = response.getReturnValue();
                    if(objectres.strResType == "success"){
                        component.set("v.IsCloneRequestresponseString",objectres.strMessage);
                        helper.updateCloneData(component);
                    }
                }});
            $A.enqueueAction(action);
        }
        
    },
    validatediscount : function(component, event, helper) {
        var salesprice= component.get("v.objdiffPric.VCPL_Offer_Price_L__c");
        if(salesprice > 0){
            var baseprice= component.get("v.objdiffPric.VCPL_Basic_Price_L__c");
            if(baseprice != null && baseprice != ''){
                component.set("v.objdiffPric.VCPL_Discount_L__c",(baseprice-salesprice));
                var discountPriceid = component.find("discountPriceauraid");
                if((baseprice-salesprice) > 100){                    
                    discountPriceid.set("v.errors", [{message:"The discount is greater than 100." }]);                    
                }
                else
                    discountPriceid.set("v.errors", null);
                helper.updatemargin(component,event,(baseprice-salesprice));
            }
        }
        else{
            var componentid = component.find("OfferPriceauraid"); 
            component.set("v.objdiffPric.VCPL_Offer_Price_L__c",null);
            componentid.set("v.errors", [{message:"The offer price cannot be negative or zero" }]);
        }
        
    },
    clearUser: function(component, event, helper) {
        
        var strSobjectName = event.getParam("ObjectLabel");
        var strexternalaparmeter = event.getParam("externalParameter");
        
        if(strSobjectName != null && strSobjectName != '' && strSobjectName == 'Customer Contact Person'){
            //component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", null);
            //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__c", null);
        }
        
        else if(strSobjectName != null && strSobjectName != '' && strSobjectName == 'Product'){
            component.set("v.objdiffPric.VCPL_Pack_Size__c", null);
            component.set("v.objdiffPric.VCPL_Part_no__c", null);
            component.set("v.objdiffPric.VCPL_Basic_Price_L__c", null);
            component.set("v.objdiffPric.VCPL_Config_Margin__c", null);
            component.set("v.objdiffPric.VCPL_Discount_L__c", null);
            component.set("v.objdiffPric.VCPL_Dealer_Margin_Liter__c", null);
            component.set("v.objdiffPric.VCPL_Offer_Price_L__c", null);     
            component.set("v.objdiffPric.VCPL_Product__c",null);
            component.set("v.objdiffPric.VCPL_LY_volume__c",null);
            component.set("v.objdiffPric.VCPL_KL_Potential_per_year__c",null);
        }
            else if(strSobjectName != null && strSobjectName != '' && strSobjectName == 'Customers'){
                component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", null);
                component.set("v.objdiffPric.VCPL_LY_volume__c",null);
                component.set("v.objdiffPric.VCPL_KL_Potential_per_year__c",null);
                component.set("v.objdiffPric.VCPL_Customer_Code__c", null);
                component.set("v.objdiffPric.VCPL_Customer_Name__c", null);
                component.set("v.objdiffPric.VCPL_Customer_contact_person_name__c", null);
                
                //var cmpContactlookup = component.find("CustomerContactauraid");
                //cmpContactlookup.set("v.SelectedItemId", null);
                //cmpContactlookup.set("v.searchString", null);
                //cmpContactlookup.ClearLookupControl();
                
                //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name", null);   
                
            }
                else if(strSobjectName != null && strSobjectName != '' && strSobjectName == 'Branches'){
                    component.set("v.objdiffPric.VCPL_Branch__c", null);
                }
        
        
        
    },
    
    cancel : function(component, event, helper) {
        var recordID = component.get("v.recordId");
        if(recordID != null && recordID != ''){
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": recordID,
                "slideDevName": "related"
            });
            navEvt.fire();
        }
        else{
            var recordIDtrue = component.get("v.objdiffPric.VCPL_Dealer_Name__c");
            if(!component.get("v.isLoginAsELP"))
                recordIDtrue = component.get("v.objdiffPric.VCPL_Branch__c");
            $A.get("e.force:navigateToSObject").setParams({ 
                "recordId": recordIDtrue 
            }).fire();
        }
        
    },
    
    saverecords : function(component, event, helper) {
        var buttonName = event.getSource().get("v.label");
        var returnval = helper.validateEmail(component);
        if(returnval == false)
            return returnval;
        var returnvalmobile = helper.validateMobilenumber(component);
        if(returnvalmobile == false)
            return returnvalmobile;
        var objectres = component.get("v.objdiffPric");
        var returnvalidate = helper.validaterequired(component, event);
        if(returnvalidate == false)
            return returnvalidate;
        var returnvalidateexception = helper.helperExceptioncase(component, event);
        if(returnvalidateexception == false)
            return returnvalidateexception;
        var action = component.get("c.upsertDiffrentailPricingRecord");
        
        action.setParams({
            "objDiffPric": JSON.stringify(objectres)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objectres = JSON.parse(response.getReturnValue() );
                var returnsatatus = objectres.objectName  ;
                var returnmessage = objectres.strId ;
                if(returnsatatus != null && returnsatatus != '' && returnsatatus == 'SUCCESS'){
                    if (!$A.util.isUndefinedOrNull(returnmessage)) {
                        var returnvaluein = returnmessage;
                        var returnlist = returnvaluein.split(";");
                        if(returnlist != null && returnlist != '' && returnlist.length > 1){
                            var toastEventsucess = $A.get("e.force:showToast");
                            toastEventsucess.setParams({
                                mode: 'dismissible',
                                message: returnlist[0],
                                type : 'Warning',
                                duration:'2000'
                            });
                            toastEventsucess.fire();
                            
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": returnlist[1],
                                "slideDevName": "related"
                            });
                            navEvt.fire();
                        }
                        else if(returnlist != null && returnlist != '' && returnlist.length == 1 ){
                            
                            if(buttonName != null && buttonName != '' && buttonName == 'Submit for approval')
                                helper.helpSubmitforApproval(component,event,returnlist[0]);
                            if(buttonName != null && buttonName != '' && buttonName == 'Save as Draft'){
                                
                                var toastEventsucessnew = $A.get("e.force:showToast");
                                toastEventsucessnew.setParams({
                                    mode: 'dismissible',
                                    message: 'Succesfully saved the records',
                                    type : 'success',
                                    duration:'2000'
                                });
                                toastEventsucessnew.fire();
                                
                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({
                                    "recordId": returnlist[0],
                                    "slideDevName": "related"
                                });
                                navEvt.fire();
                            }
                            
                        }
                    }
                }
                else if(returnsatatus != null && returnsatatus != '' && returnsatatus == 'ERROR'){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'dismissible',
                        message: returnmessage,
                        type : 'error',
                        duration:'20000'
                    });
                    toastEvent.fire();
                }
            }
            // component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
        
    },
    dateChangeComponent : function(component, event, helper) {
        
        var componentid = component.find("startdate");
        if (componentid != null || componentid != '') {
            helper.helperMethod(component,event);
        }
    },
    handleComponentEvent : function(component, event, helper) {
        var strSobjectId = event.getParam("sObjectId");
        var strRecordName = event.getParam("recordName");
        var strObjectLabel = event.getParam("ObjectLabel");
        var strExternalId = event.getParam("externalParameter");
        if(strObjectLabel != null && strObjectLabel != ''){
            if(  strObjectLabel == 'Customers')
                component.set("v.ContactLookupFilter","AccountId= '"+strSobjectId+"'");
            helper.helperupdatefields(component,event);
        }
        //alert("hii"+strSobjectId+"=="+strRecordName+"=="+strObjectLabel+"=="+strExternalId);
    },
    validateDealermarginChange : function(component, event, helper) {
        var configmargin = component.get("v.objdiffPric.VCPL_Config_Margin__c");
        var enteredmargin = component.get("v.objdiffPric.VCPL_Dealer_Margin_Liter__c");
        if(configmargin < enteredmargin){
            var componentid = component.find("DealermarginAuraId"); 
            //component.set("v.objdiffPric.VCPL_Offer_Price_L__c",null);
            componentid.set("v.errors", [{message:"The dealer margin was updated" }]);
        }
    },
    validateCustomeremail : function(component, event, helper) {
        var returnval = helper.validateEmail(component);
    }
    ,
    validateCustomerMobilenumber : function(component, event, helper) {
        var returnval = helper.validateMobilenumber(component);
    },
    updateCloneData : function(component, event, helper){
        helper.updateCloneData(component);
    },
    changennatureofbusiness : function(component, event, helper){
        var confignatureofbusiness = component.get("v.objdiffPric.VCPL_Customer_nature_of_business__c");
        if(!$A.util.isUndefinedOrNull(confignatureofbusiness)){
            if(confignatureofbusiness == 'Other'){
                component.set("v.isNatureofBusinessOther",true);
            }
            else{
                component.set("v.isNatureofBusinessOther",false);
                component.set("v.objdiffPric.VCPL_Others_Customer_Nature_of_Business__c",null);
            }
        }
        
    }
})