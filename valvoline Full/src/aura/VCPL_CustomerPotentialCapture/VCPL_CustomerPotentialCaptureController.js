({
	doInit : function(component, event, helper) {
        helper.getDetailsWrapper(component, event, helper);
	},
	onSaveButtonClick: function(component, event, helper) {
		helper.saveData(component, event, helper);
	},
	 onSearchStringChange: function(component, event, helper) {
        var searchString = component.get("v.searchString");
        helper.searchAccountHelper(component, searchString);
    },
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    }
})