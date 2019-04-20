@IsTest 
public class VA_ChatterPostTest{ 
@testSetup
    private static void datasetup(){
        Group testGroup = new Group(Name='Dispatch/WH Team', type='Queue');
        insert testGroup;
        QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Case');
        insert testQueue;
    }
    testMethod static void chatterPostTestMethod(){  
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        List<Id> lstId = new List<Id>();
        
        
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        Network objNetwork = [SELECT Id,name FROM Network where name like '%Customer%'];
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        
        FeedItem objpost = new FeedItem();
        objpost.ParentId = user.id;
        objpost.Body = 'Bell Notification-' ;
        objpost.Title =  'Bell Notification'  ;
        objpost.NetworkScope = objNetwork.id;
        insert objpost;
        
        Test.startTest();
            system.runAs(user){
                Order objOrder = VA_utilClass.createOrder(objAccount.id);
                objOrder.status = 'Draft';
                insert objOrder;
                lstId.add(objOrder.id);
                VA_ChatterPost.postFeed(lstId);
            }

        Test.stoptest();
    
    }
      testMethod static void chatterPostTestMethod1(){
        Account objAccount = new Account(Name='testpost',Is_Parent__c='Y',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North', Sold_to_code__c = '123456', Ship_to_Code__c= '123457', VA_OTC_Executive_Mail_Id__c = 'test@example.com', Payment_Term__c = 'cash');
        insert objAccount ;
        
        Account objAccountPost = VA_utilClass.createAccount();
        objAccountPost.ParentId = objAccount.id;
        objAccountPost.VA_POST_Allowed__c = 'Yes';
        
        insert objAccountPost;
        Contact objContact = VA_utilClass.createContact (objAccountPost.id);
        insert objContact;
        List<Id> lstId = new List<Id>();
        
        
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        Network objNetwork = [SELECT Id,name FROM Network where name like '%Customer%'];
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        
        FeedItem objpost = new FeedItem();
        objpost.ParentId = user.id;
        objpost.Body = 'Bell Notification-' ;
        objpost.Title =  'Bell Notification'  ;
        objpost.NetworkScope = objNetwork.id;
        insert objpost;
        
        Test.startTest();
            system.runAs(user){
                
                case objCase =  VA_utilClass.createPostTestCase();
                objCase.ContactId = objContact.Id;
                objCase.AccountId = objAccountPost.Id;
                insert objCase;
                lstId.add(objCase.id);
                system.debug('@@lstId'+lstId);
                VA_ChatterPost.postFeed(lstId);
            }

        Test.stoptest();
    
    }
    
      testMethod static void chatterPostTestMethod2(){  
        String chatterGroupName;
        Group testGroup = [select id, name,type from Group limit 1];
        system.debug('@@testGroup '+testGroup );
        
        QueuesObject objQueue = [select QueueID , SobjectType from QueuesObject limit 1];
          system.debug('@@objQueue '+objQueue );
          
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        List<Id> lstId = new List<Id>();
        
        
        
        Id profileId = [select id from profile where name='Customer Community User Login'].id;
        Network objNetwork = [SELECT Id,name FROM Network where name like '%Customer%'];
        User User = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = profileId , country='United States',IsActive =true,
                ContactId = objContact.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        system.debug(user.id);
        
        
        FeedItem objpost = new FeedItem();
        objpost.ParentId = user.id;
        objpost.Body = 'Bell Notification-' ;
        objpost.Title =  'Bell Notification'  ;
        objpost.NetworkScope = objNetwork.id;
        insert objpost;
        
        
        Test.startTest();
            system.runAs(user){
                
                Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('VA_CCMS').getRecordTypeId();
                case objCase = new case(Batch_No__c= '123',recordtypeid=caseRecordTypeId,VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=true, OwnerId = objQueue.QueueID);
                insert objCase;
                system.debug('@@objCase'+objCase);
                system.debug(objcase.owner.name);
                //chatterGroupName ='Dispatch/WH Team';
                System.debug([SELECT Owner.Name FROM Case WHERE Id = : objCase.id].Owner.Name);
                lstId.add(objCase.id);
                system.debug('@@lstId'+lstId);
                VA_ChatterPost.postFeed(lstId);
            }

        Test.stoptest();

      }
    
    
 }