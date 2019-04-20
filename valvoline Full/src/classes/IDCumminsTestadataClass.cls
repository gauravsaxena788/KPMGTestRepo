@isTest
public class IDCumminsTestadataClass {
    
    // This is used to create partner and Salesforce user
    public static User createUser(String profileName ,Boolean ispartnerUser,string struser){
        
        Id pid = [SELECT Id FROM Profile WHERE Name= :profileName].id;
        Contact con;
        Account ac ;
        
        if(ispartnerUser){
            ac = new Account(name ='Grazitti') ;
            ac.Indutry_Segment__c = 'Industrial';
            ac.BU_Name__c = 'C&I';
            ac.Account_Type__c = 'Industrial Distributor';
            ac.Market_Segment__c = 'Industrial Distributor';
            ac.Zone__c = 'East';
            ac.OwnerId = struser;
            insert ac; 
            
            con = new Contact(LastName ='testCon',AccountId = ac.Id);
            insert con; 
        }
        
        User objUser = new User();
        objUser.Alias = 'standt'+(math.random()*10).intValue();
        objUser.Email='standarduser'+(math.random()*10)+'@testorg.com';
        objUser.EmailEncodingKey='UTF-8';
        objUser.LastName='Testing'+(math.random()*10);
        objUser.LanguageLocaleKey='en_US';
        objUser.LocaleSidKey='en_US'; 
        objUser.ProfileId = pid;
        if(profileName == 'System Administrator')
            objUser.UserRoleId = [SELECT Id,Name FROM UserRole WHERE Name='CEO'].Id;
        objUser.TimeZoneSidKey='America/Los_Angeles';
        objUser.UserName = 'gsdgsd'+(math.random()*10)+'@ggd'+(math.random()*10)+'.vom';
        if(ispartnerUser){
            objUser.Contactid = con.id;
        }
        
        return objUser;
    }
    
    
    
    /*
* This is used to insert branch or Dealer account
*/ 
    public static Account returnBranchDealerAccountTestdata(String Recordtypename,String ownerDetails,Boolean BranchNotDealer,String DealerDeatils){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Recordtypename).getRecordTypeId();
        Account ac = new Account(name ='Grazitti'+(math.random()*10).intValue()) ;
        ac.Indutry_Segment__c = 'Industrial';
        ac.RecordTypeId = accRecordTypeId; 
        ac.BU_Name__c = 'C&I';
        ac.Account_Type__c = 'Industrial Distributor';
        ac.Market_Segment__c = 'Industrial Distributor';
        ac.Zone__c = 'East';
        if(BranchNotDealer)
            ac.ParentId = DealerDeatils;
        ac.OwnerId = ownerDetails;
        
        return ac;
    }
    
    /*
* This is used to inser Lead in the system.
* */
    public static Lead returnLeadTestdata(String Recordtypename, String Name, String strIndusSeg, String accountType){
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Recordtypename).getRecordTypeId();
        Lead objLead = new Lead();
        objLead.RecordTypeId = leadRecordTypeId;
        objLead.LastName = Name+(math.random()*10).intValue();
        objLead.Company = 'Test Company';
        objLead.BU_Name__c = 'C&I';
        objLead.Industry_Segment__c = strIndusSeg;
        objLead.Account_Type__c = accountType;
        objLead.Market_Segment__c ='Automotive/Anciliary';
        objLead.Service_By__c='Dealer';
        objLead.LeadSource='Cold Calls';
        objLead.Email='test@gmail.com';
        objLead.MobilePhone ='9012092901';
        objLead.Zone__c = 'East';
        objLead.Status='New';
        
        return objLead;
    }
    public static Account returnCDIDAccountTestdata(String Recordtypename, String Name, String strIndusSeg, String accountType, String marketsegment){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Recordtypename).getRecordTypeId();
        
        Account ac = new Account(name = Name+(math.random()*10).intValue()) ;
        ac.Indutry_Segment__c = strIndusSeg;
        ac.RecordTypeId = accRecordTypeId; 
        ac.BU_Name__c = 'C&I';
        ac.Account_Type__c = accountType; 
        ac.Market_Segment__c = marketsegment; 
        ac.Zone__c = 'East';        	
        
        return ac;
        
    }
    /*
* This is used to create opportunity data
**/
    public static Opportunity returnBDOpportunityTestdata(String Recordtypename, String OppName,Account objAcc){
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Recordtypename).getRecordTypeId();
        
        Opportunity objOpp = new Opportunity();
        objOpp.RecordTypeId = OppRecordTypeId;
        objOpp.AccountId = objAcc.Id;
        objOpp.Name = OppName+(math.random()*10).intValue();
        objOpp.StageName = 'Won' ;
        objOpp.Sub_Stage__c = 'Material Delivered - Valvoline Invoice attached';
        objOpp.CloseDate = System.Today();   
        objOpp.Opportunity_Type__c = 'Business Development - New Account';       	
        
        return objOpp;
    }
    
    public static Quote returnQuoteTestData(String Recordtypename,Opportunity objOpp, Contact objCon){
        
        Id QuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(Recordtypename).getRecordTypeId();
        
        Quote ObjQuote = new Quote();
        ObjQuote.RecordTypeId = QuoteRecordTypeId;
        ObjQuote.Name = 'Test Quote'+(math.random()*10).intValue();
        ObjQuote.Status = 'Draft';
        ObjQuote.Total_Vol__c = 55;
        ObjQuote.OpportunityId = objOpp.id;
        ObjQuote.Quote_Number__c = '12345';
        ObjQuote.ContactId = objCon.Id;
        ObjQuote.PV_Clause_Applicable__c = 'Yes';
        ObjQuote.Cash_Discount_Policy__c = 'For all Distributors (Non-Cummins)';
        ObjQuote.Contract_Valid_from__c= System.Today();
        ObjQuote.Contract_Valid_till__c = System.Today()+30;
        ObjQuote.Delivery_Time__c = '5 to 7 Days';
        ObjQuote.Delivery_Term__c = 'Conditional MOQ based FOC';
        ObjQuote.MOQ__c ='1000 L or 900 KG or eq';
        ObjQuote.BU_Name__c = 'C&I';
        ObjQuote.Other_Terms_Conditions__c = 'Test Other Terms Conditions';
        ObjQuote.Annexures__c = 'Annexure CI-102 - OEM and Key Account';
        return ObjQuote;
    }
    
    public static Product2 returnTestProduct(){
        product2 ObjProduct = new product2(ProductCode = '500290',Name = 'Product',Description='Laptop',Focus_Product_C_I__c = 'Yes', Focus_Product_Fleet__c= 'Yes', Focus_Product_OEM__c= 'Yes', PH1__c= 'Valvoline', PH2__c='Lubricants', PH3__c= 'Ashland Branded/Supplier Packed', PH4__c='Valvoline', PH5__c = 'Appearance - Auto', PH6_Qlikview__c='ACD- Private Label', PH6_SAP__c=' Brake Fluid', PH7__c='Brake Fluid', Packsize__c='test', SKU_Id__c=123456);
        return ObjProduct ;
    }
    
    public static PricebookEntry returncreatePriceBookEntry(Id productId){
        Id standardPBID = Test.getStandardPricebookId();     
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = standardPBID , Product2Id = productId,
            UnitPrice = 10000, IsActive = true);
        return standardPrice;
    }
    
    public static VCPL_Differential_Pricing__c returnDPData(Account objAccBranch, Account objAccCDCus, Product2 objProd){
        VCPL_Differential_Pricing__c objDP = new VCPL_Differential_Pricing__c();
        objDP.VCPL_Basic_Price_L__c =100;
        objDP.VCPL_Validity_of_Discount__c =6;
        objDP.VCPL_Validity_Start_Date__c = System.today();
        objDP.VCPL_Others_Customer_Nature_of_Business__c ='Others';
        objDP.VCPL_Config_Margin__c = 7;
        objDP.VCPL_Customer_Code__c = objAccCDCus.VCPL_CDOS_AccountId__c; 
        objDP.VCPL_Customer_Contact_No__c ='9878575885';
        objDP.VCPL_Customer_nature_of_business__c = 'Others';
        objDP.VCPL_Customer_contact_person_name__c ='Gona';
        objDP.VCPL_Dealer_Margin_Liter__c =237;
        objDP.VCPL_Discount_L__c = 13;
        objDP.VCPL_DP_Expiry_Date__c = System.Today().addMonths(6);
        objDP.VCPL_DP_Request_Status__c = 'Draft';
        objDP.VCPL_Customer_Name__c = objAccCDCus.Id;
        objDP.VCPL_Expected_volume__c = 567;
        objDP.VCPL_KL_Potential_per_year__c =905;
        objDP.VCPL_LY_volume__c = 4000;
        objDP.VCPL_Offer_Price_L__c = 240;
        objDP.VCPL_Contact_Person_Email__c = 'gona@gmail.com';
        objDP.VCPL_Pack_Size__c = objProd.Packsize__c;
        objDP.VCPL_Part_no__c = String.valueof(objProd.SKU_Id__c);
        objDP.VCPL_Price_increase_plan_in_next_quarter__c = 234;
        objDP.VCPL_Product__c = objProd.Id;
        objDP.VCPL_Reason_for_Discount__c ='Reason for test';
        objDP.VCPL_Remark__c ='Test';
        
        return objDP;  
    }
    public static VCPL_Dealer_Mapping__c returnDealerCityStateTestData(String strCity,String strState){
        VCPL_Dealer_Mapping__c objDealerMapping = new VCPL_Dealer_Mapping__c();
        objDealerMapping.VCPL_City__c = strCity;//'NEW DELHI';
        objDealerMapping.VCPL_State__c = strState; //'DELHI';
        objDealerMapping.VCPL_StateCity__c = strCity+strState; //'NEW DELHIDELHI';
        return objDealerMapping;
    }
    /*
* 
* */
    public static VCPL_Customer_Plan__c returnCustomerPlanTestData(String recordTypeName,Account objAcc,Integer Quantity){
        
        VCPL_Customer_Plan__c objCP =  new VCPL_Customer_Plan__c();
        objCP.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        objCP.VCPL_Customer_Account__c = objAcc.Id;
        objCP.VCPL_Sample_PH6_Value_1__c = Quantity;
        objCP.VCPL_Sample_PH6_Value_2__c = Quantity;
        objCP.VCPL_Sample_PH6_Value_3__c = Quantity;
        objCP.VCPL_Sample_PH6_Value_4__c = Quantity;
        objCP.VCPL_Sample_PH6_Value_5__c = Quantity;
        objCP.VCPL_Sample_PH6_Value_6__c = Quantity;
        objCP.VCPL_Sample_PH6_Value_7__c = Quantity;
        objCP.VCPL_Actual_Sales__c = objCP.VCPL_Sample_PH6_Value_1__c + objCP.VCPL_Sample_PH6_Value_2__c+objCP.VCPL_Sample_PH6_Value_3__c + objCP.VCPL_Sample_PH6_Value_4__c + objCP.VCPL_Sample_PH6_Value_5__c + objCP.VCPL_Sample_PH6_Value_6__c + objCP.VCPL_Sample_PH6_Value_7__c;
        return objCP;
    }
    public static Account_Potential__c createPotentialTest(string strAccountid,string strPH6,Double potential)
    {
    	Account_Potential__c objPotential = new Account_Potential__c();
    	objPotential.Account__c = strAccountid;
    	objPotential.VCPL_Is_Current_Financial_Year__c = true;
    	objPotential.PH6_Qlikview__c = strPH6;
    	objPotential.Potential_Volume_in_kL__c = potential;
    	objPotential.Valvoline_Financial_Year__c = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    	objPotential.BU_Name__c = 'C&I';    	
    	return objPotential;
    }
    
    //creating blis group records
    public static VCPL_BLIS_Group__c createBlisGroupRecords(User Approver,Account Dealer,String Status)
    {
        VCPL_BLIS_Group__c objBlisGrp = new VCPL_BLIS_Group__c ();
        objBlisGrp.VCPL_Approver__c = Approver.Id;
        objBlisGrp.VCPL_Dealer__c = Dealer.Id;
        objBlisGrp.VCPL_Status__c = Status;
        return objBlisGrp;
    }
    
     //creating group branch records
    public static VCPL_Group_Branch__c createBlisGroupRecords(VCPL_BLIS_Group__c blisGroup,Account branch)
    {
        VCPL_Group_Branch__c objGroupBranch = new VCPL_Group_Branch__c ();
        objGroupBranch.VCPL_BLIS_Group__c = blisGroup.Id;
        objGroupBranch.VCPL_Branch__c = branch.Id;
        return objGroupBranch;
    }
    
    //creating customer plan
    public static VCPL_Customer_Plan__c createCustomerPlan(Id dealer)
    {
        VCPL_Customer_Plan__c customerPlan = new VCPL_Customer_Plan__c();
        customerPlan.VCPL_Actual_Sales__c = 14.3;
        customerPlan.VCPL_Sample_PH6_Value_4__c = 2;
        customerPlan.VCPL_Assignment_Classification__c='Top 20';
        customerPlan.VCPL_Sample_PH6_Value_6__c = 3;
        customerPlan.VCPL_Customer_Account__c = dealer;
        return customerPlan;
    }
    //creating secondary sales
    public static VCPL_Secondary_Sales__c createSecondarySales(String recordTypeName,Date dateUser,Id customerPlan)
    {
        VCPL_Secondary_Sales__c secondarySales = new VCPL_Secondary_Sales__c();
        Id ssRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        secondarySales.RecordTypeId = ssRecordTypeId;
        secondarySales.VCPL_Invoice_Date__c = dateUser;
        secondarySales.VCPL_Branch_Customer__c = customerPlan;
        return secondarySales;
    }
    //creating secondary sales items
    public static VCPL_Secondary_Sales_LineItem__c createSecondarySalesItems(Id secondarySales)
    {
        VCPL_Secondary_Sales_LineItem__c secondarySaleItem = new VCPL_Secondary_Sales_LineItem__c();
        secondarySaleItem.VCPL_Secondary_Sales__c = secondarySales;
        secondarySaleItem.VCPL_CDOS_Classification__c = 'CO';
        secondarySaleItem.VCPL_Vol_in_Ltrs__c = 12;
        return secondarySaleItem;
    }
    //creating VCPL_AVD_QVD__c records
    public static VCPL_AVD_QVD__c createAVDQVD(String recordTypeName,String fiscalyear)
    {
        Id avdRecordTypeId = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        VCPL_AVD_QVD__c avdqvd = new VCPL_AVD_QVD__c();
        avdqvd.RecordTypeId = avdRecordTypeId;
        avdqvd.VCPL_Fiscal_Year__c = fiscalyear;
        avdqvd.VCPL_Growth_Slab_1_In_Percentage__c = 5;
        avdqvd.VCPL_Growth_Slab_2_In_Percentage__c = 5;
        avdqvd.VCPL_Growth_Slab_3_In_Percentage__c = 1;
        avdqvd.VCPL_Growth_Slab_4_In_Percentage__c = 2;
        avdqvd.VCPL_Incentive_Slab_1_AVD_In_R_L__c = 8;
        avdqvd.VCPL_Incentive_Slab_1_QVD_In_R_L__c = 9;
        avdqvd.VCPL_Incentive_Slab_2_AVD_In_R_L__c = 4;
        avdqvd.VCPL_Incentive_Slab_2_QVD_In_R_L__c = 5;
        avdqvd.VCPL_Incentive_Slab_3_AVD_In_R_L__c = 4;
        avdqvd.VCPL_Incentive_Slab_3_QVD_In_R_L__c = 3;
        avdqvd.VCPL_Incentive_Slab_4_AVD_In_R_L__c = 2;
        avdqvd.VCPL_Incentive_Slab_4_QVD_In_R_L__c = 1;
        return avdqvd;
    }
    
    public static UserRole createUserRole(String strRoleName,String strDevelopername)
    {
        UserRole objuserRole = new UserRole(DeveloperName = strDevelopername, Name = strRoleName);
		insert objuserRole;
        return objuserRole;
    }
    
    // Opportunity lineiteminsert 
     public static OpportunityLineItem createOpporLinItem(Opportunity objOpp,PricebookEntry objProd,Integer ItegeQuan){
            OpportunityLineItem objOpLI = new OpportunityLineItem();
            objOpLI.TotalPrice = 700;
            objOpLI.OpportunityId = objOpp.Id;
            objOpLI.PriceBookEntryID = objProd.Id;
            objOpLI.Description = String.valueof(ItegeQuan);
            objOpLI.Quantity = ItegeQuan;
         return objOpLI;
	}
    
    // Account Potential
     Public Static Account_Potential__c returnObjTestData(String strFinacialYear,Account objAcc,String strQlickview){
        Account_Potential__c objAccPot = new Account_Potential__c();
        objAccPot.Account__c = objAcc.Id;
        objAccPot.BU_Name__c = 'C&I';
        objAccPot.Opp_size_in_kL_sales_expected_this_yea__c = 8;
        objAccPot.VCPL_PH6__c = 'Test';
        objAccPot.PH6_Qlikview__c = strQlickview;
        objAccPot.Potential_Per_Annum__c = 12 ;
        objAccPot.Potential_Volume_in_kL__c= 12;
        objAccPot.Valvoline_Financial_Year__c= strFinacialYear;
        objAccPot.YTD_in_volume__c = 23; 
        return objAccPot;
	}
    
}