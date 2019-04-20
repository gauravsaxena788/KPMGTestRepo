@isTest
public class VCPL_ScheduleLeadSyncToCDOSTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleLeadSyncToCDOSBatch testSch = new VCPL_ScheduleLeadSyncToCDOSBatch();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}