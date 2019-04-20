@isTest
public class TestscheduledBatchableOpportunityTeam {
 public static testmethod void test()
 {
     Test.startTest();
     scheduledBatchableOpportunityTeam obj = new scheduledBatchableOpportunityTeam();
     obj.execute(null);
     DataBase.executeBatch(new BatchClassToUpdateOpportunityTeam());
     
     Test.stopTest();
 }
}