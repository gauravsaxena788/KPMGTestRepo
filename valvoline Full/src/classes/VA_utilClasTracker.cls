@isTest(seeAllData = false)
public class VA_utilClasTracker 
{
	static testmethod void unitTest()
    {
        VA_utilClass.createUser();
        
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Contact objCpontact = VA_utilClass.createContact(objAccount.id);
        
        VA_utilClass.createProject(objAccount.id,objCpontact.id);
        
        VA_AccountStatement__c objAccountStatement = VA_utilClass.createAccountstatement(objAccount.Id);
        
        VA_utilClass.createAccount();
        
        VA_utilClass.createContentVersion();
        
        VA_utilClass.createproductCategory('TEST');
        
        VA_utilClass.createPostTestCase();
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        
        Product2 objProduct = VA_utilClass.createProduct();
        
        PricebookEntry objPB = VA_utilClass.createPriceBookEntry(objProduct.id);
        
        OrderItem objOrderItem = VA_utilClass.createOrderLineItem(objOrder.id,objProduct.id,objPB.id);
        
        Opportunity objOpp = VA_utilClass.createOpportunity(objAccount.id,objOrder.id);
        
        OpportunityLineItem obj = VA_utilClass.createOpportunityLineItem(objPB.id,objOpp.id,objProduct.Id);
        
        VA_utilClass.triggeronoff();
    }
}