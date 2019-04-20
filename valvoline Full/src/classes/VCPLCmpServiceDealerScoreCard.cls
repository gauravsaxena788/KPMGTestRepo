public class VCPLCmpServiceDealerScoreCard {

    @AuraEnabled
    public static VCPLAuraResponse getDealerScoreCardData(String dealerScoreCardRecordId) {
        VCPLControllerDealerScoreCard dealerScoreCardController = new VCPLControllerDealerScoreCard(dealerScoreCardRecordId);
        return dealerScoreCardController.getScoreCardLineItems();
    }

    @AuraEnabled
    public static VCPLAuraResponse getScoreCardMasterRecordData(String scoreCardParameterRecordId, String scoreCardRecord) {
        VCPL_Score_Card__c dealerScoreCard = (VCPL_Score_Card__c) JSON.deserialize(scoreCardRecord, VCPL_Score_Card__c.class);
        VCPLControllerDealerScoreCard dealerScoreCardController = new VCPLControllerDealerScoreCard(dealerScoreCard);
        return dealerScoreCardController.getScoreCardMasterRecordData(scoreCardParameterRecordId);
    }

    @AuraEnabled
    public static VCPLAuraResponse upsertScoreCardLineItems(String scoreCardLinItemJson, String dealerScoreCardRecordId) {
        List < VCPL_Score_Card_LineItem__c > lstOfScoreCardLineItems = (List < VCPL_Score_Card_LineItem__c > ) JSON.deserialize(scoreCardLinItemJson, List < VCPL_Score_Card_LineItem__c > .class);
        VCPLControllerDealerScoreCard dealerScoreCardController = new VCPLControllerDealerScoreCard(lstOfScoreCardLineItems, dealerScoreCardRecordId);
        return dealerScoreCardController.upsertScoreCardLineItems();
    }
}