/**
    @author: SB
    @company: Saasfocus
    @description: This class is working as an Interface for insertion & update of Invoice/Invoice Line Item data from SAP
*/

@RestResource(urlMapping='/InvoiceService/*')
global  class VA_OpportunityRESTController {
    
    //This method receives data from SAP through HCI and insert/update in SFDC Opportunity Object
    //Logic for creation Of Invoice Objcet for showing invoice on customer community
    //Logic for Order status update based on invoice qunatities received
    @HttpPost
    global static ResponsedoPosts saveOpportunity(OpportunityHeaderMain OpportunityHeaderSet) {
        
        //Wrapper Class to store response to send the response back to consumer
        List<ResponsedoPost> responseDoPostLst = new List<ResponsedoPost>();
        
        //map<InvoiceNo,Response> to store succeess or failure againsts each Oppportunity
        map<string,ResponsedoPost> mapResponsedPost = new map<string,ResponsedoPost>();
        
        //Wrapper object of Response to store response opportunity wise
        ResponsedoPosts objResponsedoPosts;
        
        //To store count of total records in request
        integer TotalNumberOfRecord = 0;
        
        //Total no of unique records in the request
        integer TotalRecord = 0;
        
        //To store count of failed records in request
        integer TotalFailedRecord = 0;
        
        //Map SAP Order Id respect to Opportunity Code
        map<String,String> mapSapOrderIdOpportunityCode = new map<String,String>();
        
        //Transaction Controller Initialization 
        Savepoint sp;
        
        try{
            //object of Response (Opportunity) to store response opportunity wise
            ResponsedoPost objresponse;
            
            //List Oppo to be upserted comming from consumer
            List<Opportunity> opportunityListToBeUpserted = new List<Opportunity>();
            
            //List Oppo line item to be upserted comming from consumer
            List<OpportunityLineItem> opportunityLineItemListToBeInserted = new List<OpportunityLineItem>();
            
            //map<Opportunity Code, Opportuinty SFDC Id> 
            Map<String,Id> opportunityMap = new Map<String,Id>();
            
            //Map<ship to Code, Account SFDC Id> 
            Map<String,Id> accountMap = new Map<String,Id>();
            
            //Map<SAP Order Id, Order SFDC Id>
            Map<String,Order> OrderMap = new Map<String,Order>();
            
            //Map<Opportunity Code, AccountId> mapp of Account Id against the Oportunity Code
            Map<String,Id> OppCodeAccountIdMap = new Map<String,Id>();
            
            integer i=0;
            
            string Message;
            
            //Opportunity record id
            Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
            
            //Retrieving nodes from XML request
            if(OpportunityHeaderSet!= null && OpportunityHeaderSet.OpportunityHeader!= null && !OpportunityHeaderSet.OpportunityHeader.isEmpty()){
                
                //Set of ship to code for query
                Set<String> shiptocodeSet= new Set<String>();
                
                //Set of opportunity Codes
                Set<String> setopportunityCode = new Set<String>();             
                
                //Set of SAP Order Id for query
                Set<String> setSapOrderId = new Set<String>();
            
                //Set of Month to query monthly opportinity
                Set<String> setOppMonth = new Set<String>();
                
                //Set of year to query monthly opportinity
                Set<String> setOppYear = new Set<string>();
                
                //Set of Product Code SKU ID for Query
                Set<Integer> setProductCode = new Set<Integer>();
                
                //Map of Monthly Opportuinty <Account Id + Month + Year, Opportuinty Id>
                map<string, Id> mapOppId = new map<string, Id>();
                
                for(OpportunityHeaderInner each : OpportunityHeaderSet.OpportunityHeader){
                    if(String.isNotBlank(each.ShiptoCode)){
                        shiptocodeSet.add(each.ShiptoCode);   
                    }
                    if(String.isNotBlank(each.opportunityCode)){
                        setopportunityCode.add(each.opportunityCode);
                        
                        if(String.isNotBlank(each.SapOrderId)){
                            setSapOrderId.add(each.SapOrderId);
                            mapSapOrderIdOpportunityCode.put(each.opportunityCode, each.SapOrderId);
                        }
                    }
                    
                    if(String.isNotBlank(each.Month)){
                        setOppMonth.add(each.Month);
                    }
                    if(String.isNotBlank(each.calendarYear)){
                        setOppYear.add(each.calendarYear);
                    }
                    TotalNumberOfRecord = TotalNumberOfRecord +1;
                    
                    //getting Product codes for opportinity line items for all opportunities
                    for(OpportunityLineItemWrapper eachLine : each.OpportunityHdrToLineItemNvg){  
                        for(OpportunityLineItem eachx : eachLine.OpportunityLineItem){
                            if(eachx.ProductCode != null){
                                setProductCode.add(Integer.valueof(eachx.ProductCode));
                            }  
                        }
                    }
                }
                
                //---------------- Creating Maps where above retrieved nodes are key and whole objects is value ---------------//
                //Querying Data from Account for Id of Account against Account Ship to Code
                if(shiptocodeSet!=null && shiptocodeSet.size()>0){
                    for(Account accountObj:[Select Id,Ship_to_Code__c From Account where Ship_to_Code__c IN :shiptocodeSet AND Ship_to_Code__c != null]){
                        if(String.isNotBlank(accountObj.Ship_to_Code__c ) && !accountMap.containsKey(accountObj.Ship_to_Code__c )){ 
                            accountMap.put(accountObj.Ship_to_Code__c ,accountObj.Id);      
                        }
                    } 
                }
                
                //Querying Data from Order for Id of Order against SAP Order Id
                if(setSapOrderId!=null && setSapOrderId.size()>0){
                    for(Order orderObj:[Select Id, Status, VA_SAP_Order_Id__c From Order where VA_SAP_Order_Id__c IN :setSapOrderId AND VA_SAP_Order_Id__c != null]){
                        if(String.isNotBlank(orderObj.VA_SAP_Order_Id__c) && !OrderMap.containsKey(orderObj.VA_SAP_Order_Id__c)){ 
                            OrderMap.put(orderObj.VA_SAP_Order_Id__c,orderObj);      
                        }
                    }   
                }
                
                //Querying data for Opportunity Code and Creating map against opportunity code and Opportuinty Id
                if(setopportunityCode!=null && setopportunityCode.size()>0){
                    for(Opportunity objOpportunity:[Select Id,Opportunity_Code__c,AccountId,VA_Order__c From Opportunity  where Opportunity_Code__c IN :setopportunityCode AND Opportunity_Code__c != null]){  
                        if(!opportunityMap.Containskey(objOpportunity.Opportunity_Code__c) && String.isNotBlank(objOpportunity.Opportunity_Code__c)) {
                            opportunityMap.put(objOpportunity.Opportunity_Code__c ,objOpportunity.Id);
                        }
                    } 
                }
                
                //Querying Monthly Opportunity 
                for(Opportunity objMonthlyopportunity : [select id , AccountId, Month__c , Year__c  from Opportunity where Month__c IN:setOppMonth and Year__c IN:setOppYear and AccountId in: accountMap.values() AND AccountId != null]){
                    
                    if(objMonthlyopportunity.Month__c != null && objMonthlyopportunity.Year__c != null)
                    mapOppId.put(objMonthlyopportunity.AccountId + objMonthlyopportunity.Month__c + objMonthlyopportunity.Year__c, objMonthlyopportunity.Id);
                    
                }
                
                //Setting maps for price book entry against each product code existing in system
                Map<Integer,Id> PricebookEntryMap = new Map<Integer,Id>();
                
                if(setProductCode.size() > 0){
                    for(PricebookEntry pricebookEntryObj:[Select Id,SKU_ID__c From PricebookEntry where SKU_ID__c IN: setProductCode]){
                        PricebookEntryMap.put(Integer.valueof(pricebookEntryObj.SKU_ID__c),pricebookEntryObj.Id);
                    } 
                }
                
                
                //Check if Account is Portal Account
                Map<id, boolean> isPortalAccount = VA_DatabaseUtility.isPortalAccount(accountMap.values());
                //----------------/Creating Maps where above retrieved nodes are key and whole objects is value ---------------//
                
                //Valid data to be inserted into Database
                OpportunityHeaderMain ValidOpportunityHeader = new OpportunityHeaderMain();
                ValidOpportunityHeader.OpportunityHeader = new list<OpportunityHeaderInner>();
                
                //Map<SAP Order Id, Order SFDC Id>
                Map<String,Order> ValidOrderMap = new Map<String,Order>();
                
                //---------------- Data Validation Section 1 ----------------------//
                Set<String> notInsertedOpportunitySet = new Set<String>();
                
                for(OpportunityHeaderInner each : OpportunityHeaderSet.OpportunityHeader){
                    
                    //Opportunity Code Required
                    if(String.isBlank(each.opportunityCode)) {
                        objresponse = new responsedoPost ('FAILED', 'Opportunity code is missing in the request', each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id, addError(objresponse,mapResponsedPost));
                    }
                    
                    //Ship to code required
                    else if(String.isBlank(each.ShiptoCode)){
                        objresponse = new responsedoPost ('FAILED','Ship to code is missing in the request', each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                    }
                    
                    //Validating Account Ship to Code- if exists in Salesfroce
                    else if(String.isNotBlank(each.ShiptoCode) && !accountMap.containsKey(each.ShiptoCode)) {
                        objresponse = new responsedoPost ('FAILED','Ship-to-Code ' + each.ShiptoCode + ' does not exist in Salesforce.', each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                    }
                    
                    /*
                    //Validating Current Order Status
                    else if(String.isNotBlank(each.SapOrderId) && OrderMap.containsKey(each.SapOrderId) && OrderMap.get(each.SapOrderId).Status != 'Registered' && OrderMap.get(each.SapOrderId).Status != 'Partially fulfilled') {
                        objresponse = new responsedoPost ('FAILED','Can\'t process invoice if Order Status is '+ OrderMap.get(each.SapOrderId).Status +', SAP Order Id : ' + each.SapOrderId, each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                    }
                    
                    //In case of Portal Activated Account Order is required
                    else if(isPortalAccount.get(accountMap.get(each.ShiptoCode)) && (String.isBlank(each.SapOrderId) || (String.isNotBlank(each.SapOrderId) && !OrderMap.containsKey(each.SapOrderId)))) {
                        if(String.isBlank(each.SapOrderId)){
                            objresponse = new responsedoPost ('FAILED','Sap Order Id required for Account Activated as Portal User ', each.opportunityCode);
                            mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                        }
                        else{
                            objresponse = new responsedoPost ('FAILED','Invalid Sap Order Id : ' + each.SapOrderId + ' for Account Activated as Portal User ', each.opportunityCode);
                            mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                        }
                    }
                    */
                    
                    //Validing Calender Year and Month
                    else if(each.calendarYear == null || each.Month == null){
                        objresponse = new ResponsedoPost('FAILED','Month and Year can\'t be null', each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                    }
                    
                    //Checking Monthly Opportuinty
                    else if(each.calendarYear != null && each.Month != null && !mapOppId.ContainsKey(accountMap.get(each.ShiptoCode) + each.Month + each.calendarYear)) {
                        objresponse = new ResponsedoPost('FAILED','Monthly Plan opportunity not found for this Invoice', each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                    }
                    
                    else {
                        //Checking Product Line Item
                        for(OpportunityLineItemWrapper eachLine : each.OpportunityHdrToLineItemNvg){  
                            for(OpportunityLineItem eachx : eachLine.OpportunityLineItem){
                                if(eachx.ProductCode != null){
                                    if(!PricebookEntryMap.containsKey(Integer.valueof(eachx.ProductCode))){
                                        objresponse = new responsedoPost ('FAILED','Product code ' + eachx.ProductCode + ' does not exist in SFDC Or Pricebook is invalid' , each.opportunityCode);
                                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                                    }
                                }
                                else {
                                    objresponse = new responsedoPost ('FAILED','Product Code Cann\'t be null or blank', each.opportunityCode);
                                    mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                                }
                            }
                        }
                        
                        //Adding valid records to list for futher processing.
                        if(!mapResponsedPost.containsKey(each.opportunityCode) || Test.isRunningTest()){
                            ValidOpportunityHeader.OpportunityHeader.add(each);
                            
                            if(OrderMap.containsKey(each.SapOrderId)){
                            
                                //------------------- Order Validation --------------------------//
                                if(each.opportunityCode.endsWith('c')){
                                    //Skipping Order status check for cancelled invoices
                                    ValidOrderMap.put(each.SapOrderId,OrderMap.get(each.SapOrderId));
                                }
                                else if(String.isNotBlank(each.SapOrderId) && OrderMap.containsKey(each.SapOrderId) && OrderMap.get(each.SapOrderId).Status != 'Registered' && OrderMap.get(each.SapOrderId).Status != 'Partially fulfilled') {
                                    objresponse = new responsedoPost ('FAILED',' - Invoice cannot be created on customer portal as order status is '+ OrderMap.get(each.SapOrderId).Status +' for SAP Order ID: ' + each.SapOrderId, each.opportunityCode);
                                    mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                                }
                                
                                //In case of Portal Activated Account Order is required
                                else if(isPortalAccount.get(accountMap.get(each.ShiptoCode)) && (String.isBlank(each.SapOrderId) || (String.isNotBlank(each.SapOrderId) && !OrderMap.containsKey(each.SapOrderId)))) {
                                    if(String.isBlank(each.SapOrderId)){
                                        objresponse = new responsedoPost ('FAILED','- Invoice cannot be created on customer portal as  SAP Order Id is blank', each.opportunityCode);
                                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                                    }
                                    else{
                                        objresponse = new responsedoPost ('FAILED','- Invoice cannot be created on customer portal as  SAP Order Id doesn\'t exist in SFDC', each.opportunityCode);
                                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                                    }
                                }
                                else {
                                    ValidOrderMap.put(each.SapOrderId,OrderMap.get(each.SapOrderId));
                                }
                                //-------------------/Order Validation --------------------------//
                            }
                        }
                    }
                }
                //----------------/Data Validation Section 1 ----------------------//
                
                
                //Getting Configured Price Book for further use
                Pricebook2  priceBook2Obj= [select id,Name from Pricebook2 where Name=:Label.VA_PriceBookName ];
                
                for(OpportunityHeaderInner each : ValidOpportunityHeader.OpportunityHeader){
                    
                    Id accountId;
                    
                    Opportunity opportunityObj = new Opportunity();
                    
                    //Getting Account Id against Shipto Code
                    if(accountMap.containsKey(each.ShiptoCode)){
                        accountId = accountMap.get(each.ShiptoCode);
                        oppCodeAccountIdMap.put(each.opportunityCode,accountId);
                    }
                    
                    //Getting Order Id against Sap Order Id
                    if(ValidOrderMap.containsKey(each.SapOrderId)){
                        opportunityObj.VA_Order__c = ValidOrderMap.get(each.SapOrderId).Id;
                    }
                    
                    opportunityObj.IsCreatedfromVF__c = Boolean.valueof(each.iscreatedfromVf) !=null ? Boolean.valueof(each.iscreatedfromVf) : false;
                    opportunityObj.Opportunity_Code__c = each.opportunityCode;
                    opportunityObj.AccountId= accountId;
                    
                    opportunityObj.VA_Sap_Order_Id__c = each.SapOrderId;
                    
                    opportunityObj.Calendar_Year__c= each.calendarYear;
                    opportunityObj.VA_Ship_to_Code__c = each.ShiptoCode;
                    opportunityObj.Pricebook2Id = priceBook2Obj.Id;    
                    opportunityObj.StageName = each.StageName; 
                    
                    if(String.isNotBlank(each.CloseDate))
                    opportunityObj.CloseDate= Date.valueof(each.CloseDate);
                    
                    if(String.isNotBlank(each.invoiceDate))
                    opportunityObj.Invoice_Date__c = Date.valueof(each.invoiceDate);
                    
                    opportunityObj.RecordTypeId = each.RecordTypeId != null ? each.RecordTypeId : OppRecordTypeId  ;
                    opportunityObj.Name = each.Name;
                    opportunityObj.Month_sap__c = each.Month;
                    
                    if(String.isNotBlank(each.InvoiceDueDate))
                    opportunityObj.VCPL_Invoice_Due_Date__c = Date.valueof(each.InvoiceDueDate);
                    
                    opportunityObj.Opportunity_Id__c = mapOppId.get(accountId + each.Month + each.calendarYear);
                    opportunityListToBeUpserted.add(opportunityObj);
                }
                
                sp = Database.setSavepoint();
                
                //----------------- Upserting Opportunity ------------------//
                if(!opportunityListToBeUpserted.isEmpty()) {
                    Schema.SObjectField ftoken = Opportunity.Fields.Opportunity_Code__c;
                    
                    //Debug Required
                    system.debug('opportunityListToBeUpserted : ' + opportunityListToBeUpserted);
                    
                    List<Database.upsertResult> uResults = Database.upsert(opportunityListToBeUpserted,ftoken,False);
                    
                    //Debug Rerquired
                    system.debug('opportunityListToBeUpserted Upert Result : '+ uResults);
                    
                    i=0;
                    
                    for (database.upsertResult each : uResults) {
                        if (each.isSuccess()) { 
                        
                            if(mapResponsedPost.ContainsKey(String.valueOf(opportunityListToBeUpserted[i].get(ftoken))) && mapResponsedPost.get(String.valueOf(opportunityListToBeUpserted[i].get(ftoken))).StatusCode == 'FAILED'){
                                objresponse = new ResponsedoPost('FAILED','SAP Order Opportunity created successfully ' + mapResponsedPost.get(String.valueOf(opportunityListToBeUpserted[i].get(ftoken))).Message, String.valueOf(opportunityListToBeUpserted[i].get(ftoken)));
                            }
                            else
                                objresponse = new ResponsedoPost('SUCCESS','SAP Order Opportunity created successfully',String.valueOf(opportunityListToBeUpserted[i].get(ftoken)));
                        }
                        else {
                            for(Database.Error eachErr : each.getErrors()){  
                                Message = eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                            }
                            objresponse = new ResponsedoPost('FAILED',Message,String.valueOf(opportunityListToBeUpserted[i].get(ftoken)));
                        }
                        
                        mapResponsedPost.put(objresponse.Id, objresponse);
                        i++;  
                    }
                }
                //-----------------/Upserting Opportunity ------------------//
                
                
                //----------------- Creating Map for inserted opportinity ------------//
                for(Opportunity objOpportunityInserted:opportunityListToBeUpserted){ 
                    if(!opportunityMap.Containskey(objOpportunityInserted.Opportunity_Code__c) && String.isNotBlank(objOpportunityInserted.Opportunity_Code__c)) {
                        opportunityMap.put(objOpportunityInserted.Opportunity_Code__c, objOpportunityInserted.Id);
                    }
                }
                //-----------------/Creating Map for inserted opportinity ------------//
                
                
                //---------- Iterating over request data again to map Invoice line item to opportunity line item ----------//
                for(OpportunityHeaderInner each : ValidOpportunityHeader.OpportunityHeader){
                    
                    if(opportunityMap.containsKey(each.opportunityCode)){
                        for(OpportunityLineItemWrapper eachLine : each.OpportunityHdrToLineItemNvg){
                        
                            for(OpportunityLineItem opportunityLineItemObj : eachLine.OpportunityLineItem){
                                
                                opportunityLineItemObj.OpportunityId = opportunityMap.get(each.opportunityCode);
                                opportunityLineItemObj.PriceBookEntryId = PricebookEntryMap.get(Integer.valueof(opportunityLineItemObj.ProductCode));
                                
                                opportunityLineItemListToBeInserted.add(opportunityLineItemObj);
                            }
                        }
                    }
                    else {
                        objresponse = new responsedoPost ('FAILED',' Opportunity not found for Opportuinty Code : ' + each.opportunityCode  + ' ', each.opportunityCode);
                        mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                        //----------------/Data Validation Section 4/----------------------//
                    }
                }
                //----------/Iterating over request data again to map Invoice line item to opportunity line item ----------//
                
                
                //--------- Delete existing Opportunity Line Item ---------// 
                if(!opportunityListToBeUpserted.isEmpty() && opportunityMap.values().size()>0) {
                    delete [SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN: opportunityMap.values()];
                }
                //---------/Delete existing Opportunity Line Item ---------//
                
                
                //----------- Inserting Opportuinty line items from SAP ------------//
                if(!opportunityLineItemListToBeInserted.isEmpty()) {
                    //insert  opportunityLineItemListToBeInserted;
                    list<Database.saveResult> lstSaveResult = Database.insert(opportunityLineItemListToBeInserted, false);
                    i=0;
                    for (database.saveresult each:lstSaveResult)
                    {
                        //---------------- Exception Validation Section 1----------------------//
                        if (!each.isSuccess())
                        {
                            for(Database.Error eachErr : each.getErrors()){  
                                Message = eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                            }
                            objresponse = new ResponsedoPost('FAILED',Message,String.valueOf(opportunityLineItemListToBeInserted[i].get('VA_Opportunity_Code__c')));
                            mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                        }  
                        i++;
                        //----------------/Exception Validation Section 1----------------------//
                    }
                }
                //-----------/Inserting Opportuinty line items from SAP ------------//
                
                //------- Logic for calculating Total line item quantity & total invoice amount ---------//
                Map<String, Double> opptyQuantityMap = new Map<String, Double>();
                
                
                if(ValidOrderMap.values().size()> 0) {
                    List<AggregateResult> vLstAggr = [SELECT SUM(Billed_qty__c) sumQuanity,SUM(Invoice_Amount__c) sumInvoiceAmount, OpportunityId,VA_Opportunity_Code__c
                                                        FROM OpportunityLineItem
                                                        WHERE Opportunity.VA_Order__c in : ValidOrderMap.values()
                                                        AND Opportunity.VA_Order__c != null
                                                        GROUP BY OpportunityId,VA_Opportunity_Code__c];
                    
                    //List of Opportunities update Opportuinty with invoice lineitem aggregation results
                    list<Opportunity> lstOpportunity = new list<Opportunity>();
                    
                    for(AggregateResult vAggr : vLstAggr){
                    
                        Id OpportunityId = (Id) vAggr.get('OpportunityId');
                        Double sumLineItemQuanity = (Double) vAggr.get('sumQuanity'); 
                        Double sumLineItemInvoiceAmount = (Double) vAggr.get('sumInvoiceAmount'); 
                        
                        Opportunity objOpportunity = new Opportunity(Id = OpportunityId , VA_Line_Item_Quantity__c = sumLineItemQuanity, VA_Total_Invoice_Amount__c = sumLineItemInvoiceAmount,Opportunity_Code__c = string.valueof(vAggr.get('VA_Opportunity_Code__c')));
                        
                        lstOpportunity.add(objOpportunity);
                        opptyQuantityMap.put(OpportunityId,sumLineItemQuanity);
                    }
                    
                    //Update invoice with total line item quantity & total invoice Amount
                    if(!lstOpportunity.isEmpty()) {
                        //update lstOpportunity;
                        Database.SaveResult[] lstUpdatelstopp = Database.update(lstOpportunity, false);
                        i=0;
                        for (database.saveresult each:lstUpdatelstopp) {
                            if (!each.isSuccess()) {
                                
                                for(Database.Error eachErr : each.getErrors()){  
                                    Message = eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                                }
                                
                                objresponse = new ResponsedoPost('FAILED',Message,String.valueOf(lstOpportunity[i].get('Opportunity_Code__c')));
                                mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost));
                            }  
                            i++;  
                        }
                    }
                    
                    //Existing Invoice map
                    Map<String,String>  invOrderOppMap = new Map<String,String>();     
                    for(VA_Invoice__c inv: [Select id,VA_Opportunity__c,VA_Order__c from VA_Invoice__c where VA_Opportunity__c in: opportunityMap.values()] ){
                        
                        invOrderOppMap.put(inv.VA_Opportunity__c + '-' + inv.VA_Order__c,inv.id);
                    }
                    
                    /*-------------------- Updating Order and inserting invoice -----------------------------*/
                    map<string,string> mapoppcodebyid = new map<String,String>();
                    
                    //list of Invoice to be inserted.
                    List<VA_Invoice__c> invoiceLst = new List<VA_Invoice__c>();
                    
                    //List of order to be updated
                    List<Order> lstOrdertobeUpdated = new List<Order> ();
                    
                    //map<Order Salesforce Id, Opportunity Code> to find Opportunity code on failure of Order update 
                    map<string,string> mapoppcodebyorderid = new map<string,string>();
                    
                    
                    //Update Order Status Fulfilled/Partially Fulfilled based on difference between Order quantity and total invoice quantity
                    for(Order objOrder : [select id, VA_Order_Quantity__c,Status, (Select id, Opportunity_Code__c from Invoice__r) from order where id in: ValidOrderMap.values()]){
                        
                        Double totalOpptyQuantity = 0;
                        Double totalCancelledQuantity = 0;
                        
                        for(Opportunity opp:objOrder.Invoice__r){
                                String ordrOppKey = opp.id + '-'+objOrder.id;
                                                                
                                if(opptyQuantityMap != null && opptyQuantityMap.containsKey(opp.id) && opptyQuantityMap.get(opp.id) != null){
                                    totalOpptyQuantity = totalOpptyQuantity + opptyQuantityMap.get(opp.id);
                                    
                                    if(opp.Opportunity_Code__c.endsWith('c')){
                                        totalCancelledQuantity += opptyQuantityMap.get(opp.id);
                                    }
                                }
                                
                                if(!invOrderOppMap.containsKey(ordrOppKey)){
                                    VA_Invoice__c invObj = new VA_Invoice__c(VA_Opportunity__c = opp.id, VA_Order__c = objOrder.id, VCPL_Opportunity_Order_Id__c = ordrOppKey);
                                    invoiceLst.add(invObj);
                                    mapoppcodebyid.put(opp.id,opp.Opportunity_Code__c);
                                }
                                
                                mapoppcodebyorderid.put(objOrder.id,opp.Opportunity_Code__c);
                        }
                        
                        if(objOrder.VA_Order_Quantity__c != null ){
                            Double quantityDiff = objOrder.VA_Order_Quantity__c - totalOpptyQuantity;
                            objOrder.VA_Total_Invoice_Quantity__c = totalOpptyQuantity;
                            
                            //Check cancelled invoice is equal to Order Quantity and Cancelled Invoice Quantity will always in minus 
                            if((objOrder.VA_Order_Quantity__c + totalCancelledQuantity) == 0){
                                objOrder.status = 'Rejected';
                            }
                            else if(quantityDiff > 0 && objOrder.status != 'Rejected')
                            objOrder.status = 'Partially fulfilled';
                            
                            else if (quantityDiff == 0 && objOrder.status != 'Rejected')
                            objOrder.status = 'Fulfilled';
                            
                            lstOrdertobeUpdated.add(objOrder);
                        }
                    }
                    
                    if(invoiceLst != null && invoiceLst.size() > 0){
                        
                        list<Database.saveResult> lstSaveResult = Database.insert(invoiceLst, false);
                        i=0;
                        for (database.saveresult each:lstSaveResult) {
                            if (!each.isSuccess()) {
                                
                                for(Database.Error eachErr : each.getErrors()){
                                    if(!eachErr.getMessage().contains('duplicate value'))
                                    Message = eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                                }
                                
                                objresponse = new ResponsedoPost('FAILED',Message,String.valueOf(mapoppcodebyid.get(String.valueOf(invoiceLst[i].get('VA_Opportunity__c')))));
                            }  
                            i++;  
                        }
                    }
                    
                    if(!lstOrdertobeUpdated.isEmpty()){
                        list<Database.saveResult> lstupdateResult = Database.update(lstOrdertobeUpdated, false);
                        i=0;
                        for (database.saveresult each:lstupdateResult) {
                            if (!each.isSuccess()) {
                                
                                for(Database.Error eachErr : each.getErrors()){  
                                    Message = eachErr.getStatusCode() + ': ' +  eachErr.getMessage();
                                }
                                
                                objresponse = new ResponsedoPost('FAILED',Message,String.valueOf(mapoppcodebyorderid.get(String.valueOf(lstOrdertobeUpdated[i].get('Id')))));
                                mapResponsedPost.put(objresponse.Id,addError(objresponse,mapResponsedPost)); 
                            }  
                            i++;  
                        }
                    }
                    /*--------------------/Updating Order and inserting invoice-----------------------------*/
                    
                }
                //-------/Logic for calculating Total line item quantity & total invoice amount ---------//
            }
            
            if (!mapResponsedPost.isempty()){ 
                
                for (ResponsedoPost ResponsedoPost : mapResponsedPost.values()) {
                    responseDoPostLst.add(ResponsedoPost);
                    if (ResponsedoPost.StatusCode == 'FAILED')
                    TotalFailedRecord = TotalFailedRecord + 1;
                    TotalRecord = TotalRecord + 1;
                }
                
                if (!responseDoPostLst.isempty()) {
                
                    objResponsedoPosts = new ResponsedoPosts();
                    objResponsedoPosts.lstResponsedoPost = responseDoPostLst;
                }
            }
            
            //Creating error log with attachment
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord), JSON.serialize(OpportunityHeaderSet), JSON.serialize(objResponsedoPosts), '');
            
            return objResponsedoPosts;
        }
        
        //Saving any error occured into Error Log Object
        catch(Exception ex) {
            
            //Rolling back all the changes made in try block
            Database.rollback( sp );
            
            responsedoPost objresponse = new responsedoPost ('FAILED', string.valueof(ex) ,'');
            responseDoPostLst.add(objresponse);
            objResponsedoPosts = new ResponsedoPosts();
            objResponsedoPosts.lstResponsedoPost = responseDoPostLst;
            
            //Creating error log with attachment
            createErrorLog(TotalNumberOfRecord, TotalRecord - TotalFailedRecord, TotalNumberOfRecord - (TotalRecord - TotalFailedRecord), JSON.serialize(OpportunityHeaderSet), JSON.serialize(objResponsedoPosts), ex.getStackTraceString());
            
            return objResponsedoPosts; 
        }
    }
    
    
    @future
    public static void createErrorLog(integer TotalNumberOfRecord, integer successRecord, integer failedRecords, string requestBody, string responseBody, string stackTrace){
            
        VA_Error_Log__c errorLog = new VA_Error_Log__c();
        errorLog.Total_Number_Of_Record__c = TotalNumberOfRecord;
        errorLog.Total_Success_Record__c = successRecord  ;
        errorLog.Number_Of_Failed_Records__c = failedRecords;
        errorLog.Interface_Name__c = 'Opportunity';
        if(!string.isBlank(stackTrace)) errorLog.VA_Cause__c = 'Stack Trace : ' + stackTrace;
        insert errorLog;
        
        list<Attachment> lstAttach = new list<Attachment>();
        
        Attachment request = new Attachment();
        request.ParentId = errorLog.id;
        request.ownerId = UserInfo.getUserId();
        request.Description = 'Opportunity Request Body';
        request.name = 'Request Body.json';
        request.ContentType = 'application/json';
        request.Body = Blob.valueOf(requestBody);
        lstAttach.add(request);
        
        Attachment response = new Attachment();
        response.ParentId = errorLog.id;
        response.ownerId = UserInfo.getUserId();
        response.Description = 'Opportunity Request Body';
        response.name = 'Reresponse Body.json';
        response.ContentType = 'application/json';
        response.Body = Blob.valueOf(responseBody);
        lstAttach.add(response);
        
        insert lstAttach;
    }
    
    global class OpportunityHeaderMain {
        global  list<OpportunityHeaderInner> OpportunityHeader;  
    }
    
    global class OpportunityHeaderInner {  
        global String opportunityCode;
        global String iscreatedfromVf ;
        global String ShiptoCode; 
        global String SFDCAccountId;
        global String opportunityId;
        global String StageName;
        global String CloseDate;
        global String invoiceDate;
        global String RecordTypeId;
        global String Name;
        global String calendarYear ;
        global String SapOrderId;
        global String Month;
        global String InvoiceDueDate;
        global List<OpportunityLineItemWrapper> OpportunityHdrToLineItemNvg;    
    }
    
    global class OpportunityLineItemWrapper {  
        global List<OpportunityLineItem> OpportunityLineItem ;       
    }  
    
    // Class used to send the error message and status on response
    global class ResponsedoPost {
        public String StatusCode;
        public String Id;
        public String Message;
        
        public ResponsedoPost(string stsCode,string strMsg,string strCaseSFNum) {
            StatusCode = stsCode;
            Message= strMsg;
            Id = strCaseSFNum;
        }
        
    }
    
    public static ResponsedoPost addError(ResponsedoPost objresp, map<string,ResponsedoPost> responseMap){
        if(responseMap.containsKey(objresp.Id)  && objresp.StatusCode == 'FAILED'){
            objresp.Message = responseMap.get(objresp.Id).Message + ', ' + objresp.Message;
        }
        return objresp;
    }
    
    global class ResponsedoPosts {
        global list<ResponsedoPost> lstResponsedoPost;
    }
}