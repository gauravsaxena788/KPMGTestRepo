@isTest
public class VCPL_ScheduleCreateMonlyOpportTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleCreateMonlyOpportunityBatch testSch = new VCPL_ScheduleCreateMonlyOpportunityBatch();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}