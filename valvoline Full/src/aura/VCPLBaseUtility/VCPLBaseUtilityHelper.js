({
    NONE_LABEL: "--None--",
    DEFAULT_ERROR_MESSAGE: "Something went wrong!",
    handleFailedCallback: function(component, responseData) {
        var errorMessage = responseData.message || this.DEFAULT_ERROR_MESSAGE;
        this.showToast('Error', 'error', errorMessage);
    },
    showToast: function(title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.fire({
                "title": title,
                "type": type,
                "message": message
            });
        } else {
            //to avoid exception when opened in a standalone app.
            alert(message);
        }
    },
    hideSpinner: function(component) {
        component.set("v.isLoading", false);
    },
    showSpinner: function(component) {
        component.set("v.isLoading", true);
    },
    redirectToListView: function(objectName) {
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": null,
            "listViewName": null,
            "scope": objectName
        });
        navEvent.fire();
    },
    redirectToSobject: function(recordId, slideDevName) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": slideDevName ? slideDevName : "related"
        });
        navEvt.fire();
    },
    closeModal: function() {
        $A.get("e.force:closeQuickAction").fire();
    },
    validateEmail: function(mail) {
        // return (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(mail));
        // return (/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(mail));

        return (/^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/.test(mail));
    },
    validateContact: function(contactNumber) {
        // return (/^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[789]\d{9}|(\d[ -]?){10}\d$/.test(contactNumber));
        return !!Number(contactNumber) && contactNumber.length >= 10;
    },
    sortAndAddDefault: function(listOfOptions, isFlat) {
        listOfOptions = listOfOptions || [];
        if (isFlat) {
            listOfOptions.sort(function(option1, option2) {
                if (option1 && option2) {
                    return option1.toLowerCase().localeCompare(option2.toLowerCase());
                } else {
                    return 0;
                }
            });
            listOfOptions.unshift(this.NONE_LABEL);
        } else {
            listOfOptions.sort(function(option1, option2) {
                if (option1 && option1.label && option2 && option2.label) {
                    return option1.label.toLowerCase().localeCompare(option2.label.toLowerCase());
                } else {
                    return 0;
                }
            });
            listOfOptions.unshift({
                "label": this.NONE_LABEL,
                "text": null
            });
        }

        return listOfOptions;
    },
    sort: function(listOfOptions, isFlat) {
        listOfOptions = listOfOptions || [];
        if (isFlat) {
            listOfOptions.sort(function(option1, option2) {
                if (option1 && option2) {
                    return option1.toLowerCase().localeCompare(option2.toLowerCase());
                } else {
                    return 0;
                }
            });
        } else {
            listOfOptions.sort(function(option1, option2) {
                if (option1 && option1.label && option2 && option2.label) {
                    return option1.label.toLowerCase().localeCompare(option2.label.toLowerCase());
                } else {
                    return 0;
                }
            });
        }

        return listOfOptions;
    },
    getFormattedDate: function(unformattedDate) {
        unformattedDate = new Date(unformattedDate);

        var dd = unformattedDate.getDate();
        var mm = unformattedDate.getMonth() + 1; //January is 0!

        var yyyy = unformattedDate.getFullYear();
        if (dd < 10) {
            dd = "0" + dd;
        }

        if (mm < 10) {
            mm = "0" + mm;
        }

        var formattdDate = dd + "/" + mm + "/" + yyyy;

        return formattdDate;
    },
    validDate: function(idate) {
        debugger;
        return (/^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/.test(idate)); //true; //(/^[0-3]?[0-9]/[0-3]?[0-9]/(?:[0-9]{2})?[0-9]{2}$/.test(idate));        
    },
    fireRelatedRecordSaveEvent: function(nameOfRelatedRecord) {
        var relatedRecordSaveEvent = $A.get("e.c:GPEvntRelatedRecordSave");
        relatedRecordSaveEvent.fire({
            "nameOfRelatedRecord": nameOfRelatedRecord
        });
    },

    navigaettoURL: function(location) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": location
        });
        urlEvent.fire();
    },
    displayApplication: function(component) {
        var browser = $A.get("$Browser");
        var isIE = browser.isIE6 || browser.isIE7 || browser.isIE8 || browser.isIE9 || browser.isIE10 || browser.isIE11;
        component.set("v.displayApplication", !isIE);
    }
})