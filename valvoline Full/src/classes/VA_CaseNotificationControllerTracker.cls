@isTest(seeAllData = false)
public class VA_CaseNotificationControllerTracker 
{
	public static testmethod void unitTest1()
    {
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objContact = VA_utilClass.createContact (objAccount.id);
        insert objContact;
        
        Id caseRecordTypeId =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Register a Complaint').getRecordTypeId();
        case objCase = new case(Status='Open',Batch_No__c= '123',recordtypeid=caseRecordTypeId  ,VA_Complaint_Category__c = 'Other Complaints',VA_Other_Complaints__c='Missing coupons',ContactId=objContact.Id,AccountId=objAccount.Id,VA_Assign_to_Owner__c=false);
        insert objCase;
        

        VA_CaseNotificationController.shownotification(objCase.id);
    }
}