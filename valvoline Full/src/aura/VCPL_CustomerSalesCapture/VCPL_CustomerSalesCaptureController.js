({
    doInit: function(component, event, helper) {
        helper.getDetailsWrapper(component, event, helper);
        helper.getOpportunityWrapper(component, event, helper);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    onChangeofMonth: function(component, event, helper) {
        helper.onChangeofMonthHelper(component, event, helper);
    },
    onSaveButtonClick: function(component, event, helper) {
        helper.saveOpportunity(component, event, helper);
    },
    onSearchStringChange: function(component, event, helper) {
        var searchString = component.get("v.searchString");
        helper.searchUserHelper(component, searchString);
    },
    closeToast: function(component, event, helper) {
        component.set('v.errormsg', "");
    }
})