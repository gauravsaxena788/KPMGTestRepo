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
    
     sortByOrderNumber: function(component, event, helper) {    
        helper.sortBy(component, "OrderNumber");
    },
    sortByAccountName: function(component, event, helper) {
        helper.sortBy(component, "Account.Name");
    },
    sortByEffectiveDate: function(component, event, helper) {
        helper.sortBy(component, "EffectiveDate");
    },
    sortByStatus: function(component, event, helper) {
        helper.sortBy(component, "Status");    
    },
     sortByRequestedOrderQuantity: function(component, event, helper) {
        helper.sortBy(component, "VA_Order_Quantity_Requested_Line__c");      
    }, 
	sortByRegisteredorderQuantity: function(component, event, helper) {
		helper.sortBy(component, "VA_Order_Quantity__c");
	},
	sortByDeliveredQuantity: function(component, event, helper) {
		helper.sortBy(component, "VA_Total_Invoice_Quantity__c");
	},
    
    openRecord : function(component, event, helper) {
        var recId = event.currentTarget.id;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/order-detail?id="+recId
        });
         urlEvent.fire();
    }
   
})