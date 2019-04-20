({
	doInit : function(component, event, helper) {
		helper.doInitHelper(component, event, helper);
	},
	renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },
    onChangeOfPicklist: function(component, event, helper) {
    	helper.onchangeofPicklistHelper(component, event, helper);
    }
})