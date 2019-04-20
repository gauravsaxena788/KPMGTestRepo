@IsTest 
public class VA_OpportunityRESTControllerTest{ 
    @testSetup
    static void setupTestData(){
		Account objAccount = VA_utilClass.createAccount();
        insert objAccount;
        
        Order objOrder = VA_utilClass.createOrder(objAccount.id);
        insert objOrder;
        
        product2 ObjProduct = VA_utilClass.createProduct(); 
        insert ObjProduct ;
        
        Pricebook2 pb22 = new Pricebook2(Name='Standard Price Book');
        insert pb22;
        
        //Id standardPBID = Test.getStandardPricebookId(); 
		
        PricebookEntry objpriceBookEntry = VA_utilClass.createPriceBookEntry(ObjProduct .id);
        objpriceBookEntry.SKU_ID__c = 123456;
        insert  objpriceBookEntry ;
		
        Opportunity objOpportunity = VA_utilClass.createOpportunity (objAccount.id, objOrder.id);
        objOpportunity.Year__c = '2018';
		objOpportunity.Month__c = 'Jun';
        insert objOpportunity;
        
        OpportunityLineItem objOpplineItem = VA_utilClass.createOpportunityLineItem (objpriceBookEntry.id,objOpportunity.id , ObjProduct.id);
        
        insert objOpplineItem ;
        
        List<OpportunityLineItem > lstoppLineItem = new List<OpportunityLineItem >();
        lstoppLineItem.add(objOpplineItem );
        
        VA_Invoice__c  objInvoice = VA_utilClass.createInvoice (objOpportunity.id, objOrder.id);
        insert objInvoice ;
	}
	
    public static testmethod void invoiceRestMethod(){ 
        
        //Opportunity objOpportunity = [select id, name , Account.Ship_to_Code__c, VA_Order__r.VA_SAP_Order_Id__c, Opportunity_Code__c,IsCreatedfromVF__c,StageName,CloseDate,RecordTypeId,Calendar_Year__c,Month_sap__c from Opportunity limit 1];
        OpportunityLineItem objOpportunityLineItem = [select PriceBookEntryId,TotalPrice,Quantity,Invoice_Line_Unique_ID__c,opportunityId,ProductCode, Opportunity.name,Opportunity.Account.Ship_to_Code__c, Opportunity.VA_Order__r.VA_SAP_Order_Id__c, Opportunity.Opportunity_Code__c,Opportunity.IsCreatedfromVF__c, opportunity.StageName,opportunity.CloseDate, opportunity.RecordTypeId, opportunity.Calendar_Year__c, opportunity.Month_sap__c from OpportunityLineItem limit 1];
        system.debug('@@ProductCode'+objOpportunityLineItem.ProductCode);
        objOpportunityLineItem.Id = null;
        List<OpportunityLineItem> lstoppLineItem = new List<OpportunityLineItem>();
        lstoppLineItem.add(objOpportunityLineItem);
        VA_Error_Log__c err = new VA_Error_Log__c();
        err.Total_Number_Of_Record__c = 5;
        err.Total_Success_Record__c = 3;
        err.Number_Of_Failed_Records__c  = 2;
        err.Response_body__c  = 'Response Body';
        err.Interface_Name__c = 'Test';
        insert err;
        system.debug('@@'+lstoppLineItem);
        test.startTest();
		List<VA_OpportunityRESTController.OpportunityLineItemWrapper>  lstoppLineItemWrapper = new List<VA_OpportunityRESTController.OpportunityLineItemWrapper> ();
		VA_OpportunityRESTController.OpportunityLineItemWrapper objOppLineItemWrapper = new VA_OpportunityRESTController.OpportunityLineItemWrapper();
		objOppLineItemWrapper.OpportunityLineItem  = lstoppLineItem;
		lstoppLineItemWrapper.add(objOppLineItemWrapper);
		system.debug('@@@'+lstoppLineItemWrapper);
		List<VA_OpportunityRESTController.OpportunityHeaderInner> lstWrapper = new List<VA_OpportunityRESTController.OpportunityHeaderInner>();
		VA_OpportunityRESTController.OpportunityHeaderInner wrapper = new VA_OpportunityRESTController.OpportunityHeaderInner();
		wrapper.opportunityCode = objOpportunityLineItem.Opportunity.Opportunity_Code__c;
		wrapper.iscreatedfromVf = String.valueOf(objOpportunityLineItem.Opportunity.IsCreatedfromVF__c);
		wrapper.ShiptoCode = objOpportunityLineItem.Opportunity.Account.Ship_to_Code__c;
		
		wrapper.StageName = objOpportunityLineItem.Opportunity.StageName;
		wrapper.CloseDate = String.valueOf(system.today());
		wrapper.invoiceDate = String.valueOf(system.today());
		wrapper.RecordTypeId = objOpportunityLineItem.Opportunity.RecordTypeId;
		wrapper.Name = objOpportunityLineItem.Opportunity.name;
		wrapper.calendarYear = objOpportunityLineItem.Opportunity.Calendar_Year__c;
		wrapper.SapOrderId = objOpportunityLineItem.Opportunity.VA_Order__r.VA_SAP_Order_Id__c ;
		wrapper.Month = objOpportunityLineItem.Opportunity.Month_sap__c ;
		wrapper.OpportunityHdrToLineItemNvg = lstoppLineItemWrapper;
		lstWrapper.add(wrapper);
		VA_OpportunityRESTController.OpportunityHeaderMain objRequest= new VA_OpportunityRESTController.OpportunityHeaderMain();
		objRequest.OpportunityHeader = lstWrapper;
		
		VA_OpportunityRESTController.saveOpportunity(objRequest);
		//VA_OpportunityRESTController.Requestbody(err.id,'Test','Test Header Set');
		VA_OpportunityRESTController.createErrorLog(5,3,2,'Request Body','Response body','');
        test.StopTest();
	}
    
    public static testmethod void invoiceRestMethod2(){
        //Opportunity objOpportunity = [select id, name , Account.Ship_to_Code__c, VA_Order__r.VA_SAP_Order_Id__c, Opportunity_Code__c,IsCreatedfromVF__c,StageName,CloseDate,RecordTypeId,Calendar_Year__c,Month_sap__c from Opportunity limit 1];
        OpportunityLineItem objOpportunityLineItem = [select PriceBookEntryId,TotalPrice,Quantity,Invoice_Line_Unique_ID__c,opportunityId,ProductCode, Opportunity.name,Opportunity.Account.Ship_to_Code__c, Opportunity.VA_Order__r.VA_SAP_Order_Id__c, Opportunity.Opportunity_Code__c,Opportunity.IsCreatedfromVF__c, opportunity.StageName,opportunity.CloseDate, opportunity.RecordTypeId, opportunity.Calendar_Year__c, opportunity.Month_sap__c from OpportunityLineItem limit 1];
        system.debug('@@ProductCode'+objOpportunityLineItem.ProductCode);
        objOpportunityLineItem.Id = null;
        List<OpportunityLineItem> lstoppLineItem = new List<OpportunityLineItem>();
        lstoppLineItem.add(objOpportunityLineItem);
        VA_Error_Log__c err = new VA_Error_Log__c();
        err.Total_Number_Of_Record__c = 5;
        err.Total_Success_Record__c = 3;
        err.Number_Of_Failed_Records__c  = 2;
        err.Response_body__c  = 'Response Body';
        err.Interface_Name__c = 'Test';
        insert err;
        system.debug('@@'+lstoppLineItem);
        test.startTest();
		List<VA_OpportunityRESTController.OpportunityLineItemWrapper>  lstoppLineItemWrapper = new List<VA_OpportunityRESTController.OpportunityLineItemWrapper> ();
		VA_OpportunityRESTController.OpportunityLineItemWrapper objOppLineItemWrapper = new VA_OpportunityRESTController.OpportunityLineItemWrapper();
		objOppLineItemWrapper.OpportunityLineItem  = lstoppLineItem;
		lstoppLineItemWrapper.add(objOppLineItemWrapper);
		system.debug('@@@'+lstoppLineItemWrapper);
		List<VA_OpportunityRESTController.OpportunityHeaderInner> lstWrapper = new List<VA_OpportunityRESTController.OpportunityHeaderInner>();
		VA_OpportunityRESTController.OpportunityHeaderInner wrapper = new VA_OpportunityRESTController.OpportunityHeaderInner();
		//wrapper.opportunityCode = objOpportunityLineItem.Opportunity.Opportunity_Code__c;
		wrapper.iscreatedfromVf = String.valueOf(objOpportunityLineItem.Opportunity.IsCreatedfromVF__c);
		//wrapper.ShiptoCode = objOpportunityLineItem.Opportunity.Account.Ship_to_Code__c;
		
		wrapper.StageName = objOpportunityLineItem.Opportunity.StageName;
		wrapper.CloseDate = String.valueOf(system.today());
		wrapper.invoiceDate = String.valueOf(system.today());
		wrapper.RecordTypeId = objOpportunityLineItem.Opportunity.RecordTypeId;
		wrapper.Name = objOpportunityLineItem.Opportunity.name;
		wrapper.calendarYear = objOpportunityLineItem.Opportunity.Calendar_Year__c;
		wrapper.SapOrderId = objOpportunityLineItem.Opportunity.VA_Order__r.VA_SAP_Order_Id__c ;
		wrapper.Month = objOpportunityLineItem.Opportunity.Month_sap__c ;
		wrapper.OpportunityHdrToLineItemNvg = lstoppLineItemWrapper;
		lstWrapper.add(wrapper);
		VA_OpportunityRESTController.OpportunityHeaderMain objRequest= new VA_OpportunityRESTController.OpportunityHeaderMain();
		objRequest.OpportunityHeader = lstWrapper;
		
		VA_OpportunityRESTController.saveOpportunity(objRequest);
		//VA_OpportunityRESTController.Requestbody(err.id,'Test','Test Header Set');
		VA_OpportunityRESTController.createErrorLog(5,3,2,'Request Body','Response body','');
	}
	
	public static testmethod void invoiceRestMethod3(){
        
		OpportunityLineItem objOpportunityLineItem = [select PriceBookEntryId,TotalPrice,Quantity,Invoice_Line_Unique_ID__c,opportunityId,ProductCode, Opportunity.name,Opportunity.Account.Ship_to_Code__c, Opportunity.VA_Order__r.VA_SAP_Order_Id__c, Opportunity.Opportunity_Code__c,Opportunity.IsCreatedfromVF__c, opportunity.StageName,opportunity.CloseDate, opportunity.RecordTypeId, opportunity.Calendar_Year__c, opportunity.Month_sap__c from OpportunityLineItem limit 1];
        
		objOpportunityLineItem.Id = null;
        List<OpportunityLineItem> lstoppLineItem = new List<OpportunityLineItem>();
        lstoppLineItem.add(objOpportunityLineItem);
        
		test.startTest();
		
		List<VA_OpportunityRESTController.OpportunityLineItemWrapper>  lstoppLineItemWrapper = new List<VA_OpportunityRESTController.OpportunityLineItemWrapper> ();
		VA_OpportunityRESTController.OpportunityLineItemWrapper objOppLineItemWrapper = new VA_OpportunityRESTController.OpportunityLineItemWrapper();
		objOppLineItemWrapper.OpportunityLineItem  = lstoppLineItem;
		lstoppLineItemWrapper.add(objOppLineItemWrapper);
		
		List<VA_OpportunityRESTController.OpportunityHeaderInner> lstWrapper = new List<VA_OpportunityRESTController.OpportunityHeaderInner>();
		VA_OpportunityRESTController.OpportunityHeaderInner wrapper = new VA_OpportunityRESTController.OpportunityHeaderInner();
		
		wrapper.opportunityCode = objOpportunityLineItem.Opportunity.Opportunity_Code__c;
		wrapper.iscreatedfromVf = String.valueOf(objOpportunityLineItem.Opportunity.IsCreatedfromVF__c);
		wrapper.ShiptoCode = objOpportunityLineItem.Opportunity.Account.Ship_to_Code__c;
		
		wrapper.StageName = objOpportunityLineItem.Opportunity.StageName;
		wrapper.CloseDate = String.valueOf(system.today());
		wrapper.invoiceDate = String.valueOf(system.today());
		wrapper.RecordTypeId = objOpportunityLineItem.Opportunity.RecordTypeId;
		wrapper.Name = objOpportunityLineItem.Opportunity.name;
		wrapper.calendarYear = objOpportunityLineItem.Opportunity.Calendar_Year__c;
		wrapper.SapOrderId = objOpportunityLineItem.Opportunity.VA_Order__r.VA_SAP_Order_Id__c ;
		wrapper.Month = objOpportunityLineItem.Opportunity.Month_sap__c ;
		wrapper.OpportunityHdrToLineItemNvg = lstoppLineItemWrapper;
		lstWrapper.add(wrapper);
		
		VA_OpportunityRESTController.OpportunityHeaderMain objRequest= new VA_OpportunityRESTController.OpportunityHeaderMain();
		objRequest.OpportunityHeader = lstWrapper;
		
		VA_OpportunityRESTController.saveOpportunity(objRequest);
		VA_OpportunityRESTController.createErrorLog(5,3,2,'Request Body','Response body','');
        test.StopTest();
	}
	
}