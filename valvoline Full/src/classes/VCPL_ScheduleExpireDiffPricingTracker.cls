@isTest
public class VCPL_ScheduleExpireDiffPricingTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleExpireDiffPricingBatch testSch = new VCPL_ScheduleExpireDiffPricingBatch();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}