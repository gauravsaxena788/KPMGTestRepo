global class BatchAccountUpdate implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
          String query ='SELECT Id,Name,Account_Tenure__c,Status__c,Category__c,YTD_Volume__c, ANNUAL_PLAN_AUS__c, ANNUAL_PLAN_LUBES__c FROM Account WHERE Category__c != null AND (RecordType.DeveloperName=\'VCPL_Primary_Account\' OR RecordType.DeveloperName=\'VCPL_Industrial_Distributor\' OR RecordType.DeveloperName=\'VCPL_Cummins_Dealer\' OR RecordType.DeveloperName=\'VCPL_Cummins_Dealer_Branch\')';
          return Database.getQueryLocator(query);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<Account>scope){
       List<Account> accsToUpdate = new List<Account>();

                for(Account a :scope){
                    if(a.Status__c=='Activated'){
                      if(a.Category__c == 'New' && a.YTD_Volume__c > 5){
                         a.Category__c = 'Recent';
                      }
                      else if(a.Category__c == 'Recent')
                      {    
                         a.Category__c = 'Existing';
                      }
                      a.Account_Tenure__c = a.Account_Tenure__c + 1;
                      /*------------------ Added by JD on 21 Aug - 
                      to set planned aus/lubes values as 0 for monthly plans refering in AccountMonthlyPlan vf page
                      ------------------------------------ */ 
                      a.ANNUAL_PLAN_AUS__c = 0.0;        
                      a.ANNUAL_PLAN_LUBES__c = 0.0; 
                      //---------End of changes by JD on 21 Aug ------------------------------------     
                      accsToUpdate.add(a);
                    }
                }
            update accsToUpdate;
       }
       
     // finish method
     
       global void finish(Database.BatchableContext BC){
    
         AsyncApexJob a = [SELECT Id,Status,JobType,NumberOfErrors,JobItemsProcessed,TotalJobItems,CompletedDate,ExtendedStatus
          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
         
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
               mail.setSubject('Yearly Account Update Batch - ' + a.Status);
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
    
        BatchAccountUpdate batch = new BatchAccountUpdate ();
        String cronStr = '0 0 1 1 10 ? ?';
        System.schedule('UpdateAccountCategory', cronStr, batch);
        Database.executebatch(batch);
    }*/
}