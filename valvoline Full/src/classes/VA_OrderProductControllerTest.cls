@isTest
public class VA_OrderProductControllerTest{
    Static testMethod void testOrderProductMethod(){
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        Test.startTest();
        VA_OrderProductController.getOrderProducts(objOrder.id);
        Test.stopTest();
    }
}