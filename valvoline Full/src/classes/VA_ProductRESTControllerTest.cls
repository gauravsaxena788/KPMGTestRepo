@IsTest 
public class VA_ProductRESTControllerTest{ 
    @testSetup
    static void setupTestData(){
        

        
    }
        
    public static testmethod void ProductRestMethod(){ 
        
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount;

        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;

        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        objpriceBookEntry.SKU_ID__c = 123456;
        insert  objpriceBookEntry ;
        
        
       
        test.startTest();
           
            List<VA_ProductRESTController.ProductWrapper> lstWrapper = new List<VA_ProductRESTController.ProductWrapper>();
            VA_ProductRESTController.ProductWrapper wrapper = new VA_ProductRESTController.ProductWrapper ();
            wrapper.productInstance = objProduct;
            lstWrapper.add(wrapper);
            VA_ProductRESTController.ProductRequest objRequest= new VA_ProductRESTController.ProductRequest();
            objRequest.proDataList = lstWrapper;
            
            VA_ProductRESTController.saveProducts(objRequest);
            VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
            VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
            List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
            objStatementResponse.Id = String.valueOf(objProduct.SKU_Id__c) ;
            objStatementResponse.status = 'success';
            //List<String> messages = new List<String> ();
            //messages.add('success');
            objStatementResponse.Message = 'success';
            lstStatementResponse.add(objStatementResponse);
            
            objasc.lstStatementResponse = lstStatementResponse;

        test.StopTest();
    }
    
    public static testmethod void ProductRestMethod1(){ 
        
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount;

        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;
        
        Id standardPBID = Test.getStandardPricebookId(); 
        
        PricebookEntry objpriceBookEntry = new PricebookEntry(
            Pricebook2Id = standardPBID , Product2Id = ObjProduct.id,
            UnitPrice = 10000, IsActive = true, SKU_Id__c= 0);
        insert  objpriceBookEntry ;
        
        
       
        test.startTest();
           
            List<VA_ProductRESTController.ProductWrapper> lstWrapper = new List<VA_ProductRESTController.ProductWrapper>();
            VA_ProductRESTController.ProductWrapper wrapper = new VA_ProductRESTController.ProductWrapper ();
            wrapper.productInstance = objProduct;
            lstWrapper.add(wrapper);
            VA_ProductRESTController.ProductRequest objRequest= new VA_ProductRESTController.ProductRequest();
            objRequest.proDataList = lstWrapper;
            
            VA_ProductRESTController.saveProducts(objRequest);
            VA_DatabaseUtility.StatementResponses objasc = new  VA_DatabaseUtility.StatementResponses();
            VA_DatabaseUtility.StatementResponse objStatementResponse = new VA_DatabaseUtility.StatementResponse();
            List<VA_DatabaseUtility.StatementResponse> lstStatementResponse= new List<VA_DatabaseUtility.StatementResponse>();
            objStatementResponse.Id = String.valueOf(objProduct.id) ;
            //objStatementResponse.status = 'success';
            //List<String> messages = new List<String> ();
            //messages.add('success');
            objStatementResponse.Message = 'success';
            lstStatementResponse.add(objStatementResponse);
            
            objasc.lstStatementResponse = lstStatementResponse;

        test.StopTest();
    }
    
    
   
}