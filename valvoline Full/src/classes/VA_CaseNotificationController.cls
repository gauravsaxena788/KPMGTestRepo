public class VA_CaseNotificationController {
    @AuraEnabled
    public static string shownotification(string recordId){
        string message = '';
        if(recordId != null){
            list<Case> lstCase = [SELECT Id from Case 
                                  where Id =: recordId 
                                  and recordType.DeveloperName = 'VA_CCMS' 
                                  and Status = 'Under Review'];
            if(lstCase != null && lstCase.size() > 0) 
            message =  'Please create a Document Review in the related section and fill the CAR Report Section on the Complaint Detail tab to mark the complaint as Action Taken. Refresh after document review creation is required';
        }
        return message;
    }
}