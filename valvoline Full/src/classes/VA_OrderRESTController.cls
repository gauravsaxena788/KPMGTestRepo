@RestResource(urlMapping='/OrderService/*')  
global  class VA_OrderRESTController {
    
    @HttpPost
    global static VA_DatabaseUtility.StatementResponses doPost(OrderHeaderWrapper OrderHeaderSet) { 
        system.debug('@@@@'+OrderHeaderSet);
        system.debug('@@@@'+OrderHeaderSet.OrderHeader);
        
        Map<String,VA_DatabaseUtility.StatementResponse> response;
        integer TotalFailedRecord = 0;
        integer TotalRecord = 0;
        integer TotalNumberOfRecord = 0;
        try{   
            if(OrderHeaderSet!= null && OrderHeaderSet.OrderHeader!= null && !OrderHeaderSet.OrderHeader.isEmpty()){  
                
                List<Order> orderListToBeInserted = new List<Order>();
                List<Order> orderListToBeUpdated = new List<Order>();
                List<OrderItem> orderItemListToBeInserted = new List<OrderItem>();
                Map<String,Id> orderMap = new Map<String,Id>();
                Map<String,Id> SAPorderMap = new Map<String,Id>();
                Map<String,Id> orderItemMap = new Map<String,Id>();
                Map<String,Id> accountMap = new Map<String,Id>();
                Map<String,String> statusMap = new Map<String,String>();
                Map<Decimal,Id> PricebookEntryMap = new Map<Decimal,Id>();    
                Set<String> shipToCode = new Set<String>();
                Set<String> sfdcOrderNumber = new Set<String>();
                Set<String> SAPId = new Set<String>();
                Set<Decimal> skuNumber = new Set<Decimal>();
                Pricebook2 priceBook2Obj;
                for(OrderWrapper each : OrderHeaderSet.OrderHeader){
                    if(String.isNotBlank(each.Kunwe)){
                        shipToCode.add(each.Kunwe);   
                    }
                    if(String.isNotBlank(each.SFDCVbeln)){
                        sfdcOrderNumber.add(each.SFDCVbeln);
                    } 
                    if(String.isNotBlank(each.Vbeln)){
                        SAPId.add(each.Vbeln);   
                    }
                    TotalNumberOfRecord = TotalNumberOfRecord +1;
                }  
                for(Account accountObj:[Select Id,Ship_to_Code__c From Account where Ship_to_Code__c IN :shipToCode]){
                    
                    if(String.isNotBlank(accountObj.Ship_to_Code__c) && !accountMap.containsKey(accountObj.Ship_to_Code__c)){ 
                        accountMap.put(accountObj.Ship_to_Code__c,accountObj.Id);      
                    }
                }
                
                for(Order objOrder:[Select Id,VA_SFDC_Order_Number__c,Status From Order where VA_SFDC_Order_Number__c IN :sfdcOrderNumber]){  
                    if(!orderMap.Containskey(objOrder.VA_SFDC_Order_Number__c) && String.isNotBlank(objOrder.VA_SFDC_Order_Number__c)) {
                        orderMap.put(objOrder.VA_SFDC_Order_Number__c ,objOrder.Id);
                        statusMap.put(objOrder.VA_SFDC_Order_Number__c ,objOrder.Status);
                    }
                }
                
                for(Order objOrder:[Select Id,VA_SAP_Order_Id__c,Status From Order where VA_SAP_Order_Id__c IN :SAPId]){  
                    if(!SAPorderMap.Containskey(objOrder.VA_SAP_Order_Id__c) && String.isNotBlank(objOrder.VA_SAP_Order_Id__c)) {
                        SAPorderMap.put(objOrder.VA_SAP_Order_Id__c ,objOrder.Id);
                        statusMap.put(objOrder.VA_SAP_Order_Id__c ,objOrder.Status);
                    }
                }
                
                if(!test.isRunningTest())
                priceBook2Obj = [select id,Name from Pricebook2 where Name=: Label.VA_PriceBookName]; 
                
                response = new Map<String,VA_DatabaseUtility.StatementResponse>();
                
                for(OrderWrapper each : OrderHeaderSet.OrderHeader){
                    Order orderObj = new Order();
                    
                    if(String.isNotBlank(each.Kunwe) && accountMap.ContainsKey(each.Kunwe)) {
                        Id accountId = accountMap.get(each.Kunwe);
                        Id orderId;
                        String status;
                        if(String.isNotBlank(each.SFDCVbeln) && orderMap.get(each.SFDCVbeln)!=null){     
                            status = statusMap.get(each.SFDCVbeln);
                        }
                        
                        if(String.isNotBlank(each.Vbeln) && orderMap.get(each.Vbeln)!=null){ 
                            status = statusMap.get(each.Vbeln);
                        }
                        orderObj.VA_SAP_Order_Id__c = each.Vbeln;
                        if(String.isNotBlank(each.Bstdk)) { 
                            Date newDate = Date.valueOf(each.Bstdk);
                            orderObj.PoDate = newDate;    
                        }
                        
                        orderObj.VA_Overall_Order_Rejection__c = each.overalOrderRejection;
                        orderObj.PoNumber = each.Bstnk;
                        orderObj.AccountId= accountId;      
                        orderObj.EffectiveDate= each.orderStartDate;
                        orderObj.VA_Ship_To_Code__c = each.Kunwe;
                        
                        if(!test.isRunningTest())
                        orderObj.Pricebook2Id = priceBook2Obj.Id;   
                        
                        orderObj.VA_Depot_Code__c= each.Werks;
                        
                        if((String.isNotBlank(each.Vbeln)  && String.isBlank(each.SFDCVbeln) && !SAPorderMap.ContainsKey(each.Vbeln) || (String.isNotBlank(each.Vbeln)  && String.isNotBlank(each.SFDCVbeln) && !SAPorderMap.ContainsKey(each.Vbeln) && !orderMap.ContainsKey(each.SFDCVbeln)))){
                            
                            if(String.isNotBlank(each.overalOrderRejection)){
                                orderObj.Status= 'Rejected';
                            }
                            else if(String.isBlank(each.overalOrderRejection)){
                                orderObj.Status = 'Registered';
                            }  
                            orderListToBeInserted.add(orderObj);   
                            
                        }
                        
                        else if((String.isNotBlank(each.Vbeln) && String.isNotBlank(each.SFDCVbeln) && SAPorderMap.ContainsKey(each.Vbeln) && orderMap.ContainsKey(each.SFDCVbeln))|| (String.isNotBlank(each.Vbeln) && String.isBlank(each.SFDCVbeln) && SAPorderMap.ContainsKey(each.Vbeln)) || (String.isNotBlank(each.Vbeln) && String.isNotBlank(each.SFDCVbeln) && SAPorderMap.ContainsKey(each.Vbeln) && !orderMap.ContainsKey(each.SFDCVbeln))){
                            orderId = SAPorderMap.get(each.Vbeln);
                            orderObj.Id=orderId;
                            if(String.isNotBlank(each.overalOrderRejection)){
                                orderObj.Status= 'Rejected';
                            }
                            else if(String.isBlank(each.overalOrderRejection) && status == 'Draft'){
                                orderObj.Status= 'Registered';  
                            }
                            orderListToBeUpdated.add(orderObj);                             
                        }
                        
                        else if((String.isNotBlank(each.Vbeln) && String.isNotBlank(each.SFDCVbeln) && orderMap.ContainsKey(each.SFDCVbeln) && !SAPorderMap.ContainsKey(each.Vbeln))){
                            orderId = orderMap.get(each.SFDCVbeln);
                            orderObj.Id=orderId;
                            if(String.isNotBlank(each.overalOrderRejection)){
                                orderObj.Status= 'Rejected';
                            }
                            else if(String.isBlank(each.overalOrderRejection) && status == 'Draft'){
                                orderObj.Status= 'Registered';  
                            }
                            orderListToBeUpdated.add(orderObj); 
                        }
                        
                        else {
                            
                            //---------- Valid SAP Id not found ------------//
                            VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
                            if(response.ContainsKey(each.Vbeln))
                            objResponse = response.get(each.Vbeln);
                            
                            objResponse.Id= each.Vbeln;
                            objResponse.status = 'FAILED';
                            
                            if(objResponse.Message == null) 
                            //objResponse.Message = new list<String>();
                            
                            //objResponse.Message.add('Please enter valid SAP Id'+ each.SFDCVbeln);
                            //objResponse.Message = 'Please enter valid SAP Id';   
                            
                            if (response.containskey(each.Vbeln)  && response.get(each.Vbeln).status == 'FAILED' )
                            {
                                if (!response.get(each.Vbeln).Message.contains('Please enter valid SAP Id '+ each.SFDCVbeln ))
                                objResponse.Message =  response.get(each.Vbeln).Message + ' ' + Label.Sepration + ' ' + 'Please enter valid SAP Id '+ each.SFDCVbeln ;  
                            }   
                            else
                            {
                                objResponse.Message = 'Please enter valid SAP Id ' + each.SFDCVbeln;
                            }
                            
                            response.put(each.Vbeln, objResponse);
                            //----------/Valid SAP Id not found ------------//
                        }
                    }
                    else {
                        
                        //---------- Ship to code not found ------------//
                        VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
                        if(response.ContainsKey(each.Vbeln))
                        objResponse = response.get(each.Vbeln);
                        
                        objResponse.Id= each.Vbeln;
                        objResponse.status = 'FAILED';
                        
                        //if(objResponse.Message == null) 
                        //objResponse.Message = new list<String>();
                        
                        if (response.containskey(each.Vbeln)  && response.get(each.Vbeln).status == 'FAILED' ) {
                            if (!response.get(each.Vbeln).Message.contains('Ship-to-Code '+ each.Kunwe +' does not exist in Salesforce.'))
                            objResponse.Message =  response.get(each.Vbeln).Message + ' ' + Label.Sepration + ' ' + 'Ship-to-Code '+ each.Kunwe +' does not exist in Salesforce.' ;  
                        }
                        else {
                            objResponse.Message ='Ship-to-Code '+ each.Kunwe +' does not exist in Salesforce.';
                        }
                        
                        //objResponse.Message ='Invalid ship to code value for Account';
                        
                        response.put(each.Vbeln, objResponse);
                        
                        
                        //----------/Ship to code not found ------------//
                    }
                }
                
                if(!orderListToBeInserted.isEmpty()) {
                    Map<String,VA_DatabaseUtility.StatementResponse> responseTemp= VA_DatabaseUtility.insertionUtility(orderListToBeInserted,'VA_SAP_Order_Id__c','insert','Order');    
                    response.putAll(responseTemp);
                }                 
                if(!orderListToBeUpdated.isEmpty()) {
                    Map<String,VA_DatabaseUtility.StatementResponse> responseTemp = VA_DatabaseUtility.insertionUtility(orderListToBeUpdated,'VA_SAP_Order_Id__c','update','Order');      
                    response.putAll(responseTemp);
                } 
                
                for(Order objOrderInserted:orderListToBeInserted){ 
                    if(!orderMap.Containskey(objOrderInserted.VA_SAP_Order_Id__c) && String.isNotBlank(objOrderInserted.VA_SAP_Order_Id__c)) {
                        orderMap.put(objOrderInserted.VA_SAP_Order_Id__c ,objOrderInserted.Id);
                    }
                }
                
                for(Order objOrderUpadated:orderListToBeUpdated){    
                    if(!orderMap.Containskey(objOrderUpadated.VA_SFDC_Order_Number__c) && String.isNotBlank(objOrderUpadated.VA_SFDC_Order_Number__c)) {
                        orderMap.put(objOrderUpadated.VA_SFDC_Order_Number__c ,objOrderUpadated.Id);
                    }
                    else if(!orderMap.Containskey(objOrderUpadated.VA_SAP_Order_Id__c) && String.isNotBlank(objOrderUpadated.VA_SAP_Order_Id__c)){
                        orderMap.put(objOrderUpadated.VA_SAP_Order_Id__c ,objOrderUpadated.Id);
                        
                    }
                }
                
                for(OrderWrapper each : OrderHeaderSet.OrderHeader){
                    for(OrderItemWrapper eachLine : each.OrderHdrToItemNvg){  
                        for(OrderItem eachx : eachLine.OrderItem){
                            if(String.isNotBlank(eachx.VA_Material_SKU__c)){  
                                skuNumber.add(Decimal.valueof(eachx.VA_Material_SKU__c));
                            }  
                        }
                    }
                }
                
                for(PricebookEntry pricebookEntryObj:[Select Id,SKU_ID__c From PricebookEntry where SKU_ID__c IN:skuNumber]){
                    if((pricebookEntryObj.SKU_ID__c)!=null && !PricebookEntryMap.containsKey(pricebookEntryObj.SKU_ID__c)){  
                        PricebookEntryMap.put(pricebookEntryObj.SKU_ID__c,pricebookEntryObj.Id);         
                    }
                } 
                Set<Id> orderIds = new Set<Id>();
                for(OrderWrapper each : OrderHeaderSet.OrderHeader){
                    for(OrderItemWrapper eachLine : each.OrderHdrToItemNvg){  
                        for(OrderItem eachx : eachLine.OrderItem){
                            OrderItem orderItemObj = new OrderItem();
                            if((orderMap.ContainsKey(each.SFDCVbeln) && each.Vbeln==eachx.VA_SAP_Order_Id__c) || (orderMap.ContainsKey(eachx.VA_SAP_Order_Id__c) && each.Vbeln==eachx.VA_SAP_Order_Id__c)) {
                                Id orderId;
                                if(String.isNotBlank(each.SFDCVbeln) && orderMap.ContainsKey(each.SFDCVbeln)){
                                    orderId = orderMap.get(each.SFDCVbeln); 
                                    orderIds.add(orderId);
                                }
                                else if(String.isBlank(each.SFDCVbeln) || String.isNotBlank(each.SFDCVbeln) && !orderMap.ContainsKey(each.SFDCVbeln)){     
                                    orderId = orderMap.get(eachx.VA_SAP_Order_Id__c); 
                                    orderIds.add(orderId);    
                                }     
                                
                                orderItemObj.VA_Material_SKU__c = eachx.VA_Material_SKU__c;
                                if(String.isNotBlank(eachx.VA_Material_SKU__c) && PricebookEntryMap.ContainsKey(Decimal.valueof(eachx.VA_Material_SKU__c))) {
                                    Id PricebookEntryId = PricebookEntryMap.get(Decimal.valueof(eachx.VA_Material_SKU__c));   
                                    orderItemObj.OrderId= orderId; 
                                    system.debug('@@'+eachx.VA_Reason_for_Rejection__c);
                                    orderItemObj.VA_Reason_for_Rejection__c= eachx.VA_Reason_for_Rejection__c;
                                    if(String.isNotBlank(eachx.VA_Reason_for_Rejection__c)){
                                        orderItemObj.VA_Status__c= 'Rejected';
                                    }
                                    else{
                                        orderItemObj.VA_Status__c= 'Registered';    
                                    }
                                    orderItemObj.VA_Delivery_Quantity__c= eachx.VA_Delivery_Quantity__c;
                                    orderItemObj.VA_Position_Number__c= eachx.VA_Position_Number__c;
                                    orderItemObj.VA_Billing_Block__c= eachx.VA_Billing_Block__c;
                                    
                                    orderItemObj.Quantity= eachx.Quantity;
                                    
                                    orderItemObj.VA_SAP_Order_Id__c= eachx.VA_SAP_Order_Id__c;
                                    orderItemObj.PriceBookEntryId= PricebookEntryId;
                                    orderItemObj.VA_Is_FreeGoods__c= (eachx.VA_FreeGoods__c=='X')?True:False;  
                                    orderItemObj.UnitPrice = (eachx.UnitPrice!=null)?eachx.UnitPrice:0;  
                                    orderItemObj.VA_Type__c = 'Confirmed Line Item';
                                    orderItemObj.VA_Confirmed_Date__c = system.today();
                                    if(orderItemObj.Quantity > 0 || eachx.Quantity > 0){
                                        orderItemListToBeInserted.add(orderItemObj);
                                    }
                                    
                                }  
                                
                                else {
                                    
                                    //---------- Price Book Entry not found ------------//
                                    VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
                                    if(response.ContainsKey(each.Vbeln))
                                    objResponse = response.get(each.Vbeln);
                                    
                                    objResponse.Id= each.Vbeln;
                                    VA_DatabaseUtility.failedOrderLineItem.add(objResponse.Id);
                                    objResponse.status = 'FAILED';
                                    
                                    //if(objResponse.Message == null) 
                                    // objResponse.Message = new list<String>();
                                    //objResponse.Message.add('Price Book Entry is Not available for Given SKU : '+ eachx.VA_Material_SKU__c);
                                    
                                    
                                    
                                    if (response.containskey(each.Vbeln)  && response.get(each.Vbeln).status == 'FAILED')
                                    {   
                                        if (!response.get(each.Vbeln).Message.contains('Price Book Entry is Not available for Given SKU : '+ eachx.VA_Material_SKU__c))
                                        objResponse.Message =  response.get(each.Vbeln).Message + ' ' + Label.Sepration + ' ' +' Price Book Entry is Not available for Given SKU : '+ eachx.VA_Material_SKU__c ;  
                                    }    
                                    else
                                    {
                                        objResponse.Message =  'Price Book Entry is Not available for Given SKU : '+ eachx.VA_Material_SKU__c;
                                    }
                                    
                                    //objResponse.Message =  'Price Book Entry is Not available for Given SKU';
                                    
                                    response.put(each.Vbeln, objResponse);
                                    
                                    //----------/Price Book Entry not found ------------//
                                }
                            }
                            else {
                                
                                
                                //---------- Order not found ------------//
                                VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
                                
                                if(response.ContainsKey(each.Vbeln))
                                objResponse = response.get(each.Vbeln);
                                
                                objResponse.Id= each.Vbeln;
                                VA_DatabaseUtility.failedOrderLineItem.add(objResponse.Id);
                                objResponse.status = 'FAILED';
                                
                                //if(objResponse.Message == null) 
                                //objResponse.Message = new list<String>();
                                //objResponse.Message.add('There is some problem with SAP order id either in order or Line Items request : '+ each.Vbeln);
                                
                                if (response.containskey(each.Vbeln)  && response.get(each.Vbeln).status == 'FAILED')
                                { 
                                    if (!response.get(each.Vbeln).Message.contains('There is some problem with SAP order id either in order or Line Items request'))
                                    objResponse.Message = response.get(each.Vbeln).Message + ' ' + Label.Sepration + ' ' + 'There is some problem with SAP order id either in order or Line Items request' ;  
                                }
                                else
                                {
                                    objResponse.Message = 'There is some problem with SAP order id either in order or Line Items request ';    
                                }
                                
                                //objResponse.Message = 'There is some problem with SAP order id either in order or Line Items request';        
                                response.put(each.Vbeln, objResponse);
                                
                                //----------/Order not found ------------//
                            }
                        }
                        
                    }
                    
                    
                }
                
                if(!orderListToBeUpdated.isEmpty()) {                
                    delete [SELECT Id,VA_Type__c FROM OrderItem WHERE OrderId IN:orderIds AND VA_Type__c='Confirmed Line Item'];
                }  
                
                if(!orderItemListToBeInserted.isEmpty()) {  
                    Map<String,VA_DatabaseUtility.StatementResponse> responseTemp = VA_DatabaseUtility.insertionUtility(orderItemListToBeInserted,'VA_SAP_Order_Id__c','insert','OrderItem');         
                    response.putAll(responseTemp);
                    system.debug('<<responseTemp>>' + responseTemp);
                    
                } 
                if(VA_DatabaseUtility.failedOrderLineItem.size()>0 ) {
                    delete [SELECT Id,VA_SAP_Order_Id__c,VA_Type__c  FROM OrderItem WHERE VA_SAP_Order_Id__c IN: VA_DatabaseUtility.failedOrderLineItem AND VA_Type__c='Confirmed Line Item'];
                }
                
                //Updating Order Data after Rollup of all line-item quantity 
                database.update(orderListToBeUpdated,false);
                
            } 
            
            //return response.values(); 
            VA_DatabaseUtility.StatementResponses objasc = new VA_DatabaseUtility.StatementResponses();
            objasc.lstStatementResponse = response.values();
            
            for (VA_DatabaseUtility.StatementResponse objresponse : response.values())
            {
                if (objresponse.Status == 'FAILED')
                TotalFailedRecord = TotalFailedRecord + 1;
                TotalRecord = TotalRecord + 1;
            }    
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(OrderHeaderSet), JSON.serialize(objasc), '');
            
            return objasc;
            
        } 
        catch(Exception ex) { 
        
            VA_DatabaseUtility.StatementResponse objResponse = new VA_DatabaseUtility.StatementResponse();
            objResponse.Id = '';
            objResponse.status = 'FAILED';
            objResponse.Message = ex.getMessage();
            
            list<VA_DatabaseUtility.StatementResponse> lststatement = new list<VA_DatabaseUtility.StatementResponse>();
            lststatement.add(objResponse);
            
            VA_DatabaseUtility.StatementResponses objasc = new VA_DatabaseUtility.StatementResponses();
            objasc.lstStatementResponse = lststatement;
            
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord ), JSON.serialize(OrderHeaderSet), JSON.serialize(objasc), ex.getStackTraceString());
            
            return objasc;
        } 
    }
    
    
    @future
    public static void createErrorLog(integer TotalNumberOfRecord, integer successRecord, integer failedRecords, string requestBody, string responseBody, string stackTrace ){
        
        VA_Error_Log__c errorLog = new VA_Error_Log__c();
        errorLog.Total_Number_Of_Record__c = TotalNumberOfRecord;
        errorLog.Total_Success_Record__c = successRecord  ;
        errorLog.Number_Of_Failed_Records__c = failedRecords;
        if(!string.isBlank(stackTrace)) errorLog.VA_Cause__c = 'Stack Trace : ' + stackTrace;
        errorLog.Interface_Name__c = 'Order';
        insert errorLog;
        
        list<Attachment> lstAttach = new list<Attachment>();
        
        Attachment request = new Attachment();
        request.ParentId = errorLog.id;
        request.ownerId = UserInfo.getUserId();
        request.Description = 'Order Request Body';
        request.name = 'Request Body.json';
        request.ContentType = 'application/json';
        request.Body = Blob.valueOf(requestBody);
        lstAttach.add(request);
        
        Attachment response = new Attachment();
        response.ParentId = errorLog.id;
        response.ownerId = UserInfo.getUserId();
        response.Description = 'Order Response Body';
        response.name = 'Response Body.json';
        response.ContentType = 'application/json';
        response.Body = Blob.valueOf(responseBody);
        lstAttach.add(response);
        
        insert lstAttach;
    }
    
    
    global class OrderHeaderWrapper {
        global  list<OrderWrapper> OrderHeader;  
    }
    
    global class OrderWrapper {  
        global  String Vbeln;
        global  String Bstdk;  
        global  String Bstnk;
        global  String overalOrderRejection;
        global  Date orderStartDate;
        global  String Kunwe;
        global  String SFDCVbeln;
        global  String Werks;
        global  List<OrderItemWrapper> OrderHdrToItemNvg;    
    }
    
    global class OrderItemWrapper {  
        global List<OrderItem> OrderItem ;       
    }
}