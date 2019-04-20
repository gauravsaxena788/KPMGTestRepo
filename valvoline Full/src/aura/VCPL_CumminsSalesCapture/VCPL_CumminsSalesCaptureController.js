({
    doInit: function(component, event, helper) {
        var sortingOrder = {
            'lastYearSalesVolume': true,
            'actualSales': true,
            'potential':true
        };
        component.set("v.sortingOrder", sortingOrder);
        component.set("v.sortingOrderLYVolume", component.get("v.sortingOrder").lastYearSalesVolume);
        component.set("v.sortingOrderAS", component.get("v.sortingOrder").actualSales);
        component.set("v.sortingOrderPotential", component.get("v.sortingOrder").potential);
        
        helper.getData(component, event, helper);
    },
    sortList: function(component, event, helper) {
        var fieldNameToSort = event.currentTarget.getAttribute("data-label");
        var order = event.currentTarget.getAttribute("data-order");
        var dataWrapperReference = component.get("v.dataWrapper");
        helper.sortListForField(component, dataWrapperReference, fieldNameToSort, order);
        helper.renderPage(component);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    onChangeofClassification: function(component, event, helper) {
        helper.filterList(component, event, helper);
    },
    onSearchStringChange: function(component, event, helper) {
        helper.filterList(component, event, helper);
    },
    onSaveButtonClick: function(component, event, helper) {
        helper.saveData(component, event, helper);
    },
    onChangeofAccount: function(component, event, helper) {
        component.set('v.strClassification', component.get('v.defaultClassification'));
        component.set('v.searchString', '');
        helper.onChangeofBranch(component, event, helper);
    }
})