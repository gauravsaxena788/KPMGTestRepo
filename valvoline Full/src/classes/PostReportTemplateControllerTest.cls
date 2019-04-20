@isTest
private class PostReportTemplateControllerTest
{
    @testSetup
    private static void setupTestData(){
        
    }
    private static testMethod void AUDEFTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
            objAccount.VA_POST_Allowed__c = 'Yes';
            objAccount.ownerId= objCreditUser.id;
            insert objAccount ;
            
            Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
            objContact.ownerId= objCreditUser.id;
            insert objContact;
            
            
            VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('AU32/DEF');
            insert objProductCategory ;
            
           
            case objCase = VA_utilClass.createPostTestCase();
            //Id recTypeIdof = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sample Test Request').getRecordTypeId();
            //objCase.RecordTypeId  = recTypeIdof;
            objCase.ContactId = objContact.Id;
            objCase.AccountId = objAccount .Id;
            objCase.OwnerId = objCreditUser.id;
            objCase.Product_Category__c = objProductCategory.id;
            insert objCase;
            objCase.OwnerId = objCreditUser.id;
            update objCase;          
            
            VA_TestResult__c objtestResult = new VA_TestResult__c ();
            Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_AU32_DEF').getRecordTypeId(); 
            objtestResult.Case__c = objCase.id;
            objtestResult.RecordTypeId  = recTypeId ;
            insert objtestResult ;
            
            
            system.runAs(objCreditUser){
                
                
                objCase.status = 'Under Test';
                update objCase;
            
            }
            
            system.runAs(objCreditUser)
            {
                objCase.status = 'Report Issued By Lab';
                update objCase;
            }
            
            /*system.runAs(objCreditUser)
            {
                Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
                System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
                objCase.status = 'Final Report Released';
                //update objCase;
            }*/
        
        test.startTest();
            
           
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();

        test.stopTest();
    }
    private static testMethod void Coolant_AutoCoolantTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Coolant – Auto Coolant');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Coolant_Auto_Coolant').getRecordTypeId(); 
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        
        test.startTest();
              
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
           /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();

        test.stopTest();

        
    }
    private static testMethod void EngineOilDEOTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Engine Oil DEO');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Engine_Oil_DEO').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    private static testMethod void EngineOilGEOTest() {
        
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Engine Oil GEO');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Engine_Oil_GEO').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();


       
    }
    private static testMethod void EngineOilMCOTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Engine Oil MCO');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Engine_Oil_MCO').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    private static testMethod void EngineOilPCMOTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Engine Oil PCMO');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Engine_Oil_PCMO').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();
    
    
        test.stopTest();
    }
    private static testMethod void Gear_AxleOilTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Gear & Axle Oil');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Gear_Axle_Oil').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    private static testMethod void GreaseTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Grease');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Grease').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    private static testMethod void HydraulicOilTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Hydraulic Oil');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Hydraulic_Oil').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    private static testMethod void IndustrialOil_Cutting_EmulsionTypeTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Industrial Oil – Cutting – Emulsion Type');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c ();
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Industrial_Oil_Cutting_Emulsion_Type').getRecordTypeId(); 
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();
    
    
        test.stopTest();
    }
    private static testMethod void IndustrialOil_Cutting_NeatTypeTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Industrial Oil – Cutting – Neat Type');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
        objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Industrial_Oil_Cutting_Neat_Type').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    private static testMethod void IndustrialOthersTest() {
    
        map<string,User> mapProfileNameToUser = new map<string,User>();
        mapProfileNameToUser = VA_utilClass.createUser();
        User objCreditUser = mapProfileNameToUser.get('Lab Admin'); 
        system.debug('@@objCreditUser@@' + objCreditUser);
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.VA_POST_Allowed__c = 'Yes';
        objAccount.ownerId= objCreditUser.id;
        insert objAccount ;
        
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        objContact.ownerId= objCreditUser.id;
        insert objContact;
        
        VA_Product_Category__c objProductCategory = VA_utilClass.createproductCategory('Industrial Others');
        insert objProductCategory ;
        system.debug('@@@'+objProductCategory);
        
        case objCase = VA_utilClass.createPostTestCase();
       objCase.ContactId = objContact.Id;
        objCase.AccountId = objAccount .Id;
        objCase.OwnerId = objCreditUser.id;
        objCase.Product_Category__c = objProductCategory.id;
        insert objCase;
        objCase.OwnerId = objCreditUser.id;
        update objCase;
        
        VA_TestResult__c objtestResult = new VA_TestResult__c (); 
        Id recTypeId = Schema.SObjectType.VA_TestResult__c.getRecordTypeInfosByDeveloperName().get('VA_Industrial_Others').getRecordTypeId();
        objtestResult.Case__c = objCase.id;
        objtestResult.RecordTypeId  = recTypeId ;
        insert objtestResult ;
        
        
        system.runAs(objCreditUser){   
            objCase.status = 'Under Test';
            update objCase;
        
        }
            
        system.runAs(objCreditUser)
        {
            objCase.status = 'Report Issued By Lab';
            update objCase;
        }
        
        /*system.runAs(objCreditUser)
        {
            Case queryCase = [SELECT id,RecordType.Name ,Ownerid FROM Case WHERE id=:objCase.Id];
            System.debug('====queryCase =='+queryCase.Ownerid +'=====objCreditUser=='+objCreditUser.id+'======queryCase.RecordType.Name==='+queryCase.RecordType.Name);
            objCase.status = 'Final Report Released';
            //update objCase;
        }*/
        
        test.startTest();
            system.debug('@@objtestResult'+objtestResult);
            PageReference pageRef = Page.VA_PostTestReport;
            ApexPages.StandardController sc = new ApexPages.standardController(objtestResult);
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',objtestResult.case__c);
            
            PostReportTemplateController  controller = new PostReportTemplateController(sc);
            controller.flag= true;
            /*controller.PostReportTemplateRedirectPage();
            system.runAs(objCreditUser)
            {
                objCase.Product_Category__c = objProductCategory.id;
                update objCase;
            }*/
            controller.PostReportTemplateRedirectPage();


        test.stopTest();
    }
    
}