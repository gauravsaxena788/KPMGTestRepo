global class VCPL_ScheduleLeadSyncToCDOSBatch implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
        VCPL_LeadSyncToCDOSBatch obj = new VCPL_LeadSyncToCDOSBatch();
        Database.executeBatch(obj);
    }    
}