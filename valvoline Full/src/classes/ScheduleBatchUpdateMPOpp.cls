global class ScheduleBatchUpdateMPOpp implements Schedulable {

    // This test runs a scheduled job on 8th day of every month
   
    global void execute(SchedulableContext SC) {
      BatchUpdateMPOpp UpdateMPOpp = new BatchUpdateMPOpp ();
      
      //Parameters of BatchUpdateMPOpp (context,BatchSize[optional])
      database.executebatch(UpdateMPOpp);
     
    }
}