global class ScheduleAccountUpdate implements Schedulable {
  
  // This test runs a scheduled job on every 1 Oct
  
    global void execute(SchedulableContext SC) {
      BatchAccountUpdate batchAccount = new BatchAccountUpdate();
      database.executebatch(batchAccount);
    }
    global void accountUpdateJob(){
        ScheduleAccountUpdate sc = new ScheduleAccountUpdate();
        system.schedule('AccountUpdateJob', '0 0 0 1 10 ?', sc);
     }
}