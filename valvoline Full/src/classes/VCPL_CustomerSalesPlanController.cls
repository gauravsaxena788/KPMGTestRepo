public without sharing class VCPL_CustomerSalesPlanController 
{
	//==================================================================================================================
    //Description: get child Accounts
    //==================================================================================================================
    public static set<Id> getChildAccounts(string strAccountID)
    {
    	Id accountID;
    	Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    	if(strAccountID == NULL)
    	{
        	accountID = VCPL_MonthlySalesPlanController.getParentAccount(); 
    	}   
    	else
    	{
    		accountID = strAccountID;
    	}
        set<Id> setAccountId = new set<Id>();
        if(accountID != NULL)
        {
            list<Account> lstAccount = [select id,parentId,VCPL_Account_ID__c,RecordTypeID from Account where parentId=:accountID 
            							and RecordTypeID=:idCustomerRecordType];
            
            if(lstAccount != NULL && !lstAccount.isEmpty())
            {
                
                for(Account objAccount :lstAccount)
                {
                    setAccountId.add(objAccount.id);
                }
                
            }
        }
        if(setAccountId != NULL && !setAccountId.isEmpty())
        {
            return setAccountId;
        }
        else 
        {
            return NULL;
        }	
    }
    //==================================================================================================================
    //Description: get child Accounts
    //==================================================================================================================
    @AuraEnabled
    public static list<Account> getAccountList(string strAccountID)
    {
    	set<ID> setId = new set<Id>();
    	Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    	if(strAccountID == NULL)
    	{
    		setId = getChildAccounts(NULL);
    	}
    	else
    	{
    		setId = getChildAccounts(strAccountID);
    	}
    	return[select id,Ship_to_Code__c,name,VCPL_Account_ID__c,RecordTypeID,createdDate from Account where ID in:setId  and RecordTypeID =:
    			idCustomerRecordType];
    }
    //==================================================================================================================
    //Description: Details wrapper
    //==================================================================================================================
	public class getDetailsWrapper
    {
    	@AuraEnabled public string strUsersName;
    	@AuraEnabled public string strFinancialYear;
    	@AuraEnabled public list<string> lstAccountNames;
    }
    //============================================================================
    //This Method is used to get Account Names
    //============================================================================
    @AuraEnabled
    public static list<string> getAccountNames(string strAccountID)
    {
    	list<Account> lstAccounts = new list<Account>();
    	if(strAccountID == NULL)
    	{
    		lstAccounts = getAccountList(NULL);
    	}
    	else
    	{
    		lstAccounts = getAccountList(strAccountID);
    	} 
    	list<string> lstAccountNames = new list<string>();
    	lstAccountNames.add('No Account Found');
    	
    	if(lstAccounts != NULL && !lstAccountnames.isEmpty())
    	{
    		lstAccountNames.clear();
    		
    		for(Account objAccount : lstAccounts)
    		{
    			lstAccountNames.add(objAccount.name);
    		}	
    	}
    	if(lstAccountNames != NULL && !lstAccountNames.isEmpty())
    	{
    		return lstAccountNames;
    	}
    	else
    	{
    		return null;
    	}
    }
    @AuraEnabled
    public static map<string,Account> getAccount(string strAccountID)
    {
    	list<Account> lstAccounts = getAccountList(strAccountID);
        system.debug('lstAccounts==='+lstAccounts);
    	map<string,Account> mapofAccount = new map<string,Account>();
        
        if(lstAccounts != NULL && !lstAccounts.isEmpty())
        {
            for(Account objAccount : lstAccounts)
            {
                if(!mapofAccount.containsKey(objAccount.Name))
                {
                    mapofAccount.put(objAccount.Name, objAccount);
                }
            }
        }
        if(mapofAccount != NULL && !mapofAccount.isEmpty()){
            return mapofAccount;
        }
        else
            return null;
    }
    //==================================================================================================================
    //Description: Basic Details
    //==================================================================================================================
    @AuraEnabled
    public static getDetailsWrapper getDetails(string strAccountID)
    {
    	getDetailsWrapper objWrapper = new getDetailsWrapper();
    	
    	objWrapper.strUsersName = VCPL_MonthlySalesPlanController.getloggedInUsername();
    	objWrapper.strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    	Integer previousYear = integer.valueOf(objWrapper.strFinancialYear)-1; 
    	objWrapper.strFinancialYear = string.valueof(previousYear)+'-'+objWrapper.strFinancialYear.substring(objWrapper.strFinancialYear.length()-2);
    	if(strAccountID == NULL)
    	{
    		objWrapper.lstAccountNames = getAccountNames(NULL);
    	}
    	else
    	{
    		objWrapper.lstAccountNames = getAccountNames(strAccountID);
    	}
    	return objWrapper;
    }
    @AuraEnabled
    public static list<string> getMonthnames()
    {
    	map<string,Integer> mapofMonthSequence = VCPL_MonthlySalesPlanController.getMonthSequence();
    	list<string> lstMonths = new list<string>(mapofMonthSequence.keyset());
    	
    	return lstMonths;
    }
    //==============================================================================================================
    //Description: This Method is used to return month Name
    //==============================================================================================================
    @AuraEnabled
    public  static Map<Integer,string>  getMonthName()
    {
        Map<Integer,string> mapNameMonthNum = new Map<Integer,string>
        {1=>'January', 2=>'February', 3=>'March', 4=>'April', 5=>'May',6=>'June', 7=>'July', 8=>'August', 9=>'September',
            10=>'October',11=>'November', 12=>'December'};
                
                return mapNameMonthNum;
    }
    //==================================================================================================================
    //Description: Oportunity Wrapper
    //==================================================================================================================
    public class OpportunityWrapper
    {
    	@AuraEnabled public string strMonth;
    	@AuraEnabled public VCPL_Customer_Plan__c objOpportunity;
    	@AuraEnabled public Double plannedSales;
     	@AuraEnabled public Double latestEstimatedSales;
     	@AuraEnabled public Double actualSales;
     	@AuraEnabled public Double lastYearSalesVolume;
     	@AuraEnabled public Boolean isDisable;
     	@AuraEnabled public Boolean isDisablePlannedSales;
    }
    @AuraEnabled
    public static list<OpportunityWrapper> getOpportunityWrapper(string strAccount,string parentAccountID)
    {
    	list<OpportunityWrapper> lstOppWrapper = new list<OpportunityWrapper>();
    	if(strAccount != NULL && strAccount != 'No Account Found')
    	{
    		Id accountID = null;
    		string strAccountShipToCode;
    		Boolean disableFields = true;
    		Boolean disablePlannedSales = true;
    		string strAccountId = null;
    		map<string,Account> mapofAccount = new map<string,Account>();
    		map<string,string> mapofMonthInInt = VCPL_MonthlySalesPlanController.getMonthNo();
    		
    		if(parentAccountID == NULL)
    		{
    			mapofAccount = getAccount(NULL);
    		}
    		else
    		{
    			mapofAccount = getAccount(parentAccountID);
                system.debug('====mapofAccount===='+mapofAccount);
    		}
    		Date FYstartDate = date.newInstance(integer.valueof(VCPL_MonthlySalesPlanController.getCurrentFinancialYear())-1, 10, 1);
    		Date FYendDate = FYstartDate.addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable));
    			
			if(system.today() >= FYstartDate && system.today()<FYendDate)
			{
				disablePlannedSales = false;
			}
    		if(mapofAccount != NULL && !mapofAccount.isEmpty() && mapofAccount.containskey(strAccount) 
    			&& mapofAccount.get(strAccount) != NULL)
			{
				accountID = mapofAccount.get(strAccount).ID;
				strAccountId = mapofAccount.get(strAccount).VCPL_Account_ID__c;
				strAccountShipToCode = mapofAccount.get(strAccount).Ship_to_Code__c;
				///////////////////////////////////////////
				string strToday = string.valueof(system.today()).split(' ')[0];
				string strCreatedDate =  string.valueof(date.valueOf(mapofAccount.get(strAccount).createdDate)).split(' ')[0];
				string strthresholdDate =  string.valueof(date.valueOf(mapofAccount.get(strAccount).createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable))).split(' ')[0];
				//////////////////////////////////////////////
				if((strToday == strCreatedDate) || (system.today() >= date.valueof(mapofAccount.get(strAccount).createdDate)  
					&& system.today()< date.valueOf(mapofAccount.get(strAccount).createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable))))
				{
					disablePlannedSales = false;
				}
			}
			
			string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
			list<string> lstMonthNames = getMonthnames();
			/////////////////////////////////////////////////////////////////
			map<string,VCPL_Customer_Plan__c> mapofPrevsYearOpp = new map<string,VCPL_Customer_Plan__c>();
			if(lstMonthNames != NULL && !lstMonthNames.isEmpty())
			{
				string strPreviousFinancialYear = string.valueOf(integer.valueOf(strFinancialYear)-1);
				string strKey = null;
				for(VCPL_Customer_Plan__c objOpportunity : [select id,VCPL_Month__c,VCPL_Financial_Year__c,/*Insha Account.Ship_to_Code__c,
													Account.Name,AccountID,*/VCPL_Customer_Account__r.Ship_to_Code__c,
                                                    VCPL_Customer_Account__r.Name,VCPL_Customer_Account__c,
                                                    VCPL_Actual_Sales__c from VCPL_Customer_Plan__c where 
													VCPL_Month__c in:lstMonthNames and 
													VCPL_Financial_Year__c=:strPreviousFinancialYear and 
													/*Insha Account.Name*/VCPL_Customer_Account__r.Name=:strAccount])
				{
					strKey = '';
					strKey = objOpportunity.VCPL_Month__c+'-'+objOpportunity.VCPL_Financial_Year__c+'-'+objOpportunity.VCPL_Customer_Account__c/*objOpportunity.AccountID*/;
					
					if(!mapofPrevsYearOpp.containskey(strKey))
						mapofPrevsYearOpp.put(strKey,objOpportunity);	
				}
			}
			////////////////////////////////////////////////////////////////
			map<string,VCPL_Customer_Plan__c> mapOfOpportunities = new map<string,VCPL_Customer_Plan__c>();
			string strOppkey = '';
			Integer intCurrentMonth = system.today().month();
			for(VCPL_Customer_Plan__c objOpportunity : [select id,VCPL_Month__c,VCPL_Financial_Year__c,/*Insha accountID,Account.Name,*/VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,name,
												/*Insha StageName,closeDate,*/VCPL_Planned_sales__c,VCPL_Latest_Est_Sales__c,
												VCPL_Actual_Sales__c from VCPL_Customer_Plan__c where /*Insha accountID*/VCPL_Customer_Account__c=:accountID and 
												VCPL_Financial_Year__c =:strFinancialYear and VCPL_Month__c != NULL])
			{
				strOppkey = '';
				strOppkey =/*Insha objOpportunity.accountID*/objOpportunity.VCPL_Customer_Account__c + '-'+objOpportunity.VCPL_Month__c+'-'+objOpportunity.VCPL_Financial_Year__c;
				
				if(!mapOfOpportunities.containskey(strOppkey))
				{
					mapOfOpportunities.put(strOppkey,objOpportunity);
				}
			}
			
			
			if(lstMonthNames != NULL && !lstMonthNames.isEmpty())
			{
				string strAcckey;
				map<Integer,string> mapofMonth = getMonthName();
				string strCurrentMonth = mapofMonth.get(system.today().month());
				Date dtToday = system.today();
				Date dtStartofMonth;
				Integer intDaysDurationForDisable = integer.valueof(label.VCPL_No_of_Days_for_Disable) != NULL?integer.valueof(label.VCPL_No_of_Days_for_Disable):7;
				Date dtForDisable;
				map<string,Integer> mapofMonthtoInt = VCPL_MonthlySalesPlanController.getMonthSequence();
				
				string strToday = string.valueof(system.today()).split(' ')[0];
				string strCreatedDate =  string.valueof(date.valueOf(mapofAccount.get(strAccount).createdDate)).split(' ')[0];
				
				for(string strMonthname : lstMonthNames)
				{
					dtStartofMonth = null;
					dtForDisable = null;
					disableFields = true;
					
					if(strCurrentMonth == strMonthname) 
					{
						dtStartofMonth = dtToday.toStartOfMonth();
						dtForDisable = dtStartofMonth.addDays(intDaysDurationForDisable);
						if(dtToday >= dtStartofMonth && dtToday<dtForDisable)
						{
							disableFields = false;
						}
						if((strToday == strCreatedDate) || (system.today() >= date.valueof(mapofAccount.get(strAccount).createdDate)  
							&& system.today()< date.valueOf(mapofAccount.get(strAccount).createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Disable))))
						{
							disableFields = false;
						}
					}
					else
					{
						if(mapofMonthtoInt.get(strMonthname) > mapofMonthtoInt.get(strCurrentMonth))
		    			{
		    				disableFields = false;
		    			}
		    			else if(mapofMonthtoInt.get(strMonthname) < mapofMonthtoInt.get(strCurrentMonth))
		    			{
		    				disableFields = true;
		    			}
					}
					strAcckey = '';
					
					strAcckey = accountID+'-'+strMonthname+'-'+strFinancialYear;
					
					if(mapOfOpportunities.get(strAcckey) != NULL)
					{
						OpportunityWrapper objWrapper = new OpportunityWrapper();
						objWrapper.strMonth = strMonthname;
						objWrapper.objOpportunity = mapOfOpportunities.get(strAcckey);
						objWrapper.plannedSales = mapOfOpportunities.get(strAcckey).VCPL_Planned_sales__c != NULL?mapOfOpportunities.get(strAcckey).VCPL_Planned_sales__c*1000:0.0;
						objWrapper.latestEstimatedSales = mapOfOpportunities.get(strAcckey).VCPL_Latest_Est_Sales__c != NULL?mapOfOpportunities.get(strAcckey).VCPL_Latest_Est_Sales__c*1000:0;
						objWrapper.actualSales = mapOfOpportunities.get(strAcckey).VCPL_Actual_Sales__c != NULL?mapOfOpportunities.get(strAcckey).VCPL_Actual_Sales__c*1000:0.0;
						if(mapofPrevsYearOpp != NULL && !mapofPrevsYearOpp.isEmpty() 
							&& mapofPrevsYearOpp.containsKey(strMonthname+'-'+string.valueOf(integer.valueOf(strFinancialYear)-1)+'-'+accountID) 
							&& mapofPrevsYearOpp.get(strMonthname+'-'+string.valueOf(integer.valueOf(strFinancialYear)-1)+'-'+accountID).VCPL_Actual_Sales__c != NULL)
						{
							objWrapper.lastYearSalesVolume = mapofPrevsYearOpp.get(strMonthname+'-'+string.valueOf(integer.valueOf(strFinancialYear)-1)+'-'+accountID).VCPL_Actual_Sales__c*1000;
						}
						else
						{
							objWrapper.lastYearSalesVolume = 0.0; 
						}
						objWrapper.isDisable = disableFields;
						objWrapper.isDisablePlannedSales = disablePlannedSales;
						lstOppWrapper.add(objWrapper);
					}
					else
					{
						VCPL_Customer_Plan__c objOpportunity = new VCPL_Customer_Plan__c(/*Insha accountID = accountID*/VCPL_Customer_Account__c = accountID,
																	  VCPL_Month__c = strMonthname, 
																	  VCPL_Financial_Year__c = strFinancialYear,
																	  //name = strMonthname.substring(0,3)+'-'+VCPL_MonthlySalesPlanController.getYear(strMonthname)+'-'+strAccountShipToCode+'-'+'Monthly Plan',
																	  name = strMonthname.substring(0,3)+'-'+VCPL_MonthlySalesPlanController.getYear(strMonthname)+'-'+strAccountId+'-'+'Monthly Plan',
																	  //Insha StageName='Open',
																	  //Insha closeDate=system.today(),
																	  VCPL_Planned_sales__c=0.0,
																	  VCPL_Latest_Est_Sales__c=0.0,
																	  VCPL_Actual_Sales__c=0.0,
																	  VCPL_Opportunity_Code__c = strAccountId + mapofMonthInInt.get(strMonthname)+VCPL_MonthlySalesPlanController.getYear(strMonthname).substring(2,4));
						
						OpportunityWrapper objWrapper = new OpportunityWrapper();
						objWrapper.strMonth = strMonthname;
						objWrapper.objOpportunity = objOpportunity;
						objWrapper.plannedSales = objOpportunity.VCPL_Planned_sales__c*1000;
						objWrapper.latestEstimatedSales = objOpportunity.VCPL_Latest_Est_Sales__c*1000;
						objWrapper.actualSales = objOpportunity.VCPL_Actual_Sales__c;
						if(mapofPrevsYearOpp != NULL && !mapofPrevsYearOpp.isEmpty() 
							&& mapofPrevsYearOpp.containsKey(strMonthname+'-'+string.valueOf(integer.valueOf(strFinancialYear)-1)+'-'+accountID) 
							&& mapofPrevsYearOpp.get(strMonthname+'-'+string.valueOf(integer.valueOf(strFinancialYear)-1)+'-'+accountID).VCPL_Actual_Sales__c != NULL)
						{
							objWrapper.lastYearSalesVolume = mapofPrevsYearOpp.get(strMonthname+'-'+string.valueOf(integer.valueOf(strFinancialYear)-1)+'-'+accountID).VCPL_Actual_Sales__c;
						}
						else
						{
							objWrapper.lastYearSalesVolume = 0.0; 
						}
						objWrapper.isDisable = disableFields;
						objWrapper.isDisablePlannedSales = disablePlannedSales;
						lstOppWrapper.add(objWrapper);
						
					}
				}
			}
    	}
    	if(lstOppWrapper != NULL && !lstOppWrapper.isEmpty())
    	{
    		return lstOppWrapper;
    	}
    	else
    	{
    		return NULL;
    	}
    	
    }
    @AuraEnabled
    public static string saveOpportunity(string strResponse)
    {
    	string strStatus = 'Initiated';
    	if(strResponse != NULL)
    	{
    		list<VCPL_Customer_Plan__c> lstOpportunity = new list<VCPL_Customer_Plan__c>();
    		list<OpportunityWrapper> lstOpportunityWrapper=  (List<OpportunityWrapper>)JSON.deserialize(strResponse,List<OpportunityWrapper>.class);
    		
    		if(lstOpportunityWrapper != NULL)
    		{
    			strStatus = 'Parsed';
    			
    			for(OpportunityWrapper objOppWrapper : lstOpportunityWrapper)
    			{
    				if((objOppWrapper.plannedSales > 0 || objOppWrapper.latestEstimatedSales > 0) ||
    					(((objOppWrapper.plannedSales == 0 || objOppWrapper.plannedSales == NULL) || (objOppWrapper.latestEstimatedSales == 0 || objOppWrapper.latestEstimatedSales == NULL)) && objOppWrapper.objOpportunity.ID != NULL))
					{
						objOppWrapper.objOpportunity.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
						//Insha objOppWrapper.objOpportunity.closedate = system.today();
						objOppWrapper.objOpportunity.VCPL_Planned_sales__c = objOppWrapper.plannedSales != NULL?objOppWrapper.plannedSales/1000:0;
						objOppWrapper.objOpportunity.VCPL_Latest_Est_Sales__c = objOppWrapper.latestEstimatedSales != NULL?objOppWrapper.latestEstimatedSales/1000:0;
						//Insha objOppWrapper.objOpportunity.IsCreatedfromVF__c = true;
						
						lstOpportunity.add(objOppWrapper.objOpportunity);
					}
    			}
    			if(lstOpportunity != NULL && !lstOpportunity.isEmpty())
    			{
    				try {
    				upsert lstOpportunity;
    				strStatus='Processed successfully';
    				}
    				catch(exception ex)
    				{
    					strStatus = 'Error: ' + ex.getMessage();
    				}
    			}
    		}
    	}
    	return strStatus;
    } 
}