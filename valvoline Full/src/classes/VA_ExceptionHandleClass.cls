Public class VA_ExceptionHandleClass{

Public static boolean insertionHandler(List<Sobject> dataToInsert){
// DML statement
Database.SaveResult[] srList = Database.insert(dataToInsert, false);
Boolean allInserted = true;
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
    }
    else {
        allInserted = false;
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = err.getMessage());  
            insert errorLog;    
        }
    }
}
return allInserted;
}
public static boolean upsertionHandler(Database.UpsertResult[] srList){
// DML statement

Boolean allUpserted = true;
// Iterate through each returned result
for (Database.UpsertResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
    }
    else {
        allUpserted = false;
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = err.getMessage());  
            insert errorLog;    
        }
    }
}
return allUpserted;
}
Public static boolean updationHandler(List<Sobject> dataToUpdate){
// DML statement
Database.SaveResult[] srList = Database.update(dataToUpdate, false);
Boolean allUpdated = true;
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
    }
    else {
        allUpdated = false;
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = err.getMessage());  
            insert errorLog;    
        }
    }
}
return allUpdated;   
}
    
    
    
}