global class VCPL_ScheduleCreateMonlyOpportunityBatch implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        VCPL_CreateMonthlyOpportunityBatch obj = new VCPL_CreateMonthlyOpportunityBatch();
        Database.executeBatch(obj);
    }    
}