public without sharing class VA_OrderProductController 
{
	@AuraEnabled
    public static list<OrderItem> getOrderProducts(Id OrderId)
    {
        
    	return [select Id,Product2.Name,Quantity, UnitPrice,OrderId,VA_Type__c  from OrderItem 
                                                where OrderId=:OrderId];
    }
}