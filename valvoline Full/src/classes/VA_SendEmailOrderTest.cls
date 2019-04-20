@IsTest 
public class VA_SendEmailOrderTest{ 
    @testSetup
    static void setupTestData(){
        //VA_utilClass.createEmailTemplate();
       
        
        Account objAccount = VA_utilClass.createAccount();
        objAccount.Account_Type__c ='Service Network';
        insert objAccount;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        insert  objpriceBookEntry ;
        OrderItem  objOrderItem = VA_utilClass.createOrderLineItem(objOrder.Id, ObjProduct.id, objpriceBookEntry.id);
        insert objOrderItem ;
        ContentVersion objContentVersion = VA_utilClass.createContentVersion();
        insert objContentVersion ;
        ContentDocumentLink objContentDocumentLink = VA_utilClass.createContentDocumentLink(objContentVersion.id, objOrder.id);
        insert objContentDocumentLink ;
        
    }
        
    private static testmethod void sendEmailOrder(){ 
        List<String> lstOrder = new List<String>();
        Order objOrder = [select id,AccountId from Order Limit 1];
       
        lstOrder.add(objOrder.id);
        test.startTest();
            VA_SendEmailOrder.VA_SendEmailOrder(lstOrder);
            
        test.StopTest();
    }
    
     
    
    
    }