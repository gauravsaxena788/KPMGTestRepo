public class scheduledBatchableOpportunityTeam implements Schedulable
{
     public void execute(SchedulableContext sc) 
     {
        Database.executeBatch(new BatchClassToUpdateOpportunityTeam()) ;
     }
}