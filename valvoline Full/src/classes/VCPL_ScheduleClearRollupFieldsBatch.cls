global class VCPL_ScheduleClearRollupFieldsBatch implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        VCPL_ClearRollUpFieldBatch obj = new VCPL_ClearRollUpFieldBatch();
        Database.executeBatch(obj);
    }    
}