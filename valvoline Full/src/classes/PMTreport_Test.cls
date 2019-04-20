@isTest
public class PMTreport_Test {

    static testmethod void testPmtReport(){
        Account acc = new account();
        acc.name = 'test';
        acc.Indutry_Segment__c = 'Cummins Dealer';
        acc.Market_Segment__c= 'Industrial Distributor';
        acc.Account_Type__c= 'Industrial Distributor';
        acc.BU_Name__c= 'C&I';
        acc.Zone__c = 'North';
        
        insert acc; 
        
        AOP__c aoObj = new AOP__c();
        aoObj.AOP_DSO__c = 2;
        aoObj.AOP_Focus_Vol_in_kL__c = 1.0;
        aoObj.AOP_Forecast_Accuracy__c = 3;
        aoObj.AOP_National_GP__c = 2;
        aoObj.AOP_National_Vol_in_kL__c= 3.0;
        aoObj.AOP_New_Win_in_kL__c = 5.0;
        aoObj.AOP_Regional_GP__c = 6;
        aoObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aoObj.Valvoline_Financial_Year__c = '2016';
        insert aoObj;
        
        AOP_Line__c aopObj = new AOP_Line__c();
        aopObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aopObj.AOP_National_Vol_in_kL__c = 4.0;
        aopObj.AOP__c = aoObj.id;
        aopObj.AOP_DSO__c = 2.5;
        aopObj.AOP_Forecast_Accuracy__c = 2;
        aopObj.AOP_National_GP__c = 210;
        aopObj.AOP_New_Win_in_kL__c = 3.0;
        aopObj.AOP_Regional_GP__c = 3.4;
        aopObj.Month__c = 'Oct';
        insert aopObj;
        
        //list<recordtype> recList = [SELECT id,DeveloperName FROM recordtype WHERE sobjectType = 'Opportunity' and DeveloperName = 'Monthly_Plan'];
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
        Opportunity oppObj = new Opportunity();
        oppObj.name = 'testopp';
        oppObj.RecordTypeId = devRecordTypeId;
        oppObj.StageName = 'Known Universe';
        oppObj.CloseDate = system.today();
        oppObj.AccountId = acc.id;
        oppObj.Monthly_Plan_Month__c = 'Oct';
        oppObj.Financial_Year__c = '2019';
        insert oppObj;
        
        COGS_Movement__c cgObj = new COGS_Movement__c();
        cgobj.COGS_Value__c = 2.0;
        cgObj.Monthly_Plan_Mon__c = 'Oct';
        cgObj.Financial_Yr__c = '2019';
        insert cgObj;
        
        //list<string> monthList = new list<string>{'Oct','Nov','Dec','Jan'};
        VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
        
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'H1';
        pmtObj.checkPeriodType();
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport1(){
        Account acc = new account();
        acc.name = 'test';
        acc.Indutry_Segment__c = 'Industrial';
        acc.Market_Segment__c= 'Industrial Distributor';
        acc.Account_Type__c= 'Industrial Distributor';
        acc.BU_Name__c= 'C&I';
        acc.Zone__c = 'North';        
        insert acc; 
        
        AOP__c aoObj = new AOP__c();
        aoObj.AOP_DSO__c = 2;
        aoObj.AOP_Focus_Vol_in_kL__c = 1.0;
        aoObj.AOP_Forecast_Accuracy__c = 3;
        aoObj.AOP_National_GP__c = 2;
        aoObj.AOP_National_Vol_in_kL__c= 3.0;
        aoObj.AOP_New_Win_in_kL__c = 5.0;
        aoObj.AOP_Regional_GP__c = 6;
        aoObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aoObj.Valvoline_Financial_Year__c = '2016';
        insert aoObj;
        
        AOP_Line__c aopObj = new AOP_Line__c();
        aopObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aopObj.AOP_National_Vol_in_kL__c = 4.0;
        aopObj.AOP__c = aoObj.id;
        aopObj.AOP_DSO__c = 2.5;
        aopObj.AOP_Forecast_Accuracy__c = 2;
        aopObj.AOP_National_GP__c = 210;
        aopObj.AOP_New_Win_in_kL__c = 3.0;
        aopObj.AOP_Regional_GP__c = 3.4;
        aopObj.Month__c = 'Oct';
        insert aopObj;
        
        //list<recordtype> recList = [SELECT id,DeveloperName FROM recordtype WHERE sobjectType = 'Opportunity' and DeveloperName = 'Monthly_Plan'];
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
        Opportunity oppObj = new Opportunity();
        oppObj.name = 'testopp';
        oppObj.RecordTypeId = devRecordTypeId;
        oppObj.StageName = 'Known Universe';
        oppObj.CloseDate = system.today();
        oppObj.AccountId = acc.id;
        oppObj.Monthly_Plan_Month__c = 'Oct';
        oppObj.Financial_Year__c = '2019';
        insert oppObj;
        
        COGS_Movement__c cgObj = new COGS_Movement__c();
        cgobj.COGS_Value__c = 2.0;
        cgObj.Monthly_Plan_Mon__c = 'Oct';
        cgObj.Financial_Yr__c = '2019';
        insert cgObj;
        
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'H2';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport2(){
        Account acc = new account();
        acc.name = 'test';
        acc.Indutry_Segment__c = 'Infra';
        acc.Market_Segment__c= 'Industrial Distributor';
        acc.Account_Type__c= 'Industrial Distributor';
        acc.BU_Name__c= 'C&I';
        acc.Zone__c = 'North';        
        insert acc; 
        
        AOP__c aoObj = new AOP__c();
        aoObj.AOP_DSO__c = 2;
        aoObj.AOP_Focus_Vol_in_kL__c = 1.0;
        aoObj.AOP_Forecast_Accuracy__c = 3;
        aoObj.AOP_National_GP__c = 2;
        aoObj.AOP_National_Vol_in_kL__c= 3.0;
        aoObj.AOP_New_Win_in_kL__c = 5.0;
        aoObj.AOP_Regional_GP__c = 6;
        aoObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aoObj.Valvoline_Financial_Year__c = '2016';
        insert aoObj;
        
        AOP_Line__c aopObj = new AOP_Line__c();
        aopObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aopObj.AOP_National_Vol_in_kL__c = 4.0;
        aopObj.AOP__c = aoObj.id;
        aopObj.AOP_DSO__c = 2.5;
        aopObj.AOP_Forecast_Accuracy__c = 2;
        aopObj.AOP_National_GP__c = 210;
        aopObj.AOP_New_Win_in_kL__c = 3.0;
        aopObj.AOP_Regional_GP__c = 3.4;
        aopObj.Month__c = 'Oct';
        insert aopObj;
        
        //list<recordtype> recList = [SELECT id,DeveloperName FROM recordtype WHERE sobjectType = 'Opportunity' and DeveloperName = 'Monthly_Plan'];
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
        Opportunity oppObj = new Opportunity();
        oppObj.name = 'testopp';
        oppObj.RecordTypeId = devRecordTypeId;
        oppObj.StageName = 'Known Universe';
        oppObj.CloseDate = system.today();
        oppObj.AccountId = acc.id;
        oppObj.Monthly_Plan_Month__c = 'Oct';
        oppObj.Financial_Year__c = '2019';
        insert oppObj;
        
        COGS_Movement__c cgObj = new COGS_Movement__c();
        cgobj.COGS_Value__c = 2.0;
        cgObj.Monthly_Plan_Mon__c = 'Oct';
        cgObj.Financial_Yr__c = '2019';
        insert cgObj;
        
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'T1';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport3(){
        Account acc = new account();
        acc.name = 'test';
        acc.Indutry_Segment__c = 'Powergen';
        acc.Market_Segment__c= 'Industrial Distributor';
        acc.Account_Type__c= 'Industrial Distributor';
        acc.BU_Name__c= 'C&I';
        acc.Zone__c = 'North';        
        insert acc; 
        
        AOP__c aoObj = new AOP__c();
        aoObj.AOP_DSO__c = 2;
        aoObj.AOP_Focus_Vol_in_kL__c = 1.0;
        aoObj.AOP_Forecast_Accuracy__c = 3;
        aoObj.AOP_National_GP__c = 2;
        aoObj.AOP_National_Vol_in_kL__c= 3.0;
        aoObj.AOP_New_Win_in_kL__c = 5.0;
        aoObj.AOP_Regional_GP__c = 6;
        aoObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aoObj.Valvoline_Financial_Year__c = '2016';
        insert aoObj;
        
        AOP_Line__c aopObj = new AOP_Line__c();
        aopObj.AOP_Regional_Vol_in_kL__c = 2.0;
        aopObj.AOP_National_Vol_in_kL__c = 4.0;
        aopObj.AOP__c = aoObj.id;
        aopObj.AOP_DSO__c = 2.5;
        aopObj.AOP_Forecast_Accuracy__c = 2;
        aopObj.AOP_National_GP__c = 210;
        aopObj.AOP_New_Win_in_kL__c = 3.0;
        aopObj.AOP_Regional_GP__c = 3.4;
        aopObj.Month__c = 'Oct';
        insert aopObj;
        
        //list<recordtype> recList = [SELECT id,DeveloperName FROM recordtype WHERE sobjectType = 'Opportunity' and DeveloperName = 'Monthly_Plan'];
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
        Opportunity oppObj = new Opportunity();
        oppObj.name = 'testopp';
        oppObj.RecordTypeId = devRecordTypeId;
        oppObj.StageName = 'Known Universe';
        oppObj.CloseDate = system.today();
        oppObj.AccountId = acc.id;
        oppObj.Monthly_Plan_Month__c = 'Oct';
        oppObj.Financial_Year__c = '2019';
        insert oppObj;
        
        COGS_Movement__c cgObj = new COGS_Movement__c();
        cgobj.COGS_Value__c = 2.0;
        cgObj.Monthly_Plan_Mon__c = 'Oct';
        cgObj.Financial_Yr__c = '2019';
        insert cgObj;
        
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'T2';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport4(){
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'T3';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport5(){
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'T4';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport6(){
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'Q1';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
    
    static testmethod void testPmtReport7(){
        PMTreport pmtObj = new PMTreport();
        pmtObj.periodtype = 'Q2';
        pmtObj.checkPeriodType(); 
        pmtObj.getperiodtypelist();
        pmtObj.monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        pmtObj.getOpportunityMonthly(pmtObj.monthList);
    }
}