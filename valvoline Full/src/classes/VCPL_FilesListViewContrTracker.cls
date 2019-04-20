@isTest
public Class VCPL_FilesListViewContrTracker{

    private Static Testmethod void TestClass(){
        Account objAcc = VA_utilClass.createAccount();
        objAcc.VA_POST_Allowed__c = 'Yes';
        insert objAcc;
        ContentVersion objConVer =  VA_utilClass.createContentVersion();
        insert objConVer ;
        
        ContentDocumentLink objContDoc = VA_utilClass.createContentDocumentLink(objConVer.Id,objAcc.Id);
        insert objContDoc;
        
        List<ContentVersion> lstConDoclink = VCPL_FilesListViewController.getFilelist(String.valueOf(objAcc.Id)); 
        VA_WrapperofImage objWrapImage = VCPL_FilesListViewController.returnBlobValue(String.valueOf(objConVer.Id));
        Contact objContact = VA_utilClass.createContact(objAcc.Id);
        insert objContact ;
        Case objCase = VA_utilClass.createPostTestCase(); 
        objCase.ContactId = objContact .Id;
        insert objCase;
        Order objOrder = VA_utilClass.createOrder(objAcc.Id);
        insert objOrder ;
        Opportunity objOpp =  VA_utilClass.createOpportunity(objAcc.Id, objOrder.Id);
        objOpp.StageName = 'Market Platform';
        insert objOpp ;
        VA_Invoice__c objInv = VA_utilClass.createInvoice(objOpp.Id, objOrder.Id);
        insert objInv ;
        
        sObject objSobCase = VCPL_FilesListViewController.GetsObjectData(objCase.id);
        sObject objSobInvoice = VCPL_FilesListViewController.GetsObjectData(objOrder.id);
        sObject objSobOrder = VCPL_FilesListViewController.GetsObjectData(objInv.id);
        
        VA_WrapperofImage objWrapImage1 = new VA_WrapperofImage();
        objWrapImage1.Name = 'test';
        objWrapImage1.encodeValue = 'Test';
        objWrapImage1.fileType = 'image';
        objWrapImage1.FileExtension = 'Test';
        
    }
}