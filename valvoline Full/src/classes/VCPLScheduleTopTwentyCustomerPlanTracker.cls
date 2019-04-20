@isTest
public class VCPLScheduleTopTwentyCustomerPlanTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPLScheduleTopTwentyCustomerPlan testSch = new VCPLScheduleTopTwentyCustomerPlan();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}