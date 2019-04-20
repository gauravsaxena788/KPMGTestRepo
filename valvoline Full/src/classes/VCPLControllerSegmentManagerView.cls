public class VCPLControllerSegmentManagerView {
    private Map < Id, Account > mapOfDealer = new Map < Id, Account > ();
    private VCPLDPSegmentManagerViewCalculation DPCalculation;
    private final String SUCCESS_LABEL = 'SUCCESS';
    private String month, year;
    private JSONGenerator gen;

    public VCPLControllerSegmentManagerView(String month, String year) {
        this.month = month;
        this.year = year;
    }

    public VCPLAuraResponse getSegmentManagerViewData() {
        try {
            setDealerMapForSegmentManger();
            DPCalculation = new VCPLDPSegmentManagerViewCalculation(month, year, mapOfDealer);
            DPCalculation.setMapsForSegmentManagerView();
            setJson();
            return new VCPLAuraResponse(true, SUCCESS_LABEL, gen.getAsString());
        } catch (Exception ex) {
            return new VCPLAuraResponse(false, ex.getMessage(), null);
        }
    }

    private void setDealerMapForSegmentManger() {
        for (AccountTeamMember accTeamMember: [select Id, UserId, Account.ParentId , Account.Name, Account.Parent.Name from AccountTeamMember WHERE UserId =: UserInfo.getUserId() AND Account.ParentId != null AND Account.ParentId != '']) {
            mapOfDealer.put(accTeamMember.Account.ParentId, accTeamMember.Account.Parent);
        }
        system.debug('mapOfDealer :: ' + mapOfDealer);
        /*for (AccountTeamMember accTeamMember: [select Id, UserId, AccountId, Account.Name from AccountTeamMember where UserId =: UserInfo.getUserId()]) {
            mapOfDealer.put(accTeamMember.AccountId, accTeamMember.Account);
        }
        system.debug('mapOfDealer :: ' + mapOfDealer);*/
    }

    private void setJson() {
        gen = JSON.createGenerator(true);
        
        gen.writeStartObject();

        if (DPCalculation.mapOfDealerIdVsPrimaryConsolidatedAmount != null)
            gen.writeObjectField('mapOfDealerIdVsPrimaryConsolidatedAmount', DPCalculation.mapOfDealerIdVsPrimaryConsolidatedAmount);
        
        if (DPCalculation.mapOfDealerIdVsPrevMonthClosingSales != null)
            gen.writeObjectField('mapOfDealerIdVsPrevMonthClosingSales', DPCalculation.mapOfDealerIdVsPrevMonthClosingSales);
        
        if (DPCalculation.mapOfDealerIdVsSecodaryVolumeSum != null)
            gen.writeObjectField('mapOfDealerIdVsSecodaryVolumeSum', DPCalculation.mapOfDealerIdVsSecodaryVolumeSum);
        
        if (mapOfDealer != null)
            gen.writeObjectField('mapOfDealer', mapOfDealer);
        
        if (DPCalculation.mapOfDealerVsBalanceAmount != null)
            gen.writeObjectField('mapOfDealerVsBalanceAmount', DPCalculation.mapOfDealerVsBalanceAmount);
        
        gen.writeEndObject();
    }

}