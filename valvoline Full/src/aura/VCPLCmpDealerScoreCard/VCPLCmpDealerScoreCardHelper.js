({
    addScoreCardLineItemRowToList: function(component) {
        var recordId = component.get("v.recordId");
        var scoreCardId = component.get("v.scoreCardId");
        var listOfDealerScoreCardLineItems = component.get("v.listOfDealerScoreCardLineItems") || [];

        this.newRowAdd(recordId, listOfDealerScoreCardLineItems);
        component.set("v.listOfDealerScoreCardLineItems", listOfDealerScoreCardLineItems);
    },
    newRowAdd: function(scoreCardId, listOfDealerScoreCardLineItems) {
        var scoreCardLineItem = {
            'VCPL_Score_Card__c': scoreCardId
        };
        listOfDealerScoreCardLineItems.push(scoreCardLineItem);
    },
    getScoreCardLineItems: function(component) {
        var getDealerScoreCardData = component.get("c.getDealerScoreCardData");
        getDealerScoreCardData.setParams({
            "dealerScoreCardRecordId": component.get("v.recordId")
        });
        getDealerScoreCardData.setCallback(this, function(response) {
            this.getScoreCardLineItemsHandler(response, component);
        });
        $A.enqueueAction(getDealerScoreCardData);
    },
    getScoreCardLineItemsHandler: function(response, component) {
        var responseData = response.getReturnValue() || {};
        this.hideSpinner(component);

        if (component.isValid() && response.getState() === "SUCCESS" && responseData.isSuccess) {
            this.setScoreCardLineItems(component, responseData);
        } else {
            this.handleFailedCallback(component, responseData);
        }
    },
    setScoreCardLineItems: function(component, responseData) {
        var response = responseData.response ? JSON.parse(responseData.response) || [] : [];
        component.set("v.listOfDealerScoreCardLineItems", response.lstOfScoreCardLineItems)
    },
    validateRecord: function(component, listOfDealerScoreCardLineItems) {
        return true;
    },
    saveScoreCardLineItems: function(component, listOfDealerScoreCardLineItems) {
        var upsertScoreCardLineItems = component.get("c.upsertScoreCardLineItems");
        upsertScoreCardLineItems.setParams({
            "scoreCardLinItemJson": JSON.stringify(listOfDealerScoreCardLineItems),
            "dealerScoreCardRecordId" : component.get("v.recordId")
        });
        upsertScoreCardLineItems.setCallback(this, function(response) {
            this.upsertScoreCardLineItemsHandler(response, component);
        });
        $A.enqueueAction(upsertScoreCardLineItems);
    },
    upsertScoreCardLineItemsHandler: function(response, component) {
        var responseData = response.getReturnValue() || {};
        this.hideSpinner(component);

        if (component.isValid() && response.getState() === "SUCCESS" && responseData.isSuccess) {
            this.setScoreCardLineItems(component, responseData);
            this.showToast('Success', 'success', 'Record Saved Succesfully');
        } else {
            this.handleFailedCallback(component, responseData);
        }
    },
})