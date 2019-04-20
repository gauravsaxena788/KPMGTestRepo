@isTest
public class VCPL_ScheduleCustomerPlanTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleCustomerPlanBatch testSch = new VCPL_ScheduleCustomerPlanBatch();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}