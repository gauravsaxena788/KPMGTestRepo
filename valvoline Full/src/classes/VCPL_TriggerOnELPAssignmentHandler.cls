public class VCPL_TriggerOnELPAssignmentHandler {

    public void afterInsert(List < VCPL_ELP_Assignment__c > lstOfELPAssignment) {
        List < VCPL_ELP_Assignment__c > lstOfELPAssignmentUsedForShare = new List < VCPL_ELP_Assignment__c > ();

        for (VCPL_ELP_Assignment__c elpAssignment: lstOfELPAssignment) {
            if (elpAssignment.VCPL_isActive__c)
                lstOfELPAssignmentUsedForShare.add(elpAssignment);
        }
        if (lstOfELPAssignmentUsedForShare.size() > 0) {
            VCPLSharingService sharingService = new VCPLSharingService();
            sharingService.shareRecordsAfterELPAssignmentRecordCreation(lstOfELPAssignmentUsedForShare);
        }
    }

    public void afterUpdate(List < VCPL_ELP_Assignment__c > lstOfELPAssignment, Map < Id, VCPL_ELP_Assignment__c > mapOfELPAssignment) {
        List < VCPL_ELP_Assignment__c > lstOfELPAssignmentUsedForShareInsertion = new List < VCPL_ELP_Assignment__c > ();
        List < VCPL_ELP_Assignment__c > lstOfELPAssignmentUsedForShareDeletion = new List < VCPL_ELP_Assignment__c > ();
        VCPLSharingService sharingService = new VCPLSharingService();
        for (VCPL_ELP_Assignment__c elpAssignment: lstOfELPAssignment) {
            if (elpAssignment.VCPL_isActive__c != mapOfELPAssignment.get(elpAssignment.Id).VCPL_isActive__c) {
                if (elpAssignment.VCPL_isActive__c)
                    lstOfELPAssignmentUsedForShareInsertion.add(elpAssignment);
                else if (!elpAssignment.VCPL_isActive__c)
                    lstOfELPAssignmentUsedForShareDeletion.add(elpAssignment);
            }
        }

        if (lstOfELPAssignmentUsedForShareDeletion.size() > 0)
            sharingService.deleteShareRecordsOfLeadShareAndCustomerPlan(lstOfELPAssignmentUsedForShareDeletion);
        if (lstOfELPAssignmentUsedForShareInsertion.size() > 0)
            sharingService.shareRecordsAfterELPAssignmentRecordCreation(lstOfELPAssignmentUsedForShareInsertion);
    }

}