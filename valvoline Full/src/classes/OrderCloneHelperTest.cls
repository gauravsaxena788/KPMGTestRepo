@istest 
public class OrderCloneHelperTest 
{
     
    static testmethod void clonetest()
    {
        Test.startTest();
        
        Account acc = VA_utilClass.createAccount();
        acc.Ship_to_Code__c='sw1234';
        insert acc; 
        
        Contact con = new Contact();
        con.FirstName = 'Test';
        con.LastName = 'Test';
        con.AccountId = acc.Id;
        
        insert con;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        pb22.IsActive= true;
        //pb22.IsStandard =true;
          insert pb22;

                           
        Order od = new Order();
         od.AccountId=acc.Id; 
         od.Name = 'TestClass Od1';
         od.EffectiveDate= system.today()-10;
         od.VA_Delivery_Address__c= 'test';
         od.PoNumber= 'test';
         od.status= 'Draft';
         od.PoDate= system.today();
         od.Pricebook2Id = pb22.Id ;
         
         insert od;               
         


        Product2 prod = VA_utilClass.createProduct();
        insert prod;
   
        Id newpricebookId = Test.getStandardPricebookId();
        
         
        Order od2 = new Order();
         od2.AccountId=acc.Id; 
         od2.Name = 'TestClass Od2';
         od2.EffectiveDate= system.today()-10;
         od2.VA_Delivery_Address__c= 'test2';
         od2.PoNumber= 'test2';
         od2.status= 'Draft';
         od2.PoDate= system.today();
         od2.Pricebook2Id = newpricebookId ;
         
         insert od2;
        
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = newpricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
                       
         OrderItem otItem = new OrderItem();
         otItem.OrderId = od2.Id;
         otItem.UnitPrice = 10;
         otItem.Quantity = 10;
         otItem.Product2Id = prod.Id;
         otItem.PricebookEntryId = standardPrice.Id;
         insert otItem;
        
        Date dt = system.today();
        string posdate = dt.Year()+'-'+dt.Month()+'-'+dt.Day();
        string effectivedate = dt.Year()+'-'+dt.Month()+'-'+dt.Day();
         
        Order od1 = new Order();
        od1.AccountId=acc.Id; 
        od1.Name = 'TestClass Od3';
        od1.EffectiveDate= Date.valueOf(effectivedate);
        od1.VA_Delivery_Address__c= 'test3';
        od1.PoNumber= 'test3';
        od1.status= 'Draft';
        od1.PoDate= Date.valueOf(posdate);
        od1.Pricebook2Id = newpricebookId ;
        insert od1; 
                
        OrderCloneHelper.createOrderClone(od2.Id, posdate, effectivedate, '123', 'Test');       
        OrderCloneHelper.getDetailsFromOrder(od2.Id);
        OrderCloneHelper.getupdateOrderPriceBook(od2.Id);
        OrderCloneHelper.getcloneChildRecords(od1.Id, od2.Id);
        Test.stopTest();

     }
}