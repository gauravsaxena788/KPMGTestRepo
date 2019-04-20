({ 
    doInit: function(component, event, helper) {
        var sortingOrder = {
            'lastYearVolume': true,
            'potentialLYDifference': true
        };
        component.set("v.sortingOrder", sortingOrder);

        component.set("v.sortingOrderLYVolume", component.get("v.sortingOrder").lastYearVolume);
        component.set("v.sortingOrderPD", component.get("v.sortingOrder").potentialLYDifference);
        helper.getData(component, event, helper);
    },
    sortList: function(component, event, helper) {
        var fieldNameToSort = event.currentTarget.getAttribute("data-label");
        var order = event.currentTarget.getAttribute("data-order");
        var dataWrapperReference = component.get("v.dataWrapper");
        helper.sortListForField(component, dataWrapperReference, fieldNameToSort, order);
        helper.renderPage(component);
    },
    onChangeofClassification: function(component, event, helper) {
        helper.filterList(component, event, helper);
    },
    onSearchStringChange: function(component, event, helper) {
        helper.filterList(component, event, helper);
    },
    onChangeofAccount: function(component, event, helper) {
        component.set('v.strClassification', component.get('v.defaultClassification'));
        component.set('v.searchString', '');
        helper.onChangeofBranch(component, event, helper);
    },
    onSaveButtonClick: function(component, event, helper) {
        helper.saveData(component, event, helper);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
})