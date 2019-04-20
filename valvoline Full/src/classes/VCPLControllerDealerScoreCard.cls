public class VCPLControllerDealerScoreCard {
    private final String LIST_OF_SCORE_CARD_LINEITEMS_LABEL = 'lstOfScoreCardLineItems';
    private final String SCORE_CARD_RECORD_LABEL = 'scoreCardParameterRecord';
    private final String CALCULATED_VALUE_LABEL = 'calculatedValue';
    private final String SUCCESS_LABEL = 'SUCCESS';

    private List < VCPL_Score_Card_Parameters__c > lstOfActiveScoreCardParameters = new List < VCPL_Score_Card_Parameters__c > ();
    private List < VCPL_Score_Card_LineItem__c > lstOfScoreCardLineItems = new List < VCPL_Score_Card_LineItem__c > ();
    public Map < String, Decimal > mapOfMethodNameVsCalculatedValue = new Map < String, Decimal > ();
    public Set < String > setOfMethodNamesToExceute = new Set < String > ();
    private VCPL_Score_Card_Parameters__c scoreCardParameterRecord;
    private VCPL_Score_Card__c dealerScoreCard;
    private String dealerScoreCardRecordId;
    private Double calculatedValue = 0.0;
    private JSONGenerator gen;

    public VCPLControllerDealerScoreCard() {}

    public VCPLControllerDealerScoreCard(VCPL_Score_Card__c dealerScoreCard) {
        this.dealerScoreCard = dealerScoreCard;
    }

    public VCPLControllerDealerScoreCard(String dealerScoreCardRecordId) {
        this.dealerScoreCardRecordId = dealerScoreCardRecordId;
    }

    public VCPLControllerDealerScoreCard(List < VCPL_Score_Card_LineItem__c > lstOfScoreCardLineItems, String dealerScoreCardRecordId) {
        this.lstOfScoreCardLineItems = lstOfScoreCardLineItems;
        this.dealerScoreCardRecordId = dealerScoreCardRecordId;
    }

    public VCPLAuraResponse getScoreCardMasterRecordData(String selectedScoreCardRecordId) {
        try {
            setScoreParameterRecord(selectedScoreCardRecordId);
            setCalculateValue();
            setJson();
            return new VCPLAuraResponse(true, SUCCESS_LABEL, gen.getAsString());
        } catch (Exception ex) {
            return new VCPLAuraResponse(false, ex.getMessage(), null);
        }
    }

    public VCPLAuraResponse getScoreCardLineItems() {
        try {
            setListOfScoreCardLineItems();
            if (setOfMethodNamesToExceute.size() > 0) {
                getCalculatedScoreMap();
                setCalculatedValuesToScoreCardLineItems();
            }
            setJson();
            return new VCPLAuraResponse(true, 'SUCCESS', gen.getAsString());
        } catch (Exception ex) {
            system.debug('========Exception ======'+ex.getMessage());
            return new VCPLAuraResponse(false, ex.getMessage(), null);
        }
    }

    public VCPLAuraResponse upsertScoreCardLineItems() {
        try {
            upsert lstOfScoreCardLineItems;
            setListOfScoreCardLineItems();
            setJson();
            return new VCPLAuraResponse(true, 'SUCCESS', gen.getAsString());
        } catch (Exception ex) {
            return new VCPLAuraResponse(false, ex.getMessage(), null);
        }
    }

    private void setCalculateValue() {
        VCPLDealerScoreCardCalculation dealerValueCalculation = new VCPLDealerScoreCardCalculation(dealerScoreCard, scoreCardParameterRecord);
        mapOfMethodNameVsCalculatedValue = dealerValueCalculation.getCalculatedValue();
        calculatedValue = mapOfMethodNameVsCalculatedValue.containsKey(scoreCardParameterRecord.VCPL_Calculation_Method_Name__c) ? mapOfMethodNameVsCalculatedValue.get(scoreCardParameterRecord.VCPL_Calculation_Method_Name__c) : 0.0;
    }

    private void setScoreParameterRecord(String selectedScoreCardRecordId) {
        scoreCardParameterRecord = [select id, VCPL_Description__c, VCPL_Max_Score__c,
            VCPL_Score_Scale__c, VCPL_Value_Type__c, VCPL_Calculation_Method_Name__c
            from VCPL_Score_Card_Parameters__c where id =: selectedScoreCardRecordId ORDER BY VCPL_Value_Type__c
        ];
    }

    private void setJson() {
        gen = JSON.createGenerator(true);
        
        gen.writeStartObject();

        if (lstOfScoreCardLineItems != null)
            gen.writeObjectField(LIST_OF_SCORE_CARD_LINEITEMS_LABEL, lstOfScoreCardLineItems);

        if (scoreCardParameterRecord != null)
            gen.writeObjectField(SCORE_CARD_RECORD_LABEL, scoreCardParameterRecord);

        if (calculatedValue != null)
            gen.writeObjectField(CALCULATED_VALUE_LABEL, calculatedValue);

        gen.writeEndObject();
    }

    private void setListOfScoreCardLineItems() {
        lstOfScoreCardLineItems = [select id, VCPL_Score_Card__c, VCPL_Score_Card_Parameter__r.Name,
            VCPL_Score_Card_Parameter__r.VCPL_Description__c,
            VCPL_Comments__c, VCPL_Score_Card_Parameter__r.VCPL_Max_Score__c,
            VCPL_Score_Card_Parameter__r.VCPL_Score_Scale__c, VCPL_Score_Card_Parameter__r.VCPL_Value_Type__c,
            VCPL_Dealer_Score__c, VCPL_Value__c, VCPL_Score_Card_Parameter__c
            from VCPL_Score_Card_LineItem__c where VCPL_Score_Card__c =: dealerScoreCardRecordId
        ];
		
        if (lstOfScoreCardLineItems.size() == 0) {
            setListUsingActiveScoreCardParameters();
        }
    }
	@TestVisible
    private void getCalculatedScoreMap() {
        VCPLDealerScoreCardCalculation dealerValueCalculation = new VCPLDealerScoreCardCalculation(dealerScoreCard, setOfMethodNamesToExceute);
        mapOfMethodNameVsCalculatedValue = dealerValueCalculation.getMapOfMethodNameVsCalculatedValue();
    }

    private void setCalculatedValuesToScoreCardLineItems() {
        for (VCPL_Score_Card_LineItem__c scoreCardLineItem: lstOfScoreCardLineItems) {
            if (mapOfMethodNameVsCalculatedValue.containsKey(scoreCardLineItem.VCPL_Score_Card_Parameter__r.VCPL_Calculation_Method_Name__c)) {
                scoreCardLineItem.VCPL_Value__c = mapOfMethodNameVsCalculatedValue.get(scoreCardLineItem.VCPL_Score_Card_Parameter__r.VCPL_Calculation_Method_Name__c);
            }
        }
    }
	@TestVisible
    private void setListUsingActiveScoreCardParameters() {
        VCPL_Score_Card_LineItem__c scoreCardLineItem;
        system.debug('==dealerScoreCardRecordId==='+dealerScoreCardRecordId);
        system.debug('======Debug'+[select Id, Name, VCPL_Account__c, VCPL_As_of__c, VCPL_Financial_Year__c from VCPL_Score_Card__c where Id =: dealerScoreCardRecordId]);
        dealerScoreCard = [select Id, Name, VCPL_Account__c, VCPL_As_of__c, VCPL_Financial_Year__c from VCPL_Score_Card__c where Id =: dealerScoreCardRecordId];
        
        for (VCPL_Score_Card_Parameters__c scoreCardParameter: [select id, Name, VCPL_Description__c, VCPL_Max_Score__c,
                VCPL_Score_Scale__c, VCPL_Value_Type__c, VCPL_Calculation_Method_Name__c
                from VCPL_Score_Card_Parameters__c where VCPL_Active__c = true ORDER BY VCPL_Value_Type__c
            ]) {
            scoreCardLineItem = new VCPL_Score_Card_LineItem__c();
            scoreCardLineItem.VCPL_Score_Card__c = dealerScoreCardRecordId;
            scoreCardLineItem.VCPL_Score_Card_Parameter__r = scoreCardParameter;
            scoreCardLineItem.VCPL_Score_Card_Parameter__c = scoreCardParameter.Id;
            if (scoreCardParameter.VCPL_Value_Type__c == 'Calculated') {
                setOfMethodNamesToExceute.add(scoreCardParameter.VCPL_Calculation_Method_Name__c);
            } else
                scoreCardLineItem.VCPL_Value__c = 0;
            lstOfScoreCardLineItems.add(scoreCardLineItem);
        }
    }
}