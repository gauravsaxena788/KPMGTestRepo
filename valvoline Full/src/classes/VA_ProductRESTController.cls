@RestResource(urlMapping='/ProductService/*')  

global class VA_ProductRESTController{
    
    @HttpPost
    global static VA_DatabaseUtility.StatementResponses  saveProducts(ProductRequest productList) {
        
        Map<String,VA_DatabaseUtility.StatementResponse> response;
        integer TotalFailedRecord=0;
        integer TotalRecord=0;
        integer TotalNumberOfRecord=0;
        
        Savepoint sp;
        
        try{
            
            List<Product2> proList = new List<Product2>();
            List<PriceBookEntry> pricingList = new List<PriceBookEntry>();
            
            if(productList != null && productList.proDataList != null){
                Product2 productObj = new Product2();
                for(ProductWrapper each : productList.proDataList){
                    productObj = each.productInstance;
                    if(each.productInstance != null){
                        proList.add(each.productInstance);
                        TotalNumberOfRecord = TotalNumberOfRecord +1;
                    }
                    
                }
            }
            
            if(!proList.isEmpty()) { 
                Schema.SObjectField ftoken = Product2.Fields.SKU_Id__c;
                response = VA_DatabaseUtility.upsertionUtility(proList,ftoken,'SKU_Id__c','upsert','Product2'); 
            }            
            
            List<PriceBook2> priceBookList = [SELECT Id, Name FROM PriceBook2 WHERE Name =: Label.VA_PriceBookName LIMIT 1];
            
            Set<Decimal> skuIds = new Set<Decimal>();
            if(!priceBookList.isEmpty()){
                for(Product2 each : proList){
                    PriceBookEntry tempEntry = new PriceBookEntry(SKU_Id__c = each.SKU_Id__c, Pricebook2Id = priceBookList[0].Id, IsActive = true, Product2Id = each.Id, UnitPrice = 0);
                    skuIds.add(each.SKU_Id__c);
                    pricingList.add(tempEntry);
                }
            }
            
            sp = Database.setSavepoint();
            
            List<PriceBookEntry> lstPriceBookEntry  = [Select Id,SKU_Id__c From PriceBookEntry Where SKU_Id__c IN:skuIds]; 
            
            if(!pricingList.isEmpty() && lstPriceBookEntry.size() ==0) {
                Schema.SObjectField ftoken = PriceBookEntry.Fields.SKU_Id__c;
                response = VA_DatabaseUtility.upsertionUtility(pricingList,ftoken,'SKU_Id__c','upsert','PriceBookEntry');   
            }  
            
            VA_DatabaseUtility.StatementResponses objasc = new VA_DatabaseUtility.StatementResponses ();
            objasc.lstStatementResponse = response.values();
            
            for (VA_DatabaseUtility.StatementResponse objresponse : response.values())
            {
                if (objresponse.Status == 'FAILED')
                TotalFailedRecord = TotalFailedRecord + 1;
                TotalRecord = TotalRecord + 1;
            }
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(productList), JSON.serialize(objasc), '' );
            
            return objasc;
            
        }
        catch(exception e){
            
            Database.rollback( sp );
            
            VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
            objResponse.Id = '';
            objResponse.status = 'FAILED';
            objResponse.Message = e.getMessage();
            list<VA_DatabaseUtility.StatementResponse> lststatement = new list<VA_DatabaseUtility.StatementResponse>();
            lststatement.add(objResponse);
            
            VA_DatabaseUtility.StatementResponses objasc = new VA_DatabaseUtility.StatementResponses();
            objasc.lstStatementResponse = lststatement;
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(productList), JSON.serialize(objasc), e.getStackTraceString());
            
            return objasc;
        }
    }
    
    @future
    public static void createErrorLog(integer TotalNumberOfRecord, integer successRecord, integer failedRecords, string requestBody, string responseBody, string stackTrace){
            
        VA_Error_Log__c errorLog = new VA_Error_Log__c();
        errorLog.Total_Number_Of_Record__c = TotalNumberOfRecord;
        errorLog.Total_Success_Record__c = successRecord  ;
        errorLog.Number_Of_Failed_Records__c = failedRecords;
        errorLog.Interface_Name__c = 'Product';
        if(!string.isBlank(stackTrace)) errorLog.VA_Cause__c = 'Stack Trace : ' + stackTrace;
        insert errorLog;
        
        list<Attachment> lstAttach = new list<Attachment>();
        
        Attachment request = new Attachment();
        request.ParentId = errorLog.id;
        request.ownerId = UserInfo.getUserId();
        request.Description = 'Product Request Body';
        request.name = 'Request Body.json';
        request.ContentType = 'application/json';
        request.Body = Blob.valueOf(requestBody);
        lstAttach.add(request);
        
        Attachment response = new Attachment();
        response.ParentId = errorLog.id;
        response.ownerId = UserInfo.getUserId();
        response.Description = 'Product Request Body';
        response.name = 'Reresponse Body.json';
        response.ContentType = 'application/json';
        response.Body = Blob.valueOf(responseBody);
        lstAttach.add(response);
        
        insert lstAttach;
    }
    
    global class ProductWrapper{
        global Product2 productInstance;
    }
    
    global class ProductRequest{
        global List<ProductWrapper> proDataList;
    }
}