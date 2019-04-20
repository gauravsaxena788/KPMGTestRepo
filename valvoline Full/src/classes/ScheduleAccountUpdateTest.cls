// scheduler test method

@isTest

class ScheduleAccountUpdateTest{
    
    public static testMethod void testSchedule()
    {
        Test.StartTest();
        ScheduleAccountUpdate testSch = new ScheduleAccountUpdate();
        String testExp = '0 1 0 1 10 ? *';
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}