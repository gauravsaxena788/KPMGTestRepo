@istest
public class FileControllerTest{

@testSetup
    static void setupTestData(){
       
    
    }
    public static testmethod void FileControllermethod(){
    
        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        Opportunity objOpportunity = VA_utilClass.createOpportunity (objAccount.id, objOrder.id);
        insert objOpportunity;
        
        VA_Invoice__c  objInvoice = VA_utilClass.createInvoice (objOpportunity.id, objOrder.id);
        insert objInvoice ;
        ContentVersion objContentVersion =  VA_utilClass.createContentVersion();
        insert objContentVersion ;
        
        ContentDocumentLink objContentDocumentLink = VA_utilClass.createContentDocumentLink(objContentVersion.id, objInvoice .id);
        insert objContentDocumentLink ;
        
      
        test.startTest();
        
        
        FileController.saveTheChunk(objInvoice.id,objContentVersion.title, 'test', 'image/jpg', objContentVersion.id);
        
        
        test.stopTest();
    }
    
    public static testmethod void FileControllermethod1(){

        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        Opportunity objOpportunity = VA_utilClass.createOpportunity (objAccount.id, objOrder.id);
        insert objOpportunity;
        
        VA_Invoice__c  objInvoice = VA_utilClass.createInvoice (objOpportunity.id, objOrder.id);
        insert objInvoice ;
        ContentVersion objContentVersion =  VA_utilClass.createContentVersion();
        insert objContentVersion ;
        
        ContentDocumentLink objContentDocumentLink = VA_utilClass.createContentDocumentLink(objContentVersion.id, objInvoice .id);
        insert objContentDocumentLink ;
        
      
        test.startTest();
        
        
        FileController.saveTheFile(objInvoice.id,objContentVersion.title, 'test', 'image/jpg');
        
        
        test.stopTest();
    }
    
    public static testmethod void FileControllermethod2(){

        Account objAccount = VA_utilClass.createAccount();
        insert objAccount ;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        Opportunity objOpportunity = VA_utilClass.createOpportunity (objAccount.id, objOrder.id);
        insert objOpportunity;
        
        VA_Invoice__c  objInvoice = VA_utilClass.createInvoice (objOpportunity.id, objOrder.id);
        insert objInvoice ;
        
      
        test.startTest();
        
        
        FileController.updateCheck(objInvoice.id);
        
        
        test.stopTest();
    }
   
}