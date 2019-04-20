@isTest
public class VCPL_ScheduleSendNotifiOnNegativeTracker {
	public static testMethod void testSchedule()
    {
        Test.StartTest();
        VCPL_ScheduleSendNotifiOnNegativeDP testSch = new VCPL_ScheduleSendNotifiOnNegativeDP();
        String testExp = '0 1 0 1 10 ? *'; 
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}