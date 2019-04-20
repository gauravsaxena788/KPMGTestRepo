({
    scoreCardChangeHandler: function(component, event, helper) {
        var scoreCardRecordLineItem = component.get("v.scoreCardRecordLineItem") || {};
        var scoreCardName = event.getParam("recordName");
        var selectedScoreId = event.getParam("sObjectId");
        var index = event.getParam("externalParameter");

        if (selectedScoreId != null) {
            helper.scoreCardChangeHandler(component, selectedScoreId, scoreCardRecordLineItem);
        } else {
            scoreCardRecordLineItem.VCPL_Score_Card_Parameter__c = null;
        }

        component.set("v.scoreCardRecordLineItem", scoreCardRecordLineItem);
    },
    clearScoreCard: function(component, event, helper) {
        var scoreCardRecordLineItem = component.get("v.scoreCardRecordLineItem") || {};
         scoreCardRecordLineItem.VCPL_Score_Card_Parameter__r = null;
        component.set("v.scoreCardRecordLineItem", scoreCardRecordLineItem);

    }
})