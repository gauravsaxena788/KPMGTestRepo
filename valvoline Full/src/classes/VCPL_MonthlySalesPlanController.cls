public without sharing class VCPL_MonthlySalesPlanController  
{
	//==============================================================================================================
    //Description: This Method is used to return Financial Year on Basis of Date and Fiscal Year start Month
    //==============================================================================================================
    @AuraEnabled
    public static String getFinancialYear(Date dtDate,Integer FiscalYearStartMonth)
    {
        if(dtDate==null){return 'null';}
        
        integer currentmonth =dtDate.Month();
        integer currntDtYear= dtDate.Year();
    	
    	if(currentmonth < FiscalYearStartMonth)
        {
            return string.valueof(currntDtYear);
        }
        else
        {
        	return string.valueof(currntDtYear+1);
        }
        
         return 'null';    
    }
    //==============================================================================================================
    //Description: This Method is used to return current Fiscal Year
    //==============================================================================================================
    @AuraEnabled
    public static string getCurrentFinancialYear()
    {
        Integer fiscalYearStartMonth = 10;
        
        string strfinyear=getFinancialYear(system.today(),fiscalYearStartMonth);
        
        return strfinyear;
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
    //==============================================================================================================
    //Description: This Method is used to return month in No
    //==============================================================================================================
    @AuraEnabled
    public  static Map<string,string>  getMonthNo()
    {
        Map<string,string> mapNameMonthNum = new Map<string,string>
        {'January'=>'01','February'=>'02','March'=>'03','April'=>'04','May'=>'05','June'=>'06','July'=>'07','August'=>'08','September'=>'09',
            'October'=>'10','November'=>'11','December'=>'12'};
                
                return mapNameMonthNum;
    }
    //==============================================================================================================
    //Description: This Method is used to return month sequence
    //==============================================================================================================
    @AuraEnabled
    public  static Map<string,Integer>  getMonthSequence()
    {
        Map<string,Integer> mapNameMonthNum = new Map<string,Integer>
        {'October'=>1, 'November'=>2, 'December'=>3,'January'=>4,'February'=>5,'March'=>6,'April'=>7, 'May'=>8,'June'=>9,
            'July'=>10,'August'=>11, 'September'=>12};
                
                return mapNameMonthNum;
    }
    //==============================================================================================================
    //Description: This Method is used to return month Names ordered from Current Month
    //==============================================================================================================
    @AuraEnabled
    public static list<string> getMonthNames()
    {
        Map<Integer,string> mapNameMonthNum = getMonthName();
        
        Integer i = system.today().month();
        
        list<string> lstString = new list<string>();
        
        for(integer start = i;i< =12;i++)
        {
            lstString.add(mapNameMonthNum.get(i));
        }
        for(string strmonthName : mapNameMonthNum.values())
        {
            if(!lstString.contains(strmonthName))
            {
                lstString.add(strmonthName);
            }
        }
        
        return lstString;
    }
    
    //==================================================================================================================
    //Description: get Current Logged in User Acount Name
    //==================================================================================================================
    @AuraEnabled
    public static string getParentAccount()
    {
        Id userId = userinfo.getuserId();
        
        list<User> lstAccount = [select id,AccountId from User where Id=:userId];
        
        if(lstAccount != NULL && !lstAccount.isEmpty())
        {
            return lstAccount[0].AccountId;
        }
        else 
        {
            return null;  
        }
    }
    //==================================================================================================================
    //Description: get child Accounts
    //==================================================================================================================
    public static set<Id> getChildAccounts()
    {
        Id accountID = getParentAccount();    
        set<Id> setAccountId = new set<Id>();
        Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
        if(accountID != NULL)
        {
            list<Account> lstAccount = [select id,parentId,RecordTypeID,createdDate from Account where parentId=:accountID and 
            							RecordTypeID=:idCustomerRecordType];
            
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
    public static list<Account> getAccountList()
    {
    	Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    	set<ID> setId = getChildAccounts();
    	
    	return[select id,Ship_to_Code__c,name,VCPL_Account_ID__c,createdDate from Account where ID in:setId and 
    			RecordTypeID=:idCustomerRecordType];
    }
    //==================================================================================================================
    //Description: get Current Logged in User Name
    //==================================================================================================================
    @AuraEnabled
    public static string getloggedInUsername()
    {
        Id userId = userinfo.getuserId();
        
        list<User> lstUser = [select id,name from User where Id=:userId];
        
        if(lstUser != NULL && !lstUser.isEmpty())
        {
            return lstUser[0].name;
        }
        else
        {
            return null;
        }
    }
    //==================================================================================================================
    //Description: Details wrapper
    //==================================================================================================================
    public class getDetailsWrapper
    {
    	@AuraEnabled public string strUsersName;
    	@AuraEnabled public string strFinancialYear;
    	@AuraEnabled public list<string> lstMonthNames;
    }
    //==================================================================================================================
    //Description: Basic Details
    //==================================================================================================================
    @AuraEnabled
    public static getDetailsWrapper getDetails()
    {
    	getDetailsWrapper objWrapper = new getDetailsWrapper();
    	
    	objWrapper.strUsersName = getloggedInUsername();
    	objWrapper.strFinancialYear = getCurrentFinancialYear();
    	Integer previousYear = integer.valueOf(objWrapper.strFinancialYear)-1; 
    	objWrapper.strFinancialYear = string.valueof(previousYear)+'-'+objWrapper.strFinancialYear.substring(objWrapper.strFinancialYear.length()-2);
    	objWrapper.lstMonthNames = getMonthNames();
    
    	return objWrapper;
    } 
    public static string getYear(string strMonth)
    {
    	string strCurrentYear =string.valueOf(system.today().year());
    	if(strMonth != NULL)
    	{
    		map<string,Integer> mapofMonth = getMonthSequence();
    		
			if(mapofMonth != NULL && !mapofMonth.isEmpty())
			{
				if(mapofMonth.get(strMonth) > 3){
					strCurrentYear = string.valueOf(integer.valueOf(strCurrentYear)+1);
				}
				else{
					strCurrentYear = string.valueOf(integer.valueOf(strCurrentYear));
				}
			}
    		
    	}
    	return strCurrentYear;
    }
    //==================================================================================================================
    //Description: opportunity Details
    //==================================================================================================================
    public Class OpportunityWrapper
    {
     	@AuraEnabled public string strAccountName;
     	@AuraEnabled public VCPL_Customer_Plan__c objOpportunity;
     	@AuraEnabled public Double plannedSales;
     	@AuraEnabled public Double latestEstimatedSales;
     	@AuraEnabled public Double actualSales;
     	@AuraEnabled public Double lastYearSalesVolume;
     	@AuraEnabled public Boolean isDisable;
     	@AuraEnabled public Boolean isDisablePlannedSales;
    }
    //==================================================================================================================
    //
    //==================================================================================================================
    @AuraEnabled
    public static list<OpportunityWrapper> getData(string strMonth,string strAccountID)
    {
    	list<OpportunityWrapper> lstOppWrapper = new list<OpportunityWrapper>();
    	if(strMonth != NULL)
    	{
    		Boolean disableFields = true;
    		Boolean disablePlannedSales = true;
    		////////////////////////////////////////////////////////////////////////////////////////////////////////////
    		map<Integer,String> mapofMonth = getMonthName();
    		map<string,string> mapofMonthInInt = getMonthNo();
    		string strCurrentMonth = mapofMonth.get(system.today().month());
    		Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    		map<string,Integer> mapofMonthtoInt = getMonthSequence();
    		if(strMonth == strCurrentMonth){
    			Date dtToday = system.today();
				Date dtStartofMonth =dtToday.toStartOfMonth();
				Integer intDaysDurationForDisable = integer.valueof(label.VCPL_No_of_Days_for_Disable) != NULL?integer.valueof(label.VCPL_No_of_Days_for_Disable):7;
				Date dtForDisable = dtStartofMonth.addDays(intDaysDurationForDisable);
				
				if(dtToday < dtForDisable){disableFields = false;}
    		}
    		else
    		{
    			if(mapofMonthtoInt.get(strMonth) > mapofMonthtoInt.get(strCurrentMonth)){disableFields = false;}
    			else if(mapofMonthtoInt.get(strMonth) < mapofMonthtoInt.get(strCurrentMonth))
    			{
    				disableFields = true;
    			}
    		}
    		///////////////////////////////////////////////////////////////////////////////////////////////////////////
    		set<Id> setAccountID = new set<Id>();
    		list<Account> lstAccount = new list<Account>();
    		if(strAccountID == NULL || strAccountID == '')
    		{
    			 setAccountID = getChildAccounts();
    			 lstAccount =getAccountList();
    		}
    		else
    		{
    			lstAccount = [select id,parentID,Ship_to_Code__c,name,VCPL_Account_ID__c,RecordTypeID,createdDate from Account where parentID=:strAccountID and 
    							RecordTypeID=:idCustomerRecordType];
    			
    			if(lstAccount != NULL && !lstAccount.isEmpty())
    			{
    				for(Account objAccount : lstAccount)
    				{
    					setAccountID.add(objAccount.id);
    				}
    			}
    		}
    		string strFinancialYear = getCurrentFinancialYear();
    		/////////////////////////////////////////////////////////////////////////////////////////////////////
    		map<string,VCPL_Customer_Plan__c> mapofpreviousYearOpp = new map<string,VCPL_Customer_Plan__c>();
    		if(setAccountID != NULL && !setAccountID.isEmpty())
    		{
    			string strPrevFinancialYear = string.valueOf(Integer.valueOf(strFinancialYear)-1);
    			
    			if(strPrevFinancialYear != NULL)
    			{
    				string strKey = null;
    				for(VCPL_Customer_Plan__c objOpportunity : [select id,VCPL_Month__c,VCPL_Financial_Year__c,/*Insha Account.Ship_to_Code__c,*/VCPL_Customer_Account__r.Ship_to_Code__c,/*Insha AccountID,*/VCPL_Customer_Account__c,VCPL_Last_Year_Sales_Vol__c,
    													VCPL_Actual_Sales__c,VCPL_Opportunity_Code__c from VCPL_Customer_Plan__c where 
    													/*Insha AccountID*/VCPL_Customer_Account__c in:setAccountID and VCPL_Month__c =:strMonth 
    													and VCPL_Financial_Year__c =:strPrevFinancialYear])
					{
						strKey = '';
						strKey = objOpportunity.VCPL_Month__c+'-'+objOpportunity.VCPL_Financial_Year__c+'-'+objOpportunity.VCPL_Customer_Account__c/*Insha objOpportunity.AccountID*/;
						
						if(strKey != NULL)
						{
							if(!mapofpreviousYearOpp.containskey(strKey))
								mapofpreviousYearOpp.put(strKey,objOpportunity);
						}
					}
					
    			}
    		}
    		//////////////////////////////////////////////////////////////////////////////////////////////////////
    		string strOppkey;
    		string strAcckey;
    		map<string,VCPL_Customer_Plan__c> mapOfOpportunities = new map<string,VCPL_Customer_Plan__c>();
    		for(VCPL_Customer_Plan__c objOpportunity : [select id,VCPL_Month__c,VCPL_Financial_Year__c,/*Insha accountID,*/VCPL_Last_Year_Sales_Vol__c,/*Insha Account.Name*/VCPL_Customer_Account__r.Name,name,/*Insha StageName*,/
    											/*Insha closeDate,*/VCPL_Planned_sales__c,
    											VCPL_Latest_Est_Sales__c,VCPL_Actual_Sales__c,VCPL_Opportunity_Code__c from VCPL_Customer_Plan__c 
    											where VCPL_Month__c=:strMonth and VCPL_Financial_Year__c=:strFinancialYear and 
    											/*Insha accountID*/VCPL_Customer_Account__c in:setAccountID])
    		{
    			strOppkey = '';
    			strOppkey = /*Insha objOpportunity.accountID*/objOpportunity.VCPL_Customer_Account__c+'-'+objOpportunity.VCPL_Month__c+'-'+objOpportunity.VCPL_Financial_Year__c;	
    			mapOfOpportunities.put(strOppkey,objOpportunity);
    		}
    		if(lstAccount != NULL && !lstAccount.isEmpty())
    		{
    			Date FYstartDate = date.newInstance(integer.valueof(VCPL_MonthlySalesPlanController.getCurrentFinancialYear())-1, 10, 1);
    			Date FYendDate = FYstartDate.addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable));
    			
    			if(system.today() >= FYstartDate && system.today()<FYendDate){disablePlannedSales = false;}
    			for(Account objAccount :lstAccount)
    			{
    				strAcckey = '';
    				
    				strAcckey = objAccount.id+'-'+strMonth+'-'+strFinancialYear;
    				
    				if(mapOfOpportunities.get(strAcckey) != NULL)
    				{
    					OpportunityWrapper objWrap = new OpportunityWrapper();
    					objWrap.strAccountName = objAccount.Name;
    					objWrap.objOpportunity = mapOfOpportunities.get(strAcckey);
    					objWrap.plannedSales = mapOfOpportunities.get(strAcckey).VCPL_Planned_sales__c != NULL?mapOfOpportunities.get(strAcckey).VCPL_Planned_sales__c*1000:0;
    					objWrap.latestEstimatedSales = mapOfOpportunities.get(strAcckey).VCPL_Latest_Est_Sales__c != NULL?mapOfOpportunities.get(strAcckey).VCPL_Latest_Est_Sales__c*1000:0;
    					objWrap.actualSales = mapOfOpportunities.get(strAcckey).VCPL_Actual_Sales__c != NULL?mapOfOpportunities.get(strAcckey).VCPL_Actual_Sales__c*1000:0;
    					
    					if(mapofpreviousYearOpp != NULL && !mapofpreviousYearOpp.isEmpty() && 
    						mapofpreviousYearOpp.containskey(strMonth+'-'+string.valueOf(Integer.valueOf(strFinancialYear)-1)+'-'+objAccount.ID) && 
    						mapofpreviousYearOpp.get(strMonth+'-'+string.valueOf(Integer.valueOf(strFinancialYear)-1)+'-'+objAccount.ID).VCPL_Actual_Sales__c != NULL)
						{
							objWrap.lastYearSalesVolume = mapofpreviousYearOpp.get(strMonth+'-'+string.valueOf(Integer.valueOf(strFinancialYear)-1)+'-'+objAccount.ID).VCPL_Actual_Sales__c*1000;
						}
						else
						{
							objWrap.lastYearSalesVolume = 0.0;
						}
    					objWrap.isDisable = disableFields;
    					objWrap.isDisablePlannedSales = disablePlannedSales;
    					
    					string strToday = string.valueof(system.today()).split(' ')[0];
    					string strCreatedDate =  string.valueof(date.valueOf(objAccount.createdDate)).split(' ')[0];
    					string strthresholdDate =  string.valueof(date.valueOf(objAccount.createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable))).split(' ')[0];
    					
    					if((strToday == strCreatedDate) || (system.today() >= date.valueOf(objAccount.createdDate) && system.today() < date.valueOf(objAccount.createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable))))
    					{
    						objWrap.isDisablePlannedSales = false;
    					}
    					if((strToday == strCreatedDate) || (system.today() >= date.valueOf(objAccount.createdDate) && system.today() < date.valueOf(objAccount.createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Disable))))
                        {
                         	objWrap.isDisable = false;   
                        }
						if(mapofMonthtoInt.get(strMonth) < mapofMonthtoInt.get(strCurrentMonth))
						{
							objWrap.isDisable = true; 
						}
                        
    					lstOppWrapper.add(objWrap);
    				}
    				else
    				{
    					VCPL_Customer_Plan__c objOpportunity = new VCPL_Customer_Plan__c(VCPL_Customer_Account__c = objAccount.id,
																		VCPL_Month__c = strMonth,
																		VCPL_Financial_Year__c = strFinancialYear,
																		//name=strMonth.substring(0,3)+'-'+getYear(strMonth)+'-'+objAccount.Ship_to_Code__c+'-'+'Monthly Plan',
																		name=strMonth.substring(0,3)+'-'+getYear(strMonth)+'-'+objAccount.VCPL_Account_ID__c+'-'+'Monthly Plan',
																		//Insha StageName='Open',
																		//Insha closeDate=system.today(),
																		VCPL_Planned_sales__c=0.0,
																		VCPL_Latest_Est_Sales__c=0.0,
																		VCPL_Actual_Sales__c=0.0,
																		VCPL_Opportunity_Code__c = objAccount.VCPL_Account_ID__c+mapofMonthInInt.get(strMonth)+getYear(strMonth).substring(2,4));
    					
	    					OpportunityWrapper objWrap = new OpportunityWrapper();
	    					objWrap.strAccountName = objAccount.Name;
	    					objWrap.objOpportunity = objOpportunity;
	    					objWrap.plannedSales = objOpportunity.VCPL_Planned_sales__c != NULL?objOpportunity.VCPL_Planned_sales__c*1000:0;
	    					objWrap.latestEstimatedSales = objOpportunity.VCPL_Latest_Est_Sales__c != NULL?objOpportunity.VCPL_Latest_Est_Sales__c*1000:0;
	    					objWrap.actualSales = objOpportunity.VCPL_Actual_Sales__c != NULL?objOpportunity.VCPL_Actual_Sales__c:0;
	    					if(mapofpreviousYearOpp != NULL && !mapofpreviousYearOpp.isEmpty() &&  
    						mapofpreviousYearOpp.containskey(strMonth+'-'+string.valueOf(Integer.valueOf(strFinancialYear)-1)+'-'+objAccount.Id) && 
    						mapofpreviousYearOpp.get(strMonth+'-'+string.valueOf(Integer.valueOf(strFinancialYear)-1)+'-'+objAccount.Id).VCPL_Actual_Sales__c != NULL)
							{
								objWrap.lastYearSalesVolume = mapofpreviousYearOpp.get(strMonth+'-'+string.valueOf(Integer.valueOf(strFinancialYear)-1)+'-'+objAccount.Id).VCPL_Actual_Sales__c;
							}
							else
							{
								objWrap.lastYearSalesVolume = 0.0;
							}	
	    					
	    					objWrap.isDisable = disableFields;	
	    					objWrap.isDisablePlannedSales = disablePlannedSales;
	    					string strToday = string.valueof(system.today()).split(' ')[0];
	    					string strCreatedDate =  string.valueof(date.valueOf(objAccount.createdDate)).split(' ')[0];
	    					string strthresholdDate =  string.valueof(date.valueOf(objAccount.createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable))).split(' ')[0];
	    					if((strToday == strCreatedDate) || (system.today() >= date.valueOf(objAccount.createdDate) && system.today() < date.valueOf(objAccount.createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Planned_Sales_Disable))))
	    					{
	    						objWrap.isDisablePlannedSales = false;
	    					}
                        	if((strToday == strCreatedDate) || (system.today() >= date.valueOf(objAccount.createdDate) && system.today() < date.valueOf(objAccount.createdDate).addDays(integer.valueof(label.VCPL_No_of_Days_for_Disable))))
                            {
                                objWrap.isDisable = false;
                            }
							if(mapofMonthtoInt.get(strMonth) < mapofMonthtoInt.get(strCurrentMonth))
							{
								objWrap.isDisable = true; 
							}
	    					lstOppWrapper.add(objWrap);
    					
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
    		return null;
    	}
    }
    @AuraEnabled
    public static string saveOpportunity(string strResponse)
    {
    	string strStatus='Initiated';
    	
    	list<VCPL_Customer_Plan__c> lstOpportunity = new list<VCPL_Customer_Plan__c>();
    	if(strResponse != NULL)
    	{
    		list<VCPL_MonthlySalesPlanController.OpportunityWrapper> lstOpportunityWrapper=  (List<VCPL_MonthlySalesPlanController.OpportunityWrapper>)JSON.deserialize(strResponse,List<VCPL_MonthlySalesPlanController.OpportunityWrapper>.class);
    		strStatus='Parsed';
    		if(lstOpportunityWrapper != NULL && !lstOpportunityWrapper.isEmpty())
    		{
    			for(OpportunityWrapper objOppWrapper : lstOpportunityWrapper)
    			{
					if((objOppWrapper.plannedSales > 0 || 
						objOppWrapper.latestEstimatedSales > 0) || (((objOppWrapper.plannedSales == 0 || objOppWrapper.plannedSales == NULL) || (objOppWrapper.latestEstimatedSales == 0 || objOppWrapper.latestEstimatedSales == NULL)) && 
							objOppWrapper.objOpportunity.Id != NULL))
					{
						objOppWrapper.objOpportunity.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
						//Insha objOppWrapper.objOpportunity.closeDate = system.today();
						objOppWrapper.objOpportunity.VCPL_Planned_sales__c = objOppWrapper.plannedSales != NULL?objOppWrapper.plannedSales/1000:0;
						//objOppWrapper.objOpportunity.VCPL_Actual_Sales__c = objOppWrapper.actualSales;
						objOppWrapper.objOpportunity.VCPL_Latest_Est_Sales__c = objOppWrapper.latestEstimatedSales != NULL?objOppWrapper.latestEstimatedSales/1000:0;
						//Insha objOppWrapper.objOpportunity.IsCreatedfromVF__c = true;
						lstOpportunity.add(objOppWrapper.objOpportunity);
					}
				}
    			if(lstOpportunity != NULL && !lstOpportunity.isEmpty())
    			{
    				try {upsert lstOpportunity;
    					strStatus='Processed successfully';
    				}
    				catch(exception ex) {strStatus = 'Error: ' + ex.getMessage();
    				}
    			}
    		}
    	}
    	return strStatus;
    }
    @AuraEnabled
    public static list<OpportunityWrapper> getSearchResults(string strSearchString,string strResponse)
    {
    	list<OpportunityWrapper> lstWrapper = new list<OpportunityWrapper>();
    	
    	if(strResponse != NULL && strResponse != '')
    	{
    		list<OpportunityWrapper> lstOpportunityWrapper =  (List<OpportunityWrapper>)JSON.deserialize(strResponse,List<OpportunityWrapper>.class);
    		
    		if(lstOpportunityWrapper != NULL && !lstOpportunityWrapper.isEmpty())
    		{
    			if(strSearchString != NULL && strSearchString != '')
    			{
    				for(OpportunityWrapper objWrapper : lstOpportunityWrapper)
    				{
    					if(objWrapper.strAccountName.containsIgnoreCase(strSearchString))
    					{
    						lstWrapper.add(objWrapper);
    					}
    				}
    			}
    			else
    			{
    				return lstOpportunityWrapper;
    			}
    		}
    	}
    	if(lstWrapper != NULL && !lstWrapper.isEmpty())
    	{
    		return lstWrapper;
    	}
    	else
    	{
    		return NULL;
    	}
    }
}