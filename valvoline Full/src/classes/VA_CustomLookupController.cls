public class VA_CustomLookupController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String recordId) {
        system.debug('ObjectName-->' + ObjectName);
        system.debug('rec'+recordId);
        String searchKey = '%' + searchKeyWord + '%';
        String approved = 'Approved';
        List < sObject > returnList = new List < sObject > ();
        String sQuery = 'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey ';
        if(ObjectName == 'VA_Project__c'){
           // List<Case> caselst = [Select id,AccountId FROM Case where id=: recordId];
            //if(!caselst.isEmpty()){
                //String accId = caselst[0].AccountId;
                sQuery += ' AND VA_Status__c =\'' + approved + '\' AND VA_Account__c =\''+ recordId+'\''; 
            //}
        }
        
        sQuery += ' order by createdDate DESC limit 5';
        system.debug('@@query@@'+sQuery); 
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}