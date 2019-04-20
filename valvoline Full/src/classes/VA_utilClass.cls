public class VA_utilClass{
    public static map<string,User> createUser(){
        map<string,User> mapProfileNameToUser = new map<string,User>();
        map<string,Id> mapRoleNameToId = new map<string,Id>();
        map<Id,string> mapProfileNameToId = new map<Id,string>();
        list<User> lstUser = new list<User>();
        integer i=0;
        
        for(UserRole obj : [select Id,Name from UserRole])
        {
            mapRoleNameToId.put(obj.Name,obj.Id);
        }
        for(Profile objP : [SELECT Id,Name FROM Profile where name = 'Lab Admin' ]){
        
            mapProfileNameToId.put(objP.Id,objP.Name);
            system.debug('@@mapProfileNameToId@@' + mapProfileNameToId);
            User objUser = new User();
            objUser.Alias = 'standt'+i;
            objUser.Email='standarduser@testorg.com';
            objUser.EmailEncodingKey='UTF-8';
            objUser.LastName='Testing';
            objUser.LanguageLocaleKey='en_US';
            objUser.LocaleSidKey='en_US'; 
            objUser.ProfileId = objP.Id;
            objUser.TimeZoneSidKey='America/Los_Angeles';
            objUser.UserName = 'gsdgsd'+i+'@ggd'+i+'.vom';
            //objUser.FederationIdentifier = '123';
            
            
            
            lstUser.add(objUser);
        }
        if(lstUser.size() > 0){
            insert lstUser;
            for(User obj : lstUser){
                if(mapProfileNameToId.get(obj.ProfileId)!= null)
                    mapProfileNameToUser.put(mapProfileNameToId.get(obj.ProfileId),obj);
            }
        }
        
        return mapProfileNameToUser;
    }
      
    public static VA_AccountStatement__c  createAccountstatement(id AccountId){

        VA_AccountStatement__c  objAccountStatement = new VA_AccountStatement__c ();
        
        Id recTypeId = Schema.SObjectType.VA_AccountStatement__c.getRecordTypeInfosByDeveloperName().get('Half_Yearly').getRecordTypeId();
        objAccountStatement.name = 'April-2018';
        objAccountStatement.recordTypeId = recTypeId ;
        objAccountStatement.VA_Year__c = '2018';
        objAccountStatement.VA_Month__c= 'January';
        Date dat = System.Today();
        string objdate = dat.format();    
       
        objAccountStatement.VA_From_Date__c =  date.newInstance(2018,07,01);
        objAccountStatement.VA_To_Date__c = date.newInstance(2018,07,01);
        system.debug('todate'+objAccountStatement.VA_To_Date__c);
        objAccountStatement.VA_Frequency__c = 'Monthly';
        objAccountStatement.VA_Account__c = AccountId;
        objAccountStatement.VA_Ship_To_Code__c = '123456';
        
            
        return objAccountStatement;
    }
    public static Account createAccount(){
        Account objAccount = new Account(Name='test',Is_Parent__c='N',Type='Factory Fill',Indutry_Segment__c='On-Highway',Market_Segment__c='PowerGen',Quote_allowed__c='Yes',BU_Name__c='OEM',Category__c='New',Accound_Aprroved__c=true,Account_Type__c='Factory Fill',Zone__c = 'North', Sold_to_code__c = '123456', Ship_to_Code__c= '123456', VA_OTC_Executive_Mail_Id__c = 'test@example.com', Payment_Term__c = 'cash');
        
        return objAccount;
    }
    
    public static VA_Project__c createProject(id AccountId, Id contactId){
        VA_Project__c objProject = new VA_Project__c (Name='test',VA_Account__c = AccountId, VA_Contact__c= contactId, VA_Reason__c= ' Field validation of New Product', VA_Frequency__c= '1-5' , VA_No_Of_Equipment__c= '1-10', VA_Outcome__c= 'test' );
        
        return objProject ;
    }
    
    
    
    public static ContentVersion createContentVersion(){
        ContentVersion testContentInsert = new ContentVersion(); 
        Blob b=Blob.valueOf('Unit Test Attachment Body');

        testContentInsert.Title ='Google.com';
        testContentInsert.pathOnClient= URL.getSalesforceBaseUrl().toExternalForm() + '/' + testContentInsert.title + '.pdf';
        testContentInsert.VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body');
        system.debug('@@testContentInsert'+testContentInsert);
        
         return testContentInsert;
         
    }
    public static ContentDocumentLink createContentDocumentLink(Id ContentVersionID, Id LinkedEntityId ){
        
       
        ContentVersion objContentVersion  = [select id, contentdocumentid from ContentVersion where id =:ContentVersionID];
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.ShareType = 'V';
        contentlink.Visibility = 'AllUsers';
        contentlink.contentdocumentid = objContentVersion.contentdocumentid;
        contentlink.LinkedEntityId = LinkedEntityId ;
        
        return contentlink;
    }
    
    public static VA_Product_Category__c createproductCategory(string productcategoryName){
        VA_Product_Category__c objProductCategory = new VA_Product_Category__c ();
        objProductCategory.name = productcategoryName;
        
        return objProductCategory ;
    }
    public static Case createPostTestCase(){
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('VA_Post').getRecordTypeId();
        //system.debug('@@RecordTypeIdPostCase '+RecordTypeIdPostCase );
        case objCase = new case(RecordTypeId  = recTypeId ,VA_Assign_to_Owner__c=false ,status = 'Sample In Transit', ownerid= userinfo.getUserid());
       
        system.debug(objCase.Product_Category__r.name );
        system.debug(objCase);
        return objCase;
    }
     
    
    public static Order createOrder(id AccountId){
        Id standardPBID = Test.getStandardPricebookId(); 
        Order objOrder = new Order (VA_Total_Invoice_Quantity__c= 1,VA_Delivery_Address__c= 'test', AccountID = AccountId, VA_SFDC_Order_Number__c = 'test011', EffectiveDate = system.today(),PoNumber = '123',VA_PO_Attached__c= true, Status = 'Registered', Pricebook2Id = standardPBID, VA_SAP_Order_Id__c= '12345', PoDate = system.today(), VA_Overall_Order_Rejection__c = 'test',  VA_Ship_To_Code__c= '123456', VA_Depot_Code__c = '12345' );   
        
        return objOrder;
    }
    public static OrderItem createOrderLineItem(Id OrderId, Id ProductId, Id PricebookEntryId){
        
        OrderItem  objOrderLineItem = new OrderItem  (VA_Material_SKU__c = '123456', Quantity = 1 , UnitPrice = 12.00, VA_SFDC_Order_Line_Item_Number__c = '12345', OrderId = OrderId, Product2Id= ProductId, PricebookEntryId=  PricebookEntryId, VA_SAP_Order_Id__c = '12345', VA_Status__c = 'Registered', VA_Delivery_Quantity__c = 1, VA_Position_Number__c ='10', VA_Billing_Block__c= '12', VA_Is_FreeGoods__c = false, VA_FreeGoods__c = 'X',  VA_Type__c= 'Confirmed Line Item', VA_Confirmed_Date__c= system.today());   
        
        return objOrderLineItem;
    }
    public static Product2 createProduct(){
       product2 ObjProduct = new product2(ProductCode = '500290',Name = 'Product',Description='Laptop',Focus_Product_C_I__c = 'Yes', Focus_Product_Fleet__c= 'Yes', Focus_Product_OEM__c= 'Yes', PH1__c= 'Valvoline', PH2__c='Lubricants', PH3__c= 'Ashland Branded/Supplier Packed', PH4__c='Valvoline', PH5__c = 'Appearance - Auto', PH6_Qlikview__c='ACD- Private Label', PH6_SAP__c=' Brake Fluid', PH7__c='Brake Fluid', Packsize__c='test', SKU_Id__c=123456);
       
       
        
        return ObjProduct ;
    }
    
    public static PricebookEntry createPriceBookEntry(Id productId){
        Id standardPBID = Test.getStandardPricebookId(); 
        
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = standardPBID , Product2Id = productId,
            UnitPrice = 10000, IsActive = true);
        return standardPrice;
    }
    public static Opportunity createOpportunity (id AccountId, Id OrderId){
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SAP_Order').getRecordTypeId();
        Opportunity oppt = new Opportunity(Opportunity_Code__c= 'IN9181200216', IsCreatedfromVF__c= false,StageName= 'Closed',Month_sap__c= 'Jun',Calendar_Year__c = '2018',name = 'IN9181200216',
                            AccountID = AccountId,
                            Amount = 3000,
                            CloseDate = System.today(),RecordTypeId= OppRecordTypeId, VA_Order__c = OrderId 
                            );

       return oppt;
    }
    
    public static OpportunityLineItem  createOpportunityLineItem (Id pricebookEntryId, Id OppId, Id ProductId){
        OpportunityLineItem OPplineitem = new OpportunityLineItem ( Quantity=2,TotalPrice = 500,PriceBookEntryId=pricebookEntryId, VA_Opportunity_Code__c = 'IN9181200216',  State_Name__c = 'Jharkhand', Depot_Name__c = 'VCPL - Ranchi', Invoice_Line_Unique_ID__c= 'IN918120021622', product2Id = ProductId, OpportunityId= OppId);
        return OPplineitem;
    }
    public static VA_Invoice__c createInvoice (Id OppId, Id OrderId){
        VA_Invoice__c  objInvoice= new VA_Invoice__c (VA_Opportunity__c = OppId, VA_Order__c = OrderId);
        return objInvoice;
    }
    
    public static Contact createContact (Id AccId){
        Contact objContact= new Contact(AccountId = AccId, LastName = 'Test saas',Email = 'Test@rkl.com',Contact_Record_Type__c = 'Decision Maker');
        return objContact;
    }
    
    public static list<VA_Trigger_Settings__c> triggeronoff(){
        boolean isDisabled = false;
        
        List<VA_Trigger_Settings__c> lstTriggerOnOff = new List<VA_Trigger_Settings__c>();
        VA_Trigger_Settings__c AccountTrigger= new VA_Trigger_Settings__c(Name='AccountTrigger',VA_Is_Trigger_Disabled__c=isDisabled);
        
        
    
        lstTriggerOnOff.add(AccountTrigger);
        
        
        insert lstTriggerOnOff; 
        
        return lstTriggerOnOff;
    }
}