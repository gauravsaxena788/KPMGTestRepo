({

    doInit : function(component, event, helper) {  
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");  
        helper.getCase(component,helper,pageNumber, pageSize);//get data from the helper
    },
    
    handleNext: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        helper.getCase(component,helper,pageNumber, pageSize);
    },
     
    handlePrev: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        helper.getCase(component,helper,pageNumber, pageSize);
    },
     
    onSelectChange: function(component, event, helper) {
        var page = 1
        var pageSize = component.find("pageSize").get("v.value");
        helper.getCase(component,helper,page, pageSize);       
    },
    
     sortByName: function(component, event, helper) {    
        helper.sortBy(component, "Name");
    },
    sortByTotalInvoiceQuantity: function(component, event, helper) {
        helper.sortBy(component, "VA_Total_Invoice_Quantity__c");
    },
    sortByInvoiceStatus: function(component, event, helper) {
        helper.sortBy(component, "VA_Invoice_Status__c");
    },
    sortBySAPInvoiceNumber: function(component, event, helper) {
        helper.sortBy(component, "VA_Invoice_Number__c");
    },
	sortByOrderNumber:function(component, event, helper) {
		helper.sortBy(component, "VA_Order__r.OrderNumber");
	},
	sortByInvoiceDate:function(component, event, helper) {
		helper.sortBy(component, "VA_Invoice_Date__c");
	},
	sortByPODUploadDate:function(component, event, helper) {
		helper.sortBy(component, "VA_POD_Upload_Date__c");
	},
    openRecord : function(component, event, helper) 
    {
        var recId = event.currentTarget.id;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/invoice-detail?id="+recId
        });
        urlEvent.fire();
    }
   
})