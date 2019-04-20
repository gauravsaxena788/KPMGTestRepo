({
    doInit : function(component, event, helper) {
        
        var device = $A.get("$Browser.formFactor");
        component.set("v.devicetype",device);
        if(device == 'DESKTOP'){
            var recordIdofQuote = component.get("v.recordId");
            var win = window.open("/ID/apex/PerformaInvoiceIDCustomer?recordId="+recordIdofQuote, '_blank');
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