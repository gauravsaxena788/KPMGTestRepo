@IsTest 
public class VA_CommunityComplaintControllerTest{ 

@testSetup
    static void setupTestData(){
    
        Account objAccount = new Account(Name='jain',Is_Parent__c='N',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North');
        insert objAccount;
    
        Contact objContact = new Contact(LastName='jain',AccountId=objAccount.Id);
        insert objContact;
        
        Id caseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('VA_CCMS').getRecordTypeId();
        case objCase = new case(Batch_No__c= '123',recordTypeid= caseRecordTypeId ,VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false);
        insert objCase;
        
        }
        
        
        testMethod static void CommunityComplaintControllerMethod(){  
        case objCase = [select id,caseNumber,VA_Assign_to_Owner__c,VA_Date_of_complaint_accepted__c from Case Limit 1];
        Id profileId=userinfo.getProfileId();
        VA_CommunityComplaintController.wrapperClass wrapper = new VA_CommunityComplaintController.wrapperClass();
        VA_CommunityComplaintController.initMethod(objCase.Id,profileId);
        
       }
       
       
       }