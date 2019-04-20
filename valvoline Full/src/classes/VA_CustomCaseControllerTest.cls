@IsTest(isParallel=false)
public class VA_CustomCaseControllerTest{ 

@testSetup
    static void setupTestData(){
    
        Account objAccount = new Account(Name='jain',Is_Parent__c='N',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North');
        insert objAccount;
    
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        insert objContact;
        
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('VA_CCMS').getRecordTypeId();
        case objCase = new case(Batch_No__c= '123',recordtypeid=caseRecordTypeId,VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false);
        insert objCase;
        
        
        }
        
        
        testMethod static void CustomCaseControllerMethod(){  
        Test.Starttest();
        case objCase = [select id,caseNumber,VA_Assign_to_Owner__c from Case Limit 1 for update];
        Id profileId=userinfo.getProfileId();
        VA_CustomCaseController.wrapperClass wrapper = new VA_CustomCaseController.wrapperClass();
        String Status = wrapper.Status;
        VA_CustomCaseController.initMethod(objCase.Id,profileId);
        Test.stopTest();
       }
       
       
       }