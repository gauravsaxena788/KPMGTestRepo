global class VCPL_ScheduleExpireDiffPricingBatch implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        VCPL_ExpireDifferentialPricingBatch obj = new VCPL_ExpireDifferentialPricingBatch();
        Database.executeBatch(obj);
    }    
}