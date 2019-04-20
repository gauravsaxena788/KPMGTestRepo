({

    getCase : function(component,helper,pageNumber, pageSize) { 
        debugger;
        var strAccountId =component.get("v.accountId"); 
        var strObjectName =component.get("v.objectName");
        var strfieldNames =component.get("v.fieldNames"); 
        
        var action = component.get("c.getCaseList");//get data from controller
        
        action.setParams({ "strRecordId" : strAccountId,
                          "strObjectApI" : strObjectName,
                          "strFieldListName" : strfieldNames,
                          "pageNumber": pageNumber,
                          "pageSize": pageSize,
                          "parentId": helper.getParentId(),
                          "filterName" : component.get("v.filterName")
                         });   
        
        action.setCallback(this, function(result) {
            var state = result.getState();  
            
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                
                component.set("v.Invoices", resultData.invoiceList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }  
            });
        $A.enqueueAction(action);
    },  
     
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        component.set("v.data", data);
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.Invoices");
        sortAsc = (field == sortField)? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],  
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.Invoices", records);  
    },
    
    getParentId : function () {
        var query = location.search.substr(1);

        var result = {};
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            result[item[0]] = decodeURIComponent(item[1]);
        });

        return result.id;
    }
 
})