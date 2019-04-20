public class OrderCloneHelper {
    
    public Static Date podate {get;set;}
    public Static Date orderstartdate {get;set;}
    
   @AuraEnabled
   public static String currentloggedinUser()
   {
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        return PROFILE[0].Name;    
   }
    
    
    @AuraEnabled
    public static Order getDetailsFromOrder(String orderId){
        
        Order orderList = [SELECT Id, Name, Pricebook2Id, AccountId, Status, EffectiveDate, PoDate, PoNumber, VA_Delivery_Address__c FROM Order WHERE Id=:orderId limit 1];
        
        return orderList;
    }
    
    @AuraEnabled
    public static String createOrderClone(String orderId, String posdate, String effectivedate, String ponumber, String deliveryaddress)
    {
        try{   
            system.debug('call create method');
            
            podate = Date.valueOf(posdate);
            orderstartdate = Date.valueOf(effectivedate);
            
            /*if(Date.valueOf(qvalidtill)<system.today())
            {
                return 'Invalid Date';
            }*/
                        
            Order orderList = [SELECT Id, Name, AccountId, Pricebook2Id, PoNumber, Status, EffectiveDate, PoDate, VA_Delivery_Address__c  
                               FROM Order WHERE Id=:orderId limit 1];
            system.debug(' my order list: '+orderList);
            Order orderClone = orderList.clone(false,false,false,false);
                        
            orderClone.EffectiveDate = Date.valueOf(orderstartdate);
            orderClone.PoDate = Date.valueOf(podate);
            orderClone.VA_Delivery_Address__c = deliveryaddress;
            orderClone.PoNumber = ponumber;
            orderClone.Status = 'Draft'; 
            insert orderClone;
            System.debug('orderClone:'+orderClone);
            getupdateOrderPriceBook(orderClone.Id);
            getcloneChildRecords(orderId, orderClone.Id);
            system.debug('Order Clone: '+orderClone);
            return orderClone.Id;
        }
        catch(exception e)
        {
            return e.getMessage();
        }
    }
   
  @AuraEnabled
    public static String getcloneChildRecords(String orderId, String clonedOrderId)
    {
        Map<Id, Id> ProductandPriceBookMap = new Map<Id, Id>();
        
        List<PriceBookEntry> pbEntyList = [Select Id, PriceBook2.Name, Product2.Id, Product2.Name, Name 
                                        FROM PricebookEntry 
                                        WHERE  PriceBook2.Name = 'Standard Price Book' LIMIT 50000];
         for(PriceBookEntry pbeList: pbEntyList)
         {
             ProductandPriceBookMap.put(pbeList.Product2Id, pbeList.Id);
         }
        
        List<OrderItem> opList = new List<OrderItem>();
        
                    
        for(OrderItem op: [Select Id, Product2Id, OrderId, TotalPrice, VA_Delivery_Quantity__c, UnitPrice, VA_Billing_Block__c, Quantity, VA_Reason_for_Rejection__c, VA_SFDC_Order_Number__c, VA_SAP_Order_Id__c, VA_SFDC_Order_Line_Item_Number__c, VA_Material_SKU__c, VA_Type__c, VA_Is_FreeGoods__c, VA_Status__c, Requested_Total_Price__c, VA_Confirmed_Price__c from OrderItem
                              Where OrderId=:orderId])
        {
            OrderItem opItemClone = op.clone(false,false,false,false);
            opItemClone.OrderId = clonedOrderId;
            opItemClone.UnitPrice = op.UnitPrice;
            opItemClone.Quantity = op.Quantity;
            opItemClone.PriceBookEntryId = ProductandPriceBookMap.get(opItemClone.Product2Id);
            
            opList.add(opItemClone);
        }

       
         
        if(opList.size()>0)
        {
            insert opList;
            System.debug('OrderItemList:'+opList);
            
        }
        
        
        return '';
    }
    
    // Update Standard price book for Order
    public static void getupdateOrderPriceBook(String oId)
    {        
        List<PriceBook2> priceBookList = [select id from Pricebook2 where IsStandard = TRUE];
         system.debug('Price Book List: '+priceBookList);
         if(!priceBookList.isEmpty())
         {
              List<Order> oList = [select Id, PriceBook2Id from Order where Id=:oId];
              system.debug('Order List: '+oList);
              for(Order o: oList)
              {
                  o.PriceBook2Id = priceBookList[0].Id;
              }
              update oList;
              system.debug('oList: '+oList);
         }
    }
    
}