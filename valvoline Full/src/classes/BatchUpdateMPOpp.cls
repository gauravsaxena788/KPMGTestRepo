global class BatchUpdateMPOpp implements Database.Batchable<SObject>{
             
    String recId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
   
    List<Opportunity> OppToUpdate = new List<Opportunity>();
    Date prevDay = System.today();
        
    global Database.QueryLocator start(Database.BatchableContext BC){
  
        String query = 'Select Id, Name, StageName, CloseDate, RecordTypeId From Opportunity Where RecordTypeId=:recId And CloseDate<=:prevDay And StageName = \'Open\' AND (Account.RecordType.DeveloperName=\'VCPL_Primary_Account\' OR Account.RecordType.DeveloperName=\'VCPL_Industrial_Distributor\' OR Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer\' OR Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer_Branch\')';
        return Database.getQueryLocator(query);
    }
    
    // execute method
     
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
      
        for(Opportunity Opp : scope)
        {  
           Opp.StageName = 'Closed';
           OppToUpdate.add(Opp);           
        }
        
        update OppToUpdate;
     }
    
    // finish method
    
    global void finish(Database.BatchableContext BC){
    
      AsyncApexJob a = [SELECT Id,Status,JobType,NumberOfErrors,JobItemsProcessed,TotalJobItems,CompletedDate,ExtendedStatus
          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        system.debug('BC.getJobId()------------->'+BC.getJobId());
        system.debug('a------------->'+a);
          
      List<User> userList = new List<User>();
         userList = [SELECT Id,Email,IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = True] ;
          
       // Send an email to all active Admins notifying of job completion.
           
        List<String> toAddresses = new List<String>();
        for(User u : userList)
        {           
           toAddresses.add(u.Email);
        }  
        
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setToAddresses(toAddresses);
           //mail.setTargetObjectId(u.Id);
           mail.setSubject('Updating Monthly Plan Opportunity Batch - ' + a.Status);
           mail.setSaveAsActivity(false);
           mail.setPlainTextBody
           ('The batch Apex job completed on  ' + a.CompletedDate + ',\n\n' +
           'Job Status : ' + a.Status + '\n'+
           'Total Job Items processed : ' + a.TotalJobItems + '\n'+
           'Number of Job Items processed : ' + a.JobItemsProcessed + '\n' +
           'Number of Failures : '+ a.NumberOfErrors);
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }          
    
    
     // schedule method  
     /*
       global void execute(SchedulableContext sc){
    
        BatchUpdateMPOpp batch = new BatchUpdateMPOpp ();
        String cronStr = '0 0 0 8 * ? *';
        System.schedule('BatchUpdateMPOpp', cronStr, batch);
        Database.executebatch(batch);
    }*/
    
}