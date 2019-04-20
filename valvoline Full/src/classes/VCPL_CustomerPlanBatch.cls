//This batch class is used to Last Year Customer Plan and Current Year Customer Plan
global class VCPL_CustomerPlanBatch implements Database.Batchable<sObject> {
    
    global Database.querylocator start(Database.BatchableContext bc) {
        string strCustPlanQuery = 'select id,VCPL_Is_Current_Financial_Year__c, VCPL_Last_Financial_Year__c, VCPL_Financial_Year__c from VCPL_Customer_Plan__c';
        strCustPlanQuery += ' where' +'(RecordType.Name='+'\'Branch Customer\'';
        strCustPlanQuery += ' OR '+'RecordType.Name='+'\'Dealer Customer\''+')';
        strCustPlanQuery +='  and VCPL_Financial_Year__c != NULL';
        strCustPlanQuery +='  and ( VCPL_Last_Financial_Year__c = true';
        strCustPlanQuery +='  OR VCPL_Is_Current_Financial_Year__c = true)';
        strCustPlanQuery += ' order by lastmodifiedDate desc';
        
        return Database.getQueryLocator(strCustPlanQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<VCPL_Customer_Plan__c> lstCP) {
        
        if(lstCP != NULL && !lstCP.isEmpty()){
        
            string strcurrentFY = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
            string lastFY = String.valueOf(Integer.valueOf(strcurrentFY)-1);
            
            for(VCPL_Customer_Plan__c objCP : lstCP) {
                objCP.VCPL_Is_Current_Financial_Year__c = objCP.VCPL_Financial_Year__c == strcurrentFY ? true : false;
                objCP.VCPL_Last_Financial_Year__c = objCP.VCPL_Financial_Year__c == lastFY ? True : false;
            }
            update lstCP;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }    
}