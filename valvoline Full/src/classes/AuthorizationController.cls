Public class AuthorizationController{
 public string authCode{get;set;}
 
 public PageReference getAuthorizationCode(){
    PageReference pageRef = new PageReference('https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9CEn_O3jvv0x7vniRNIxOCHRjBk3LrNNFtjXtL1B5KZYAMzJRV5JDZHYtiW8IISxOgSXlOhtUckxfO37.&redirect_uri=https://google.com&state=mystate');
    pageRef.setRedirect(true);
    return pageRef;
 }
 
 public void makeCallout(){
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://login.salesforce.com?grant_type=password&client_id=3MVG9Yb5IgqnkB4oOOcJ4vPEeMgi6wuapiKF7wh2.__M88JdIinE8Z82x4SpGQzsymXUeXM.jo7qkid12_82F&client_secret=3322591688046586595&username=phase2@valvolinecummins.com.partialcpy&password=Vcpl@1234');
    request.setMethod('POST');
    //request.setHeader('Content-Type', 'application/json;charset=UTF-8');
// Set the body as a JSON object
    //request.setBody('{"name":"mighty moose"}');
    HttpResponse response = http.send(request);
  }
}