global class VCPLScheduleTopTwentyCustomerPlan implements Schedulable {	
    global void execute(SchedulableContext sc)
    {
        BatchForCreateTopTwentyCustomerPlan obj = new BatchForCreateTopTwentyCustomerPlan();
        Database.executeBatch(obj,2);
    }  
}