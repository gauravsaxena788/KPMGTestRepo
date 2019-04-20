({
    doInit: function(component, event, helper) {
        helper.getScoreCardLineItems(component);
    },
    addScoreCardLineItemRow: function(component, event, helper) {
        helper.addScoreCardLineItemRowToList(component);
    },
    saveScoreCardLineItems: function(component, event, helper) {
        var listOfDealerScoreCardLineItems = component.get("v.listOfDealerScoreCardLineItems");
        if (!listOfDealerScoreCardLineItems || listOfDealerScoreCardLineItems.length == 0) {
            helper.showToast('Error', 'error', 'Please add a record!');
            return;
        }

        if (helper.validateRecord(component, listOfDealerScoreCardLineItems))
            helper.saveScoreCardLineItems(component, listOfDealerScoreCardLineItems);
    }
})