global class VCPL_ScheduleAccountPotentialBatch implements Schedulable
{
	global void execute(SchedulableContext sc)
	{
		VCPL_AccountPotentialBatch obj = new VCPL_AccountPotentialBatch();
		Database.executeBatch(obj);
	} 
}