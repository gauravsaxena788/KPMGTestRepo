({
	groupTab : function(component, event, helper) {
		helper.clearAll(component, event);
        //make fruits tab active and show tab data
        component.find("BLISGROUP").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("groupDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';	
	},
    dealerTab: function(component, event, helper) {
		helper.clearAll(component, event);
        //make fruits tab active and show tab data
        component.find("BLISBRANCH").getElement().className = 'slds-tabs--scoped__item slds-active customClassForTab';
        component.find("dealerDataId").getElement().className = 'slds-tabs--scoped__content slds-show customClassForTabData';        
    }
})