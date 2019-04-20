public class scheduledBatchableMonthlyOpportunity implements Schedulable
{
     public void execute(SchedulableContext sc) 
     {
        Database.executeBatch(new BatchClassforMonthlyOpportunity()) ;
     }
}