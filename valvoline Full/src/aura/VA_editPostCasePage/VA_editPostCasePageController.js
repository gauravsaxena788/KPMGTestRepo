({
    doInit: function(component, event, helper) {
         
        component.find("lab").set("v.value","Ambernath");
        var myObjectMap = {"VA1_Lab__c":"lab",
                           "VA_Request_Purpose__c": "reqPurpose",
                           "VA_Type_Of_Sample__c":"sampleType",
                           "VA_Total_Engine_Hours__c":"totalEquipmentLife"
                          };
        $A.util.addClass(component.find("projectdiv"), "slds-hide");
        $A.util.addClass(component.find("otherSampleDiv"), "slds-hide");
        $A.util.addClass(component.find("complaintNoDiv"), "slds-hide");
        $A.util.addClass(component.find("additionalCommentsDiv"), "slds-hide");
        //$A.util.addClass(component.find("accountDiv"), "slds-hide");
        //$A.util.addClass(component.find("contactDiv"), "slds-hide");
        
        console.log("In edtPstCasePgCmp-->H-->doInit-->Val of ifAccIdExist--> "+component.get("v.ifAccIdExist"));
        var accVal = component.get("v.ifAccIdExist");
        if($A.util.isUndefinedOrNull(accVal)  || accVal === ""){
             helper.getAccountName(component, event);
            helper.getContactName(component, event);
        }else{
            helper.getAccountName2(component, event);
        }



        helper.fetchlistPickListVal(component, myObjectMap);
        //helper.getContactName(component, event);
        var recId = component.get("v.recordId");
        if(!$A.util.isUndefinedOrNull(recId)){
           helper.fetchExistingValues(component, event, recId);
        }
        if($A.get("$Browser.formFactor") == 'DESKTOP'){
             $A.util.removeClass(component.find("modelFooter"), "slds-hide");
             $A.util.addClass(component.find("modelFooterMobile"), "slds-hide");
        }
        else{
            $A.util.addClass(component.find("modelFooter"), "slds-hide");
            $A.util.removeClass(component.find("modelFooterMobile"), "slds-hide");
        }
       
    },
    cancel : function(component, event, helper) {
        component.set('v.showTestPage',false);
    },
    closeToast : function(component, event, helper) {
        component.set('v.errormsg',"");
    },
    controllerSaveCaseDetails:function(component, event, helper) {
    	component.set("v.caseObj.AccountId",component.get("v.selectedLookUpRecord.Id"));
        component.set("v.caseObj.ContactId",component.get("v.selectedLookUpContact.Id"));
        component.set("v.caseObj.VA_Project__c",component.get("v.selectedProjectrecord.Id"));
        component.set("v.caseObj.VA_Product__c",component.get("v.selectedProductrecord.Id"));
        component.set("v.caseObj.Product_Category__c",component.get("v.selectedProductCategoryRecord.Id"));
        var caseObj = component.get("v.caseObj");
        //alert(JSON.stringify(caseObj));
        helper.savePostCase(component, event, helper);
    },
    onReqPurposeChange:function(component, event, helper) {
        helper.setReqPurpose(component, event, helper);
    },
    onSampleTypeChange : function(component, event, helper) {
        helper.setSampleType(component, event, helper);
    },
    navigateToPreviousPage : function (component, event, helper){
         
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }
})