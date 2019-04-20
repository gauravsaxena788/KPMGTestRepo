({
    NONE_ENTRY: {
        'text': '',
        'label': 'None'
    },
    getLoggedInUserRelatedDetails: function(component, event, helper) {
        var getLoggedInUserRelatedDataService = component.get("c.getLoggedInUserRelatedDataService");
        getLoggedInUserRelatedDataService.setParams({
            "leadRecordId": component.get("v.recordId")
        });
        getLoggedInUserRelatedDataService.setCallback(this, function(response) {
            this.getLoggedInUserRelatedDataServiceHandler(response, component);
        });
        $A.enqueueAction(getLoggedInUserRelatedDataService);
    },
    getLoggedInUserRelatedDataServiceHandler: function(response, component) {
        var responseData = response.getReturnValue() || {};
        this.hideSpinner(component);

        if (component.isValid() && response.getState() === "SUCCESS" && responseData.isSuccess) {
            this.setUserRelatedDetails(component, responseData);
        } else {
            this.handleFailedCallback(component, responseData);
        }
    },
    setUserRelatedDetails: function(component, responseData) {
        var response = responseData.response ? JSON.parse(responseData.response) || {} : {};
        component.set("v.leadRecord", response.leadRecord);
        component.set("v.mapOfRelatedInputPicklists", response.mapOfRelatedInputPicklists);
        component.set("v.loggedInUser", response.currentLogedInUserDetails);
        this.setListOfBranches(component);
        this.setBranchHeadList(component);
        this.setELPList(component);
    },
    setListOfBranches: function(component) {
        var mapOfRelatedInputPicklists = component.get("v.mapOfRelatedInputPicklists") || {};
        var lstOfBranches = [];
        var branch = {};
        if (mapOfRelatedInputPicklists.branchList) {
            for (var index = 0; index < mapOfRelatedInputPicklists.branchList.length; index++) {
                branch = {
                    'text': mapOfRelatedInputPicklists.branchList[index].Id,
                    'label': mapOfRelatedInputPicklists.branchList[index].Name
                };
                lstOfBranches.push(branch);
            }
            component.set("v.lstOfBranches", lstOfBranches);
        }
    },
    setBranchHeadList: function(component, helper) {
        var value = component.get("v.leadRecord.VCPL_Branch__c");
        var mapOfRelatedInputPicklists = component.get("v.mapOfRelatedInputPicklists") || {};
        var lstOfBranchHeads = [];
        var branchHeads = {};
        if (mapOfRelatedInputPicklists.branchHeadList) {
            for (var index = 0; index < mapOfRelatedInputPicklists.branchHeadList.length; index++) {
                if (mapOfRelatedInputPicklists.branchHeadList[index].Contact.AccountId == value) {
                    branchHeads = {
                        'text': mapOfRelatedInputPicklists.branchHeadList[index].Id,
                        'label': mapOfRelatedInputPicklists.branchHeadList[index].Name
                    };
                    lstOfBranchHeads.push(branchHeads);
                }
            }
        }
        lstOfBranchHeads.unshift(this.NONE_ENTRY);
        component.set("v.lstOfBranchHeads", lstOfBranchHeads);

    },
    setELPList: function(component, helper) {
        var value = component.get("v.leadRecord.VCPL_Branch__c");
        var mapOfRelatedInputPicklists = component.get("v.mapOfRelatedInputPicklists") || {};
        var lstOfELPAssignments = [];
        var elpAssignment = {};
        if (mapOfRelatedInputPicklists.ELPList) {
            for (var index = 0; index < mapOfRelatedInputPicklists.ELPList.length; index++) {
                if (mapOfRelatedInputPicklists.ELPList[index].VCPL_Branch__c == value) {
                    elpAssignment = {
                        'text': mapOfRelatedInputPicklists.ELPList[index].Id,
                        'label': mapOfRelatedInputPicklists.ELPList[index].Name
                    };
                    lstOfELPAssignments.push(elpAssignment);
                }
            }
        }
        lstOfELPAssignments.unshift(this.NONE_ENTRY);
        component.set("v.lstOfELPAssignments", lstOfELPAssignments);
    },
    saveAssignment: function(component, value, helper) {
        var leadRecord = component.get("v.leadRecord") || {};
        if (leadRecord.VCPL_ELP__c == null && leadRecord.VCPL_Branch_Head__c == null) {
            component.set("v.isError", true);
            return;
        } else {
            component.set("v.isError", false);
            var saveRecordData = component.get("c.saveRecordData");
            saveRecordData.setParams({
                "leadRecordJson": JSON.stringify(component.get("v.leadRecord"))
            });
            saveRecordData.setCallback(this, function(response) {
                $A.get("e.force:closeQuickAction").fire();
                this.showToast('SUCCESS', 'success', 'Lead Assignment Done successfully.');
            });
            $A.enqueueAction(saveRecordData);
        }
    }
})