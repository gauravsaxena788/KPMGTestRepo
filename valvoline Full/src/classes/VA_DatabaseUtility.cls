global class VA_DatabaseUtility{     
    global static Set<String> failedOrderLineItem = new Set<String>();
    global static StatementResponse statementResponseObj = new StatementResponse();
    global static StatementResponses objasc1 = new StatementResponses();
    global static Map<String,StatementResponse> responseMap = new Map<String,StatementResponse>();  
    
    global static Map<String,StatementResponse> insertionUtility(List<Sobject> listToInsert, String fieldId, String operationType, String objectName){
        List<Database.SaveResult> theResult = operationType == 'insert' ? Database.insert(listToInsert, false) : (operationType == 'update' ? Database.update(listToInsert, false) : new List<Database.SaveResult>());
        Integer i = 0;
        
        for(Database.SaveResult each : theResult){
            statementResponseObj = new StatementResponse();
            if(!each.isSuccess()){ 
                if(objectName=='OrderItem'){
                    failedOrderLineItem.add(String.valueof(listToInsert[i].get(fieldId)));
                }
                
                String fldType = VA_databaseUtility.returnFieldType(objectName,fieldId);
                
                if(fldType != null && fldType == 'DOUBLE')
                    statementResponseObj.ID = String.valueOf(integer.valueOf(listToInsert[i].get(fieldId)));
                else
                    statementResponseObj.ID = String.valueOf(listToInsert[i].get(fieldId));
                
                statementResponseObj.STATUS = 'FAILED';
                for(Database.Error eachErr : each.getErrors()){  
                    
                    if (responseMap.containskey(String.valueOf(listToInsert[i].get(fieldId)))  && responseMap.get(String.valueOf(listToInsert[i].get(fieldId))).status == 'FAILED')
                    { 
                        if (!responseMap.get(String.valueOf(listToInsert[i].get(fieldId))).Message.contains(eachErr.getStatusCode() + ': ' + eachErr.getMessage()))
                        statementResponseObj.Message = responseMap.get(String.valueOf(listToInsert[i].get(fieldId))).Message + ' ' + Label.Sepration + ' ' + eachErr.getStatusCode() + ': ' + eachErr.getMessage() ;  
                    }
                    else
                    {
                        statementResponseObj.Message = eachErr.getStatusCode() + ': ' + eachErr.getMessage();
                    }
                    
                    //statementResponseObj.Message = eachErr.getStatusCode() + ': ' + eachErr.getMessage(); 
                } 
                
                
            }
            else
            {
                String fldType = VA_databaseUtility.returnFieldType(objectName,fieldId);
                if(fldType != null && fldType == 'DOUBLE')
                    statementResponseObj.ID = String.valueOf(integer.valueOf(listToInsert[i].get(fieldId)));
                else
                    statementResponseObj.ID = String.valueOf(listToInsert[i].get(fieldId));
                statementResponseObj.STATUS =  'SUCCESS';
                statementResponseObj.Message = 'Record '+ operationType + ' successfully completed ' ;
            }
            system.debug('statementResponseObj'+ statementResponseObj);
            responseMap.put(statementResponseObj.ID,statementResponseObj);
            system.debug('<<responseMap>>'+ responseMap);
            i++;    
        }
        
        return responseMap;  
    }
    
    
    private static string returnFieldType(String objectName, String fieldId){
        //Field type getting checked currently only for product interface as other interfaces are not having external id with Double type
        Schema.DisplayType fldType;     
        if(objectName == 'Product2'){
            Map<String, Schema.SObjectField> productFields = Schema.SObjectType.Product2.fields.getMap();
            Schema.SObjectField field = productFields.get(fieldId);
            fldType = field.getDescribe().getType();
        }
        if(fldType != null){
            return String.valueOf(fldType);
        }
        else
            return null;
    }
    
    global static Map<String,StatementResponse> upsertionUtility(List<Sobject> listToInsert, Schema.SObjectField ftoken, String fieldId, String operationType, String objectName){
        
        
        List<Database.UpsertResult> theResult;
        
        if( operationType == 'upsert') {
            if(objectName == 'Product2') theResult = Database.upsert((List<Product2>)listToInsert, ftoken, false);
            else if(objectName == 'PriceBookEntry') theResult = Database.upsert((List<PriceBookEntry>)listToInsert, ftoken, false);
        }
        else {
            theResult = new List<Database.UpsertResult>();
        }
        Integer i = 0; 
        
        for(Database.UpsertResult each : theResult){
            statementResponseObj = new StatementResponse();
            if(!each.isSuccess()){ 
                
                String fldType = VA_databaseUtility.returnFieldType(objectName,fieldId);
                if(fldType != null && fldType == 'DOUBLE')
                    statementResponseObj.ID = String.valueOf(integer.valueOf(listToInsert[i].get(fieldId)));
                else
                    statementResponseObj.ID = String.valueOf(listToInsert[i].get(fieldId));
                
                statementResponseObj.STATUS = 'FAILED';                
                for(Database.Error eachErr : each.getErrors()){  
                    
                    if (responseMap.containskey(String.valueOf(listToInsert[i].get(fieldId)))  && responseMap.get(String.valueOf(listToInsert[i].get(fieldId))).status == 'FAILED')
                    { 
                        if (!responseMap.get(String.valueOf(listToInsert[i].get(fieldId))).Message.contains(eachErr.getStatusCode() + ': ' + eachErr.getMessage()))
                        statementResponseObj.Message = responseMap.get(String.valueOf(listToInsert[i].get(fieldId))).Message + ' ' + Label.Sepration + ' ' + eachErr.getStatusCode() + ': ' + eachErr.getMessage() ;  
                    }
                    else
                    {
                        statementResponseObj.Message = eachErr.getStatusCode() + ': ' + eachErr.getMessage();
                    }
                    
                    //statementResponseObj.Message = eachErr.getStatusCode() + ': ' + eachErr.getMessage(); 
                    
                }  
            }             
            else
            {
                
                String fldType = VA_databaseUtility.returnFieldType(objectName,fieldId);
                if(fldType != null && fldType == 'DOUBLE')
                    statementResponseObj.ID = String.valueOf(integer.valueOf(listToInsert[i].get(fieldId)));
                else
                    statementResponseObj.ID = String.valueOf(listToInsert[i].get(fieldId));
                statementResponseObj.STATUS =  'SUCCESS';
                statementResponseObj.Message = 'Successfully Record Created/Updated' ;
            }
            responseMap.put(statementResponseObj.ID,statementResponseObj);
            i++;
            
        }           
        return responseMap;  
    }
    
    public static Map<id, boolean> isPortalAccount(List<String> accIdLst){
        Map<String,Id> accountMap = new Map<String,Id>();    
        Map<Id,boolean> isPortalAccountMap = new Map<Id,boolean>();
        Map<Id, boolean> accisPortalMap = new Map<Id,boolean>();
        //Map<Id,Account> idAccountMap = new Map<Id,Account>([Select id, ]);
        List<User> usrLst = [Select id, Contact.AccountId from User where Profile.Name like '%Customer Community%' AND Contact.AccountId != null];
        
        if(usrLst != null && usrLst.size() > 0){
            for(User use:usrLst){
                isPortalAccountMap.put(use.Contact.AccountId,true);
            }
        }
        
        for(String id:accIdLst){
            if(isPortalAccountMap != null && isPortalAccountMap.containsKey(id)){
                accisPortalMap.put(id,true);
            }
            else if(isPortalAccountMap != null && !isPortalAccountMap.containsKey(id)){
                accisPortalMap.put(id,false);
            }
        }
        
        if(accisPortalMap != null && accisPortalMap.keySet().size() > 0)
            return accisPortalMap;
         else{
             return null;
         }
        
    }
    
    global class StatementResponses {
        global list<StatementResponse> lstStatementResponse;
    }
    
    global class StatementResponse{
        global String Id; 
        global string status; 
        global String Message;
        
    }
}