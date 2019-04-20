public class VCPLSharingService { 

    List < SObject > listOfSharingRecordsToInsert = new List < SObject > ();
    Set < String > setofCommitedRecords = new Set < String > ();
    AccountShare accSharingRecord;

    public void shareRecordsAfterELPAssignmentRecordCreation(List < VCPL_ELP_Assignment__c > listOfELPAssignments) {
        Map < Id, Set < Id >> mapOfBranchIdsVsSetOfCustomerPlanIdsToBeShared = new Map < Id, Set < Id >> ();
        Map < Id, Set < Id >> mapOfBranchIdsVsSetOfLeadIdsToBeShared = new Map < Id, Set < Id >> ();
        Set < String > setOfAccountIdAndUserId = new Set < String > ();
        Set < Id > setOfBranchIds = new Set < Id > ();
        Set < Id > setOfUserIds = new Set < Id > ();

        for (VCPL_ELP_Assignment__c ELPAssignment: listOfELPAssignments) {
            if (ELPAssignment.VCPL_isActive__c) {
                setOfUserIds.add(ELPAssignment.VCPL_User__c);
                setOfBranchIds.add(ELPAssignment.VCPL_Branch__c);
            }
        }

        if (setOfUserIds.size() > 0) {
            for (Lead leadRecord: [select Id, VCPL_Branch__c from Lead where VCPL_Branch__c in: setOfBranchIds]) {
                if (!mapOfBranchIdsVsSetOfLeadIdsToBeShared.containsKey(leadRecord.VCPL_Branch__c))
                    mapOfBranchIdsVsSetOfLeadIdsToBeShared.put(leadRecord.VCPL_Branch__c, new Set < Id > ());

                mapOfBranchIdsVsSetOfLeadIdsToBeShared.get(leadRecord.VCPL_Branch__c).add(leadRecord.Id);
            }

            for (LeadShare leadShareRecord: [select Id, userOrGroupId, LeadId from LeadShare where userOrGroupId in: setOfUserIds]) {
                setofCommitedRecords.add(leadShareRecord.userOrGroupId + '@@' + leadShareRecord.LeadId);
            }

            for (AccountShare branchShareRecord: [select Id, userOrGroupId, AccountId from AccountShare where userOrGroupId in: setOfUserIds]) {
                setOfAccountIdAndUserId.add(branchShareRecord.AccountId + '@@' + branchShareRecord.userOrGroupId);
            }

            for (VCPL_ELP_Assignment__c ELPAssignment: listOfELPAssignments) {
                //Lead sharing
                if (mapOfBranchIdsVsSetOfLeadIdsToBeShared.containskey(ELPAssignment.VCPL_Branch__c)) {
                    for (Id recordIdToShare: mapOfBranchIdsVsSetOfLeadIdsToBeShared.get(ELPAssignment.VCPL_Branch__c)) {
                        addLeadShareRecord(ELPAssignment.VCPL_User__c, recordIdToShare, 'edit');
                    }
                }

                if (!setOfAccountIdAndUserId.contains(ELPAssignment.VCPL_Branch__c + '@@' + ELPAssignment.VCPL_User__c)) {
                    //Branch Sharing
                    accSharingRecord = new AccountShare();
                    accSharingRecord.UserOrGroupId = ELPAssignment.VCPL_User__c;
                    accSharingRecord.AccountAccessLevel = 'Read';
                    accSharingRecord.AccountId = ELPAssignment.VCPL_Branch__c;
                    accSharingRecord.OpportunityAccessLevel = 'None';
                    listOfSharingRecordsToInsert.add(accSharingRecord);
                    setOfAccountIdAndUserId.add(ELPAssignment.VCPL_Branch__c + '@@' + ELPAssignment.VCPL_User__c);
                }
            }

            if (listOfSharingRecordsToInsert.size() > 0) {
                List < Database.SaveResult > sr = Database.insert(listOfSharingRecordsToInsert, false);
            }
        }

    }

    public void deleteShareRecordsOfLeadShareAndCustomerPlan(List < VCPL_ELP_Assignment__c > listOfELPAssignments) {
        Map < Id, Set < Id >> mapOfContactIdVsUserId = new Map < Id, Set < Id >> ();
        Map < Id, Set < Id >> mapOfBranchVsUserIds = new Map < Id, Set < Id >> ();
        List < SObject > lstOfOfSharingRecordsToDelete = new List < SObject > ();
        Map < Id, Id > mapOfLeadIdVsBranchId = new Map < Id, Id > ();
        Map < Id, Id > mapOfUserIdVsContactId = new Map < Id, Id > ();
        Set < Id > setOfBranchIds = new Set < Id > ();
        Set < Id > setOfUserIds = new Set < Id > ();

        for (VCPL_ELP_Assignment__c ELPAssignment: listOfELPAssignments) {
            if (!ELPAssignment.VCPL_isActive__c) {
                setOfUserIds.add(ELPAssignment.VCPL_User__c);
                setOfBranchIds.add(ELPAssignment.VCPL_Branch__c);

                if (!mapOfBranchVsUserIds.containsKey(ELPAssignment.VCPL_Branch__c))
                    mapOfBranchVsUserIds.put(ELPAssignment.VCPL_Branch__c, new Set < Id > ());
                mapOfBranchVsUserIds.get(ELPAssignment.VCPL_Branch__c).add(ELPAssignment.VCPL_User__c);
            }
        }
        if (setOfUserIds.size() > 0) {
            for (Lead leadRecord: [select Id, VCPL_Branch__c from Lead where VCPL_Branch__c in: setOfBranchIds]) {
                mapOfLeadIdVsBranchId.put(leadRecord.Id, leadRecord.VCPL_Branch__c);
            }

            for (LeadShare leadShareRecord: [select Id, userOrGroupId, rowCause, LeadId from LeadShare where userOrGroupId in: setOfUserIds]) {
                if (mapOfLeadIdVsBranchId.containsKey(leadShareRecord.LeadId)) {
                    Id branchId = mapOfLeadIdVsBranchId.get(leadShareRecord.LeadId);
                    if (leadShareRecord.rowCause != 'owner' && mapOfBranchVsUserIds.containsKey(branchId) && mapOfBranchVsUserIds.get(branchId).contains(leadShareRecord.userOrGroupId))
                        lstOfOfSharingRecordsToDelete.add(leadShareRecord);
                }
            }

            for (User user: [select Id, ContactId from User where Id in: setOfUserIds]) {
                mapOfUserIdVsContactId.put(user.Id, user.ContactId);
            }

            for (VCPL_Customer_Plan__c customerPlan: [select Id, VCPL_ELP_Branch_Head__c from VCPL_Customer_Plan__c where VCPL_ELP_Branch_Head__c in: mapOfUserIdVsContactId.values()]) {
                if (!mapOfContactIdVsUserId.containsKey(customerPlan.VCPL_ELP_Branch_Head__c))
                    mapOfContactIdVsUserId.put(customerPlan.VCPL_ELP_Branch_Head__c, new Set < Id > ());
                mapOfContactIdVsUserId.get(customerPlan.VCPL_ELP_Branch_Head__c).add(customerPlan.Id);
            }

            for (AccountShare branchShareRecord: [select Id, userOrGroupId, rowcause, AccountId from AccountShare where userOrGroupId in: setOfUserIds]) {
                if (branchShareRecord.rowcause != 'owner' && mapOfBranchVsUserIds.containsKey(branchShareRecord.AccountId) &&
                    mapOfBranchVsUserIds.get(branchShareRecord.AccountId).contains(branchShareRecord.userOrGroupId) &&
                    mapOfUserIdVsContactId.containsKey(branchShareRecord.userOrGroupId) &&
                    !mapOfContactIdVsUserId.containsKey(mapOfUserIdVsContactId.get(branchShareRecord.userOrGroupId)))
                    lstOfOfSharingRecordsToDelete.add(branchShareRecord);
            }

            if (lstOfOfSharingRecordsToDelete.size() > 0)
                delete lstOfOfSharingRecordsToDelete;
        }
    }

    public void shareLeadRecords(List < Lead > lstLead) {
        Map < Id, List < Lead >> mapOfDealerAssociatedLeads = new Map < Id, List < Lead >> ();
        Map < Id, List < Lead >> mapOfBranchAssociatedLeads = new Map < Id, List < Lead >> ();
        Set < Id > setOfDealerAndBranchIds = new Set < Id > ();
        Set < Id > setOfDealerIds = new Set < Id > ();
        Set < Id > setOfBranchIds = new Set < Id > ();
        Set < Id > setOfUserIds = new Set < Id > ();
        Set < Id > setOfLeadIds = new Set < Id > ();

        for (Lead leadRecord: lstLead) {
            if (leadRecord.VCPL_Partner_Account__c != null) {

                setOfDealerAndBranchIds.add(leadRecord.VCPL_Partner_Account__c);
                setOfDealerIds.add(leadRecord.VCPL_Partner_Account__c);

                if (!mapOfDealerAssociatedLeads.containsKey(leadRecord.VCPL_Branch__c))
                    mapOfDealerAssociatedLeads.put(leadRecord.VCPL_Partner_Account__c, new List < Lead > ());

                mapOfDealerAssociatedLeads.get(leadRecord.VCPL_Partner_Account__c).add(leadRecord);
            }

            if (leadRecord.VCPL_Branch__c != null) {
                setOfDealerAndBranchIds.add(leadRecord.VCPL_Branch__c);
                setOfBranchIds.add(leadRecord.VCPL_Branch__c);

                if (!mapOfBranchAssociatedLeads.containsKey(leadRecord.VCPL_Branch__c))
                    mapOfBranchAssociatedLeads.put(leadRecord.VCPL_Branch__c, new List < Lead > ());

                mapOfBranchAssociatedLeads.get(leadRecord.VCPL_Branch__c).add(leadRecord);
            }
            setOfLeadIds.add(leadRecord.Id);
        }

        if (setOfDealerAndBranchIds.size() > 0) {
            //Set < String > setofCommitedLeadShareRecords = new Set < String > ();
            for (LeadShare leadShareRecord: [select id, UserOrGroupId, LeadId from LeadShare where LeadId in: setOfLeadIds]) {
                setofCommitedRecords.add(leadShareRecord.UserOrGroupId + '@@' + leadShareRecord.LeadId);
            }

            for (User userRecord: [select Id, (select Id, VCPL_User__c, VCPL_Branch__c from ELP_Assignment__r where VCPL_Branch__c in: setOfBranchIds and VCPL_isActive__c = true), VCPL_Contact_Role__c, AccountId from User where AccountId in: setOfDealerAndBranchIds]) {
                if (userRecord.VCPL_Contact_Role__c == 'Branch Head' && mapOfBranchAssociatedLeads.containsKey(userRecord.AccountId)) {
                    for (Lead leadRecord: mapOfBranchAssociatedLeads.get(userRecord.AccountId)) {
                        addLeadShareRecord(userRecord.Id, leadRecord.Id, 'edit');
                    }
                } else if (userRecord.VCPL_Contact_Role__c == 'HOD' && mapOfDealerAssociatedLeads.containsKey(userRecord.AccountId)) {
                    for (Lead leadRecord: mapOfDealerAssociatedLeads.get(userRecord.AccountId)) {
                        addLeadShareRecord(userRecord.Id, leadRecord.Id, 'edit');
                    }

                } else if (userRecord.VCPL_Contact_Role__c == 'ELP' && userRecord.ELP_Assignment__r.size() > 0 && mapOfDealerAssociatedLeads.containsKey(userRecord.AccountId)) {
                    for (Lead leadRecord: mapOfDealerAssociatedLeads.get(userRecord.AccountId)) {
                        for (VCPL_ELP_Assignment__c elpAssignment: userRecord.ELP_Assignment__r) {
                            if (elpAssignment.VCPL_Branch__c == leadRecord.VCPL_Branch__c) {
                                addLeadShareRecord(userRecord.Id, leadRecord.Id, 'edit');
                            }
                        }
                    }
                }
            }
            if (listOfSharingRecordsToInsert.size() > 0)
                insert listOfSharingRecordsToInsert;
        }
    }

    public void shareBlanketOpportunities(List < Opportunity > lstOfOpportunities) {
        Id blanketOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();
        Map < Id, List < Opportunity >> mapOfBranchIdVsOpportunities = new Map < Id, List < Opportunity >> ();
        Set < Id > setOfDealerAccountIds = new Set < Id > ();
        Set < Id > setOfOpportunityIds = new Set < Id > ();
        Set < Id > setOfBranchIds = new Set < Id > ();

        for (Opportunity opportunityRecord: lstOfOpportunities) {
            if (opportunityRecord.RecordTypeId == blanketOpportunityRecordTypeId && opportunityRecord.VCPL_Branch__c != null) {
                setOfBranchIds.add(opportunityRecord.VCPL_Branch__c);

                if (!mapOfBranchIdVsOpportunities.containsKey(opportunityRecord.VCPL_Branch__c))
                    mapOfBranchIdVsOpportunities.put(opportunityRecord.VCPL_Branch__c, new List < Opportunity > ());

                mapOfBranchIdVsOpportunities.get(opportunityRecord.VCPL_Branch__c).add(opportunityRecord);
            }
        }

        if (mapOfBranchIdVsOpportunities.Keyset().size() > 0) {

            for (OpportunityShare opportunityShareRecord: [select Id, userOrGroupId, OpportunityId from OpportunityShare where OpportunityId in: setOfOpportunityIds]) {
                setofCommitedRecords.add(opportunityShareRecord.userOrGroupId + '@@' + opportunityShareRecord.OpportunityId);
            }

            for (VCPL_ELP_Assignment__c ELPAssignment: [select id, VCPL_Branch__c, VCPL_Branch__r.ParentId, VCPL_User__c from VCPL_ELP_Assignment__c where VCPL_Branch__c in: mapOfBranchIdVsOpportunities.keySet() and VCPL_isActive__c = true]) {
                setOfDealerAccountIds.add(ELPAssignment.VCPL_Branch__r.ParentId);
                if(mapOfBranchIdVsOpportunities.containsKey(ELPAssignment.VCPL_Branch__c)){
                    for (Opportunity opportunityRecord: mapOfBranchIdVsOpportunities.get(ELPAssignment.VCPL_Branch__c)) {
                        addOpportunityShareRecord(ELPAssignment.VCPL_User__c, opportunityRecord.Id, 'edit');
                    }
                }
            }

            for (User userRecord: [select id, AccountId from User where AccountId in: setOfDealerAccountIds and VCPL_Contact_Role__c = 'HOD']) {
                if(mapOfBranchIdVsOpportunities.containsKey(userRecord.AccountId)){
                    for (Opportunity opportunityRecord: mapOfBranchIdVsOpportunities.get(userRecord.AccountId)) {
                        addOpportunityShareRecord(userRecord.Id, opportunityRecord.Id, 'edit');
                    }
                }
            }

            if (listOfSharingRecordsToInsert.size() > 0)
                insert listOfSharingRecordsToInsert;
        }
    }

    private void addLeadShareRecord(Id userId, Id leadId, String accessLevel) {
        if (!setofCommitedRecords.contains(userId + '@@' + leadId)) {
            LeadShare leadSharingRecord = new LeadShare();
            leadSharingRecord.UserOrGroupId = userId;
            leadSharingRecord.LeadAccessLevel = accessLevel;
            leadSharingRecord.LeadId = leadId;
            listOfSharingRecordsToInsert.add(leadSharingRecord);
            setofCommitedRecords.add(userId + '@@' + leadId);
        }
    }

    private void addOpportunityShareRecord(Id userId, Id opportunityId, String accessLevel) {
        if (!setofCommitedRecords.contains(userId + '@@' + opportunityId)) {
            OpportunityShare opportunityShareRecord = new OpportunityShare();
            opportunityShareRecord.OpportunityId = opportunityId;
            opportunityShareRecord.UserOrGroupId = userId;
            opportunityShareRecord.OpportunityAccessLevel = 'edit';
            listOfSharingRecordsToInsert.add(opportunityShareRecord);
            setofCommitedRecords.add(opportunityShareRecord.UserOrGroupId + '@@' + opportunityShareRecord.OpportunityId);
        }
    }
    
    

}