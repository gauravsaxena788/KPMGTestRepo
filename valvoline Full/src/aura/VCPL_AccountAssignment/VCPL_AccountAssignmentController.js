({
    doInit: function(component, event, helper) {
        var sortingOrder = {
            'lastYearVolume': true,
            'potentialLYDifference': true
        };
        component.set("v.sortingOrder", sortingOrder);
        helper.getData(component, event, helper);
    },
    onChangeofClassification: function(component, event, helper) {
        helper.filterList(component, event, helper);
    },
    onSearchStringChange: function(component, event, helper) {
        helper.filterList(component, event, helper);
    },
    onSaveButtonClick: function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.saveData(component, event, helper);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    sortList: function(component, event, helper) {
        var fieldNameToSort = event.currentTarget.getAttribute("data-label");
        var order = event.currentTarget.getAttribute("data-order");
        var dataWrapperReference = component.get("v.dataWrapper");
        helper.sortListForField(component, dataWrapperReference, fieldNameToSort, order);
        helper.renderPage(component);
    }
})