public class VCPLDPSegmentManagerViewCalculation {
    public Map < Id, VCPL_Differential_Pricing__c > mapOfDifferentialPricing = new Map < Id, VCPL_Differential_Pricing__c > ();
    public Map < String, Double > mapOfDealerIdVsPrimaryConsolidatedAmount = new Map < String, Double > ();
    public Map < String, Double > mapOfDealerIdVsSecodaryVolumeSum = new Map < String, Double > ();
    public Map < Id, Double > mapOfDealerIdVsPrevMonthClosingSales = new Map < Id, Double > ();
    public Map < Id, Double > mapOfDealerVsBalanceAmount = new Map < Id, Double > ();
    public Set < Id > setOfDealerIdsWithNegativeDisount = new Set < Id > ();

    private Map < String, Integer > mapOfMonthNameToNumber = new Map < String, Integer > { 'january' => 1, 'february' => 2, 'march' => 3, 'april' => 4, 'may' => 5, 'june' => 6, 'july' => 7, 'august' => 8, 'september' => 9, 'october' => 10, 'november' => 11, 'december' => 12 };
    private Map < Id, Account > mapOfDealer = new Map < Id, Account > ();
    private Date monthStartDate, monthEndDate;
    private Date previousMonthStartDate, previousMonthEndDate;
    private Integer month, year;
    private String monthName;
    private Map < Integer, String > mapNameMonthNum = new Map < Integer, String > {
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December'
    };

    public VCPLDPSegmentManagerViewCalculation(String month, String year, Map < Id, Account > mapOfDealer) {
        this.month = mapOfMonthNameToNumber.get(month.toLowerCase());
        this.year = Integer.ValueOf(year);
        this.monthName = mapNameMonthNum.get(this.month);
        this.monthStartDate = Date.newInstance(this.year, this.month, 1);
        this.monthEndDate = (Date.newInstance(this.year, this.month + 1, 1)).addDays(-1);
        this.mapOfDealer = mapOfDealer;
        this.previousMonthStartDate = Date.newInstance(this.year, this.month - 1, 1);
        this.previousMonthEndDate = (Date.newInstance(this.year, this.month, 1)).addDays(-1);
    }

    public void setMapsForSegmentManagerView() {
        setDifferentialPricingMapForSegmentManger();
        getGroupedResultOfSecondaryLineItemsForCurrentMonth();
        setMapOfDealerVsPreviousMonthClosingBalance();
        getGroupedResultOfPrimaryLineItemsForCurrentMonth();
        setMapOfDealerVsBalanceAmount();
    }
	@TestVisible
    private void setDealerMapForSegmentManger() {
        for (AccountTeamMember accTeamMember: [select Id, UserId, Account.ParentId , Account.Name, Account.Parent.Name from AccountTeamMember WHERE UserId =: UserInfo.getUserId() AND Account.Parent.Name != null]) {
            mapOfDealer.put(accTeamMember.Account.ParentId, accTeamMember.Account.Parent);
        }
        system.debug('mapOfDealer :: ' + mapOfDealer);
    }

    private void setDifferentialPricingMapForSegmentManger() {
        if (mapOfDealer.keySet().size() > 0) {
            mapOfDifferentialPricing = new Map < Id, VCPL_Differential_Pricing__c > ([select Id, VCPL_Dealer_Name__c from VCPL_Differential_Pricing__c where VCPL_Dealer_Name__c in: mapOfDealer.KeySet()]);
        }
        system.debug('mapOfDifferentialPricing :: ' + mapOfDifferentialPricing);
    }

    private void getGroupedResultOfSecondaryLineItemsForCurrentMonth() {
        if (mapOfDifferentialPricing.keySet().size() > 0) {
            for (AggregateResult secondaryResult: [SELECT SUM(VCPL_Final_DP__c) sumOfConsideredAmount,
                    VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId dealerId
                    FROM VCPL_Secondary_Sales_LineItem__c
                    where VCPL_Differential_Pricing__c in: mapOfDifferentialPricing.keySet()
                    AND VCPL_Invoice__c <=: previousMonthEndDate AND VCPL_Invoice__c >=: previousMonthStartDate
                    GROUP BY VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId
                ]) {
                mapOfDealerIdVsSecodaryVolumeSum.put(String.valueOf(secondaryResult.get('dealerId')), Double.ValueOf(secondaryResult.get('sumOfConsideredAmount')) != null ? Double.ValueOf(secondaryResult.get('sumOfConsideredAmount')) : 0);
            	    system.debug('mapOfDealerIdVsSecodaryVolumeSum==='+mapOfDealerIdVsSecodaryVolumeSum);
                }

        }
        system.debug(' mapOfDealerIdVsSecodaryVolumeSum : ' + mapOfDealerIdVsSecodaryVolumeSum);
    }

    private void setMapOfDealerVsPreviousMonthClosingBalance() {
        system.Debug(' mapOfDealerIdVsPrevMonthClosingSales:outside::'+mapOfDealerIdVsPrevMonthClosingSales);
       if (mapOfDealer.keySet().size() > 0) {
           system.Debug(' mapOfDealerIdVsPrevMonthClosingSales::insideif:'+mapOfDealerIdVsPrevMonthClosingSales);
           system.Debug('previousMonthEndDate---'+previousMonthEndDate+'==== previousMonthStartDate'+previousMonthStartDate);
           system.debug('===mapOfDealerkeyset==='+mapOfDealer.keyset());
           //Id monthlyPlanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SAP_Order').getRecordTypeId();
           Id monthlyPlanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
           
           for (AggregateResult OpportunityresultResult: [SELECT SUM(VCPL_Previous_Month_Closing_Balance__c) sumOfConsideredAmount, Account.ParentId dealerId  FROM Opportunity
                                                        WHERE Account.ParentId IN :mapOfDealer.keyset() AND RecordtypeId =:monthlyPlanRecordTypeId AND CloseDate <= :previousMonthEndDate AND CloseDate >=:previousMonthStartDate
                                    					GROUP BY Account.ParentId]
               ) {
                   if(OpportunityresultResult.get('dealerId') != null){
                       mapOfDealerIdVsPrevMonthClosingSales.put(String.valueOf(OpportunityresultResult.get('dealerId')), Double.ValueOf(OpportunityresultResult.get('sumOfConsideredAmount')) != null ? Double.ValueOf(OpportunityresultResult.get('sumOfConsideredAmount')) : 0);
                       //mapOfDealerIdVsPrevMonthClosingSales.put(monthlyOpportunitylineitem.Account.ParentId, monthlyOpportunitylineitem.MTD_Volume__c != null ? monthlyOpportunitylineitem.MTD_Volume__c : 0);
                   }
            		system.Debug(' mapOfDealerIdVsPrevMonthClosingSales:::'+mapOfDealerIdVsPrevMonthClosingSales);
                }
           /* 
            * 
            * Opportunity monthlyOpportunitylineitem: [SELECT Id, MTD_Volume__c, VCPL_Previous_Month_Closing_Balance__c ,Account.ParentId, CloseDate, Recordtype.Name  FROM Opportunity
                                                        WHERE Account.ParentId IN :mapOfDealer.keyset() AND RecordtypeId =:monthlyPlanRecordTypeId AND CloseDate <= :previousMonthEndDate AND CloseDate >=:previousMonthStartDate
                                    					]

            AggregateResult OpportunityresultResult: [SELECT SUM(MTD_Volume__c) sumOfConsideredAmount, Account.ParentId dealerId  FROM Opportunity
                                                        WHERE  AND RecordtypeId =:monthlyPlanRecordTypeId AND CloseDate <= :previousMonthEndDate AND CloseDate >=:previousMonthStartDate
                                    					GROUP BY Account.ParentId]
					SELECT SUM(VCPL_Considered_Discount__c) sumOfConsideredAmount,
                    VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId dealerId
                    FROM VCPL_Secondary_Sales_LineItem__c
                    where Account.ParentId IN :mapOfDealer.keyset()
                    AND Opportunity.CloseDate <=: previousMonthEndDate AND Opportunity.CloseDate >=: previousMonthStartDate
                    GROUP BY VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId
                ]
            for (OpportunityLineItem monthlyOpportunitylineitem: [SELECT Id, Volume_Discount__c, Opportunity.VCPL_Previous_Month_Closing_Balance__c, Opportunity.AccountId
                    ,Opportunity.Account.ParentId   FROM OpportunityLineItem
                    WHERE Opportunity.Account.ParentId IN: mapOfDealer.keySet()
                    AND Opportunity.CloseDate <=: previousMonthEndDate AND Opportunity.CloseDate >=: previousMonthStartDate
                ]) {
                    system.Debug(' monthlyOpportunity:::'+monthlyOpportunitylineitem);
                	mapOfDealerIdVsPrevMonthClosingSales.put(monthlyOpportunitylineitem.Opportunity.Account.ParentId, monthlyOpportunitylineitem.Opportunity.VCPL_Previous_Month_Closing_Balance__c != null ? monthlyOpportunitylineitem.Opportunity.VCPL_Previous_Month_Closing_Balance__c : 0);
            		system.Debug(' mapOfDealerIdVsPrevMonthClosingSales:::'+mapOfDealerIdVsPrevMonthClosingSales);
                }
			*/
        }
    }

    private void getGroupedResultOfPrimaryLineItemsForCurrentMonth() {
        if (mapOfDifferentialPricing.keySet().size() > 0) {
            for (AggregateResult primaryResult: [SELECT SUM(Volume_Discount__c) sumOfDiscountedVolume, Opportunity.Account.ParentId dealerId
                    FROM OpportunityLineItem
                    where Opportunity.Account.ParentId in: mapOfDealer.keySet()
                    AND Opportunity.Invoice_Date__c <=: monthEndDate AND Opportunity.Invoice_Date__c >=: monthStartDate
                    GROUP BY Opportunity.Account.ParentId
                ]) {
                    system.debug('mapOfDealerIdVsPrimaryConsolidatedAmount'+mapOfDealerIdVsPrimaryConsolidatedAmount);
                    if(primaryResult.get('dealerId') != null)
                		mapOfDealerIdVsPrimaryConsolidatedAmount.put(String.valueOf(primaryResult.get('dealerId')), Double.ValueOf(primaryResult.get('sumOfDiscountedVolume')) != null ? Double.ValueOf(primaryResult.get('sumOfDiscountedVolume')) : 0);
            		system.debug('mapOfDealerIdVsPrimaryConsolidatedAmount after'+mapOfDealerIdVsPrimaryConsolidatedAmount);
                }
        }
    }

    private void setMapOfDealerVsBalanceAmount() {
        Double secondaryVolumeSum = 0, prevVolumePassed = 0, discountEligible = 0, discountPassed = 0;
        for (Id dealerId: mapOfDealer.KeySet()) {
            secondaryVolumeSum = mapOfDealerIdVsSecodaryVolumeSum.containsKey(dealerId) ? mapOfDealerIdVsSecodaryVolumeSum.get(dealerId) : 0;
            prevVolumePassed = mapOfDealerIdVsPrevMonthClosingSales.containskey(dealerId) ? mapOfDealerIdVsPrevMonthClosingSales.get(dealerId) : 0;
            discountEligible = secondaryVolumeSum + prevVolumePassed;
            discountPassed = mapOfDealerIdVsPrimaryConsolidatedAmount.containsKey(dealerId) ? mapOfDealerIdVsPrimaryConsolidatedAmount.get(dealerId) : 0;
            mapOfDealerVsBalanceAmount.put(dealerId, discountEligible - discountPassed);
            if (discountEligible - discountPassed < 0)
                setOfDealerIdsWithNegativeDisount.add(dealerId);
        }
    }
}