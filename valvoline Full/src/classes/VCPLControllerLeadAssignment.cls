public without sharing class VCPLControllerLeadAssignment {
    private final String SUCCESS_LABEL = 'SUCCESS';

    private Map < String, List < SObject >> mapOfRelatedInputPicklists = new Map < String, List < SObject >> ();
    private Set < Id > setOfBranchIds = new Set < Id > ();
    @TestVisible private User currentLogedInUserDetails;
    private String leadRecordId;
    private JSONGenerator gen;
    private Lead leadRecord;

    public VCPLControllerLeadAssignment(String leadRecordId) {
        this.leadRecordId = leadRecordId;
    }

    public VCPLControllerLeadAssignment(Lead leadRecord) {
        this.leadRecord = leadRecord;
    }

    public VCPLAuraResponse getLoggedInUserRelatedData() {
        try {
            setLeadRecord();
            setCurrentUser();

            if (currentLogedInUserDetails.VCPL_Contact_Role__c == 'HOD')
                setBranchListForHOD();
            else if (currentLogedInUserDetails.VCPL_Contact_Role__c == 'Branch Head')
                setBranchListForBH();
            else 
                setBranchListForELP();

            setBranchHeadList();
            setBranchELPList();
            setJson();
            return new VCPLAuraResponse(true, SUCCESS_LABEL, gen.getAsString());
        } catch (Exception ex) {
            return new VCPLAuraResponse(false, ex.getMessage(), null);
        }
    }

    public VCPLAuraResponse upsertLeadRecord() {
        try {
            upsert leadRecord;
            return new VCPLAuraResponse(true, SUCCESS_LABEL, JSON.serialize(leadRecord));
        } catch (Exception ex) {
            return new VCPLAuraResponse(false, ex.getMessage(), null);
        }
    }

    @TestVisible
    private void setJson() {
        gen = JSON.createGenerator(true);
        gen.writeStartObject();
        if (leadRecord != null)
            gen.writeObjectField('leadRecord', leadRecord);
        if (mapOfRelatedInputPicklists != null)
            gen.writeObjectField('mapOfRelatedInputPicklists', mapOfRelatedInputPicklists);
        if (currentLogedInUserDetails != null)
            gen.writeObjectField('currentLogedInUserDetails', currentLogedInUserDetails);
        gen.writeEndObject();
    }

    @TestVisible
    private void setLeadRecord() {
        leadRecord = [select Id, VCPL_Partner_Account__c, VCPL_Partner_Account__r.Name, VCPL_Sync_to_CDOS__c,
            VCPL_Branch__r.Name, VCPL_Branch__c,
            VCPL_Branch_Head__r.Name, VCPL_Branch_Head__c, VCPL_ELP__c, VCPL_ELP__r.Name from Lead where Id =: leadRecordId
        ];
    }

    @TestVisible
    private void setBranchListForELP() {
        for (VCPL_ELP_Assignment__c elpAssignment: [select id, Name, VCPL_Branch__c, VCPL_Branch__r.Name, VCPL_Branch__r.Id from VCPL_ELP_Assignment__c where VCPL_User__c =: UserInfo.getUserId() and VCPL_isActive__c = true]) {

            if (!mapOfRelatedInputPicklists.containsKey('branchList'))
                mapOfRelatedInputPicklists.put('branchList', new List < SObject > ());
            mapOfRelatedInputPicklists.get('branchList').add(elpAssignment.VCPL_Branch__r);

            setOfBranchIds.add(elpAssignment.VCPL_Branch__c);
        }
    }

    @TestVisible
    private void setBranchListForHOD() {
        for (Account accountRecord: [select Id, Name from Account where ParentId =: currentLogedInUserDetails.AccountId and RecordType.Name = 'Cummins Dealer Branch']) {
            if (!mapOfRelatedInputPicklists.containsKey('branchList'))
                mapOfRelatedInputPicklists.put('branchList', new List < SObject > ());
            mapOfRelatedInputPicklists.get('branchList').add(accountRecord);
            setOfBranchIds.add(accountRecord.Id);
        }
    }
    
    @TestVisible
    private void setBranchListForBH () {
        system.debug('currentLogedInUserDetails==='+currentLogedInUserDetails+'=======');
        for (Account accountRecord: [select Id, Name from Account where Id =: currentLogedInUserDetails.AccountId and RecordType.Name = 'Cummins Dealer Branch']) {
            if (!mapOfRelatedInputPicklists.containsKey('branchList'))
                mapOfRelatedInputPicklists.put('branchList', new List < SObject > ());
            mapOfRelatedInputPicklists.get('branchList').add(accountRecord);
            setOfBranchIds.add(accountRecord.Id);
        }
    }
	
    @TestVisible
    private void setBranchHeadList() {
        for (User userRecord: [select id, Name, Contact.AccountId from User where Contact.AccountId in: setOfBranchIds]) {
            if (!mapOfRelatedInputPicklists.containsKey('branchHeadList'))
                mapOfRelatedInputPicklists.put('branchHeadList', new List < SObject > ());
            mapOfRelatedInputPicklists.get('branchHeadList').add(userRecord);
        }
    }
    
	@TestVisible
    private void setBranchELPList() {
        for (VCPL_ELP_Assignment__c elpAssignment: [select id, Name, VCPL_Branch__c, VCPL_Branch__r.Name, VCPL_Branch__r.Id from VCPL_ELP_Assignment__c where VCPL_Branch__c in: setOfBranchIds and VCPL_isActive__c = true]) {

            if (!mapOfRelatedInputPicklists.containsKey('ELPList'))
                mapOfRelatedInputPicklists.put('ELPList', new List < SObject > ());
            mapOfRelatedInputPicklists.get('ELPList').add(elpAssignment);
        }
    }
    
	@TestVisible
    private void setCurrentUser() {
        currentLogedInUserDetails = [select Id, Profile.Name, VCPL_Contact_Role__c, AccountId from User where Id =: UserInfo.getUserId()];
    }
}