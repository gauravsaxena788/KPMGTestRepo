public without sharing class VA_ShareCaseRecords {
  @InvocableMethod
  public static void shareRecords(List<String> olduserAndRecordId) {
    CaseShare cshare = new CaseShare();
    String userId = '';
    String recordId = '';
    
    system.debug('@@@oldUser'+olduserAndRecordId);
    for(String strOld:olduserAndRecordId){
        if(!String.isBlank(strOld)){
            userID = strOld.split('-')[0];
            recordId = strOld.split('-')[1];
        }
    }
    
    cshare.CaseId= recordId;
        
      // Set the ID of user or group being granted access.
    cshare.UserOrGroupId = userID;
        
      // Set the access level.
    cshare.CaseAccessLevel = 'Read';
        
      // Set rowCause to 'manual' for manual sharing.
      // This line can be omitted as 'manual' is the default value for sharing objects.
    cshare.RowCause = 'Manual';
    system.debug('@@@cshare'+cshare);
    insert cshare; 
    system.debug('@@@share'+cshare);
   // Database.SaveResult sr = Database.insert(cshare,false);
  }
}