({
    helperMethod : function(component,event) {
        
        var componentid = component.find("startdate");
        var datechange = componentid.get("v.value");
        if(datechange == null || datechange == '')
            component.set("v.objdiffPric.VCPL_DP_Expiry_Date__c", '');
        var action = component.get("c.validateDateRecord");
        
        action.setParams({
            "Startdate": datechange
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objectresmessage = response.getReturnValue() ;
                if (!$A.util.isUndefinedOrNull(objectresmessage)) {
                    component.set("v.meassgefordate",objectresmessage );
                    component.set("v.objdiffPric.VCPL_DP_Expiry_Date__c", objectresmessage.enddate);
                    
                    if(objectresmessage.strmessage == 'Old Date'){
                        componentid.set("v.errors", [{message:"The Validity start date is past" }]);
                        component.set("v.isdatepast",true);
                    }
                    else if(objectresmessage.strmessage == 'Old Date no accepted'){
                        componentid.set("v.errors", [{message:"The Validity start date is cannot be more than 90 days" }]);
                        componentid.set("v.value",null);
                        component.set("v.objdiffPric.VCPL_DP_Expiry_Date__c", null);
                        // component.set("v.isdatepast",true);
                    }
                        else{
                            componentid.set("v.errors", null); 
                            component.set("v.isdatepast",false);
                        }
                }
            }
            // component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    helperupdatefields : function(component,event){
        var SelectedDealerId = component.get("v.objdiffPric.VCPL_Dealer_Name__c");
        var strrelateddata ;
        var strSobjectId = event.getParam("sObjectId");
        var strRecordName = event.getParam("recordName");
        var strObjectLabel = event.getParam("ObjectLabel");
        if(strObjectLabel == 'Product'){
            strrelateddata = component.get("v.objdiffPric.VCPL_Customer_Name__c");
        }
        else if(strObjectLabel == 'Customers'){
           strrelateddata = component.get("v.objdiffPric.VCPL_Product__c"); 
        }
        var strExternalId = event.getParam("externalParameter");
        
        var action = component.get("c.returnrelatedata");
        
        action.setParams({
            "objectname": strObjectLabel,
            "strId":strSobjectId,
            "DealerAccount":SelectedDealerId,
            "relatedData":strrelateddata
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objectresmessage = response.getReturnValue() ;
                if (!$A.util.isUndefinedOrNull(objectresmessage)) {
                    var objclassjson = JSON.parse(objectresmessage);
                    if(strObjectLabel == 'Product' && (objclassjson == null || objclassjson == '')){
                        component.set("v.objdiffPric.VCPL_Pack_Size__c", null);
                        component.set("v.objdiffPric.VCPL_Part_no__c", null);
                        component.set("v.objdiffPric.VCPL_Basic_Price_L__c", null);
                    }
                    //alert(objclassjson);
                    else if(strObjectLabel == 'Product' && objclassjson != null && objclassjson != ''){
                        component.set("v.objdiffPric.VCPL_Pack_Size__c", objclassjson.Product__r.Packsize__c);
                        component.set("v.objdiffPric.VCPL_Part_no__c", objclassjson.VCPL_Product_SKU_Id__c);
                        component.set("v.objdiffPric.VCPL_Basic_Price_L__c", objclassjson.VCPL_Base_Price__c);
                        var returnlistrecord = objclassjson.Name.split(" - ");
                        if(returnlistrecord != null && returnlistrecord != '' && returnlistrecord.length > 1){
                            component.set("v.objdiffPric.VCPL_KL_Potential_per_year__c", returnlistrecord[1] );
                            component.set("v.objdiffPric.VCPL_LY_volume__c", returnlistrecord[0] );
                        }
                    }
                    /*else if(strObjectLabel == 'Customer Contact Person' && (objclassjson == null || objclassjson == ''))
                            component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", null);
                            else if(strObjectLabel == 'Customer Contact Person' && objclassjson != null && objclassjson != ''){
                                component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", objclassjson.MobilePhone);
                            }*/
                        else if(strObjectLabel == 'Customers' && (objclassjson == null || objclassjson == '')){
                            component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", null);
                            component.set("v.objdiffPric.VCPL_Customer_Code__c", null);
                            // component.set("v.objdiffPric.VCPL_Customer_Contact_Person__c", null);
                        }
                    // alert(objclassjson);
                            else if(strObjectLabel == 'Customers' && objclassjson != null && objclassjson != ''){
                                
                                
                                if(objclassjson.Account != null && objclassjson.Account != '' && 
                                   objclassjson.Account.VCPL_CDOS_AccountId__c != null && objclassjson.Account.VCPL_CDOS_AccountId__c != ''){
                                    component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", objclassjson.MobilePhone);
                                    component.set("v.objdiffPric.VCPL_Customer_Code__c", objclassjson.Account.VCPL_CDOS_AccountId__c);
                                    component.set("v.objdiffPric.VCPL_KL_Potential_per_year__c", objclassjson.Account.VCPL_Current_FY_Total_Actual_Sales_Vol__c );
                                    component.set("v.objdiffPric.VCPL_LY_volume__c", objclassjson.Account.VCPL_Current_Month_Total_Planned_Sales__c );
                                    //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__c", objclassjson.Id);
                                    //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name", objclassjson.Name);
                                    //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Id", objclassjson.Id);
                                    //var cmpContactlookupfrom = component.find("CustomerContactauraid");
                                    //cmpContactlookupfrom.initMethod();
                                    //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name", null);
                                }
                                
                                else if(objclassjson.VCPL_CDOS_AccountId__c != null && objclassjson.VCPL_CDOS_AccountId__c != ''){
                                    component.set("v.objdiffPric.VCPL_Customer_Code__c", objclassjson.VCPL_CDOS_AccountId__c);
                                    component.set("v.objdiffPric.VCPL_KL_Potential_per_year__c", objclassjson.VCPL_Current_FY_Total_Actual_Sales_Vol__c );
                                    component.set("v.objdiffPric.VCPL_LY_volume__c", objclassjson.VCPL_Current_Month_Total_Planned_Sales__c );
                                    component.set("v.objdiffPric.VCPL_Customer_Contact_No__c", null);
                                    //component.set("v.objdiffPric.VCPL_Customer_Contact_Person__c", null);
                                    // component.set("v.objdiffPric.VCPL_Customer_Contact_Person__r.Name", null);
                                    
                                }
                                
                                //cmpContactlookupfrom.set("v.searchString", objclassjson.Name);
                            }
                }
            }
            // component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    updatemargin : function(component,event,discount){
        var action = component.get("c.getMarginpercentage");
        
        action.setParams({
            "discount": discount
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnvar = response.getReturnValue() ;
                component.set("v.objdiffPric.VCPL_Config_Margin__c", returnvar);
                component.set("v.objdiffPric.VCPL_Dealer_Margin_Liter__c", returnvar);
            }
        });
        $A.enqueueAction(action);
    },
    validaterequired : function(component,event){
        var returnstate = true;
        var cmpAccountlookupid = component.find("AccountLookupauraid");
        var cmpAccountlookupauraid = cmpAccountlookupid.find("lookup");
        var cmpAccountlookupidval = cmpAccountlookupauraid.get("v.value");
        if(cmpAccountlookupauraid != null && cmpAccountlookupauraid != ''){
            if(cmpAccountlookupidval == null || cmpAccountlookupidval == ''){
                cmpAccountlookupauraid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else if(component.get("v.objdiffPric.VCPL_Customer_Name__c") == null || component.get("v.objdiffPric.VCPL_Customer_Name__c") == ''){
                cmpAccountlookupauraid.set("v.errors", [{message:"Enter a valid value" }]);
                returnstate = false;
            }
                else
                    cmpAccountlookupauraid.set("v.errors", null); 
        }
        
        var cmpBranchlookup = component.find("BranchLookupauraid");
        if(!$A.util.isUndefinedOrNull(cmpBranchlookup)){
            var cmpBranchlookupauraid = cmpBranchlookup.find("lookup");
            var cmpBranchlookupidval = cmpBranchlookupauraid.get("v.value");
            if(cmpBranchlookupidval == null || cmpBranchlookupidval == ''){
                cmpBranchlookupauraid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else if(component.get("v.objdiffPric.VCPL_Branch__c") == null || component.get("v.objdiffPric.VCPL_Branch__c") == ''){
                cmpBranchlookupauraid.set("v.errors", [{message:"Enter a valid value" }]);
                returnstate = false;
            }
                else
                    cmpBranchlookupauraid.set("v.errors", null); 
        }
        
        var OfferPriceauraidfield = component.find("OfferPriceauraid"); 
        if(!$A.util.isUndefinedOrNull(OfferPriceauraidfield)){
            var OfferPriceauraidval = OfferPriceauraidfield.get("v.value");
            if(OfferPriceauraidval < 0){
                OfferPriceauraidfield.set("v.errors", [{message:"The offer price cannot be negative" }]);
                returnstate = false;
            }
            else
                OfferPriceauraidfield.set("v.errors", null); 
        }
        
        /**
                var cmpCustomerContactlookupid = component.find("CustomerContactauraid");
                var cmpCustomerContactlookupauraid = cmpCustomerContactlookupid.find("lookup");
                var cmpCustomerContactlookupidval = cmpCustomerContactlookupauraid.get("v.value");;
                if(cmpCustomerContactlookupauraid != null && cmpCustomerContactlookupauraid != ''){
                    if(cmpCustomerContactlookupidval == null || cmpCustomerContactlookupidval == ''){
                        cmpCustomerContactlookupauraid.set("v.errors", [{message:"This field is required" }]);
                        returnstate = false;
                    }
                    else if(component.get("v.objdiffPric.VCPL_Customer_Contact_Person__c") == null || component.get("v.objdiffPric.VCPL_Customer_Contact_Person__c") == ''){
                        cmpCustomerContactlookupauraid.set("v.errors", [{message:"Enter a valid value" }]);
                    }
                    else
                       cmpCustomerContactlookupauraid.set("v.errors", null); 
                }
                */
        var cmpproductlookupid = component.find("ProductLookupauraid");
        var cmpproductlookupauraid = cmpproductlookupid.find("lookup");
        var cmpproductlookupidval = cmpproductlookupauraid.get("v.value");;
        if(cmpproductlookupauraid != null && cmpproductlookupauraid != ''){
            if(cmpproductlookupidval == null || cmpproductlookupidval == ''){
                cmpproductlookupauraid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else if(component.get("v.objdiffPric.VCPL_Product__c") == null || component.get("v.objdiffPric.VCPL_Product__c") == ''){
                cmpproductlookupauraid.set("v.errors", [{message:"Enter a valid value" }]);
                returnstate = false;
            }
                else
                    cmpproductlookupauraid.set("v.errors", null); 
        }
        
        var offerpriceid = component.find("OfferPriceauraid");
        var offerpriceidval = offerpriceid.get("v.value");
        if(offerpriceid != null && offerpriceid != ''){
            if(offerpriceidval == null || offerpriceidval == ''){
                offerpriceid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else if(offerpriceidval < 1 ){ 
                offerpriceid.set("v.value",null);
                offerpriceid.set("v.errors", [{message:"The offer price cannot be negative or zero" }]);
                returnstate = false;
            }
                else
                    offerpriceid.set("v.errors", null); 
        }
        
        var expectedvolumeid = component.find("expectedvolumeauraid");
        var expectedvolumeidval = expectedvolumeid.get("v.value");
        
        if(expectedvolumeid != null && expectedvolumeid != ''){
            if(expectedvolumeidval == null || expectedvolumeidval == ''){
                expectedvolumeid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
                expectedvolumeid.set("v.errors", null);
        }
        
        
        var CustomerPersonNameid = component.find("CustomerPersonName");
        var CustomerPersonNameidval = CustomerPersonNameid.get("v.value");
        if(!$A.util.isUndefinedOrNull(CustomerPersonNameid)){
            if($A.util.isUndefinedOrNull(CustomerPersonNameidval)){
                CustomerPersonNameid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
                CustomerPersonNameid.set("v.errors", null);
        } 
        
        var CustomerMobileNumberid = component.find("CustomerMobileNumber");
        var CustomerMobileNumberidval = CustomerMobileNumberid.get("v.value");
        if(!$A.util.isUndefinedOrNull(CustomerMobileNumberid) ){
            if($A.util.isUndefinedOrNull(CustomerMobileNumberidval)){
                CustomerMobileNumberid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
                CustomerMobileNumberid.set("v.errors", null);
        } 
        
        var startdateid = component.find("startdate");
        var startdateidval = startdateid.get("v.value");
        if(!$A.util.isUndefinedOrNull(startdateid)){
            if(startdateidval == null || startdateidval == ''){
                startdateid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
                startdateid.set("v.errors", null);
        }
        
        var natureofbusinessid = component.find("natureofbusinessauraid");
        var natureofbusinessval = natureofbusinessid.get("v.value");
        if(!$A.util.isUndefinedOrNull(natureofbusinessid)){
            if(natureofbusinessval == null || natureofbusinessval == ''){
                natureofbusinessid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;                
            }
            else{
                natureofbusinessid.set("v.errors", null);
                if(natureofbusinessval == 'Other'){                    
                    var Othernatureofbusinessid = component.find("Othernatureofbusinessauraid");
                    var Othernatureofbusinessval = Othernatureofbusinessid.get("v.value");
                     if(!$A.util.isUndefinedOrNull(Othernatureofbusinessid)){
                        if(Othernatureofbusinessval == null || Othernatureofbusinessval == ''){
                            Othernatureofbusinessid.set("v.errors", [{message:"This field is required" }]);
                            returnstate = false; 
                     }
                     else
                        Othernatureofbusinessid.set("v.errors", null); 
                    }
                }
            }
                
        }
        
        /**
                var lyvolumeid = component.find("lyvolumeauraid");
                var lyvolumeidval = lyvolumeid.get("v.value");
                if(lyvolumeid != null && lyvolumeid != ''){
                    if(lyvolumeidval == null || lyvolumeidval == ''){
                        lyvolumeid.set("v.errors", [{message:"This field is required" }]);
                        returnstate = false;
                    }
                     else
                         lyvolumeid.set("v.errors", null);
                }
                */
        var reasonfordisid = component.find("reasonfordisauraid");
        var reasonfordisidval = reasonfordisid.get("v.value");
        if(reasonfordisid != null && reasonfordisid != ''){
            if(reasonfordisidval == null || reasonfordisidval == ''){
                reasonfordisid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
                reasonfordisid.set("v.errors", null);
        }
        
        return returnstate;
    },
    helperExceptioncase : function(component,event){
        var returnstate = true;
        var strmessage ='This request will have to be approved via an additional approval process. Please populate the [Exception Reason] field as it is mandatory in such scenarios. The request is being marked as requiring additional approvals because of the following reasons:  <br/>';
        
        var dateispast = component.get("v.isdatepast");
        var configmargin = component.get("v.objdiffPric.VCPL_Config_Margin__c");
        var enteredmargin = component.get("v.objdiffPric.VCPL_Dealer_Margin_Liter__c");
        var getdiscountamount = component.get("v.objdiffPric.VCPL_Discount_L__c");
        if(!$A.util.isUndefinedOrNull(configmargin) && configmargin != '' && !$A.util.isUndefinedOrNull(enteredmargin) && enteredmargin != '' &&
           enteredmargin > configmargin){
            strmessage= strmessage + '-> Given margin is more than configured margin. <br/>';
            returnstate = false;
        }
        if(!$A.util.isUndefinedOrNull(dateispast) && dateispast){
            returnstate = false;
            strmessage= strmessage + '-> Start date occurs before current date.<br/>';
        }
        if(!$A.util.isUndefinedOrNull(getdiscountamount) && getdiscountamount > 100){
            returnstate = false;
            strmessage= strmessage + '-> Discount/L more than 100.';
        }
        var reasonfordexcetionid = component.find("reasonforexceptionauraid");
        var reasonfordexcetiondval = reasonfordexcetionid.get("v.value");
        if(reasonfordexcetionid != null && reasonfordexcetionid != '' && !returnstate){
            if(reasonfordexcetiondval == null || reasonfordexcetiondval == ''){
                reasonfordexcetionid.set("v.errors", [{message:"This field is required" }]);
                component.set("v.content",strmessage);
                returnstate = false;
            }
            else{
                reasonfordexcetionid.set("v.errors", null);
                component.set("v.content",null);
                returnstate = true;
            }
            
        }
        return returnstate;
    },
    helpSubmitforApproval :function(component,event,DPId){
        var action = component.get("c.submitforApproval");
        
        action.setParams({
            "strDPId": DPId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // var objWrapCase = response.getReturnValue();
                // component.set("v.objWrapCase",resultLst);
                var responseres = response.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                if(responseres.strResType == 'success')
                {
                    resultsToast.setParams({
                        "type": "success",
                        "title" : "Saved and Submitted for approval",
                        "message" : responseres.strMessage
                    });
                    resultsToast.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": DPId,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
                else if(responseres.strResType == 'error')
                { 
                    resultsToast.setParams({
                        "type": "error",
                        "title" : "Submitted for approval",
                        "message" : responseres.strMessage
                    });
                    resultsToast.fire();
                }  
            }
        });
        $A.enqueueAction(action);
        
    },
    validateEmail : function(component) {
        var isValidEmail = true; 
        var emailField = component.find("CustomerEMail");
        // Store Regular Expression That 99.99% Works. [ http://emailregex.com/] 
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        if(!$A.util.isUndefinedOrNull(emailField)){
            var emailFieldValue = emailField.get("v.value");            
            if(!$A.util.isEmpty(emailFieldValue)){   
                if(emailFieldValue.match(regExpEmailformat)){
                    emailField.set("v.errors", [{message: null}]);
                    $A.util.removeClass(emailField, 'slds-has-error');
                    isValidEmail = true;
                }else{
                    $A.util.addClass(emailField, 'slds-has-error');
                    emailField.set("v.errors", [{message: "Please enter a valid email address"}]);
                    isValidEmail = false;
                }
            }
        }
        
        
        // if Email Address is valid then execute code     
        if(isValidEmail){
            return true;
        }
        else{
            return false;
        }
    },
    validateMobilenumber : function(component) {
        var isValidMobileNumber = true; 
        var MobileNumberField = component.find("CustomerMobileNumber");
        // Store Regular Expression That 99.99% Works. [ http://emailregex.com/] 
        var regExpMobileNumberformat = /^[6-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}[0-9]{1}$/;
        // /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        if(!$A.util.isUndefinedOrNull(MobileNumberField)){
            var MobileNumberFieldValue = MobileNumberField.get("v.value");            
            if(!$A.util.isEmpty(MobileNumberFieldValue)){   
                if(MobileNumberFieldValue.match(regExpMobileNumberformat)){
                    MobileNumberField.set("v.errors", [{message: null}]);
                    $A.util.removeClass(MobileNumberField, 'slds-has-error');
                    isValidMobileNumber = true;
                }else{
                    $A.util.addClass(MobileNumberField, 'slds-has-error');
                    MobileNumberField.set("v.errors", [{message: "Please enter a valid mobile number"}]);
                    isValidMobileNumber = false;
                }
            }
        }
        
        if(isValidMobileNumber){
            return true;
        }
        else{
            return false;
        }
    },
    getPicklistValue : function(component) {
        var action = component.get("c.getPickliskvalue");
        action.setParams({ 
            "objName" : "VCPL_Differential_Pricing__c",
            "FieldName" : "VCPL_Customer_nature_of_business__c"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                
                if (!$A.util.isUndefinedOrNull(response)) {
                    component.set("v.PicklistVal", response);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    updateCloneData : function(component){
        var objectres = component.get("v.IsCloneRequestresponseString");
        if (!$A.util.isUndefinedOrNull(objectres)) {
            component.set("v.objdiffPric", JSON.parse(objectres));
            var objdata = component.get("v.objdiffPric");
            
            component.set("v.objwrapObjectwithName", JSON.parse(component.get("v.objdiffPric.VCPL_Remark__c")));
            var wrapclassname = component.get("v.objwrapObjectwithName");
            component.set("v.AccountName",objdata.VCPL_Customer_Name__c);
            component.set("v.DAMName", wrapclassname.DAMName);
            component.set("v.DealerName", wrapclassname.DealerName);
            component.set("v.BranchName", wrapclassname.BranchName);
            component.set("v.TextName",wrapclassname.BranchName);
            console.log('=====wrapclassname.LoginUserProfile'+wrapclassname.LoginUserProfile);
            if(wrapclassname.LoginUserProfile == 'ELP')
                component.set("v.isLoginAsELP",true);
            
            component.set("v.AccountName",objdata.VCPL_Customer_Name__c);
            component.set("v.DAMName", wrapclassname.DAMName);
            component.set("v.DealerName", wrapclassname.DealerName);
            component.set("v.BranchName", wrapclassname.BranchName);
            var cmpAccountlookup = component.find("AccountLookupauraid");
            cmpAccountlookup.initMethod();
            
            component.set("v.TextName", objdata.VCPL_Customer_Name__c);
            component.set("v.AccountName", wrapclassname.CustomerName);
            
            var cmpBranchlookup = component.find("BranchLookupauraid");
            if(!$A.util.isUndefinedOrNull(cmpBranchlookup))
                cmpBranchlookup.initMethod();
            
            var cmpProductlookup = component.find("ProductLookupauraid"); 
            cmpProductlookup.set("v.SelectedItemId",objdata.VCPL_Product__c);
            if(objdata.VCPL_Product__c != null && objdata.VCPL_Product__c != '' 
               && objdata.VCPL_Product__r.Name != null && objdata.VCPL_Product__r.Name != ''){
                component.set("v.objdiffPric.VCPL_Product__r.Name",objdata.VCPL_Product__r.Name);
                cmpProductlookup.initMethod();
            }
            var confignatureofbusiness = objdata.VCPL_Customer_nature_of_business__c;
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
    }
})