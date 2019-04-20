//Batch Test Method

@isTest

public class BatchAccountUpdateTest{
    
     static testMethod void testBatchMethod() 
    {
        List<Account> accountListin = new List<Account>();
        List<Account> accountListup = new List<Account>();
        
        for(Integer i=0 ;i<200;i++)
        {
            Account acc = new Account();
            acc.Name = 'testAccount'+i;
            acc.BU_Name__c = 'C&I';
            acc.Market_Segment__c = 'Cement';
            acc.Indutry_Segment__c = 'Industrial';
            acc.Account_Type__c = 'Cummins Dealer';
            acc.Account_Tenure__c=1.0;
            acc.Category__c = 'New';
            acc.Is_Parent__c = 'Y';
            acc.Zone__c = 'North';
            accountListin.add(acc);
            
        }
        insert accountListin;
        for(Account ac : accountListin)
        {
            for(Integer j=0;j<200;j++)
            {
                if(ac.Category__c == 'New' && ac.YTD_Volume__c >5)
                {ac.Category__c = 'Recent';}
                else
                {ac.Category__c = 'Existing';} 
                
            }
            accountListup.add(ac);
            
        }
         update accountListup;
                
     // start test
        
        Test.startTest();

            BatchAccountUpdate batchUpdate = new BatchAccountUpdate();
            DataBase.executeBatch(batchUpdate);
                   
        Test.stopTest();
    }
}