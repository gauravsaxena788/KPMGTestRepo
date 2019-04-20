@isTest
public class VA_ContentDocumentLinkHandlerTracker{

    private static testMethod void testmethod1(){
        VA_IntegrationUtility__c objIU = new VA_IntegrationUtility__c();
        objIU.Name = 'Loaction';
        objIU.VA_EndPoint__c ='https://oauthasservices-c28b54e4b.ap1.hana.ondemand.com/oauth2/api/v1/token?grant_type=client_credentials';
        objIU.VA_FinalEndPoint__c ='https://l6349-iflmap.hcisbp.ap1.hana.ondemand.com/http/sfdcpodimage';
        objIU.VA_MethodType__c = 'POST';
        objIU.VA_Password__c ='Vcpl@123';
        objIU.VA_UserName__c = '5f351f71-923f-3008-b66d-d3813fa7dd66';
        insert objIU;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test","accessToken":"ADAFSVgju242557431dfdxdfbgcbg"}');
        res.setStatusCode(200);
        
        
        Account objAcc = VA_utilClass.createAccount();
        objAcc.VA_POST_Allowed__c = 'Yes';
        insert objAcc;
        ContentVersion objConVer =  VA_utilClass.createContentVersion();
        insert objConVer ;
        Order objOrder = VA_utilClass.createOrder(objAcc.Id);
        insert objOrder ;
        Opportunity objOpp =  VA_utilClass.createOpportunity(objAcc.Id, objOrder.Id);
        objOpp.StageName = 'Market Platform';
        insert objOpp ;
        VA_Invoice__c objInv = VA_utilClass.createInvoice(objOpp.Id, objOrder.Id);
        insert objInv ;
        
        ContentDocumentLink objContDoc = VA_utilClass.createContentDocumentLink(objConVer.Id,objInv.Id);
        insert objContDoc;
    }
}