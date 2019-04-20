({

    doInit : function(component, event, helper) {  
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");  
        helper.getCase(component,helper,pageNumber, pageSize);//get data from the helper
    },
   
    handleRouteChange : function(component,event,helper){
        console.log("ZZ in VA_ShwLstVwCmp-->C-->RouteChangeEVT-->URL-->"+location.search);
    },
    onUrlChange : function(component,event,helper){

    },
    locationChange: function(component,event,helper){
        var url = event.getParam('token'); 
        var query = event.getParam('querystring'); 
        
        console.log("ZZ in VA_ShwLstVwCmp-->C-->LocChangeEVT-->URL-->"+JSON.stringify(url));
        console.log("ZZ in VA_ShwLstVwCmp-->C-->LocChangeEVT-->query-->"+JSON.stringify(query));
        console.log("ZZ in VA_ShwLstVwCmp-->C-->LocChangeEVT-->loc ref URL-->"+location.search);
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
    
     sortByCaseNumber: function(component, event, helper) {    
        helper.sortBy(component, "CaseNumber");
    },
    sortByContactName: function(component, event, helper) {
        helper.sortBy(component, "Contact.Name");
    },
    sortByComplaintcategory: function(component, event, helper) {
        helper.sortBy(component, "VA_Complaint_Category__c");
    },
    sortByStatus: function(component, event, helper) {
        helper.sortBy(component, "Status");
    },
    sortByCreatedDate: function(component, event, helper) {
        helper.sortBy(component, "CreatedDate");    
    },
     sortByCaseOwner: function(component, event, helper) {
        helper.sortBy(component, "Owner.Name");      
    }, 
    
    openRecord : function(component, event, helper) {
        var recId = event.currentTarget.id;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          //"url": "/case-detail?id="+recId
          //"url": "/case/"+recId+"/detail"
          'url' : '/case/'+recId //+'/detail'
         //   "url" : "/case/"+recId
        });
        urlEvent.fire();
    }
   
})