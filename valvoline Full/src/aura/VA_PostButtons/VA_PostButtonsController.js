({
	openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        component.set("v.cssStyle", ".forceStyle .viewport .oneHeader.slds-global-header_container {z-index: 0;} .forceStyle.desktop .viewport{overflow:hidden;}")
    }
})