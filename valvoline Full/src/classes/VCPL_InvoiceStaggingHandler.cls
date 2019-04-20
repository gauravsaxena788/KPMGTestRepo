/*
    @author: Shubham Shukla
    @company: Saasfocus
    @description: This class is working As an Handler for InvoiceStaggingTrigger. 
*/

public class VCPL_InvoiceStaggingHandler {
    
    public string strCurrentFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    public string strCurrentPrevFinancialYear = string.valueof(integer.valueof(strCurrentFinancialYear) - 1);
    public Id AccDelarRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    public Id CDCustomerRecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
    
    ////Method is used for Inserting the Records of secondary sales and secondary sales line item.    
    public void InsertInvoices(list<VCPL_Invoice_Stagging__c> triggerNew)
    {
        list<VCPL_Secondary_Sales__c> lstVCPLSecondarySales = new list<VCPL_Secondary_Sales__c>();
        list<VCPL_Secondary_Sales__c> lstVCPLSecondarySalesold = new list<VCPL_Secondary_Sales__c>();
        map<string,list<VCPL_Invoice_Stagging__c>> mapheadderwithInvoicedetail = new map<string,list<VCPL_Invoice_Stagging__c>>();
        map<string,VCPL_Secondary_Sales__c> mapheadderwithInvoicehdr = new map<string,VCPL_Secondary_Sales__c>();
        list<VCPL_Invoice_Stagging__c> lstLineItems ;
        list<VCPL_Secondary_Sales_LineItem__c> lstSSL = new list<VCPL_Secondary_Sales_LineItem__c>();
        map<string,string> mapUnSuccessfulRecordInvoiceByError = new map<string,string>();
        map<string,string> mapUnSuccessfulRecordNameByError = new map<string,string>();
        Id InvRecordTypeId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get('CD Secondary Sales').getRecordTypeId();
        integer i=0;
        boolean IsError =false;
        set<string> SetSuccessRecordId = new set<string>();
        map<String,String> mapAccountIdbyBranch= new map<string,string>();   
        map<string,ID> mapVCPLBranchCustomer = new  map<string,ID> ();
        map<string,ID> mapVCPLDealerCustomer = new  map<string,ID> ();
        set<string> setInvoiceNotProcessed = new set<string>();
        set<string> setInvoicealreadyProcessed = new set<string>();    
        set<string> setInvoicehadDetails = new set<string>();
        map<string,ID> mapValidBranchbyAccount = new map<string,ID>();
        map<string,ID> mapValidCustomerAccount = new map<string,ID>();
        set<string> setInvoiceNumber = new set<string>();
        set<string> setCDSKU = new set<string>();
        map<string,CD_SKU_Mapping__c> mapCDSKU = new map<string,CD_SKU_Mapping__c>();
        string sstrMessage='';
        set<string> setoldUniquerowid = new set<string>();
        set<string> setAccBranchfis = new set<string>();
        
        Savepoint sp = Database.setSavepoint();
        
        try{
            set<String> invoiceNoSet = new set<String>();
            for(VCPL_Invoice_Stagging__c objInvoice: triggerNew) {
                if(objInvoice.Invoice_Number__c != null)
                invoiceNoSet.add(objInvoice.Invoice_Number__c);
            }
            
            // For getting the old data of same batch 
            for (VCPL_Invoice_Stagging__c objInvoiceStaggingoldData : [select id,name,Invoice_Number__c,Status__c,Unique_Row_Id__c from VCPL_Invoice_Stagging__c 
            where IsResultProcessd__c = false  and Status__c <> '' and Invoice_Number__c in : invoiceNoSet])
            {   
                system.debug('====objInvoiceStaggingoldData==='+objInvoiceStaggingoldData);
                if (objInvoiceStaggingoldData.Status__c =='Processed'){
                    //Adding list in Existing Map 
                    lstLineItems = new list<VCPL_Invoice_Stagging__c>();
                    mapheadderwithInvoicedetail.put(objInvoiceStaggingoldData.Invoice_Number__c,lstlineItems);
                    //Ceating the set of Old data for already proccessed 
                    setInvoicealreadyProcessed.add(objInvoiceStaggingoldData.Invoice_Number__c);
                    setoldUniquerowid.add(objInvoiceStaggingoldData.Unique_Row_Id__c);
                }
                else if (objInvoiceStaggingoldData.Status__c =='Has Error')
                {
                    //Ceating the set of Old data those have Errors 
                    setInvoiceNotProcessed.add(objInvoiceStaggingoldData.Invoice_Number__c);         
                } 
            }
            
            // creating map of Accout id and Division for using these values for getting the Customer Plan     
            for(VCPL_Invoice_Stagging__c objInvoice: triggerNew)
            { 
                sstrMessage = '';
                if (!string.isblank(objInvoice.ACCOUNT_ADDR_ID__c) && (!string.isblank(objInvoice.Division_Name__c)) && (!string.isblank(objInvoice.Invoice_Date__c)))
                {
                    mapAccountIdbyBranch.put(objInvoice.ACCOUNT_ADDR_ID__c,objInvoice.Division_Name__c);
                    setAccBranchfis.add(objInvoice.ACCOUNT_ADDR_ID__c +':'+objInvoice.Division_Name__c +'@'+ VCPL_MonthlySalesPlanController.getFinancialYear(VCPL_CommonUtilityClass.convertCDOSDate(objInvoice.Invoice_Date__c),10));
                }
                else {
                    if (string.isblank(objInvoice.ACCOUNT_ADDR_ID__c))
                    {
                        sstrMessage = 'ACCOUNT ADDR ID Cannot Be Blank'  ;
                    }
                    if (string.isblank(objInvoice.Division_Name__c))
                    {
                        if (sstrMessage ==''){
                            sstrMessage = 'Division Name Cannot Be Blank';
                        }
                        else{
                            sstrMessage = sstrMessage + ', Division Name Cannot Be Blank';
                        }           
                    }
                    if(string.isblank(objInvoice.Invoice_Date__c))
                    {
                        if (sstrMessage ==''){
                            sstrMessage = 'Invoice Date Cannot Be Blank';
                        }
                        else{
                            sstrMessage = sstrMessage + ', Invoice Date Cannot Be Blank';
                        }
                    }
                    
                    mapUnSuccessfulRecordNameByError.put(objInvoice.Name,sstrMessage);
                    setInvoiceNumber.add(objInvoice.Invoice_Number__c);
                }
                
                if (string.isblank(objInvoice.Invoice_Number__c))
                {
                    if (sstrMessage ==''){
                        sstrMessage='Invoice Number Cannot Be Blank';
                    }
                    else
                    {
                        sstrMessage = sstrMessage +  ',Invoice Number Cannot Be Blank';
                    }
                    
                    mapUnSuccessfulRecordNameByError.put(objInvoice.Name,sstrMessage);
                }
                if (!string.isblank(objInvoice.Item_Name__c))
                setCDSKU.add(objInvoice.Item_Name__c);
                
                if (string.isblank(objInvoice.Unique_Row_Id__c)){
                    
                    if (sstrMessage ==''){
                        sstrMessage='Unique Row Id Cannot Be Blank';
                    }
                    else
                    {
                        sstrMessage = sstrMessage +  ',Unique Row Id Cannot Be Blank';
                    } 
                    
                    mapUnSuccessfulRecordNameByError.put(objInvoice.Name,sstrMessage);
                    setInvoiceNumber.add(objInvoice.Invoice_Number__c);
                }
                
                if (setoldUniquerowid.contains(objInvoice.Unique_Row_Id__c))
                {
                    mapUnSuccessfulRecordNameByError.put(objInvoice.Name,'Duplicate Unique Row Id Found:'+ objInvoice.Unique_Row_Id__c);  
                }
                
            }
            
            if (setCDSKU.size() > 0)
            {
                mapCDSKU = GetProduct(setCDSKU);
            }
            
            
            if (mapAccountIdbyBranch.size() >0)
            {
                //Customer Plan based on Customer and Branch   
                mapVCPLBranchCustomer = getCustomerBranchPlanData(mapAccountIdbyBranch,setAccBranchfis);
                //Customer Plan based on Dealr and Branch  
                mapVCPLDealerCustomer  = getCustomerDealerPlanData(mapAccountIdbyBranch,setAccBranchfis);
                
                mapValidCustomerAccount  = getValidCustomerAccount(mapAccountIdbyBranch);
                mapValidBranchbyAccount =  getValidBranch (mapAccountIdbyBranch);
            }
            
            //for validation and error handling
            for(VCPL_Invoice_Stagging__c objInvoiceStag: triggerNew)
            {   
                sstrMessage = '';            
                if (!mapValidCustomerAccount.containskey(objInvoiceStag.ACCOUNT_ADDR_ID__c))
                {
                    sstrMessage = 'ACCOUNT ADDR ID Is Not Found For :'+ objInvoiceStag.ACCOUNT_ADDR_ID__c ; 
                    mapUnSuccessfulRecordNameByError.put(objInvoiceStag.name,sstrMessage);
                    setInvoiceNumber.add(objInvoiceStag.Invoice_Number__c);
                }
                
                if(!mapValidBranchbyAccount.containskey(objInvoiceStag.Division_Name__c))
                {
                    if (sstrMessage ==''){
                        sstrMessage = 'Division Name Not Found For :' + objInvoiceStag.Division_Name__c; 
                    }
                    else{
                        sstrMessage = sstrMessage +  ', Division Name Not Found For :' + objInvoiceStag.Division_Name__c;
                    }
                    mapUnSuccessfulRecordNameByError.put(objInvoiceStag.name,sstrMessage);
                    setInvoiceNumber.add(objInvoiceStag.Invoice_Number__c);
                }
                
                if(!mapCDSKU.containskey(objInvoiceStag.Item_Name__c))
                {
                    if (sstrMessage ==''){
                        sstrMessage = 'Product Not Found For SKUID:' + objInvoiceStag.Item_Name__c; 
                    }
                    else{
                        sstrMessage = sstrMessage +  ', Product Not Found For SKUID:' + objInvoiceStag.Item_Name__c; 
                    }
                    mapUnSuccessfulRecordNameByError.put(objInvoiceStag.name,sstrMessage);
                    setInvoiceNumber.add(objInvoiceStag.Invoice_Number__c);
                }
            }
            
            for(VCPL_Invoice_Stagging__c objInvoiceStagging: triggerNew)
            {  
                system.debug(setInvoiceNumber+'====objInvoiceStagging.Invoice_Number__c'+objInvoiceStagging.Invoice_Number__c);
                if (!setInvoiceNumber.contains(objInvoiceStagging.Invoice_Number__c) && ! string.isblank(objInvoiceStagging.Invoice_Number__c) ){
                    if (mapheadderwithInvoicedetail.size()==0 || !mapheadderwithInvoicedetail.containskey(objInvoiceStagging.Invoice_Number__c)) 
                    {
                        if (!setInvoiceNotProcessed.contains(objInvoiceStagging.Invoice_Number__c)){
                            VCPL_Secondary_Sales__c objVCPLSS = new VCPL_Secondary_Sales__c();
                            objVCPLSS.VCPL_CDOS_Account_Id__c = objInvoiceStagging.AccountID__c;
                            objVCPLSS.RecordTypeId = InvRecordTypeId;
                            objVCPLSS.VCPL_CDOS_Division_Name__c = objInvoiceStagging.Division_Name__c;
                            objVCPLSS.VCPL_CDOS_Order_Number__c = objInvoiceStagging.Order_Number__c;
                            objVCPLSS.VCPL_CDOS_SAP_VCL_Code__c = objInvoiceStagging.SAP_VCL_Code__c;
                            objVCPLSS.VCPL_CDOS_Zonal_Office__c = objInvoiceStagging.Zonal_Office__c;
                            objVCPLSS.VCPL_CDOS_Customer_Name__c = objInvoiceStagging.Customer_Name__c;
                            objVCPLSS.VCPL_CDOS_Customer_Number__c = objInvoiceStagging.Customer_Number__c;
                            objVCPLSS.VCPL_CDOS_Bill_To_Account_Id__c = objInvoiceStagging.Bill_To_Account_Id__c;
                            ObjVCPLSS.VCPL_CDOS_ACCOUNT_ADDR_ID__c = objInvoiceStagging.ACCOUNT_ADDR_ID__c;
                            objVCPLSS.VCPL_Invoice_Date__c = VCPL_CommonUtilityClass.convertCDOSDate(objInvoiceStagging.Invoice_Date__c);
                            objVCPLSS.VCPL_CDOS_Order_Date__c = VCPL_CommonUtilityClass.convertCDOSDate(objInvoiceStagging.Order_Date__c);
                            objVCPLSS.VCPL_CDOS_Created__c = VCPL_CommonUtilityClass.convertCDOSDate(objInvoiceStagging.Created__c);
                            objVCPLSS.Invoice_Number__c = objInvoiceStagging.Invoice_Number__c;
                            objVCPLSS.VCPL_CDOS_Sales_Exec__c = objInvoiceStagging.Sales_Exec__c;
                            objVCPLSS.VCPL_CDOS_Source_Invoice_Name__c = objInvoiceStagging.Source_Invoice_Name__c;
                            objVCPLSS.VCPL_Dealer_Customer__c = mapVCPLDealerCustomer.get(objInvoiceStagging.ACCOUNT_ADDR_ID__c + objInvoiceStagging.Division_Name__c + VCPL_MonthlySalesPlanController.getFinancialYear(VCPL_CommonUtilityClass.convertCDOSDate(objInvoiceStagging.Invoice_Date__c),10));
                            objVCPLSS.VCPL_Branch_Customer__c = mapVCPLBranchCustomer.get(objInvoiceStagging.ACCOUNT_ADDR_ID__c + objInvoiceStagging.Division_Name__c + VCPL_MonthlySalesPlanController.getFinancialYear(VCPL_CommonUtilityClass.convertCDOSDate(objInvoiceStagging.Invoice_Date__c),10));            
                            objVCPLSS.VCPL_CDOS_Area_Office__c = objInvoiceStagging.Area_Office__c;
                            objVCPLSS.VCPL_CDOS_Billing_Address__c = objInvoiceStagging.Billing_Address__c;
                            objVCPLSS.VCPL_CDOS_Organization_Name__c= objInvoiceStagging.Organization_Name__c;
                            objVCPLSS.VCPL_CDOS_Customer_Category__c = objInvoiceStagging.Customer_Category__c;
                            objVCPLSS.name = objInvoiceStagging.AccountID__c;
                            objVCPLSS.Account__c = mapValidCustomerAccount.get(objInvoiceStagging.ACCOUNT_ADDR_ID__c);
                            
                            lstVCPLSecondarySales.add(objVCPLSS);
                            mapheadderwithInvoicehdr.put(objInvoiceStagging.Invoice_Number__c,objVCPLSS);
                            
                            lstLineItems = new list<VCPL_Invoice_Stagging__c>();
                            lstlineItems.add(objInvoiceStagging);
                            mapheadderwithInvoicedetail.put(objInvoiceStagging.Invoice_Number__c,lstlineItems);
                        }
                    }
                    else
                    {
                        mapheadderwithInvoicedetail.get(objInvoiceStagging.Invoice_Number__c).add(objInvoiceStagging);
                        //adding the Headder for old Values
                        if (setInvoicealreadyProcessed.contains(objInvoiceStagging.Invoice_Number__c))
                        {
                            setInvoicehadDetails.add(objInvoiceStagging.Invoice_Number__c);
                        }
                    }
                }
                
            }
            
            
            //inserting Records in Secondary sales adding set in condition to excute the code for old Secondary sales.
            if (!lstVCPLSecondarySales.isempty() || setInvoicehadDetails.size() > 0){
                i=0;
                if (!lstVCPLSecondarySales.isempty()){
                    Schema.SObjectField f = VCPL_Secondary_Sales__c.Fields.Invoice_Number__c;
                    Database.upsertResult[] SaveResult = Database.upsert(lstVCPLSecondarySales,f,false);
                    for (Database.upsertResult sr : SaveResult) {
                        if (!sr.isSuccess()){
                            //Removing the Record from map (mapheadderwithInvoicedetail) those have Errors 
                            mapheadderwithInvoicedetail.remove(lstVCPLSecondarySales[i].Invoice_Number__c);
                            for(Database.Error eachErr : sr.getErrors()){  
                                //Creating the Map for marking the Error Records. 
                                mapUnSuccessfulRecordInvoiceByError.put(lstVCPLSecondarySales[i].Invoice_Number__c,eachErr.getStatusCode() + ': ' +  eachErr.getMessage());  
                            }
                        }
                        i++;
                    }
                }
                
                //adding old Invoice Records    
                if (setInvoicehadDetails.size() > 0){
                    for (VCPL_Secondary_Sales__c objVCPLSecondarySales : [select id,name,Invoice_Number__c from VCPL_Secondary_Sales__c where Invoice_Number__c IN: setInvoicehadDetails ]){
                        lstVCPLSecondarySales.add(objVCPLSecondarySales);
                        lstVCPLSecondarySalesold.add(objVCPLSecondarySales);
                    }    
                }
                
                map<id,string> maphdridwithItemnumber = new map<id,string>();
                for (VCPL_Secondary_Sales__c objSS : lstVCPLSecondarySales){
                    if (mapheadderwithInvoicedetail.size() > 0 && mapheadderwithInvoicedetail.containsKey(objSS.Invoice_Number__c)){
                        list<VCPL_Invoice_Stagging__c> lstVCPLInvoiceStgg = mapheadderwithInvoicedetail.get(objSS.Invoice_Number__c);
                        for (VCPL_Invoice_Stagging__c objVCPLInvoiceStgg :lstVCPLInvoiceStgg){
                            if (!setoldUniquerowid.contains(objVCPLInvoiceStgg.Unique_Row_Id__c)){
                                VCPL_Secondary_Sales_LineItem__c objSSL = new  VCPL_Secondary_Sales_LineItem__c();
                                objSSL.VCPL_CDOS_ESN__c = objVCPLInvoiceStgg.ESN__c;
                                objSSL.VCPL_CDOS_Item_Category__c = objVCPLInvoiceStgg.Item_Category__c;
                                objSSL.VCPL_CDOS_Unit_Volume__c = objVCPLInvoiceStgg.Unit_Volume__c;
                                objSSL.VCPL_Vol_in_Ltrs__c = objVCPLInvoiceStgg.Extended_Volume__c;
                                objSSL.VCPL_CDOS_Product_Description__c = objVCPLInvoiceStgg.Product_Description__c;
                                objSSL.VCPL_CDOS_Invoice_Line_Number__c = objVCPLInvoiceStgg.Invoice_Line_Number__c;
                                objSSL.VCPL_CDOS_Invoice_Qty__c = objVCPLInvoiceStgg.Invoice_Qty__c;
                                objSSL.VCPL_CDOS_Invoice_Return_Qty__c = objVCPLInvoiceStgg.Invoice_Return_Qty__c;
                                objSSL.VCPL_CDOS_Item_Base_Price__c = objVCPLInvoiceStgg.Item_Base_Price__c;
                                objSSL.VCPL_CDOS_Item_Selling_Price__c = objVCPLInvoiceStgg.Item_Selling_Price__c;
                                if (mapCDSKU.containskey(objVCPLInvoiceStgg.Item_Name__c))
                                {
                                    objSSL.VCPL_CDOS_Classification__c= mapCDSKU.get(objVCPLInvoiceStgg.Item_Name__c).Classification__c;
                                    objSSL.VCPL_Product__c =    mapCDSKU.get(objVCPLInvoiceStgg.Item_Name__c).Product__c;
                                }
                                objSSL.VCPL_CDOS_Item_Name__c = objVCPLInvoiceStgg.Item_Name__c;    
                                objSSL.VCPL_CDOS_DISC_AMT_PER_ITEM__c = objVCPLInvoiceStgg.Disc_Amt_Item__c;
                                objSSL.VCPL_Secondary_Sales__c = objSS.id;
                                objSSL.VCPL_CDOS_Unique_Row_Id__c = objVCPLInvoiceStgg.Unique_Row_Id__c;    
                                lstSSL.add(objSSL);
                                setoldUniquerowid.add(objVCPLInvoiceStgg.Unique_Row_Id__c);
                            }
                            else
                            {
                                mapUnSuccessfulRecordNameByError.put(objVCPLInvoiceStgg.Name,'Duplicate Unique Row Id Found:'+ objVCPLInvoiceStgg.Unique_Row_Id__c);  
                            }
                        }
                        
                        maphdridwithItemnumber.put(objSS.id,objSS.Invoice_Number__c);
                    }   
                }
                
                //inserting Records in Secondary sales line item
                if (!lstSSL.isempty()){
                    i=0;
                    Schema.SObjectField f = VCPL_Secondary_Sales_LineItem__c.Fields.VCPL_CDOS_Unique_Row_Id__c;
                    Database.upsertResult[] SaveResult1 = Database.upsert(lstSSL,f,false);
                    for (Database.upsertResult sr : SaveResult1) {
                        if (!sr.isSuccess()){
                            for(Database.Error eachErr : sr.getErrors()){  
                                mapUnSuccessfulRecordInvoiceByError.put(maphdridwithItemnumber.get(lstSSL[i].id),eachErr.getStatusCode() + ': ' +  eachErr.getMessage());
                                mapUnSuccessfulRecordNameByError.put(lstSSL[i].Name,eachErr.getStatusCode() + ': ' +  eachErr.getMessage());
                            }
                            IsError = true;
                        }
                        i++;
                    }
                    
                    if (IsError == true){
                        system.debug('<<Rollback>>');
                        Database.rollback(sp);
                        lstVCPLSecondarySales = new list<VCPL_Secondary_Sales__c>();
                        for (string str:mapheadderwithInvoicedetail.keyset()){
                            if (!mapUnSuccessfulRecordInvoiceByError.containskey(str) && mapheadderwithInvoicehdr.containsKey(str)){
                                VCPL_Secondary_Sales__c objVCPLSS = mapheadderwithInvoicehdr.get(str);
                                lstVCPLSecondarySales.add(objVCPLSS);
                            }
                            else
                            {
                                mapheadderwithInvoicedetail.remove(str);
                            }
                        }
                        //inserting Secondary sales and Secondary sales Line items records those not getting error previously
                        if (!lstVCPLSecondarySales.isempty()){
                            upsert lstVCPLSecondarySales Invoice_Number__c;
                            
                            // add oldvalues in list for Proccessing the line items                        
                            if (!lstVCPLSecondarySalesold.isempty()){
                                lstVCPLSecondarySales.addall(lstVCPLSecondarySalesold);
                            }
                            
                            for (VCPL_Secondary_Sales__c objSS : lstVCPLSecondarySales){
                                if (mapheadderwithInvoicedetail.size() > 0 && mapheadderwithInvoicedetail.containsKey(objSS.Invoice_Number__c)){
                                    list<VCPL_Invoice_Stagging__c> lstVCPLInvoiceStgg = mapheadderwithInvoicedetail.get(objSS.Invoice_Number__c);
                                    for (VCPL_Invoice_Stagging__c objVCPLInvoiceStgg :lstVCPLInvoiceStgg){  
                                        if (!setoldUniquerowid.contains(objVCPLInvoiceStgg.Unique_Row_Id__c)){
                                            VCPL_Secondary_Sales_LineItem__c objSSL = new  VCPL_Secondary_Sales_LineItem__c();
                                            objSSL.VCPL_CDOS_ESN__c = objVCPLInvoiceStgg.ESN__c;
                                            objSSL.VCPL_CDOS_Item_Category__c = objVCPLInvoiceStgg.Item_Category__c;
                                            objSSL.VCPL_CDOS_Unit_Volume__c = objVCPLInvoiceStgg.Unit_Volume__c;
                                            objSSL.VCPL_Vol_in_Ltrs__c = objVCPLInvoiceStgg.Extended_Volume__c;
                                            objSSL.VCPL_CDOS_Product_Description__c = objVCPLInvoiceStgg.Product_Description__c;
                                            objSSL.VCPL_CDOS_Invoice_Line_Number__c = objVCPLInvoiceStgg.Invoice_Line_Number__c;
                                            objSSL.VCPL_CDOS_Invoice_Qty__c = objVCPLInvoiceStgg.Invoice_Qty__c;
                                            objSSL.VCPL_CDOS_Invoice_Return_Qty__c = objVCPLInvoiceStgg.Invoice_Return_Qty__c;
                                            objSSL.VCPL_CDOS_Item_Base_Price__c = objVCPLInvoiceStgg.Item_Base_Price__c;
                                            objSSL.VCPL_CDOS_Item_Selling_Price__c = objVCPLInvoiceStgg.Item_Selling_Price__c;
                                            if (mapCDSKU.containskey(objVCPLInvoiceStgg.Item_Name__c))
                                            {
                                                objSSL.VCPL_CDOS_Classification__c= mapCDSKU.get(objVCPLInvoiceStgg.Item_Name__c).Classification__c;
                                                objSSL.VCPL_Product__c =    mapCDSKU.get(objVCPLInvoiceStgg.Item_Name__c).Product__c;
                                            }
                                            objSSL.VCPL_CDOS_Item_Name__c = objVCPLInvoiceStgg.Item_Name__c;
                                            objSSL.VCPL_CDOS_DISC_AMT_PER_ITEM__c = objVCPLInvoiceStgg.Disc_Amt_Item__c;
                                            objSSL.VCPL_Secondary_Sales__c = objSS.id;
                                            objSSL.VCPL_CDOS_Unique_Row_Id__c = objVCPLInvoiceStgg.Unique_Row_Id__c;     
                                            lstSSL.add(objSSL);
                                        }
                                    }
                                }   
                            }
                            
                            if (!lstSSL.isempty()){
                                upsert lstSSL VCPL_CDOS_Unique_Row_Id__c;
                            }
                            
                        }
                        
                    }
                }   
            }
            list<VCPL_Invoice_Stagging__c> lstInv = new list<VCPL_Invoice_Stagging__c>();
            list<VCPL_Invoice_Stagging__c> lstInvSt = [select ID,Name,Invoice_Number__c,Status__c,Error__c from VCPL_Invoice_Stagging__c where ID IN: triggernew ];                
            //Updating the Record status in Invoice Stagging object 
            for(VCPL_Invoice_Stagging__c objInvSt: lstInvSt)
            {    
                if (mapUnSuccessfulRecordInvoiceByError.size() > 0 && mapUnSuccessfulRecordInvoiceByError.containskey(objInvSt.Invoice_Number__c))
                {
                    objInvSt.Status__c = 'Has Error';
                    objInvSt.Error__c = mapUnSuccessfulRecordInvoiceByError.get(objInvSt.Invoice_Number__c);
                }
                else if (mapUnSuccessfulRecordNameByError.size() > 0 && mapUnSuccessfulRecordNameByError.Containskey(objInvSt.Name))
                {
                    objInvSt.Status__c = 'Has Error';
                    objInvSt.Error__c = mapUnSuccessfulRecordNameByError.get(objInvSt.Name);
                }
                else
                {
                    objInvSt.Status__c = 'Processed';
                }
                
                lstInv.add(objInvSt); 
            }
            if (!lstInv.isempty())
            update lstInv;
            
        }
        catch(exception ex)
        {
            Database.rollback(sp);
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;
        }
        
        if(test.isrunningTest()){
            integer a = integer.valueof('InvalidInput');
        }
    }    
        
    public map<string,Id> getValidCustomerAccount(map<string,string> mapCustomer){
        map<string,ID> mapCustomerAccount = new map<string,ID>();
        Id CDCustomerRecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
        
        list<account> lstCustomerAccount  =  [select Id,Name,VCPL_CDOS_AccountId__c from account where Recordtypeid =:CDCustomerRecordTypeid and  VCPL_CDOS_AccountId__c IN:mapCustomer.keyset()];
        if (!lstCustomerAccount.isempty()){
            for (Account objAcc:lstCustomerAccount){
                mapCustomerAccount.put(objAcc.VCPL_CDOS_AccountId__c,objAcc.id);
            }
        }
        return mapCustomerAccount;
    }  
    
    
    public map<string,Id> getValidBranch(map<string,string> mapCustomer){
        map<string,ID> mapBranchbyAccount = new map<string,ID>();
        Id AccDelarRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
        
        list<account> lstCustomerAccount  =  [select Id,Name from Account where Recordtypeid =: AccDelarRecordTypeId and  name IN: mapCustomer.Values()];
        if (!lstCustomerAccount.isempty()){
            for (Account objAcc:lstCustomerAccount){
                mapBranchbyAccount.put(objAcc.Name,objAcc.id);
            }
        }
        return mapBranchbyAccount;
    } 
    //get the Product from Maping object
    public map<string,CD_SKU_Mapping__c> GetProduct(set<string> setCDSKU){
        map<string,CD_SKU_Mapping__c> mapCDSKU = new map<string,CD_SKU_Mapping__c>();
        for(CD_SKU_Mapping__c objCDSKUMapping :[select id,Product__c,Classification__c,Name  from CD_SKU_Mapping__c where Name IN:setCDSKU ]) {
            mapCDSKU.put(objCDSKUMapping.Name,objCDSKUMapping);            
        }
        return mapCDSKU;
    }
    
    
    public map<string,id> getCustomerBranchPlanData(map<string,string>mapcustomerBranch,set<string> setAccBranchfis)
    {
        map<string,Account> mapAccountid = new map<string,Account>();
        map<string,id> mapCustomerPlanid = new map<string,id>();
        map<id,string> mapAccountidbyCDOSAccid = new map<id,string>();
        list<VCPL_Customer_Plan__c> lstCustomerPlan = new list<VCPL_Customer_Plan__c>();
        set<id> setAccountId = new set<id>();
        set<string> setBranch = new set<string>();
        map<string,Account> mapAccountidbybranch = new map<string,Account>();
        map<string,id> MapCPIdByAccountBranch = new map<string,id>();
        map<string,VCPL_Customer_Plan__c> mapCustomerPlanold = new map<string,VCPL_Customer_Plan__c>(); 
        map<string,Account> mapAccountbyaccountid = new map<string,Account>();
        
        if (mapcustomerBranch != null &&  mapcustomerBranch.size() > 0){
            
            list<Account> lstBranchAccount =  [select id,name,VCPL_BC_Auto_Number__c from Account where Recordtypeid =:AccDelarRecordTypeId and name IN: mapcustomerBranch.values()];
            if (!lstBranchAccount.isempty()){
                for (Account objAcc:lstBranchAccount)
                mapAccountidbybranch.put(objAcc.name,objAcc);
            }
            
            list<Account> lstAcc = [select id,name,VCPL_CDOS_AccountId__c,VCPL_Current_Fin_Year_Total_Potential__c  from Account where RecordTypeid =:CDCustomerRecordTypeid  and  VCPL_CDOS_AccountId__c IN:mapcustomerBranch.keyset()];
            
            if (!lstAcc.isempty()){
                for (Account objAcc: lstAcc){
                    mapAccountid.put(objAcc.VCPL_CDOS_AccountId__c,objAcc);
                    mapAccountbyaccountid.put(objAcc.id,objAcc);
                    setAccountId.add(objAcc.id);                    
                }
                
                if (setAccBranchfis.size() > 0){
                    string strAccount;
                    string str2;
                    string strBranch;
                    map<String,String> mapsepratedValues = new map<String,String>();
                    map<String,String> mapsepratedValuesold = new map<String,String>();
                    set<string> setacccustfin = new set<string>();
                    set<string> setacccustfinold = new set<string>();
                    for (string strconcat:setAccBranchfis){
                        
                        str2=strconcat.substringAfter(':');
                        
                        
                        if (mapAccountid.containskey(strconcat.substringBefore(':')) && mapAccountidbybranch.containskey(str2.substringBefore('@'))){
                            
                            strAccount = mapAccountid.get(strconcat.substringBefore(':')).id;
                            strBranch=mapAccountidbybranch.get(str2.substringBefore('@')).id;
                            if(strAccount != null && strBranch != null && str2 != null){
                                setacccustfin.add(strAccount + strBranch + str2.substringAfter('@'));
                            }
                            mapsepratedValues.put(strAccount + strBranch + str2.substringAfter('@'),strAccount +':'+ strBranch +'@'+ str2.substringAfter('@')); 
                            setacccustfinold.add(strAccount + strBranch + string.valueof(integer.valueof(str2.substringAfter('@'))-1));
                            mapsepratedValuesold.put(strAccount + strBranch + string.valueof(integer.valueof(str2.substringAfter('@'))-1),strAccount +':'+ strBranch +'@'+ string.valueof(integer.valueof(str2.substringAfter('@'))-1));
                        }
                    }
                    
                    Id CPRecordTypeId = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
                    list<VCPL_Customer_Plan__c> lstVCPLCustomerPlan = [select id,VCPL_Customer_Account__c,VCPL_CD_Customer__c,VCPL_Branch__c,VCPL_CD_Customer__r.VCPL_CDOS_Accountid__c,VCPL_Customer_Account__r.Name,VCPL_Financial_Year__c from VCPL_Customer_Plan__c 
                    where VCPL_MergeValues__c IN:setacccustfin ];
                    
                    if (!lstVCPLCustomerPlan.isempty()){
                        for (VCPL_Customer_Plan__c objCP: lstVCPLCustomerPlan){
                            mapCustomerPlanid.put(string.valueof(objCP.VCPL_CD_Customer__c) + string.valueof(objCP.VCPL_Customer_Account__c) + string.valueof(objCP.VCPL_Financial_Year__c ) ,objCP.id);
                            MapCPIdByAccountBranch.put(objCP.VCPL_CD_Customer__r.VCPL_CDOS_Accountid__c + objCP.VCPL_Customer_Account__r.Name + objCP.VCPL_Financial_Year__c ,objCP.id);
                        }
                    }
                    
                    for(VCPL_Customer_Plan__c objVCPLCustomerPlanold :[select id,VCPL_Last_Year_Sales_Vol__c,VCPL_Customer_Account__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.VCPL_CDOS_Accountid__c,VCPL_Customer_Account__r.Name,VCPL_Financial_Year__c,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c from VCPL_Customer_Plan__c 
                    where VCPL_MergeValues__c IN:setacccustfinold])
                    {
                        mapCustomerPlanold.put(string.valueof(objVCPLCustomerPlanold.VCPL_CD_Customer__c) + string.valueof(objVCPLCustomerPlanold.VCPL_Customer_Account__c)  + string.valueof(objVCPLCustomerPlanold.VCPL_Financial_Year__c) ,objVCPLCustomerPlanold);    
                    }
                    
                    if (setacccustfin.size() > 0){
                        for (string str:setacccustfin)
                        {
                            if (mapCustomerPlanid.size() ==0 || (!mapCustomerPlanid.containskey(str))){
                                if (mapAccountbyaccountid.Containskey(mapsepratedValues.get(str).substringBefore(':'))){
                                    string strValue = mapsepratedValues.get(str).substringafter(':');
                                    Account objAccount = mapAccountbyaccountid.get(mapsepratedValues.get(str).substringBefore(':'));
                                    VCPL_Customer_Plan__c objcp = new VCPL_Customer_Plan__c();
                                    if (!string.isblank(strValue.substringBefore('@'))){
                                        objcp.VCPL_Customer_Account__c = strValue.substringBefore('@');
                                    }
                                    objcp.VCPL_CD_Customer__c = objAccount.id;
                                    objcp.RecordTypeId = CPRecordTypeId;    
                                    objcp.VCPL_Financial_Year__c = mapsepratedValues.get(str).substringafter('@');
                                    if (mapAccountidbybranch.Containskey(mapcustomerBranch.get(objAccount.VCPL_CDOS_AccountId__c))){    
                                        objcp.name = mapsepratedValues.get(str).substringafter('@') +'-'+ objAccount.Name+'-'+ mapAccountidbybranch.get(mapcustomerBranch.get(objAccount.VCPL_CDOS_AccountId__c)).VCPL_BC_Auto_Number__c;
                                    }
                                    
                                    /*if (mapsepratedValuesold.size() > 0 && mapsepratedValuesold.containskey(str) && mapCustomerPlanold.containskey(objAccount.id + strValue + strValue.substringafter('@')) ){
                                        objcp.VCPL_Last_Year_Sales_Vol__c = mapCustomerPlanold.get(objAccount.id + strValue + strValue.substringafter('@')).VCPL_Last_Year_Sales_Vol__c ;
                                        objcp.VCPL_Last_Year_IO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue + strValue.substringafter('@')).VCPL_Branch_IO_Sales__c ;
                                        objcp.VCPL_Last_Year_CO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue + strValue.substringafter('@')).VCPL_Branch_CO_Sales__c ;
                                    } */ 
                                    
                                    if (mapsepratedValuesold.size() > 0 && mapsepratedValuesold.containskey(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)) && mapCustomerPlanold.containskey(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)) ){
                                        objcp.VCPL_Last_Year_Sales_Vol__c = mapCustomerPlanold.get(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)).VCPL_Last_Year_Sales_Vol__c ;
                                        objcp.VCPL_Last_Year_IO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)).VCPL_Branch_IO_Sales__c ;
                                        objcp.VCPL_Last_Year_CO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)).VCPL_Branch_CO_Sales__c ;
                                    }     
                                    
                                    objcp.VCPL_Potential__c=objAccount.VCPL_Current_Fin_Year_Total_Potential__c;
                                    objcp.VCPL_Assignment_Classification__c = 'Others';
                                    if (mapsepratedValues.get(str).substringafter('@') == strCurrentFinancialYear)
                                    objcp.VCPL_Is_Current_Financial_Year__c = true ;
                                    lstCustomerPlan.add(objcp);
                                    mapAccountidbyCDOSAccid.put(objAccount.id,objAccount.VCPL_CDOS_AccountId__c);
                                }
                            }
                        }
                        
                        if (!lstCustomerPlan.isempty()){
                            insert  lstCustomerPlan ;
                            
                            for (VCPL_Customer_Plan__c objCustomerPlan : lstCustomerPlan){  
                                MapCPIdByAccountBranch.put(mapAccountidbyCDOSAccid.get(objCustomerPlan.VCPL_CD_Customer__c) + mapcustomerBranch.get(mapAccountidbyCDOSAccid.get(objCustomerPlan.VCPL_CD_Customer__c)) + objCustomerPlan.VCPL_Financial_Year__c,objCustomerPlan.id);
                            }
                        }                               
                    }  
                }      
            }
        }
        return MapCPIdByAccountBranch;
    }    
    
    public map<String,id> getCustomerDealerPlanData(map<string,string>mapcustomerBranch,set<string> setAccBranchfis)
    {
        map<string,Account> mapAccountid = new map<string,Account>();
        map<string,id> mapCustomerPlanid = new map<string,id>();
        map<id,string> mapAccountidbyCDOSAccid = new map<id,string>();
        list<VCPL_Customer_Plan__c> lstCustomerPlan = new list<VCPL_Customer_Plan__c>();
        set<id> setAccountId = new set<id>();
        map<string,Account> mapAccountidbybranch = new map<string,Account>();
        map<string,id> mapAccountidbyDelar = new map<string,id>();
        map<string,id> MapCPIdByAccountDealer = new map<string,id>();
        map<string,VCPL_Customer_Plan__c> mapCustomerPlanold = new map<string,VCPL_Customer_Plan__c>();
        map<id,string> mapbranchbyparentid = new map<id,string>();
        map<string,Account> mapAccountbyaccountid = new map<string,Account>();
        
        if (mapcustomerBranch != null &&  mapcustomerBranch.size() > 0){
            
            list<Account> lstBranchAccount =  [select id,name,parentid,VCPL_CDOS_AccountId__c,VCPL_DC_Auto_Number__c from Account where Recordtypeid =:AccDelarRecordTypeId and name IN: mapcustomerBranch.values()];
            if (!lstBranchAccount.isempty()){
                for (Account objAcc:lstBranchAccount){
                    mapAccountidbybranch.put(objAcc.name,objAcc);
                    mapAccountidbyDelar.put(objAcc.name,objAcc.parentid);
                    mapbranchbyparentid.put(objAcc.parentid,objAcc.name);
                    
                }
                
                list<Account> lstAcc = [select id,name,VCPL_CDOS_AccountId__c,VCPL_Current_Fin_Year_Total_Potential__c,VCPL_DC_Auto_Number__c from Account where Recordtypeid =:CDCustomerRecordTypeid and  VCPL_CDOS_AccountId__c IN:mapcustomerBranch.keyset()];
                
                if (!lstAcc.isempty()){
                    for (Account objAcc: lstAcc){
                        mapAccountid.put(objAcc.VCPL_CDOS_AccountId__c,objAcc);
                        mapAccountbyaccountid.put(objAcc.id,objAcc);
                        setAccountId.add(objAcc.id);    
                    }
                    Id CPRecordTypeId = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Dealer Customer').getRecordTypeId();
                    
                    if (setAccBranchfis.size() > 0){
                        string strAccount;
                        string str2;
                        string strBranch;
                        map<String,String> mapsepratedValues = new map<String,String>();
                        map<String,String> mapsepratedValuesold = new map<String,String>();
                        set<string> setacccustfin = new set<string>();
                        set<string> setacccustfinold = new set<string>();
                        for (string strconcat:setAccBranchfis){
                            str2=strconcat.substringAfter(':');
                            if (mapAccountid.containskey(strconcat.substringBefore(':')) && mapAccountidbybranch.containskey(str2.substringBefore('@'))){
                                strAccount = mapAccountid.get(strconcat.substringBefore(':')).id;
                                strBranch=mapAccountidbybranch.get(str2.substringBefore('@')).parentid;
                                
                                setacccustfin.add(strAccount + strBranch + str2.substringAfter('@'));
                                mapsepratedValues.put(strAccount + strBranch + str2.substringAfter('@'),strAccount +':'+ strBranch +'@'+ str2.substringAfter('@')); 
                                setacccustfinold.add(strAccount + strBranch + string.valueof(integer.valueof(str2.substringAfter('@'))-1));
                                mapsepratedValuesold.put(strAccount + strBranch + string.valueof(integer.valueof(str2.substringAfter('@'))-1),strAccount +':'+ strBranch +'@'+ string.valueof(integer.valueof(str2.substringAfter('@'))-1));
                            }
                        }
                        
                        list<VCPL_Customer_Plan__c> lstVCPLCustomerPlan = [select id,VCPL_Customer_Account__c,VCPL_CD_Customer__c,VCPL_Dealer_Account__c,VCPL_Branch__c,VCPL_CD_Customer__r.VCPL_CDOS_Accountid__c,VCPL_Customer_Account__r.Name,VCPL_Financial_Year__c 
                        from VCPL_Customer_Plan__c where VCPL_MergeValues__c IN:setacccustfin ];
                        if (!lstVCPLCustomerPlan.isempty()){
                            for (VCPL_Customer_Plan__c objCP: lstVCPLCustomerPlan){
                                mapCustomerPlanid.put(string.valueof(objCP.VCPL_CD_Customer__c) + string.valueof(objCP.VCPL_Customer_Account__c)  + string.valueof(objCP.VCPL_Financial_Year__c) ,objCP.id);
                                MapCPIdByAccountDealer.put(objCP.VCPL_CD_Customer__r.VCPL_CDOS_Accountid__c + mapbranchbyparentid.get(objCP.VCPL_Customer_Account__c) + string.valueof(objCP.VCPL_Financial_Year__c),objCP.id);
                            }
                        }
                        
                        for(VCPL_Customer_Plan__c objVCPLCustomerPlanold :[select id,VCPL_Last_Year_Sales_Vol__c,VCPL_Customer_Account__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.VCPL_CDOS_Accountid__c,VCPL_Customer_Account__r.Name,VCPL_Financial_Year__c,VCPL_Dealer_IO_Sales__c,VCPL_Dealer_CO_Sales__c 
                        from VCPL_Customer_Plan__c where VCPL_MergeValues__c IN: setacccustfinold ])
                        {
                            mapCustomerPlanold.put(string.valueof(objVCPLCustomerPlanold.VCPL_CD_Customer__c) + string.valueof(objVCPLCustomerPlanold.VCPL_Customer_Account__c) + string.valueof(objVCPLCustomerPlanold.VCPL_Financial_Year__c) ,objVCPLCustomerPlanold);    
                        }
                        
                        if (setacccustfin.size() > 0){
                            for (string str:setacccustfin)
                            {
                                if (mapCustomerPlanid.size() ==0 || (!mapCustomerPlanid.containskey(str))){
                                    if (mapAccountbyaccountid.containskey(mapsepratedValues.get(str).substringBefore(':'))){
                                        string strValue = mapsepratedValues.get(str).substringafter(':');                                   
                                        Account objAccount = mapAccountbyaccountid.get(mapsepratedValues.get(str).substringBefore(':'));
                                        VCPL_Customer_Plan__c objcp = new VCPL_Customer_Plan__c();
                                        objcp.VCPL_CD_Customer__c = objAccount.id;
                                        
                                        if (!string.isblank(strValue.substringbefore('@'))){
                                            objcp.VCPL_Customer_Account__c = strValue.substringbefore('@');
                                        }
                                        objcp.RecordTypeId = CPRecordTypeId;    
                                        objcp.VCPL_Financial_Year__c = mapsepratedValues.get(str).substringafter('@');
                                        if (mapAccountidbybranch.containskey(mapcustomerBranch.get(objAccount.VCPL_CDOS_Accountid__c))){
                                            objcp.name = mapsepratedValues.get(str).substringafter('@') +'-'+objAccount.Name +'-'+ mapAccountidbybranch.get(mapcustomerBranch.get(objAccount.VCPL_CDOS_Accountid__c)).VCPL_DC_Auto_Number__c;
                                        }
                                        
                                        /*if (mapsepratedValuesold.size() > 0 && mapsepratedValuesold.containskey(str) && mapCustomerPlanold.containskey(objAccount.id + strValue + strValue.substringafter('@'))){
                                            objcp.VCPL_Last_Year_Sales_Vol__c = mapCustomerPlanold.get(objAccount.id + strValue + strValue.substringafter('@')).VCPL_Last_Year_Sales_Vol__c ;
                                            objcp.VCPL_Last_Year_IO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue + strValue.substringafter('@')).VCPL_Branch_IO_Sales__c ;
                                            objcp.VCPL_Last_Year_CO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue + strValue.substringafter('@')).VCPL_Branch_CO_Sales__c ;
                                        }*/
                                        
                                        if (mapsepratedValuesold.size() > 0 && mapsepratedValuesold.containskey(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)) && mapCustomerPlanold.containskey(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1))){
                                            objcp.VCPL_Last_Year_Sales_Vol__c = mapCustomerPlanold.get(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)).VCPL_Last_Year_Sales_Vol__c ;
                                            objcp.VCPL_Last_Year_IO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)).VCPL_Dealer_IO_Sales__c ;
                                            objcp.VCPL_Last_Year_CO_Sales_Volume__c = mapCustomerPlanold.get(objAccount.id + strValue.substringbefore('@') + string.valueof(integer.valueof(strValue.substringAfter('@'))-1)).VCPL_Dealer_CO_Sales__c ;
                                        }
                                        
                                        objcp.VCPL_Potential__c=objAccount.VCPL_Current_Fin_Year_Total_Potential__c;
                                        objcp.VCPL_Assignment_Classification__c = 'Others';
                                        if (mapsepratedValues.get(str).substringafter('@') == strCurrentFinancialYear)
                                        objcp.VCPL_Is_Current_Financial_Year__c = true ;
                                        
                                        lstCustomerPlan.add(objcp);
                                        mapAccountidbyCDOSAccid.put(objAccount.id,objAccount.VCPL_CDOS_AccountId__c);
                                    }
                                }
                            }
                            
                            if (!lstCustomerPlan.isempty()){
                                insert  lstCustomerPlan ;
                                
                                for (VCPL_Customer_Plan__c objCustomerPlan : lstCustomerPlan){  
                                    MapCPIdByAccountDealer.put(mapAccountidbyCDOSAccid.get(objCustomerPlan.VCPL_CD_Customer__c) + mapcustomerBranch.get(mapAccountidbyCDOSAccid.get(objCustomerPlan.VCPL_CD_Customer__c)) + objCustomerPlan.VCPL_Financial_Year__c ,objCustomerPlan.id);  
                                }
                            }
                        }    
                        
                    }
                    
                }
            }   
        }
        return MapCPIdByAccountDealer;
    }
    
}