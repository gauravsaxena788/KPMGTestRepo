// scheduler test method

@isTest

class ScheduleBatchUpdateMPOppTest{
    
    public static testMethod void testSchedule()
    {
        Test.StartTest();
        ScheduleBatchUpdateMPOpp testSch = new ScheduleBatchUpdateMPOpp();
        String testExp =  '0 0 0 8 * ? *';
        system.schedule('Test Status Schedule Class',testExp,testSch);
        Test.StopTest();
    }
}