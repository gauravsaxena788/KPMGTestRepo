public class VCPLCmpServiceLeadAssignment {

    @AuraEnabled
    public static VCPLAuraResponse getLoggedInUserRelatedDataService(String leadRecordId) {
        VCPLControllerLeadAssignment leadAssignmentController = new VCPLControllerLeadAssignment(leadRecordId);
        return leadAssignmentController.getLoggedInUserRelatedData();
    }

    @AuraEnabled
    public static VCPLAuraResponse saveRecordData(String leadRecordJson) {
        Lead leadRecord = (Lead) JSON.deserialize(leadRecordJson, Lead.class);
        VCPLControllerLeadAssignment leadAssignmentController = new VCPLControllerLeadAssignment(leadRecord);
        return leadAssignmentController.upsertLeadRecord();
    }

}