({
    doInit: function(component, event, helper) {
        var todayYear = new Date().getFullYear();
        var lstOfYear = ['None'];
        var baseYear = 2017;
        while (baseYear <= todayYear) {
            lstOfYear.push(baseYear);
            baseYear++;
        }
        component.set("v.lstOfYear", lstOfYear);
    },
    getSegmentManagerView: function(component, event, helper) {
        component.set("v.lstOfDealerWiseSegmentView",null);
        var selectedMonth = component.get("v.selectedMonth");
        var selectedYear = component.get("v.selectedYear");
        if (selectedMonth == 'None' || selectedYear == 'None') {
            helper.showToast('Error', 'Error', 'Please Select Duration!');
            return;
        }
        helper.showSpinner(component);
        helper.getSegmentManagerViewHelper(component);
    }
})