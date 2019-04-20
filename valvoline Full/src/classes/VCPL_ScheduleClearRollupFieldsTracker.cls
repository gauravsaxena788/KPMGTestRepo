@isTest(seeAllData=false)
public class VCPL_ScheduleClearRollupFieldsTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleClearRollupFieldsBatch testSch = new VCPL_ScheduleClearRollupFieldsBatch();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}