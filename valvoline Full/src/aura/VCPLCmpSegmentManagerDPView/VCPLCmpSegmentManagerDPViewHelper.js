({
    getSegmentManagerViewHelper: function(component) {
        var getSegmentManagerViewDataService = component.get("c.getSegmentManagerViewDataService");
        getSegmentManagerViewDataService.setParams({
            "month": component.get("v.selectedMonth"),
            "year": component.get("v.selectedYear")
        });
        getSegmentManagerViewDataService.setCallback(this, function(response) {
            this.getSegmentManagerViewDataServiceHandler(response, component);
        });
        $A.enqueueAction(getSegmentManagerViewDataService);
    },
    getSegmentManagerViewDataServiceHandler: function(response, component) {
        var responseData = response.getReturnValue() || {};
        this.hideSpinner(component);

        if (component.isValid() && response.getState() === "SUCCESS" && responseData.isSuccess) {
            this.setResponseData(component, responseData);
        } else {
            this.handleFailedCallback(component, responseData);
        }
    },
    setResponseData: function(component, responseData) {
        var response = responseData.response ? JSON.parse(responseData.response) || [] : [];
        component.set("v.mapOfDealerIdVsPrimaryConsolidatedAmount", response.mapOfDealerIdVsPrimaryConsolidatedAmount);
        component.set("v.mapOfDealerIdVsPrevMonthClosingSales", response.mapOfDealerIdVsPrevMonthClosingSales);
        component.set("v.mapOfDealerIdVsSecodaryVolumeSum", response.mapOfDealerIdVsSecodaryVolumeSum);
        component.set("v.mapOfDealer", response.mapOfDealer);
        component.set("v.mapOfDealerVsBalanceAmount", response.mapOfDealerVsBalanceAmount);
        this.setDealerView(component, response.mapOfDealerIdVsSecodaryVolumeSum, response.mapOfDealerIdVsPrimaryConsolidatedAmount, response.mapOfDealerIdVsPrevMonthClosingSales, response.mapOfDealer);
    },
    setDealerView: function(component, mapOfDealerIdVsSecodaryVolumeSum, mapOfDealerIdVsPrimaryConsolidatedAmount, mapOfDealerIdVsPrevMonthClosingSales, mapOfDealer) {
        var lstOfDealerWiseSegmentView = [];
        var dealerRecord = {};
        for (var dealer in mapOfDealerIdVsSecodaryVolumeSum) {
            dealerRecord.dealerName = mapOfDealer[dealer].Name;
            dealerRecord.discountEligible = mapOfDealerIdVsSecodaryVolumeSum[dealer] ? mapOfDealerIdVsSecodaryVolumeSum[dealer] : 0 + mapOfDealerIdVsPrevMonthClosingSales[dealer] ? mapOfDealerIdVsPrevMonthClosingSales[dealer] : 0;
            dealerRecord.discountPassed = mapOfDealerIdVsPrimaryConsolidatedAmount[dealer] ? mapOfDealerIdVsPrimaryConsolidatedAmount[dealer] : 0;
            dealerRecord.balanceAmount = dealerRecord.discountEligible - dealerRecord.discountPassed;
            lstOfDealerWiseSegmentView.push(dealerRecord);
        }
        if (lstOfDealerWiseSegmentView.length > 0)
            component.set("v.lstOfDealerWiseSegmentView", lstOfDealerWiseSegmentView);
        else
            this.showToast('Error', 'Error', 'No DP found for the combination!');
    }
})