public class VCPL_ScheduleCustomerPlanBatch implements Schedulable
{
    public void execute(SchedulableContext sc) 
    {
    	Database.executeBatch(new VCPL_CustomerPlanBatch()) ;
    }
}