({
    getAccountName : function(component,event) {
        var action=component.get("c.getAccountNameMethod");
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.selectedLookUpRecord",result);
                    var cmp = component.find("lookupComp");
                    cmp.set('v.SearchKeyWord',result.Name);
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
                    console.log("In EdtPstKitCasePgCmp-->H-->getAccName2-->ret val from Apex-->"+JSON.stringify(result));
                    var cmp = component.find("lookupComp");
                    cmp.set('v.SearchKeyWord',result.Name);
                }
            }
            
        }); 
        $A.enqueueAction(action);                    
        //} 
    },
    getContactName : function(component,event) {
       
        var action=component.get("c.getContactNameMethod");
        
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
            
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.selectedLookUpContact",result);
                    var cmp = component.find("lookupContact");
                    var name = result.FirstName + ' '+result.LastName;
                    cmp.set('v.SearchKeyWord',name);
                }
            }
            
        }); 
        $A.enqueueAction(action);                     
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
             
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBottleData: function(component, event){
        var accId = component.get("v.selectedLookUpRecord.Id");
        var action = component.get("c.getBottlesDataMethod");
       
        action.setParams({
            "accId": accId
        });
        
        action.setCallback(this, function(actionresult) {
            
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                var bottleBalnace = 0;
                if(!$A.util.isUndefinedOrNull(result) && !$A.util.isUndefinedOrNull(result.VA_Total_No_Of_Bottles_Requested__c) && !$A.util.isUndefinedOrNull(result.VA_Total_Test_Already_Requested__c)){
                    if(Number(result.VA_Total_No_Of_Bottles_Requested__c) > Number(result.VA_Total_Test_Already_Requested__c)){
                    	bottleBalnace = Number(result.VA_Total_No_Of_Bottles_Requested__c) - Number(result.VA_Total_Test_Already_Requested__c);
                    	component.set("v.bottleBalanceWithCustomer",bottleBalnace);
                    }
                    else{
                        component.set("v.bottleBalanceWithCustomer",0);
                    }
                }
                if(!$A.util.isUndefinedOrNull(result) && !$A.util.isUndefinedOrNull(result.VA_Total_No_Of_Bottles_Requested__c)){
                    component.set("v.totalBottlesAlreadyRequested",result.VA_Total_No_Of_Bottles_Requested__c);
                }
                if(!$A.util.isUndefinedOrNull(result) &&  !$A.util.isUndefinedOrNull(result.VA_Total_Test_Already_Requested__c)){
                    component.set("v.totalTestsAlreadyRequested",result.VA_Total_Test_Already_Requested__c);
                }
            }
        }); 
        $A.enqueueAction(action);
        
    },
    
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
    
    savePostKitData: function (component, event){
        
       
        var recId = component.get("v.recordId");
        component.set("v.caseObj.AccountId",component.get("v.selectedLookUpRecord.Id"));
        component.set("v.caseObj.VA_Project__c",component.get("v.selectedProjectrecord.Id"));
        component.set("v.caseObj.ContactId",component.get("v.selectedLookUpContact.Id"));
        console.log('ZZZ H-->savePostKit-->Contact ID-->'+component.get("v.selectedLookUpContact.Id"));
        component.set("v.caseObj.Id",recId);
        var caseObj = component.get("v.caseObj");
		
		var reqPurpose = component.find("reqPurpose");
		var project = component.find("lookupCompProject").find("textValue");
        var bottleBalanceWithCustomer = component.get("v.bottleBalanceWithCustomer");
		var compNumber = component.find("complaint");
		var numberOfBottleReq = component.find("numberKit");
		var reason = component.find("reasonAdditional");
        var additionalComent = component.find("AdditionalComments");
		var additionalBottleOtherReason = component.find("otherReason");
        var projectRecord = component.get("v.selectedProjectrecord");
        var isValid=true;
        var sErrorMsg ="";
        sErrorMsg = "";
        if(caseObj.VA_Request_Purpose__c == ''){
			isValid = false;
            sErrorMsg = 'Please select a Request Purpose ';
			reqPurpose.set("v.errors", [{message: sErrorMsg}]);
        }
        else if(caseObj.VA_Request_Purpose__c == 'Project' && $A.util.isUndefinedOrNull(projectRecord.Name)){
            isValid = false;
            sErrorMsg = 'Please select a Project';
			//reqPurpose.set("v.errors", [{message: sErrorMsg}]);
        }
        else if(caseObj.VA_Request_Purpose__c == 'Others' && $A.util.isUndefinedOrNull(caseObj.VA_Additional_Comments__c)){
            isValid = false;
            sErrorMsg = 'Please enter Additional Comment';
			additionalComent.set("v.errors", [{message: sErrorMsg}]);
        }
		else if(caseObj.VA_Request_Purpose__c == 'Complaints' && $A.util.isUndefinedOrNull(caseObj.VA_Complaint_Number__c)){
            isValid = false;
            sErrorMsg = 'Please enter a valid Complaint Number.';
			compNumber.set("v.errors", [{message: sErrorMsg}]);
        }
        else if($A.util.isUndefinedOrNull(caseObj.VA_No_Of_Bottles_Requested__c)){
            isValid = false;
            sErrorMsg = 'Please enter No. of Additional Kit Requested.';
			numberOfBottleReq.set("v.errors", [{message: sErrorMsg}]);
        }
        else if(!$A.util.isUndefinedOrNull(caseObj.VA_No_Of_Bottles_Requested__c) && isNaN(caseObj.VA_No_Of_Bottles_Requested__c)){
			  isValid = false;
			  sErrorMsg = 'Please enter numeric value for Number Of Bottles.';
			  numberOfBottleReq.set("v.errors", [{message: sErrorMsg}]);
        }
        else if(!$A.util.isUndefinedOrNull(caseObj.VA_No_Of_Bottles_Requested__c) && caseObj.VA_No_Of_Bottles_Requested__c > 0 && bottleBalanceWithCustomer > 0 && caseObj.VA_Reason__c == ''){
            isValid = false;
            sErrorMsg = 'Please select a Reason for Additional Bottles.';
			reason.set("v.errors", [{message: sErrorMsg}]);
        }
		else if(caseObj.VA_Reason__c != '' && caseObj.VA_Reason__c == 'Other Reason' && ($A.util.isUndefinedOrNull(caseObj.VA_Additional_Bottle_Other_Reason__c) || caseObj.VA_Additional_Bottle_Other_Reason__c == '')){
            isValid = false;
            sErrorMsg = 'Please enter Other Reason for Additional Bottles.';
			additionalBottleOtherReason.set("v.errors", [{message: sErrorMsg}]);
        }
        
        
        
        if(!isValid){
            this.showToast(component, event,sErrorMsg); 
            return;
        }
        
        console.log('@@@'+caseObj);
        this.waiting();
        var action=component.get("c.savePostKitDataMethod");
        action.setParams({"caseObj" :caseObj});
        action.setCallback(this, function(actionresult) {
            var state = actionresult.getState();
            if(state === "SUCCESS"){
                var result =actionresult.getReturnValue();
                var res = result.substring(0, 5);
                if (res== 'Error'){
                    	var toastEvent = $A.get("e.force:showToast");
                    	toastEvent.setParams({
                        message: "An error has occurred.Please contact your system administrator if this problem persists.",
                        type : 'error'
                        
                    });
                    toastEvent.fire(); 
                    return;	    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    	toastEvent.setParams({
                        message: "Case successfully created!",
                        type : 'success'
                        
                    });
                    toastEvent.fire();	    
                }
                console.log(result);
                component.set("v.recordId",result);
                this.navigate(component, event, result);
               
            }
            this.doneWaiting();
        }); 
        $A.enqueueAction(action);                     
    },
    
    fetchExistingValues: function(component, event, recId){
        if(!$A.util.isUndefinedOrNull(recId)){
            var action=component.get("c.fetchExistingValuesMethod");
            action.setParams({"recId" :recId});
            action.setCallback(this, function(actionresult) {
                var state = actionresult.getState();
                if(state === "SUCCESS"){
                    
                    var result = actionresult.getReturnValue();
                    if(!$A.util.isUndefinedOrNull(result)){
                        var cmpContact = component.find("lookupContact");
                        var cmpAccount = component.find("lookupComp");
                        var cmpProject = component.find("lookupCompProject");
                        cmpContact.set('v.SearchKeyWord',result.Contact.Name);
                        cmpAccount.set('v.SearchKeyWord',result.Account.Name);
                        component.set('v.caseObj',result);
                        cmpProject.set('v.SearchKeyWord',result.VA_Project__r.Name);
                    }
                    
                    //component.set("v.recordId",result);
                }
            }); 
            $A.enqueueAction(action);
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
    },
    
    navigate: function(component, event, recId) {
    
        if($A.get("$Browser.formFactor") == 'DESKTOP'){
            if (recId.indexOf("500") >-1) { //Note 500 is prefix for Case Record
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/case/'+recId
                  //"url" : '/case-detail?id='+recId
                });
                urlEvent.fire();
            }
        }
        else{
           if (recId.indexOf("500") >-1) { //Note 500 is prefix for Case Record
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/'+recId
                });
                urlEvent.fire();
            } 
        }
    },
    
    clearLookup: function(component){
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
    
    getKitPrice : function (component, event){
     
        //alert('getprice');
        var action = component.get("c.getKitPriceMethod");
        action.setCallback(this, function(response) {
           
            var state = response.getState();
            console.log(state);
            //alert(state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
               
                if(!$A.util.isUndefinedOrNull(result)){
                    component.set("v.kitPrice",result);
                }
            }
            
        }); 
        $A.enqueueAction(action);
    }
})