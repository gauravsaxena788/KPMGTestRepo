@istest
public class VA_AccountStatementControllerTest{

@testSetup
    static void setupTestData(){
        
    
    }
    public static testmethod void AccountStatementControllermethod(){
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Account objAcc = [SELECT SFDC_Account_ID__c FROM Account WHERE ID=:objAccount.id];
        VA_AccountStatement__c objAccountStatement = VA_utilClass.createAccountstatement(objAccount.Id);
        objAccountStatement.VA_SFDC_Account_Id__c = objAcc.SFDC_Account_ID__c ;
        insert objAccountStatement ;
        
        ContentVersion objContentVersion =  VA_utilClass.createContentVersion();
        
        insert objContentVersion ;
        
        ContentDocumentLink objContentDocumentLink = VA_utilClass.createContentDocumentLink(objContentVersion.id, objAccountStatement.id);
       
        
        
        
      
        test.startTest();
         system.debug('=====Method 1==');
        List<VA_AccountStatementController.StatementRequestWrapper> lstwrapper = new List<VA_AccountStatementController.StatementRequestWrapper>();
        VA_AccountStatementController.statementrequest request = new VA_AccountStatementController.statementrequest();
        VA_AccountStatementController.StatementRequestWrapper wrapper = new VA_AccountStatementController.StatementRequestWrapper();
        VA_AccountStatement__c objAccountStatement1 = VA_utilClass.createAccountstatement(objAccount.Id);
        objAccountStatement.VA_SFDC_Account_Id__c = objAcc.SFDC_Account_ID__c ;
        
        wrapper.accountStatement =  objAccountStatement1;
        
        
        insert objContentDocumentLink ;
        
        wrapper.statementImage = 'test';
        lstwrapper.add(wrapper);
        
        request.statementDataList = lstwrapper; 
        system.debug(request.statementDataList);
        VA_AccountStatementController.saveStatementImage(request);
        
        
        test.stopTest();
    }
    
    public static testmethod void AccountStatementControllermethod1(){
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        Account objAcc = [SELECT SFDC_Account_ID__c FROM Account WHERE ID=:objAccount.id];
        
        Map<String,Id> accountMap = new Map<String,Id>();
        accountMap.put(objAcc.SFDC_Account_ID__c ,objAcc.id);
        system.debug('@@accountMap'+accountMap);
        
        VA_AccountStatement__c  objAccountStatement = new VA_AccountStatement__c ();
        Id recTypeId = Schema.SObjectType.VA_AccountStatement__c.getRecordTypeInfosByDeveloperName().get('Half_Yearly').getRecordTypeId();
        objAccountStatement.name = 'April-2018';
        objAccountStatement.recordTypeId = recTypeId ;
        objAccountStatement.VA_Year__c = '2018';
        objAccountStatement.VA_Month__c= 'January';
        Date dat = System.Today();
        string objdate = dat.format();    
        objAccountStatement.VA_SFDC_Account_Id__c = objAcc.SFDC_Account_ID__c ;
        objAccountStatement.VA_From_Date__c =  System.Today().addYears(-1);
        objAccountStatement.VA_To_Date__c = System.Today();
        system.debug('todate'+objAccountStatement.VA_To_Date__c);
        objAccountStatement.VA_Frequency__c = 'Monthly';
        objAccountStatement.VA_Account__c = accountMap.get(objAcc.SFDC_Account_ID__c );
        objAccountStatement.VA_Ship_To_Code__c = '123456';
        //insert objAccountStatement ;
        

        test.startTest();
        system.debug('=====Method 2==');
        List<VA_AccountStatementController.StatementRequestWrapper> lstwrapper = new List<VA_AccountStatementController.StatementRequestWrapper>();
        VA_AccountStatementController.statementrequest request = new VA_AccountStatementController.statementrequest();
        VA_AccountStatementController.StatementRequestWrapper wrapper = new VA_AccountStatementController.StatementRequestWrapper();
        wrapper.accountStatement =  objAccountStatement;
        wrapper.statementImage = 'test';
        lstwrapper.add(wrapper);
        
        request.statementDataList = lstwrapper; 
        system.debug(request.statementDataList);
        VA_AccountStatementController.saveStatementImage(request);
        
        
       
        test.stopTest();
    }
    
     public static testmethod void AccountStatementControllermethod2(){
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.Is_Parent__c = 'Y';
        insert objAccount ;
        Account objAcc = [SELECT SFDC_Account_ID__c FROM Account WHERE ID=:objAccount.id];
        Map<String,Id> accountMap = new Map<String,Id>();
        accountMap.put(objAcc.SFDC_Account_ID__c ,objAcc.id);
        Id accountId = accountMap.put(objAcc.SFDC_Account_ID__c ,objAcc.id);
        system.debug('@@accountMap'+accountMap);
        
        Id recTypeId = Schema.SObjectType.VA_AccountStatement__c.getRecordTypeInfosByDeveloperName().get('Half_Yearly').getRecordTypeId();
        
        VA_AccountStatement__c  objAccountStatement = new VA_AccountStatement__c (name = 'April-2018', recordTypeId = recTypeId , VA_Year__c = '2018', VA_Month__c= 'January', VA_From_Date__c =  System.Today(), VA_To_Date__c = System.Today().addYears(3), VA_Frequency__c = 'Monthly', VA_Account__c = accountId  , VA_SFDC_Account_Id__c = objAcc.SFDC_Account_ID__c, VA_Ship_To_Code__c = '123456');
        
       

        test.startTest();
         system.debug('=====Method 3==');
        List<VA_AccountStatementController.StatementRequestWrapper> lstwrapper = new List<VA_AccountStatementController.StatementRequestWrapper>();
        VA_AccountStatementController.statementrequest request = new VA_AccountStatementController.statementrequest();
        VA_AccountStatementController.StatementRequestWrapper wrapper = new VA_AccountStatementController.StatementRequestWrapper();
        wrapper.accountStatement =  objAccountStatement;
        system.debug('objAccountStatement'+objAccountStatement.id);
        system.debug('@@accountStatement'+wrapper.accountStatement);
        
        wrapper.statementImage = 'test';
        lstwrapper.add(wrapper);
        
        request.statementDataList = lstwrapper; 
        system.debug(request.statementDataList);
        VA_AccountStatementController.saveStatementImage(request);
        
        
        test.stopTest();
    }
       public static testmethod void AccountStatementControllermethod3(){
        
          Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        Account objAcc = [SELECT SFDC_Account_ID__c FROM Account WHERE ID=:objAccount.id];
        
        Map<String,Id> accountMap = new Map<String,Id>();
        accountMap.put(objAcc.SFDC_Account_ID__c ,objAcc.id);
        system.debug('@@accountMap'+accountMap);
        
        VA_AccountStatement__c  objAccountStatement = new VA_AccountStatement__c ();
        Id recTypeId = Schema.SObjectType.VA_AccountStatement__c.getRecordTypeInfosByDeveloperName().get('Half_Yearly').getRecordTypeId();
        objAccountStatement.name = 'April-2018';
        objAccountStatement.recordTypeId = recTypeId ;
        objAccountStatement.VA_Year__c = '2018';
        objAccountStatement.VA_Month__c= 'January';
        Date dat = System.Today();
        string objdate = dat.format();    
        objAccountStatement.VA_SFDC_Account_Id__c = objAcc.SFDC_Account_ID__c ;
        objAccountStatement.VA_From_Date__c =  System.Today();
        objAccountStatement.VA_To_Date__c = System.Today().addYears(1);
        system.debug('todate'+objAccountStatement.VA_To_Date__c);
        objAccountStatement.VA_Frequency__c = 'Monthly';
        objAccountStatement.VA_Account__c = accountMap.get(objAcc.SFDC_Account_ID__c );
        objAccountStatement.VA_Ship_To_Code__c = '123456';
        //insert objAccountStatement ;
        

        test.startTest();
        system.debug('=====Method 2==');
        List<VA_AccountStatementController.StatementRequestWrapper> lstwrapper = new List<VA_AccountStatementController.StatementRequestWrapper>();
        VA_AccountStatementController.statementrequest request = new VA_AccountStatementController.statementrequest();
        VA_AccountStatementController.StatementRequestWrapper wrapper = new VA_AccountStatementController.StatementRequestWrapper();
        wrapper.accountStatement =  objAccountStatement;
        wrapper.statementImage = 'test';
        lstwrapper.add(wrapper);
        
        request.statementDataList = lstwrapper; 
        system.debug(request.statementDataList);
        VA_AccountStatementController.saveStatementImage(request);
        
        
        
        test.stopTest();
    }
   
}