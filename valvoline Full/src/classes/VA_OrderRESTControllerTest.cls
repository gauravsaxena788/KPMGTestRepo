@IsTest 
public class VA_OrderRESTControllerTest{ 
    @testSetup
    static void setupTestData(){

    }
        
    private static testmethod void orderRestMethod(){ 
        Double totalLineItemQuantity = 0;
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;

        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        objpriceBookEntry.SKU_ID__c = 123456;
        insert  objpriceBookEntry ;
        OrderItem  objOrderItem = VA_utilClass.createOrderLineItem(objOrder.Id, ObjProduct.id, objpriceBookEntry.id);
        insert objOrderItem ;
        //String messages = '';
        
        
        
        //List<Order> lstOrder = new List<Order>();
        
        List<OrderItem> lstOrderItem = new List<OrderItem>();
        lstOrderItem.add(objOrderItem);
        Map<String,Id> orderMap = new Map<String,Id>(); 
        //Map<String,Id> accountMap = new Map<String,Id>();
        //lstOrder.add(objOrder.id);
        
        
        test.startTest();
            totalLineItemQuantity = totalLineItemQuantity + objOrderItem.Quantity;
            List<VA_OrderRESTController.OrderItemWrapper>  lstOrderItemWrapper = new List<VA_OrderRESTController.OrderItemWrapper> ();
            VA_OrderRESTController.OrderItemWrapper objOrderItemWrapper = new VA_OrderRESTController.OrderItemWrapper();
            objOrderItemWrapper.OrderItem = lstOrderItem;
            
            Map<String,VA_DatabaseUtility.StatementResponse> response = new Map<String,VA_DatabaseUtility.StatementResponse>(); 
              
            orderMap.put(objOrder.VA_SFDC_Order_Number__c ,objOrder.Id);
            //accountMap.put(objOrder.Account.Ship_to_Code__c,objOrder.AccountId); 
            lstOrderItemWrapper.add(objOrderItemWrapper);
            List<VA_OrderRESTController.OrderWrapper> lstOrderWrapper = new List<VA_OrderRESTController.OrderWrapper>();
            VA_OrderRESTController.OrderWrapper objOrderWrapper = new VA_OrderRESTController.OrderWrapper();
            
            objOrderWrapper.Vbeln = objOrder.VA_SAP_Order_Id__c ;
            objOrderWrapper.Bstdk = String.valueof(objOrder.PoDate) ;
            objOrderWrapper.Bstnk = objOrder.PoNumber  ;
            objOrderWrapper.overalOrderRejection = objOrder.VA_Overall_Order_Rejection__c  ;
            objOrderWrapper.orderStartDate = objOrder.EffectiveDate ;
            objOrderWrapper.Kunwe = objOrder.VA_Ship_To_Code__c  ;
            objOrderWrapper.SFDCVbeln = objOrder.VA_SFDC_Order_Number__c  ;
            objOrderWrapper.Werks = objOrder.VA_Depot_Code__c  ;
            objOrderWrapper.OrderHdrToItemNvg = lstOrderItemWrapper ;
            lstOrderWrapper.add(objOrderWrapper);
            VA_OrderRESTController.OrderHeaderWrapper objheaderWrapper = new VA_OrderRESTController.OrderHeaderWrapper();
            objheaderWrapper.OrderHeader = lstOrderWrapper;
            VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
            VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
            List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
            objStatementResponse.Id = objOrder.VA_SAP_Order_Id__c;
            objStatementResponse.status = 'success';
            //List<String> messages = new List<String> ();
            //messages = 'success';
            objStatementResponse.Message = 'Success';
            lstStatementResponse.add(objStatementResponse);
            
            objasc.lstStatementResponse = lstStatementResponse;

            response.put(objOrder.VA_SAP_Order_Id__c,objStatementResponse);
            system.debug('@@'+response);
            system.debug('@@@objheaderWrapper '+objheaderWrapper );
            VA_OrderRESTController.doPost(objheaderWrapper);
        test.StopTest();
    }
    private static testmethod void orderRestMethod1(){
    
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount;
         Id standardPBID = Test.getStandardPricebookId(); 
        Order objOrder = new Order(VA_Delivery_Address__c= 'test', AccountID = objAccount.id, VA_SFDC_Order_Number__c = 'test011', EffectiveDate = system.today(),PoNumber = '123',VA_PO_Attached__c= true, Status = 'Rejected', Pricebook2Id = standardPBID, PoDate = system.today(), VA_Overall_Order_Rejection__c = 'test',  VA_Ship_To_Code__c= '123456', VA_Depot_Code__c = '12345');
        
        insert objOrder;
        
        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;


        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        objpriceBookEntry.SKU_ID__c = 123456;
        insert  objpriceBookEntry ;
        OrderItem  objOrderItem = VA_utilClass.createOrderLineItem(objOrder.Id, ObjProduct.id, objpriceBookEntry.id);
        insert objOrderItem ;
        
        
        //List<Order> lstOrder = new List<Order>();
        List<OrderItem> lstOrderItem = new List<OrderItem>();
        lstOrderItem.add(objOrderItem);
        //Map<String,Id> accountMap = new Map<String,Id>();
        //lstOrder.add(objOrder.id);
        
        test.startTest();
            List<VA_OrderRESTController.OrderItemWrapper>  lstOrderItemWrapper = new List<VA_OrderRESTController.OrderItemWrapper> ();
            VA_OrderRESTController.OrderItemWrapper objOrderItemWrapper = new VA_OrderRESTController.OrderItemWrapper();
            objOrderItemWrapper.OrderItem = lstOrderItem;
            
            Map<String,VA_DatabaseUtility.StatementResponse> response = new Map<String,VA_DatabaseUtility.StatementResponse>(); 
              
           
            //accountMap.put(objOrder.Account.Ship_to_Code__c,objOrder.AccountId); 
            lstOrderItemWrapper.add(objOrderItemWrapper);
            List<VA_OrderRESTController.OrderWrapper> lstOrderWrapper = new List<VA_OrderRESTController.OrderWrapper>();
            VA_OrderRESTController.OrderWrapper objOrderWrapper = new VA_OrderRESTController.OrderWrapper();
            
            objOrderWrapper.Vbeln = objOrder.VA_SAP_Order_Id__c ;
            objOrderWrapper.Bstdk = String.valueof(objOrder.PoDate) ;
            objOrderWrapper.Bstnk = objOrder.PoNumber  ;
            objOrderWrapper.overalOrderRejection = objOrder.VA_Overall_Order_Rejection__c  ;
            objOrderWrapper.orderStartDate = objOrder.EffectiveDate ;
            objOrderWrapper.Kunwe = objOrder.VA_Ship_To_Code__c  ;
            objOrderWrapper.SFDCVbeln = objOrder.VA_SFDC_Order_Number__c  ;
            objOrderWrapper.Werks = objOrder.VA_Depot_Code__c  ;
            objOrderWrapper.OrderHdrToItemNvg = lstOrderItemWrapper ;
            lstOrderWrapper.add(objOrderWrapper);
            VA_OrderRESTController.OrderHeaderWrapper objheaderWrapper = new VA_OrderRESTController.OrderHeaderWrapper();
            objheaderWrapper.OrderHeader = lstOrderWrapper;
            VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
            VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
            List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
            objStatementResponse.Id = objOrder.VA_SAP_Order_Id__c;
            objStatementResponse.status = 'success';
            List<String> messages = new List<String> ();
            //messages.add('success');
            objStatementResponse.Message = 'Success';
            lstStatementResponse.add(objStatementResponse);
            
            objasc.lstStatementResponse = lstStatementResponse;

            response.put(objOrder.VA_SAP_Order_Id__c,objStatementResponse);
            system.debug('@@'+response);
            system.debug('@@@objheaderWrapper '+objheaderWrapper );
            VA_OrderRESTController.doPost(objheaderWrapper);
        test.StopTest();
    }
    private static testmethod void orderRestMethod2(){
    
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount;
         Id standardPBID = Test.getStandardPricebookId(); 
        Order objOrder = new Order(VA_Delivery_Address__c= 'test', AccountID = objAccount.id, VA_SFDC_Order_Number__c = 'test011', EffectiveDate = system.today(),PoNumber = '123',VA_PO_Attached__c= true, Status = 'Rejected', Pricebook2Id = standardPBID, PoDate = system.today(), VA_Overall_Order_Rejection__c = 'test',  VA_SAP_Order_Id__c= '12345', VA_Depot_Code__c = '12345');
        
        insert objOrder;
        
        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;

        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        objpriceBookEntry.SKU_ID__c = 123456;
        insert  objpriceBookEntry ;
        
        OrderItem  objOrderItem = VA_utilClass.createOrderLineItem(objOrder.Id, ObjProduct.id, objpriceBookEntry.id);
        insert objOrderItem ;
        
        
        //List<Order> lstOrder = new List<Order>();
        List<OrderItem> lstOrderItem = new List<OrderItem>();
        lstOrderItem.add(objOrderItem);
        //Map<String,Id> accountMap = new Map<String,Id>();
        //lstOrder.add(objOrder.id);
        
        test.startTest();
            List<VA_OrderRESTController.OrderItemWrapper>  lstOrderItemWrapper = new List<VA_OrderRESTController.OrderItemWrapper> ();
            VA_OrderRESTController.OrderItemWrapper objOrderItemWrapper = new VA_OrderRESTController.OrderItemWrapper();
            objOrderItemWrapper.OrderItem = lstOrderItem;
            
            Map<String,VA_DatabaseUtility.StatementResponse> response = new Map<String,VA_DatabaseUtility.StatementResponse>(); 
              
           
            //accountMap.put(objOrder.Account.Ship_to_Code__c,objOrder.AccountId); 
            lstOrderItemWrapper.add(objOrderItemWrapper);
            List<VA_OrderRESTController.OrderWrapper> lstOrderWrapper = new List<VA_OrderRESTController.OrderWrapper>();
            VA_OrderRESTController.OrderWrapper objOrderWrapper = new VA_OrderRESTController.OrderWrapper();
            
            objOrderWrapper.Vbeln = objOrder.VA_SAP_Order_Id__c ;
            objOrderWrapper.Bstdk = String.valueof(objOrder.PoDate) ;
            objOrderWrapper.Bstnk = objOrder.PoNumber  ;
            objOrderWrapper.overalOrderRejection = objOrder.VA_Overall_Order_Rejection__c  ;
            objOrderWrapper.orderStartDate = objOrder.EffectiveDate ;
            objOrderWrapper.Kunwe = objOrder.VA_Ship_To_Code__c  ;
            objOrderWrapper.SFDCVbeln = objOrder.VA_SFDC_Order_Number__c  ;
            objOrderWrapper.Werks = objOrder.VA_Depot_Code__c  ;
            objOrderWrapper.OrderHdrToItemNvg = lstOrderItemWrapper ;
            lstOrderWrapper.add(objOrderWrapper);
            VA_OrderRESTController.OrderHeaderWrapper objheaderWrapper = new VA_OrderRESTController.OrderHeaderWrapper();
            objheaderWrapper.OrderHeader = lstOrderWrapper;
            VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
            VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
            List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
            objStatementResponse.Id = objOrder.VA_SAP_Order_Id__c;
            objStatementResponse.status = 'success';
            List<String> messages = new List<String> ();
            //messages.add('success');
            objStatementResponse.Message = 'Success';
            lstStatementResponse.add(objStatementResponse);
            
            objasc.lstStatementResponse = lstStatementResponse;

            response.put(objOrder.VA_SAP_Order_Id__c,objStatementResponse);
            system.debug('@@'+response);
            system.debug('@@@objheaderWrapper '+objheaderWrapper );
            VA_OrderRESTController.doPost(objheaderWrapper);
        test.StopTest();
    }
    private static testmethod void orderRestMethod3(){
    
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount;
         Id standardPBID = Test.getStandardPricebookId(); 
        Order objOrder = new Order(VA_Delivery_Address__c= 'test', AccountID = objAccount.id, VA_SFDC_Order_Number__c = 'test011', EffectiveDate = system.today(),PoNumber = '123',VA_PO_Attached__c= true, Status = 'Rejected', Pricebook2Id = standardPBID, PoDate = system.today(), VA_Overall_Order_Rejection__c = 'test',  VA_SAP_Order_Id__c= '12345', VA_Depot_Code__c = '12345');
        
        insert objOrder;
        
        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;

        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        objpriceBookEntry.SKU_ID__c = 12345;
        insert  objpriceBookEntry ;
        
        OrderItem  objOrderItem = VA_utilClass.createOrderLineItem(objOrder.Id, ObjProduct.id, objpriceBookEntry.id);
        insert objOrderItem ;
        
        
        //List<Order> lstOrder = new List<Order>();
        List<OrderItem> lstOrderItem = new List<OrderItem>();
        lstOrderItem.add(objOrderItem);
        //Map<String,Id> accountMap = new Map<String,Id>();
        //lstOrder.add(objOrder.id);
        
        test.startTest();
            List<VA_OrderRESTController.OrderItemWrapper>  lstOrderItemWrapper = new List<VA_OrderRESTController.OrderItemWrapper> ();
            VA_OrderRESTController.OrderItemWrapper objOrderItemWrapper = new VA_OrderRESTController.OrderItemWrapper();
            objOrderItemWrapper.OrderItem = lstOrderItem;
            
            Map<String,VA_DatabaseUtility.StatementResponse> response = new Map<String,VA_DatabaseUtility.StatementResponse>(); 
              
           
            //accountMap.put(objOrder.Account.Ship_to_Code__c,objOrder.AccountId); 
            lstOrderItemWrapper.add(objOrderItemWrapper);
            List<VA_OrderRESTController.OrderWrapper> lstOrderWrapper = new List<VA_OrderRESTController.OrderWrapper>();
            VA_OrderRESTController.OrderWrapper objOrderWrapper = new VA_OrderRESTController.OrderWrapper();
            
            objOrderWrapper.Vbeln = objOrder.VA_SAP_Order_Id__c ;
            objOrderWrapper.Bstdk = String.valueof(objOrder.PoDate) ;
            objOrderWrapper.Bstnk = objOrder.PoNumber  ;
            objOrderWrapper.overalOrderRejection = objOrder.VA_Overall_Order_Rejection__c  ;
            objOrderWrapper.orderStartDate = objOrder.EffectiveDate ;
            objOrderWrapper.Kunwe = objOrder.VA_Ship_To_Code__c  ;
            objOrderWrapper.SFDCVbeln = objOrder.VA_SFDC_Order_Number__c  ;
            objOrderWrapper.Werks = objOrder.VA_Depot_Code__c  ;
            objOrderWrapper.OrderHdrToItemNvg = lstOrderItemWrapper ;
            lstOrderWrapper.add(objOrderWrapper);
            VA_OrderRESTController.OrderHeaderWrapper objheaderWrapper = new VA_OrderRESTController.OrderHeaderWrapper();
            objheaderWrapper.OrderHeader = lstOrderWrapper;
            VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
            VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
            List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
            objStatementResponse.Id = objOrder.VA_SAP_Order_Id__c;
            objStatementResponse.status = 'success';
            List<String> messages = new List<String> ();
            //messages.add('success');
            objStatementResponse.Message = 'Success';
            lstStatementResponse.add(objStatementResponse);
            
            objasc.lstStatementResponse = lstStatementResponse;

            response.put(objOrder.VA_SAP_Order_Id__c,objStatementResponse);
            system.debug('@@'+response);
            system.debug('@@@objheaderWrapper '+objheaderWrapper );
            VA_OrderRESTController.doPost(objheaderWrapper);
        test.StopTest();
    }
    
    
    }