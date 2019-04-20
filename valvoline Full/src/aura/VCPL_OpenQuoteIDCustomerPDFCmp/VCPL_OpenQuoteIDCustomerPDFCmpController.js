({
    doInit : function(component, event, helper) {
        var device = $A.get("$Browser.formFactor");
        if(device == 'DESKTOP'){
            var recordIdofQuote = component.get("v.recordId");
            component.set("v.pageId","/apex/GeneratePDFCIDealer?recordId=");  
            window.open("/ID/apex/GeneratePDFCIDealer?recordId="+recordIdofQuote, '_blank');
        }
        else{
            var toastEventsucessnew = $A.get("e.force:showToast");
            toastEventsucessnew.setParams({
                mode: 'dismissible',
                message: 'Cannot open Quote in '+device.toLowerCase(),
                type : 'error'
            });
            toastEventsucessnew.fire();
        }
        $A.get("e.force:closeQuickAction").fire();
    }
})