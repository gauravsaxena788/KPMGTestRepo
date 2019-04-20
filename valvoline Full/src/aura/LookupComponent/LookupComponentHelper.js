({
    /**
     * Perform the SObject search via an Apex Controller
     */
    doFilteredSearch: function(cmp, event, filtername) {
        var inputElement = cmp.find("lookup");
        var lookupList = cmp.find("lookuplist");
        var sObjectAPIName = cmp.get("v.sObjectAPIName");
        
        cmp.set('v.isProcessing',true);
        
        // Get the search string, input element and the selection container
        var searchString = cmp.get("v.searchString");
        
		if(searchString == undefined) searchString = '';        
        
        if(searchString.length > 2 || searchString == null || searchString == '' ){
            // Clear any errors and destroy the old lookup items container
            inputElement.set('v.errors', null);
    
            // Show the lookuplist
            $A.util.removeClass(lookupList, 'slds-hide');
            debugger;
            var action = cmp.get('c.filterLookup');
            if(filtername == 'DealerMapping')
            	action = cmp.get('c.filterLookup');
            else if(filtername == 'ELPUserMapping')
            	action = cmp.get('c.filterDealerLookup');
            
            action.setParams({
                "searchString": searchString,
                "filterTypeName": filtername,
                "sObjectName": sObjectAPIName
            });
    
            // Mark the action as abortable, this is to prevent multiple events from the keyup executing
            action.setAbortable();
    
            // Define the callback
            action.setCallback(this, function(response) {
                var state = response.getState();
				cmp.set('v.isProcessing',false);    
                // Callback succeeded
                if (cmp.isValid() && state === "SUCCESS") {
                    // Get the search matches
                    var matches = response.getReturnValue();
    
                    // If we have no matches, return nothing
                    if (matches.length === 0) {
                        cmp.set('v.matches', null);
                        return;
                    }
    
                    // Store the results
                    cmp.set('v.matches', matches);
                } 
                else if (state === "ERROR") // Handle any error by reporting it
                {
                    var errors = response.getError();
    
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.displayToast('Error', errors[0].message);
                        }
                    } else {
                        this.displayToast('Error', 'Unknown error.');
                    }
                }
            });
    
            // Enqueue the action                  
            $A.enqueueAction(action);
        }
    },
    doSearch: function(cmp, event) {
        // Get the search string, input element and the selection container
        var searchString = cmp.get("v.searchString");
        var inputElement = cmp.find("lookup");
        var lookupList = cmp.find("lookuplist");
        var filtercondition = cmp.get("v.FilterCondition");
        var islookupclick = cmp.get("v.IsClickOnSearch");
		
        cmp.set('v.isProcessing',true);
        
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);

        // We need at least 2 characters for an effective search
        if (((typeof searchString === 'undefined' || searchString.length < 2) && islookupclick === false) ||
            event && event.getParams() && event.getParams().keyCode && event.getParams().keyCode === 27) {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            cmp.set('v.isProcessing',false);
            return;
        }

        // Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');

        // Get the API Name
        var sObjectAPIName = cmp.get("v.sObjectAPIName");
        var listOfFieldsToBeQueried = cmp.get("v.listOfFieldsToBeQueried");
        // Create an Apex action

        var action;
        if (listOfFieldsToBeQueried && listOfFieldsToBeQueried.length > 0) {
            action = cmp.get('c.lookupByFields');

            // Set the parameters
            action.setParams({
                "searchString": searchString,
                "sObjectAPIName": sObjectAPIName,
                "FilterCondition": filtercondition,
                "isClickOnSearch": islookupclick,
                "listOfFieldsToBeQueried": listOfFieldsToBeQueried
            });
        } else {
            action = cmp.get('c.lookup');

            // Set the parameters
            action.setParams({
                "searchString": searchString,
                "sObjectAPIName": sObjectAPIName,
                "FilterCondition": filtercondition,
                "isClickOnSearch": islookupclick
            });
        }

        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
		
        // Define the callback
        action.setCallback(this, function(response) {
            cmp.set('v.isProcessing',false);
            var state = response.getState();

            // Callback succeeded
            if (cmp.isValid() && state === "SUCCESS") {
                // Get the search matches
                var matches = response.getReturnValue();

                // If we have no matches, return nothing
                if (matches.length === 0) {
                    cmp.set('v.matches', null);
                    return;
                }

                // Store the results
                cmp.set('v.matches', matches);
            } else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.displayToast('Error', errors[0].message);
                    }
                } else {
                    this.displayToast('Error', 'Unknown error.');
                }
            }
        });

        // Enqueue the action                  
        $A.enqueueAction(action);
    },
    /**
     * Handle the Selection of an Item
     */
    handleSelection: function(cmp, event) {
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)       
        var objectId = event.currentTarget.id !== undefined ? this.resolveId(event.currentTarget.id) : '';
        cmp.set("v.isValid", true);
        // The Object label is the 2nd child (index 1)
        //var objectLabel = event.currentTarget.id !== undefined ? event.currentTarget.innerText : '';
		var objectLabel = event.currentTarget.id !== undefined ? this.findName(event.currentTarget.id) : '';
        
        //The object label text pass by event
        var objectlabeltext = cmp.get("v.pluralLabel");

        // Create the UpdateLookupId event
        //var updateEvent =  $A.get("e.RealityForce:UpdateLookupId");
        var updateEvent = cmp.getEvent("updateLookupIdEvent");

        //Call function for set selected value
        this.SetSelectedValue(cmp, objectLabel, objectId)

        //get external number parameter
        var externalParameter = cmp.get("v.externalParameter");

        // Populate the event with the selected Object Id
        updateEvent.setParams({
            "sObjectId": objectId,
            "recordName": objectLabel,
            "ObjectLabel": objectlabeltext,
            "externalParameter": externalParameter
        });

        // Fire the event
        updateEvent.fire();

    },
    /*
     * Function for set selected value
     */
    SetSelectedValue: function(cmp, objectLabel, objectId) {
        // Update the Searchstring with the Label
        cmp.set("v.searchString", objectLabel);
        cmp.set("v.SelectedItemId", objectId);

        // Hide the Lookup List
        var lookupList = cmp.find("lookuplist");
        $A.util.addClass(lookupList, 'slds-hide');

        // Hide the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.addClass(inputElement, 'slds-hide');
        
        var lookupSearch = cmp.find('lookupSearch');
        $A.util.addClass(lookupSearch, 'slds-hide');

        // Show the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.removeClass(lookupPill, 'slds-hide');

        // Lookup Div has selection
        inputElement = cmp.find('lookup-div');
        $A.util.addClass(inputElement, 'slds-has-selection');
        cmp.set('v.matches', null);
    },
    /**
     * Clear the Selection
     */
    clearSelection: function(cmp) {
        
        //Fetch object label text pass by event
        var objectlabeltext = cmp.get("v.pluralLabel");
        // Create the ClearLookupId event
        var clearEvent = cmp.getEvent("clearLookupIdEvent");
        clearEvent.setParams({
            "ObjectLabel": objectlabeltext,
            "externalParameter": cmp.get("v.externalParameter")
        });
        // Fire the event
        clearEvent.fire();
        // Clear the Searchstring
        cmp.set("v.searchString", '');

        // Hide the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        $A.util.addClass(lookupPill, 'slds-hide');

        // Show the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide');
        
        var lookupSearch = cmp.find('lookupSearch');
        $A.util.removeClass(lookupSearch, 'slds-hide');

        // Lookup Div has no selection
        inputElement = cmp.find('lookup-div');
        $A.util.removeClass(inputElement, 'slds-has-selection');
    },

    /**
     * Resolve the Object Id from the Element Id by splitting the id at the _
     */
    resolveId: function(elmId) {
        var seData = elmId.split('_');
        return seData[2];
        //var i = elmId.lastIndexOf('_');
        //return elmId.substr(i + 1);
    },
    findName: function(elmId) {
        var seData = elmId.split('_');
        return seData[4];
    },

    /**
     * Display a message
     */
    displayToast: function(title, message) {
        var toast = $A.get("e.force:showToast");

        // For lightning1 show the toast
        if (toast) {
            //fire the toast event in Salesforce1
            toast.setParams({
                "title": title,
                "message": message
            });

            toast.fire();
        }
    }
})