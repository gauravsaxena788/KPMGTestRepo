global class BatchForCreateTopTwentyCustomerPlan implements Database.Batchable<sObject>
{        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {        
        String query = 'SELECT Id  FROM Account WHERE Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer_Branch\'';      
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> lstOfAccount)
    {
        List<VCPL_Customer_Plan__c> lstOfCPInsert = new List<VCPL_Customer_Plan__c>();
        Map<String,List<VCPL_Customer_Plan__c>> mapofCustomerPlan = new Map<String,List<VCPL_Customer_Plan__c>>();
        Set<String> setofAccId= new Set<String>();
        String strCurrentFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
        String strPrevsFinancialYear = String.valueof(Integer.valueof(strCurrentFinancialYear)-1);
        Id branchCPRTID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByDeveloperName().get('VCPL_Branch_Customer').getRecordTypeId();
        
        for(Account objAcc: lstOfAccount){
            setofAccId.add(objAcc.Id);
        }
        
        /*
List<VCPL_Customer_Plan__c> lstCP = [SELECT Id,VCPL_Financial_Year__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.ParentID,
VCPL_Last_Year_Sales_Vol__c,VCPL_Actual_Sales__c,RecordTypeID,
VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_Customer_Account__r.parentID,
VCPL_Dealer_Account__c,VCPL_Potential__c,VCPL_Branch__c,VCPL_Assignment_Classification__c,
VCPL_ELP_Branch_Head__c,VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c   
FROM VCPL_Customer_Plan__c WHERE VCPL_Customer_Account__c IN:setofAccId and RecordTypeID=:branchCPRTID 
AND VCPL_Financial_Year__c=:strPrevsFinancialYear ORDER BY VCPL_Actual_Sales__c DESC];
*/ 
        
        for(VCPL_Customer_Plan__c objCP : [SELECT Id,VCPL_Financial_Year__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.ParentID,
                                           VCPL_Last_Year_Sales_Vol__c,VCPL_Actual_Sales__c,RecordTypeID,Name,
                                           VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_Customer_Account__r.parentID,
                                           VCPL_Dealer_Account__c,VCPL_Potential__c,VCPL_Branch__c,VCPL_Assignment_Classification__c,
                                           VCPL_ELP_Branch_Head__c,VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
                                           VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c   
                                           FROM VCPL_Customer_Plan__c WHERE VCPL_Customer_Account__c IN:setofAccId and RecordTypeID=:branchCPRTID 
                                           AND VCPL_Financial_Year__c=:strPrevsFinancialYear ORDER BY VCPL_Branch_CO_Sales__c DESC]){
                                               String CPName = (objCP.Name).replace(strPrevsFinancialYear, strCurrentFinancialYear);
                                               if(mapofCustomerPlan.get(objCP.VCPL_Customer_Account__c) != null && mapofCustomerPlan.get(objCP.VCPL_Customer_Account__c).size() < 20){
                                                   
                                                   List<VCPL_Customer_Plan__c> lstCP = mapofCustomerPlan.get(objCP.VCPL_Customer_Account__c); 
                                                   
                                                   VCPL_Customer_Plan__c objCPnew = new VCPL_Customer_Plan__c();                                                   
                                                   objCPnew.Name = CPName;
                                                   objCPnew.VCPL_Customer_Account__c= objCP.VCPL_Customer_Account__c;
                                                   objCPnew.VCPL_Last_Year_CO_Sales_Volume__c = objCP.VCPL_Branch_CO_Sales__c;
                                                   objCPnew.VCPL_Last_Year_IO_Sales_Volume__c = objCP.VCPL_Branch_IO_Sales__c;
                                                   objCPnew.VCPL_Assignment_Classification__c = 'Top 20';
                                                   objCPnew.VCPL_Financial_Year__c = strCurrentFinancialYear;
                                                   objCPnew.VCPL_CD_Customer__c = objCP.VCPL_CD_Customer__c;
                                                   objCPnew.RecordTypeID = objCP.RecordTypeID;             
                                                   lstCP.add(objCPnew);
                                                   
                                                   mapofCustomerPlan.put(objCP.VCPL_Customer_Account__c,lstCP);
                                               }
                                               else if(mapofCustomerPlan.get(objCP.VCPL_Customer_Account__c) == null){
                                                   
                                                   List<VCPL_Customer_Plan__c> lstCP = new List<VCPL_Customer_Plan__c>();
                                                   
                                                   VCPL_Customer_Plan__c objCPnew = new VCPL_Customer_Plan__c();
                                                   objCPnew.Name = CPName;
                                                   objCPnew.VCPL_Customer_Account__c= objCP.VCPL_Customer_Account__c;
                                                   objCPnew.VCPL_Last_Year_CO_Sales_Volume__c = objCP.VCPL_Branch_CO_Sales__c;
                                                   objCPnew.VCPL_Last_Year_IO_Sales_Volume__c = objCP.VCPL_Branch_IO_Sales__c;
                                                   objCPnew.VCPL_Assignment_Classification__c = 'Top 20';
                                                   objCPnew.VCPL_Financial_Year__c = strCurrentFinancialYear;
                                                   objCPnew.VCPL_CD_Customer__c = objCP.VCPL_CD_Customer__c;
                                                   objCPnew.RecordTypeID = objCP.RecordTypeID ;            
                                                   lstCP.add(objCPnew);
                                                   
                                                   mapofCustomerPlan.put(objCP.VCPL_Customer_Account__c,lstCP);
                                               }
                                               
                                           }
        
        for(String strAccId : setofAccId){
            if(mapofCustomerPlan.get(strAccId) != null)
                lstOfCPInsert.addAll(mapofCustomerPlan.get(strAccId));
        }
        
        if(lstOfCPInsert.size() > 0){
            system.debug(lstOfCPInsert.size()+'lstOfCPInsert'+lstOfCPInsert);
            insert lstOfCPInsert;
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}