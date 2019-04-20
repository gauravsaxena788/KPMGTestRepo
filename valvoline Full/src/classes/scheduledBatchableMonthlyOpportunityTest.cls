@isTest
public class scheduledBatchableMonthlyOpportunityTest {
    
    public static testmethod void test1()
    {
    
    
     Test.startTest();
     
     scheduledBatchableMonthlyOpportunity obj = new scheduledBatchableMonthlyOpportunity();
     obj.execute(null);
         
     DataBase.executeBatch(new BatchClassforMonthlyOpportunity());
     Test.stopTest();
    }
}