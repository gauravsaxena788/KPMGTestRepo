@IsTest 
public class VA_updateConsentforAccountStatementTest{ 
@testSetup
    private static void datasetup(){
        VA_utilClass.triggeronoff();
    }
    testMethod static void updateConsentTestMethod(){  
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        VA_AccountStatement__c objAccountStatement = VA_utilClass.createAccountstatement(objAccount.id); 
         
        insert objAccountStatement;
        Test.startTest();
            objAccount.VA_POST_Allowed__c = 'Yes' ;
            update objAccount ;
            VA_updateConsentforAccountStatement.wrapperClass wrapper = new VA_updateConsentforAccountStatement.wrapperClass();
            
            VA_updateConsentforAccountStatement.updateCheck(objAccountStatement.Id);
        test.stopTest();
    }
    
    testMethod static void updateConsentTestMethod1(){  
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        VA_AccountStatement__c objAccountStatement = VA_utilClass.createAccountstatement(objAccount.id); 
        objAccountStatement.VA_Account__c = objAccount.Id;  
        insert objAccountStatement;
        
        Test.starttest();
            VA_updateConsentforAccountStatement.wrapperClass wrapper = new VA_updateConsentforAccountStatement.wrapperClass();
            
            VA_updateConsentforAccountStatement.updateCheck(objAccount.Id);
        test.stopTest();
    }
    
    
    
    
 }