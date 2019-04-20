({
    scoreCardChangeHandler: function(component, selectedScoreId, scoreCardRecordLineItem) {
        var dealerScoreCardRecord = component.get("v.dealerScoreCardRecord") || {};
        if ($A.util.isEmpty(selectedScoreId))
            return;
        var getScoreCardMasterRecordData = component.get("c.getScoreCardMasterRecordData");
        getScoreCardMasterRecordData.setParams({
            "scoreCardParameterRecordId": selectedScoreId,
            "scoreCardRecord": JSON.stringify(dealerScoreCardRecord)
        });
        this.showSpinner(component);
        getScoreCardMasterRecordData.setCallback(this, function(response) {
            this.getScoreCardMasterRecordDatahandler(response, component, scoreCardRecordLineItem);
        });
        $A.enqueueAction(getScoreCardMasterRecordData);
    },
    getScoreCardMasterRecordDatahandler: function(response, component, scoreCardRecordLineItem) {
        var responseData = response.getReturnValue() || {};
        this.hideSpinner(component);

        if (component.isValid() && response.getState() === "SUCCESS" &&
            responseData.isSuccess && responseData.response) {
            var response = JSON.parse(responseData.response) || [];
            scoreCardRecordLineItem.VCPL_Score_Card_Parameter__r = response.scoreCardParameterRecord;
            scoreCardRecordLineItem.VCPL_Value__c = response.calculatedValue;
        } else {
            this.handleFailedCallback(component, responseData);
        }
        component.set("v.scoreCardRecordLineItem", scoreCardRecordLineItem);
    }
})