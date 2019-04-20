({
    /**
     * Search an SObject for a match
     */

    search: function(cmp, event, helper) {
        //cmp.set("v.IsClickOnSearch",false);
        var filterName = cmp.get('v.FilterName');
        
        if(filterName == null || filterName == '' || filterName == undefined)
        	helper.doSearch(cmp, event);
        else
        	helper.doFilteredSearch(cmp, event,filterName);
    },

    /**
     * Select an SObject from a list
     */
    select: function(cmp, event, helper) {
        helper.handleSelection(cmp, event);
    },

    /**
     * Clear the currently selected SObject
     */
    clear: function(cmp, event, helper) {
       
        helper.clearSelection(cmp);
    },
    /**
     * Function for set default value in lookup
     */
    SetDefaultValue: function(component, event, helper) {

        var selectedItemId = component.get("v.SelectedItemId");
        var selectedItemText = component.get("v.SelectedItemText");
        
        if (selectedItemId && selectedItemId.length > 0) {
            helper.SetSelectedValue(component, selectedItemText, selectedItemId);
        }

    },
    /**
     * Dispaly last 10 modify record when user click on lookup
     **/
    DisplayLastModifyRecord: function(component, event, helper) {
        component.set("v.IsClickOnSearch", true);
        helper.doSearch(component, event);
    }
})