public class VCPLDealerScoreCardCalculation {
    private final String CUMMINS_INVOICE_RECORDTYPE_LABEL = 'CD Secondary Sales';
    private final String BRANCH_CUSTOMER_RECORDTYPE_LABEL = 'Branch Customer';
    private final String DEALER_CUSTOMER_RECORDTYPE_LABEL = 'Dealer Customer';
    private final String CD_CUSTOMER_RECORDTYPE_LABEL = 'CD-Customer';
    private final String SAP_ORDER_RECORDTYPE_LABEL = 'SAP Order';

    private Date startDateOfCurrentFinancialYear, endDateOfCurrentFinancialYear, startDateOfPrevFinancialYear, endDateOfPrevFinancialYear;
    private VCPL_Score_Card_Parameters__c scoreCardParameter;
    private VCPL_Score_Card__c dealerScoreCard;
    private Decimal calculatedValue = 0.0;

    public Map < String, Decimal > mapOfMethodNameVsCalculatedValue = new Map < String, Decimal > ();
    public Set < String > setOfMethodNamesToExceute = new Set < String > ();

    public VCPLDealerScoreCardCalculation() {}

    public VCPLDealerScoreCardCalculation(VCPL_Score_Card__c dealerScoreCard, VCPL_Score_Card_Parameters__c scoreCardParameter) {
        this.dealerScoreCard = dealerScoreCard;
        this.scoreCardParameter = scoreCardParameter;
        setDateValues();
    }

    public VCPLDealerScoreCardCalculation(VCPL_Score_Card__c dealerScoreCard, Set < String > setOfMethodNamesToExceute) {
        this.dealerScoreCard = dealerScoreCard;
        this.setOfMethodNamesToExceute = setOfMethodNamesToExceute;
        setDateValues();
    }

    public Map < String, Decimal > getCalculatedValue() {
        calculateValueForParameter();
        return mapOfMethodNameVsCalculatedValue;
    }

    public Map < String, Decimal > getMapOfMethodNameVsCalculatedValue() {
        if (setOfMethodNamesToExceute.contains('nonDiscountedVolumeGrowth'))
            nonDiscountedVolumeGrowth();
        if (setOfMethodNamesToExceute.contains('primaryGrowth'))
            primaryGrowth();
        if (setOfMethodNamesToExceute.contains('secondaryGrowth'))
            secondaryGrowth();
        if (setOfMethodNamesToExceute.contains('dealerPenetration'))
            dealerPenetration();
        if (setOfMethodNamesToExceute.contains('filterBuyPercentage'))
            filterBuyPercentage();
        if (setOfMethodNamesToExceute.contains('dealerTop20Potential') || setOfMethodNamesToExceute.contains('dealerTarget20Potential'))
            dealerTarget20AndTop20Potential();
        if (setOfMethodNamesToExceute.contains('dealerTarget20CYSales') || setOfMethodNamesToExceute.contains('dealerTop20CYSales') ||
            setOfMethodNamesToExceute.contains('dealerTop20CYEstimateSales') || setOfMethodNamesToExceute.contains('dealerTarget20CYEstimateSales'))
            dealerTarget20AndTop20CYSalesAndEstimateSales();
        if (setOfMethodNamesToExceute.contains('dealerTarget20LYSales') || setOfMethodNamesToExceute.contains('dealerTop20LYSales'))
            dealerTarget20AndTop20LYSales();
        if (setOfMethodNamesToExceute.contains('percentageVolQualifiedForBLIS'))
            percentageVolQualifiedForBLIS();
        if (setOfMethodNamesToExceute.contains('weightedAverage'))
            weightedAverage();


        return mapOfMethodNameVsCalculatedValue;
    }

    private void calculateValueForParameter() {
        if (scoreCardParameter.VCPL_Calculation_Method_Name__c == '' || scoreCardParameter.VCPL_Calculation_Method_Name__c == null) {
            return;
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'nonDiscountedVolumeGrowth') {
            nonDiscountedVolumeGrowth();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'primaryGrowth') {
            primaryGrowth();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'secondaryGrowth') {
            secondaryGrowth();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerPenetration') {
            dealerPenetration();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'filterBuyPercentage') {
            filterBuyPercentage();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTop20Potential' || scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTarget20Potential') {
            dealerTarget20AndTop20Potential();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTarget20CYSales' ||
            scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTop20CYSales' ||
            scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTop20CYEstimateSales' ||
            scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTarget20CYEstimateSales') {
            dealerTarget20AndTop20CYSalesAndEstimateSales();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTarget20LYSales' || scoreCardParameter.VCPL_Calculation_Method_Name__c == 'dealerTop20LYSales') {
            dealerTarget20AndTop20LYSales();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'percentageVolQualifiedForBLIS') {
            percentageVolQualifiedForBLIS();
        } else if (scoreCardParameter.VCPL_Calculation_Method_Name__c == 'weightedAverage') {
            weightedAverage();
        } else {
            return;
        }
    }

    private void setDateValues() {
        Integer year = Integer.valueOf(dealerScoreCard.VCPL_Financial_Year__c);
        if (dealerScoreCard.VCPL_As_of__c == 'March') {
            startDateOfCurrentFinancialYear = Date.newInstance(year - 1, 10, 1);
            endDateOfCurrentFinancialYear = Date.newInstance(year, 3, 31);
            startDateOfPrevFinancialYear = Date.newInstance(year - 2, 10, 1);
            endDateOfPrevFinancialYear = Date.newInstance(year - 2, 3, 31);
        } else if (dealerScoreCard.VCPL_As_of__c == 'September') {
            startDateOfCurrentFinancialYear = Date.newInstance(year, 4, 1);
            endDateOfCurrentFinancialYear = Date.newInstance(year, 9, 30);
            startDateOfPrevFinancialYear = Date.newInstance(year - 1, 4, 1);
            endDateOfPrevFinancialYear = Date.newInstance(year - 1, 9, 30);
        }
    }

    //TO DO Non discounted Identification missing
    //Formula Shared - Dealer volume CY (non DP)/Dealer vol LY (non DP)
    private void nonDiscountedVolumeGrowth() {
        Decimal currentHalfYearNonDiscountedVolume = 0.0, previousHalfYearNonDiscountedVolume = 0.0;
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
		
        for (VCPL_Secondary_Sales__c cdCumminsInvoiceOpprtunity: [select id, VCPL_Invoice_Date__c, VCPL_Volume__c
                from VCPL_Secondary_Sales__c
                where VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c AND
                RecordTypeId =: cumminsInvoiceRecordTypeId
                AND(
                    (VCPL_Invoice_Date__c >=: startDateOfCurrentFinancialYear AND VCPL_Invoice_Date__c <=: endDateOfCurrentFinancialYear) OR(VCPL_Invoice_Date__c >=: startDateOfPrevFinancialYear AND VCPL_Invoice_Date__c <=: endDateOfPrevFinancialYear))
            ]) {

            cdCumminsInvoiceOpprtunity.VCPL_Volume__c = cdCumminsInvoiceOpprtunity.VCPL_Volume__c != null ? cdCumminsInvoiceOpprtunity.VCPL_Volume__c : 0;

            if (cdCumminsInvoiceOpprtunity.VCPL_Invoice_Date__c != null && cdCumminsInvoiceOpprtunity.VCPL_Invoice_Date__c <= endDateOfCurrentFinancialYear &&
                cdCumminsInvoiceOpprtunity.VCPL_Invoice_Date__c >= startDateOfCurrentFinancialYear) {
                currentHalfYearNonDiscountedVolume += cdCumminsInvoiceOpprtunity.VCPL_Volume__c;
            } else if (cdCumminsInvoiceOpprtunity.VCPL_Invoice_Date__c != null && cdCumminsInvoiceOpprtunity.VCPL_Invoice_Date__c <= endDateOfPrevFinancialYear &&
                cdCumminsInvoiceOpprtunity.VCPL_Invoice_Date__c >= startDateOfPrevFinancialYear) {
                previousHalfYearNonDiscountedVolume += cdCumminsInvoiceOpprtunity.VCPL_Volume__c;
            }
        }
        if (previousHalfYearNonDiscountedVolume != 0) {
            calculatedValue = currentHalfYearNonDiscountedVolume / previousHalfYearNonDiscountedVolume;
        }

        mapOfMethodNameVsCalculatedValue.put('nonDiscountedVolumeGrowth', calculatedValue);
    }

    //Formula shared - CY YTD Primary CO sales/LY YTD primary CO sales
    private void primaryGrowth() {
        Decimal currentHalfYearNonDiscountedVolume = 0.0, previousHalfYearNonDiscountedVolume = 0.0;
        Id SAPOrderOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(SAP_ORDER_RECORDTYPE_LABEL).getRecordTypeId();

        for (OpportunityLineItem sapOrderOpportunityPrimaryOLI: [select id, Opportunity.Invoice_Date__c, Vol_inltrs__c
                from OpportunityLineItem
                where Opportunity.RecordTypeId =: SAPOrderOpportunityRecordTypeId AND
                Opportunity.Account.ParentId =: dealerScoreCard.VCPL_Account__c AND
                Product2.PH6_Qlikview__c = 'Cummins Oil'
                AND(
                    (Opportunity.Invoice_Date__c >=: startDateOfCurrentFinancialYear AND Opportunity.Invoice_Date__c <=: endDateOfCurrentFinancialYear) OR(Opportunity.Invoice_Date__c >=: startDateOfPrevFinancialYear AND Opportunity.Invoice_Date__c <=: endDateOfPrevFinancialYear))
            ]) {
            sapOrderOpportunityPrimaryOLI.Vol_inltrs__c = sapOrderOpportunityPrimaryOLI.Vol_inltrs__c != null ? sapOrderOpportunityPrimaryOLI.Vol_inltrs__c : 0;

            if (sapOrderOpportunityPrimaryOLI.Opportunity.Invoice_Date__c != null && sapOrderOpportunityPrimaryOLI.Opportunity.Invoice_Date__c <= endDateOfCurrentFinancialYear &&
                sapOrderOpportunityPrimaryOLI.Opportunity.Invoice_Date__c >= startDateOfCurrentFinancialYear) {
                currentHalfYearNonDiscountedVolume += sapOrderOpportunityPrimaryOLI.Vol_inltrs__c;
            } else if (sapOrderOpportunityPrimaryOLI.Opportunity.Invoice_Date__c != null && sapOrderOpportunityPrimaryOLI.Opportunity.Invoice_Date__c <= endDateOfPrevFinancialYear &&
                sapOrderOpportunityPrimaryOLI.Opportunity.Invoice_Date__c >= startDateOfPrevFinancialYear) {
                previousHalfYearNonDiscountedVolume += sapOrderOpportunityPrimaryOLI.Vol_inltrs__c;
            }
        }

        if (previousHalfYearNonDiscountedVolume != 0) {
            calculatedValue = currentHalfYearNonDiscountedVolume / previousHalfYearNonDiscountedVolume;
        }
        mapOfMethodNameVsCalculatedValue.put('primaryGrowth', calculatedValue);
    }

    //Formula shared - CY YTD Secondary CO sales/LY YTD Sec CO sales
    private void secondaryGrowth() {
        Decimal currentHalfYearNonDiscountedVolume = 0.0, previousHalfYearNonDiscountedVolume = 0.0;
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();

        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceCOOpprtunityLineItem: [select id, VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c, VCPL_Vol_in_Ltrs__c
                from VCPL_Secondary_Sales_LineItem__c
                where VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c AND
                VCPL_Secondary_Sales__r.RecordTypeId =: cumminsInvoiceRecordTypeId AND
                VCPL_Product__r.PH6_Qlikview__c = 'Cummins Oil'
                AND(
                    (VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfCurrentFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfCurrentFinancialYear) OR(VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfPrevFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfPrevFinancialYear))
            ]) {

            cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Vol_in_Ltrs__c = cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Vol_in_Ltrs__c != null ? cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Vol_in_Ltrs__c : 0;

            if (cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c != null && cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <= endDateOfCurrentFinancialYear &&
                cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >= startDateOfCurrentFinancialYear) {
                currentHalfYearNonDiscountedVolume += cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Vol_in_Ltrs__c;
            } else if (cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c != null && cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <= endDateOfPrevFinancialYear &&
                cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >= startDateOfPrevFinancialYear) {
                previousHalfYearNonDiscountedVolume += cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Vol_in_Ltrs__c;
            }
        }
        if (previousHalfYearNonDiscountedVolume != 0) {
            calculatedValue = currentHalfYearNonDiscountedVolume / previousHalfYearNonDiscountedVolume;
        }
        mapOfMethodNameVsCalculatedValue.put('secondaryGrowth', calculatedValue);
    }

    //Formula shared - CY YTD Discount/L/LY YTD Discount/L
    private void weightedAverage() {
        Decimal currentHalfYearDiscountedVolume = 0.0, previousHalfYearDiscountedVolume = 0.0;
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();

        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceCOOpprtunityLineItem: [select id, VCPL_Discount_L__c, VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c, VCPL_Vol_in_Ltrs__c
                from VCPL_Secondary_Sales_LineItem__c
                where VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c AND
                VCPL_Secondary_Sales__r.RecordTypeId =: cumminsInvoiceRecordTypeId 
                AND(
                    (VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfCurrentFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfCurrentFinancialYear) OR(VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfPrevFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfPrevFinancialYear))
            ]) {

            if (cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c != null && cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <= endDateOfCurrentFinancialYear &&
                cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >= startDateOfCurrentFinancialYear) {
                currentHalfYearDiscountedVolume += cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Discount_L__c;
            } else if (cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c != null && cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <= endDateOfPrevFinancialYear &&
                cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >= startDateOfPrevFinancialYear) {
                previousHalfYearDiscountedVolume += cdCumminsInvoiceCOOpprtunityLineItem.VCPL_Discount_L__c;
            }
        }
        if (previousHalfYearDiscountedVolume != 0) {
            calculatedValue = currentHalfYearDiscountedVolume / previousHalfYearDiscountedVolume;
        }
        mapOfMethodNameVsCalculatedValue.put('weightedAverage', calculatedValue);
    }

    //Formula shared - Dealer total secondary CO sales/Dealer total Sec Sales potential (Sum of Sec customer accounts dealer wise potential)
    private void dealerPenetration() { //CO == LIneItem CO/IO Check -- >CO --field volume in ltrs product filter not applied
        calculatedValue = 0.0;
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
        Decimal totalSecondaryCOSales = 0.0, totalSecSalesPotential = 0.0;
        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceOpprtunityLineItem: [select id, VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c, VCPL_Vol_in_Ltrs__c,
                VCPL_Product__r.PH6_Qlikview__c, VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Potential__c
                from VCPL_Secondary_Sales_LineItem__c
                where VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c AND
                VCPL_Secondary_Sales__r.RecordTypeId =: cumminsInvoiceRecordTypeId
                AND(VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfCurrentFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfCurrentFinancialYear)
            ]) {
            if (cdCumminsInvoiceOpprtunityLineItem.VCPL_Product__r.PH6_Qlikview__c == 'Cummins Oil')
                totalSecondaryCOSales += cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c != null ? cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c : 0;

            totalSecSalesPotential += cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Potential__c != null ? cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Potential__c : 0;
        }
        if (totalSecSalesPotential != 0) {
            calculatedValue = totalSecondaryCOSales / totalSecSalesPotential;
        }
        mapOfMethodNameVsCalculatedValue.put('dealerPenetration', calculatedValue);
    }

    //Formula Shared - No. of Accounts buying filter not CO oil/Total no. of customer accounts for dealer buying Filter
    private void filterBuyPercentage() { //Invoice date filter not needed
        calculatedValue = 0.0;
        //Id CDCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CD_CUSTOMER_RECORDTYPE_LABEL).getRecordTypeId();
        Id cumminsDealerInvoiceRecordTypeId = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get(DEALER_CUSTOMER_RECORDTYPE_LABEL).getRecordTypeId();
        Integer noOfAccountBuyingFilterNotCOOil = 0, noOfCustomerAccountsBuyingFilter = 0;
        for (VCPL_Customer_Plan__c dealerCustomerOpportunity: [select id, VCPL_Customer_Account__c, VCPL_Customer_Account__r.VCPL_CDOS_Filter_Sales__c
                from VCPL_Customer_Plan__c
                where RecordTypeId =: cumminsDealerInvoiceRecordTypeId AND
                VCPL_Customer_Account__c =: dealerScoreCard.VCPL_Account__c
            ]) {
            //TODO VCPL_Customer_Account__r. add filter.
            noOfAccountBuyingFilterNotCOOil++;
            noOfCustomerAccountsBuyingFilter++;
        }
        if (noOfCustomerAccountsBuyingFilter != 0) {
            calculatedValue = noOfAccountBuyingFilterNotCOOil / noOfCustomerAccountsBuyingFilter;
        }
        mapOfMethodNameVsCalculatedValue.put('filterBuyPercentage', calculatedValue);
    }

    //Formula Shared -Sum of Potential of all customer accounts assigned as TGT 20 to all its branches - Annual
    //Formula Shared - Sum of Potential of all customer accounts assigned as TOP 20 to all its branches - Annual
    private void dealerTarget20AndTop20Potential() { //Invoice date filter not needed
        Id branchCustomerRecordType = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get(BRANCH_CUSTOMER_RECORDTYPE_LABEL).getRecordTypeId();
        Decimal sumOfTop20Potential = 0, sumOfTarget20Potential = 0;
        for (VCPL_Customer_Plan__c branchCustomerTarget20Oppty: [select id, VCPL_Potential__c, VCPL_Assignment_Classification__c
                from VCPL_Customer_Plan__c
                where RecordTypeId =: branchCustomerRecordType
                AND(VCPL_Assignment_Classification__c = 'Target 20'
                    OR VCPL_Assignment_Classification__c = 'Top 20')
                AND
                VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c
            ]) {

            branchCustomerTarget20Oppty.VCPL_Potential__c = branchCustomerTarget20Oppty.VCPL_Potential__c != null ? branchCustomerTarget20Oppty.VCPL_Potential__c : 0;

            if (branchCustomerTarget20Oppty.VCPL_Assignment_Classification__c == 'Target 20')
                sumOfTarget20Potential += branchCustomerTarget20Oppty.VCPL_Potential__c;
            else if (branchCustomerTarget20Oppty.VCPL_Assignment_Classification__c == 'Top 20')
                sumOfTop20Potential += branchCustomerTarget20Oppty.VCPL_Potential__c;
        }
        mapOfMethodNameVsCalculatedValue.put('dealerTarget20Potential', sumOfTarget20Potential);
        mapOfMethodNameVsCalculatedValue.put('dealerTOP20Potential', sumOfTop20Potential);
    }

    //Formula Shared - Sum of LY sec CO sales of TGT 20CY customer accounts assigned as TGT 20 to all its branches - annual
    //Formula Shared - Sum of LY sec CO sales of TOP 20CY customer accounts assigned as TOP 20 to all its branches - annual
    private void dealerTarget20AndTop20LYSales() {
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
        Decimal totalLYCOSalesOfTop20Customers = 0.0, totalLYCOSalesOfTarget20Customers = 0.0;
        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer: [select id, VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c, VCPL_Vol_in_Ltrs__c,
                VCPL_Product__r.PH6_Qlikview__c, VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Potential__c
                from VCPL_Secondary_Sales_LineItem__c
                where VCPL_Product__r.PH6_Qlikview__c = 'Cummins Oil'
                AND
                VCPL_Secondary_Sales__r.RecordTypeId =: cumminsInvoiceRecordTypeId
                AND(VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Target 20'
                    OR VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Top 20')
                AND
                VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c
                AND(VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfPrevFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfPrevFinancialYear)
            ]) {

            cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c = cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c != null ? cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c : 0;

            if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Top 20')
                totalLYCOSalesOfTop20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c;
            else if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Target 20')
                totalLYCOSalesOfTarget20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c;
        }

        mapOfMethodNameVsCalculatedValue.put('dealerTarget20LYSales', totalLYCOSalesOfTarget20Customers);
        mapOfMethodNameVsCalculatedValue.put('dealerTop20LYSales', totalLYCOSalesOfTop20Customers);
    }

    //Formula Shared - Sum of CY actual CO sales of cust accounts assigned as TGT 20 for all its branches - 6 Month
    //Formula Shared - Sum of CY actual CO sales of cust accounts assigned as TOP 20 for all its branches - 6 Month
    //Formula Shared - Sum of CY LE of Sec cust accounts assigned as TGT 20 for all its branches - Data for 6 months
    //Formula Shared - Sum of CY LE of Sec cust accounts assigned as TOP 20 for all its branches - Data for 6 months
    private void dealerTarget20AndTop20CYSalesAndEstimateSales() {
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
        Decimal totalCYCOSalesOfTarget20Customers = 0.0, totalLYCOSalesOfTop20Customers = 0.0, totalCYEstimateSalesOfTop20Customers = 0.0, totalCYEstimateSalesOfTarget20Customers = 0.0;
        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer: [select id, VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c, VCPL_Vol_in_Ltrs__c,
                VCPL_Product__r.PH6_Qlikview__c, VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Potential__c, VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c
                ,VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c from VCPL_Secondary_Sales_LineItem__c
                where(VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Target 20'
                    OR VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Top 20')
                AND VCPL_Secondary_Sales__r.RecordTypeId =: cumminsInvoiceRecordTypeId AND
                VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c
                AND(VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfCurrentFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: startDateOfCurrentFinancialYear)
            ]) {

            cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c = cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c != null ? cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c : 0;

            if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Product__r.PH6_Qlikview__c == 'Cummins Oil') {
                if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Top 20')
                    totalLYCOSalesOfTop20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c;
                else if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Target 20')
                    totalCYCOSalesOfTarget20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Vol_in_Ltrs__c;
            }
            if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Target 20')
                totalCYEstimateSalesOfTarget20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c;
            else if (cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Top 20')
                totalCYEstimateSalesOfTop20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTarget20OrTop20Customer.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c;
        }

        mapOfMethodNameVsCalculatedValue.put('dealerTarget20CYSales', totalCYCOSalesOfTarget20Customers);
        mapOfMethodNameVsCalculatedValue.put('dealerTop20CYSales', totalLYCOSalesOfTop20Customers);

        mapOfMethodNameVsCalculatedValue.put('dealerTarget20CYEstimateSales', totalCYEstimateSalesOfTarget20Customers);
        mapOfMethodNameVsCalculatedValue.put('dealerTop20CYEstimateSales', totalCYEstimateSalesOfTop20Customers);
    }

    //Formula Shared - Dealer branches qualified for BLIS volume/Dealer total Sales volume (sec sales)
    public void percentageVolQualifiedForBLIS() {
        calculatedValue = 0.0;
        Id cumminsInvoiceRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
        Id blissRecordTypeID = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
        Map < Id, Double > mapOfBranchIdVsPreviousYearSales = new Map < Id, Double > ();
        Map < Id, Double > mapOfBranchIdVsCurrentYearSales = new Map < Id, Double > ();


        Decimal totalSecondaryCOSales = 0.0, totalSecSalesPotential = 0.0;

        list < VCPL_AVD_QVD__c > lstAVDQVDConfigs = [select id, VCPL_Growth_Slab_1_In_Percentage__c, VCPL_Fiscal_Year__c,
            VCPL_Growth_Slab_2_In_Percentage__c, VCPL_Growth_Slab_3_In_Percentage__c,
            VCPL_Growth_Slab_4_In_Percentage__c, VCPL_Incentive_Slab_1_AVD_In_R_L__c,
            VCPL_Incentive_Slab_1_QVD_In_R_L__c, VCPL_Incentive_Slab_2_AVD_In_R_L__c,
            VCPL_Incentive_Slab_2_QVD_In_R_L__c, VCPL_Incentive_Slab_3_AVD_In_R_L__c,
            VCPL_Incentive_Slab_3_QVD_In_R_L__c, VCPL_Incentive_Slab_4_AVD_In_R_L__c,
            VCPL_Incentive_Slab_4_QVD_In_R_L__c from VCPL_AVD_QVD__c where
            VCPL_Fiscal_Year__c =: dealerScoreCard.VCPL_Financial_Year__c and recordTypeID =: blissRecordTypeID
        ];

        if (lstAVDQVDConfigs.size() == 0)
            return;

        List < VCPL_Secondary_Sales_LineItem__c > lstOfCDCumminsInvoiceOpprtunityLineItem = new List < VCPL_Secondary_Sales_LineItem__c > ([select id, VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c, VCPL_Vol_in_Ltrs__c,
            VCPL_Product__r.PH6_Qlikview__c, VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Potential__c, VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c
            from VCPL_Secondary_Sales_LineItem__c
            where VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Customer_Account__r.ParentId =: dealerScoreCard.VCPL_Account__c AND
            VCPL_Secondary_Sales__r.RecordTypeId =: cumminsInvoiceRecordTypeId
            AND((VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfCurrentFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfCurrentFinancialYear) OR(VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >=: startDateOfPrevFinancialYear AND VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <=: endDateOfPrevFinancialYear))
        ]);

        Double firstSlabValue = 0, secondSlabValue = 0, thirdSlabValue = 0, fourthSlabValue = 0, firstIncentiveValue = 0, secondIncentiveValue = 0, thirdIncentiveValue = 0, fourthIncentiveValue = 0, calculatedIncentive = 0, totalBLISSSalesCalculatedVolume = 0, totalSecondarySales = 0;


        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceOpprtunityLineItem: lstOfCDCumminsInvoiceOpprtunityLineItem) {

            cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c = cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c != null ? cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c : 0;

            if (cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c != null && cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <= endDateOfCurrentFinancialYear &&
                cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >= startDateOfCurrentFinancialYear) {
                if (!mapOfBranchIdVsCurrentYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c))
                    mapOfBranchIdVsCurrentYearSales.put(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c, cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c);
                else
                    mapOfBranchIdVsCurrentYearSales.put(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c, cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c + mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c));

            } else if (cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c != null && cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c <= endDateOfPrevFinancialYear &&
                cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Invoice_Date__c >= startDateOfPrevFinancialYear) {
                if (!mapOfBranchIdVsPreviousYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c))
                    mapOfBranchIdVsPreviousYearSales.put(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c, cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c);
                else
                    mapOfBranchIdVsPreviousYearSales.put(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c, cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c + mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c));
            }
        }

        for (VCPL_Secondary_Sales_LineItem__c cdCumminsInvoiceOpprtunityLineItem: lstOfCDCumminsInvoiceOpprtunityLineItem) {
            firstSlabValue = mapOfBranchIdVsPreviousYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) * (1 + lstAVDQVDConfigs[0].VCPL_Growth_Slab_1_In_Percentage__c / 100) : 0;
            secondSlabValue = mapOfBranchIdVsPreviousYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) * (1 + lstAVDQVDConfigs[0].VCPL_Growth_Slab_2_In_Percentage__c / 100) : 0;
            thirdSlabValue = mapOfBranchIdVsPreviousYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) * (1 + lstAVDQVDConfigs[0].VCPL_Growth_Slab_3_In_Percentage__c / 100) : 0;
            fourthSlabValue = mapOfBranchIdVsPreviousYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? mapOfBranchIdVsPreviousYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) * (1 + lstAVDQVDConfigs[0].VCPL_Growth_Slab_4_In_Percentage__c / 100) : 0;

            firstIncentiveValue = mapOfBranchIdVsCurrentYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? firstSlabValue - mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) : 0;
            secondIncentiveValue = mapOfBranchIdVsCurrentYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? secondSlabValue - mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) : 0;
            thirdIncentiveValue = mapOfBranchIdVsCurrentYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? thirdSlabValue - mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) : 0;
            fourthIncentiveValue = mapOfBranchIdVsCurrentYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) && mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) > 0 ? fourthSlabValue - mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c) : 0;

            if (mapOfBranchIdVsCurrentYearSales.containsKey(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c)) {
                Double currentSales = mapOfBranchIdVsCurrentYearSales.get(cdCumminsInvoiceOpprtunityLineItem.VCPL_Secondary_Sales__r.VCPL_Branch_Customer__r.VCPL_Branch__c);
                if (currentSales < firstSlabValue) {
                    calculatedIncentive = 0;
                } else if (currentSales >= firstSlabValue && currentSales < secondSlabValue) {
                    calculatedIncentive = currentSales * lstAVDQVDConfigs[0].VCPL_Growth_Slab_1_In_Percentage__c;
                } else if (currentSales >= secondSlabValue && currentSales < thirdSlabValue) {
                    calculatedIncentive = currentSales * lstAVDQVDConfigs[0].VCPL_Growth_Slab_2_In_Percentage__c;
                } else if (currentSales >= thirdSlabValue && currentSales < fourthSlabValue) {
                    calculatedIncentive = currentSales * lstAVDQVDConfigs[0].VCPL_Growth_Slab_3_In_Percentage__c;
                } else {
                    calculatedIncentive = currentSales * lstAVDQVDConfigs[0].VCPL_Growth_Slab_4_In_Percentage__c;
                }
            } else {
                calculatedIncentive = 0;
            }

            if (calculatedIncentive > 0)
                totalBLISSSalesCalculatedVolume += cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c;
            totalSecondarySales += cdCumminsInvoiceOpprtunityLineItem.VCPL_Vol_in_Ltrs__c;

        }

        if (totalSecondarySales > 0) {
            calculatedValue = totalBLISSSalesCalculatedVolume / totalSecondarySales;
        }

        mapOfMethodNameVsCalculatedValue.put('percentageVolQualifiedForBLIS', calculatedValue);

    }


    //Formula Shared - Sum of CY actual CO sales of cust accounts assigned as TOP 20 for all its branches - 6 Month
    //private void dealerTop20CYSales() {
    //    Id cumminsInvoiceRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
    //    Decimal totalLYCOSalesOfTop20Customers = 0.0;
    //    for (OpportunityLineItem cdCumminsInvoiceCOOpprtunityLineItemForTop20Customer: [select id, Opportunity.Invoice_Date__c, Vol_inltrs__c,
    //            Product2.PH6_Qlikview__c, Opportunity.VCPL_Branch_Customer__r.VCPL_Potential__c
    //            from OpportunityLineItem
    //            where Opportunity.RecordTypeId =: cumminsInvoiceRecordTypeId AND
    //            Product2.PH6_Qlikview__c = 'Cummins Oil'
    //            AND Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Top 20'
    //            AND
    //            Opportunity.VCPL_Branch_Customer__r.VCPL_Branch__r.ParentId =: dealerScoreCard.VCPL_Account__c
    //            AND(Opportunity.Invoice_Date__c >=: startDateOfCurrentFinancialYear AND Opportunity.Invoice_Date__c <=: startDateOfCurrentFinancialYear)
    //        ]) {
    //        totalLYCOSalesOfTop20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTop20Customer.Vol_inltrs__c;
    //    }

    //    calculatedValue = totalLYCOSalesOfTop20Customers;
    //    mapOfMethodNameVsCalculatedValue.put('dealerTop20CYSales', calculatedValue);
    //}

    //Formula Shared - Sum of CY LE of Sec cust accounts assigned as TGT 20 for all its branches - Data for 6 months
    //Formula Shared - Sum of CY LE of Sec cust accounts assigned as TOP 20 for all its branches - Data for 6 months
    //private void dealerTarget20AndTop20CYEstimateSales() {
    //    Id cumminsInvoiceRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
    //    Decimal totalCYEstimateSalesOfTop20Customers = 0.0, totalCYEstimateSalesOfTarget20Customers = 0.0;
    //    for (OpportunityLineItem cdCumminsInvoiceOpprtunityLineItemForTarget20OrTop20Customer: [select id, Opportunity.Invoice_Date__c, Vol_inltrs__c,
    //            Opportunity.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c,
    //            Product2.PH6_Qlikview__c, Opportunity.VCPL_Branch_Customer__r.VCPL_Potential__c
    //            from OpportunityLineItem
    //            where Opportunity.RecordTypeId =: cumminsInvoiceRecordTypeId
    //            AND(Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Target 20'
    //                OR Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Top 20')
    //            AND
    //            Opportunity.VCPL_Branch_Customer__r.VCPL_Branch__r.ParentId =: dealerScoreCard.VCPL_Account__c
    //            AND(Opportunity.Invoice_Date__c >=: startDateOfCurrentFinancialYear AND Opportunity.Invoice_Date__c <=: endDateOfCurrentFinancialYear)
    //        ]) {
    //        if (cdCumminsInvoiceOpprtunityLineItemForTarget20OrTop20Customer.Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Target 20')
    //            totalCYEstimateSalesOfTarget20Customers += cdCumminsInvoiceOpprtunityLineItemForTarget20OrTop20Customer.Opportunity.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c;
    //        else if (cdCumminsInvoiceOpprtunityLineItemForTarget20OrTop20Customer.Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c == 'Top 20')
    //            totalCYEstimateSalesOfTop20Customers += cdCumminsInvoiceOpprtunityLineItemForTarget20OrTop20Customer.Opportunity.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c;
    //    }
    //    mapOfMethodNameVsCalculatedValue.put('dealerTarget20CYEstimateSales', totalCYEstimateSalesOfTarget20Customers);
    //    mapOfMethodNameVsCalculatedValue.put('dealerTop20CYEstimateSales', totalCYEstimateSalesOfTop20Customers);
    //}

    //Formula Shared - Sum of CY LE of Sec cust accounts assigned as TOP 20 for all its branches - Data for 6 months
    //private void dealerTop20CYEstimateSales() {
    //    Id cumminsInvoiceRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
    //    Decimal totalLYCOSalesOfTop20Customers = 0.0;
    //    for (OpportunityLineItem cdCumminsInvoiceOpprtunityLineItemForTop20Customer: [select id, Opportunity.Invoice_Date__c, Vol_inltrs__c,
    //            Opportunity.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c,
    //            Product2.PH6_Qlikview__c, Opportunity.VCPL_Branch_Customer__r.VCPL_Potential__c
    //            from OpportunityLineItem
    //            where Opportunity.RecordTypeId =: cumminsInvoiceRecordTypeId
    //            AND Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Top 20'
    //            AND
    //            Opportunity.VCPL_Branch_Customer__r.VCPL_Branch__r.ParentId =: dealerScoreCard.VCPL_Account__c
    //            AND(Opportunity.Invoice_Date__c >=: startDateOfCurrentFinancialYear AND Opportunity.Invoice_Date__c <=: endDateOfCurrentFinancialYear)
    //        ]) {
    //        totalLYCOSalesOfTop20Customers += cdCumminsInvoiceOpprtunityLineItemForTop20Customer.Opportunity.VCPL_Branch_Customer__r.VCPL_Latest_Est_Sales__c;
    //    }
    //    calculatedValue = totalLYCOSalesOfTop20Customers;
    //    mapOfMethodNameVsCalculatedValue.put('dealerTop20CYEstimateSales', calculatedValue);
    //}

    //Formula Shared - Sum of LY sec CO sales of TOP 20CY customer accounts assigned as TOP 20 to all its branches - annual
    //private void dealerTop20LYSales() {
    //    Id cumminsInvoiceRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CUMMINS_INVOICE_RECORDTYPE_LABEL).getRecordTypeId();
    //    Decimal totalLYCOSalesOfTop20Customers = 0.0;
    //    for (OpportunityLineItem cdCumminsInvoiceCOOpprtunityLineItemForTop20Customer: [select id, Opportunity.Invoice_Date__c, Vol_inltrs__c,
    //            Product2.PH6_Qlikview__c, Opportunity.VCPL_Branch_Customer__r.VCPL_Potential__c
    //            from OpportunityLineItem
    //            where Opportunity.RecordTypeId =: cumminsInvoiceRecordTypeId AND
    //            Product2.PH6_Qlikview__c = 'Cummins Oil'
    //            AND Opportunity.VCPL_Branch_Customer__r.VCPL_Assignment_Classification__c = 'Top 20'
    //            AND
    //            Opportunity.VCPL_Branch_Customer__r.VCPL_Branch__r.ParentId =: dealerScoreCard.VCPL_Account__c
    //            AND(Opportunity.Invoice_Date__c >=: startDateOfPrevFinancialYear AND Opportunity.Invoice_Date__c <=: endDateOfPrevFinancialYear)
    //        ]) {
    //        totalLYCOSalesOfTop20Customers += cdCumminsInvoiceCOOpprtunityLineItemForTop20Customer.Vol_inltrs__c;
    //    }

    //    calculatedValue = totalLYCOSalesOfTop20Customers;
    //    mapOfMethodNameVsCalculatedValue.put('dealerTop20LYSales', calculatedValue);
    //}

    //Formula Shared - Sum of Potential of all customer accounts assigned as TOP 20 to all its branches - Annual
    //private void dealerTOP20Potential() { //Invoice date filter not needed
    //    Id branchCustomerRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(BRANCH_CUSTOMER_RECORDTYPE_LABEL).getRecordTypeId();
    //    Decimal sumOfTop20Potential = 0;
    //    for (Opportunity branchCustomerTOP20Oppty: [select id, Invoice_Date__c, Volume__c, VCPL_Potential__c
    //            from Opportunity
    //            where RecordTypeId =: branchCustomerRecordType
    //            AND VCPL_Assignment_Classification__c = 'Top 20'
    //            AND
    //            VCPL_Branch_Customer__r.VCPL_Branch__r.ParentId =: dealerScoreCard.VCPL_Account__c
    //        ]) {
    //        sumOfTop20Potential += branchCustomerTOP20Oppty.VCPL_Potential__c;
    //    }
    //    calculatedValue = sumOfTop20Potential;
    //    mapOfMethodNameVsCalculatedValue.put('dealerTOP20Potential', calculatedValue);
    //}
}