@IsTest 
public class VA_ShowListViewControllerTest {

    @testSetup
    static void setupTestData(){
    
        Account objAccount =  VA_utilClass.createAccount();
        insert objAccount;
        
        Account objAccountPost = new Account(VA_POST_Allowed__c = 'Yes',Name='testPost',Is_Parent__c='N',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North', Sold_to_code__c = '123456', Ship_to_Code__c= '123457', VA_OTC_Executive_Mail_Id__c = 'test@example.com', Payment_Term__c = 'cash');
        insert objAccountPost;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        Contact objContactPost= new Contact(AccountId = objAccountPost.id, LastName = 'Test contact Post',Email = 'Test@rkl.com',Contact_Record_Type__c = 'Decision Maker');
        insert objContactPost ;
        
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('VA_CCMS').getRecordTypeId();
        case objCase = new case(VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false,recordTypeId=caseRecordTypeId,Batch_No__c='Test');    
        insert objCase;
        
        Id casePostKitRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('VA_Post_kit').getRecordTypeId();
        case objPostKitCase = new case(VA_No_Of_Bottles_Requested__c = 5,VA_Request_Purpose__c='Others',ContactId=objContactPost.Id,AccountId=objAccountPost.Id,VA_Reason__c='Bottle Not Received',recordTypeId=casePostKitRecordTypeId,Status='New',VA_Additional_Comments__c = 'Test');      
        insert objPostKitCase;
        
       /* Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('VA_CCMS').getRecordTypeId();
        case objCase = new case(VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false,recordTypeId=caseRecordTypeId,Batch_No__c='Test');    
        insert objCase;*/    
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);    
        insert objOrder;
        
        Opportunity objOpportunity = VA_utilClass.createOpportunity (objAccount.id, objOrder.id);
        insert objOpportunity;
        
        VA_Invoice__c objInvoice = VA_utilClass.createInvoice (objOpportunity.id, objOrder.id);  
        insert objInvoice;

        }
    
      testMethod static void listViewForOrderMethod(){  
        Test.Starttest();
        Order objOrder = [select id from Order Limit 1]; 
        Decimal pageNumber = 5;
        Decimal pageSize =5;
        string strFieldListName = 'Id';  
        string strObjectApI = 'Order';
        string parentId = userInfo.getUserId();
        string filterName = 'order';  
        VA_ShowListViewController.DataTableWrapper wrapper = new VA_ShowListViewController.DataTableWrapper();
        VA_ShowListViewController.getCaseList(pageNumber,pageSize,objOrder.Id,strFieldListName,strObjectApI,parentId,filterName,'');   
        VA_ShowListViewController.getCaseList(pageNumber,pageSize,objOrder.Id,strFieldListName,strObjectApI,parentId,filterName,'child');   
        Test.stopTest();
       }
    
    
    testMethod static void listViewForCCMSCaseMethod(){  
        Test.Starttest();
        Account objAccount = [select id from Account LIMIT 1];
        case objCase = [select id,caseNumber,VA_Assign_to_Owner__c from Case where recordType.developerName='VA_CCMS'];
        Decimal pageNumber = 5;
        Decimal pageSize =5;
        string strFieldListName = 'Id';
        string strObjectApI = 'Case';
        string parentId = userInfo.getUserId();   
        string filterName = 'ccms';
        VA_ShowListViewController.DataTableWrapper wrapper = new VA_ShowListViewController.DataTableWrapper();
        VA_ShowListViewController.getCaseList(pageNumber,pageSize,objCase.Id,strFieldListName,strObjectApI,parentId,filterName,'');  
        VA_ShowListViewController.getAccountUser(objAccount.Id);  
        Test.stopTest();
       }
    
    testMethod static void listViewForPostKitCaseMethod(){  
        Test.Starttest();
        Account objAccount = [select id from Account LIMIT 1];
        case objCase = [select id from Case where recordType.developerName='VA_Post_kit'];
        Decimal pageNumber = 5;
        Decimal pageSize =5;
        string strFieldListName = 'Id';
        string strObjectApI = 'Case';
        string parentId = userInfo.getUserId();   
        string filterName = 'post';  
        VA_ShowListViewController.DataTableWrapper wrapper = new VA_ShowListViewController.DataTableWrapper();
        VA_ShowListViewController.getCaseList(pageNumber,pageSize,objCase.Id,strFieldListName,strObjectApI,parentId,filterName,'');  
        VA_ShowListViewController.getAccountUser(objAccount.Id);  
        Test.stopTest();
       }
    
    testMethod static void listViewForInvoiceMethod(){  
        Test.Starttest();
        VA_Invoice__c objInvoice =  [select id from VA_Invoice__c Limit 1]; 
        Decimal pageNumber = 5;
        Decimal pageSize =5;
        string strFieldListName = 'Id';    
        string strObjectApI = 'VA_Invoice__c';
        string parentId = userInfo.getUserId();     
        string filterName = 'invoice';    
        VA_ShowListViewController.DataTableWrapper wrapper = new VA_ShowListViewController.DataTableWrapper();
        VA_ShowListViewController.getCaseList(pageNumber,pageSize,objInvoice.Id,strFieldListName,strObjectApI,parentId,filterName,'');   
        Test.stopTest();
       }
}