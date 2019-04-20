public class VCPLCmpServiceSegmentManagerView {

    @AuraEnabled
    public static VCPLAuraResponse getSegmentManagerViewDataService(String month, String year) {
        VCPLControllerSegmentManagerView segmentManagerViewController = new VCPLControllerSegmentManagerView(month, year);
        return segmentManagerViewController.getSegmentManagerViewData();
    }

}