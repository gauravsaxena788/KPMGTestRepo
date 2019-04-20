global class VCPL_CreateMonthlyOpportunityBatch implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
          
          String Accntrcdtype = Label.VCPL_Account_Record_type_for_Batch;
          String query = 'SELECT Id,Name, VCPL_Account_ID__c FROM Account WHERE RecordType.Name = :Accntrcdtype';
          return Database.getQueryLocator(query);
        } 
   
   global void execute(Database.BatchableContext BC, List<Account> lstofAccnt){
       
       // Variables defined
       Set<String> setaccntId = new Set<String>();
       Map<String,String> mapAccntidWithAccntId = new Map<String,String>();
       
       
       for(Account objAcc : lstofAccnt){
           setaccntId.add(objAcc.Id);
           mapAccntidWithAccntId.put(objAcc.Id,objAcc.VCPL_Account_ID__c);
       } 
       
       // method called to create opportunity
       VA_AcountTriggerHandler clsAccnthandler = new VA_AcountTriggerHandler();
       clsAccnthandler.createOpportunityforYear(setaccntId,mapAccntidWithAccntId);
       
   }
   
   global void finish(Database.BatchableContext BC){
   
   }      
}