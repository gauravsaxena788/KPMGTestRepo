@isTest(seeAllData=false)
public class VCPL_ScheduleAccountPotentialTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleAccountPotentialBatch testSch = new VCPL_ScheduleAccountPotentialBatch();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}