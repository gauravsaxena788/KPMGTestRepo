public without sharing class VCPL_CustomerSalesCaptureController 
{
	public class getDetailsWrapper
    {
    	@AuraEnabled public string strUsersName;
    	@AuraEnabled public string strFinancialYear;
    	@AuraEnabled public list<string> lstMonthNames;
    }
     @AuraEnabled
    public static getDetailsWrapper getDetails()
    {
    	getDetailsWrapper objWrapper = new getDetailsWrapper();
    	
    	objWrapper.strUsersName = VCPL_MonthlySalesPlanController.getloggedInUsername();
    	objWrapper.strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    	Integer previousYear = integer.valueOf(objWrapper.strFinancialYear)-1; 
    	objWrapper.strFinancialYear = string.valueof(previousYear)+'-'+objWrapper.strFinancialYear.substring(objWrapper.strFinancialYear.length()-2);
    	objWrapper.lstMonthNames = VCPL_MonthlySalesPlanController.getMonthNames();
    
    	return objWrapper;
    } 
    public class detailsWrapper
    {
    	@AuraEnabled public string strAccountName;
    	@AuraEnabled public string strOpportunityName;
    	@AuraEnabled public VCPL_Customer_Plan__c objOpportunity;
    	@AuraEnabled public Double samplePH6value1;
    	//@AuraEnabled public Double potential1;
    	@AuraEnabled public Double samplePH6value2;
    	//@AuraEnabled public Double potential2;
    	@AuraEnabled public Double samplePH6value3;
    	//@AuraEnabled public Double potential3;
    	@AuraEnabled public Double samplePH6value4;
    	//@AuraEnabled public Double potential4;
    	@AuraEnabled public Double samplePH6value5;
    	//@AuraEnabled public Double potential5;
    	@AuraEnabled public Double samplePH6value6;
    	//@AuraEnabled public Double potential6;
    	@AuraEnabled public Double samplePH6value7;
    	//@AuraEnabled public Double potential7;
    	@AuraEnabled public Boolean isDisableSamplePH6value;
    	//@AuraEnabled public Boolean isDisablepotential;
    }
    @AuraEnabled
    public static list<detailsWrapper> getData(string strMonth,string strAccountID)
    {
    	list<detailsWrapper> lstWrapper = new list<detailsWrapper>();
    	
    	if(strMonth != NULL)
    	{
    		Boolean disableSamplePH6value = true;
    		Boolean disablePotential = true;
    		map<string,string> mapofMonthInInt = VCPL_MonthlySalesPlanController.getMonthNo();
    		set<Id> setAccountID = new set<Id>();
    		list<Account> lstAccount = new list<Account>();
    		Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    		
    		if(strAccountID == NULL || strAccountID == '') //For Community consider Logged in User's Account
    		{
    			setAccountID = VCPL_MonthlySalesPlanController.getChildAccounts();
    			lstAccount =VCPL_MonthlySalesPlanController.getAccountList();
    		}
    		else//For Internal Salesforce
    		{
    			lstAccount = [select id,parentID,Ship_to_Code__c,name,VCPL_Account_ID__c,RecordTypeID from Account 
    							where parentID=:strAccountID and RecordTypeID=:idCustomerRecordType];
    							 
    			if(lstAccount != NULL && !lstAccount.isEmpty())
    			{
    				for(Account objAccount : lstAccount)
    				{
    					setAccountID.add(objAccount.id);
    				}
    			}
    		}
    		string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    		
    		if(strFinancialYear != NULL && setAccountID != NULL)
    		{
    			string strOppkey;
    			
    			map<string,VCPL_Customer_Plan__c> mapofOpportunity = new map<string,VCPL_Customer_Plan__c>();  
    			
    			for(VCPL_Customer_Plan__c objOpportunity : [select id,VCPL_Month__c,VCPL_Financial_Year__c,VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,
															name,VCPL_Planned_sales__c,VCPL_Latest_Est_Sales__c,
															VCPL_Actual_Sales__c,VCPL_Sample_PH6_Value_1__c,VCPL_Sample_PH6_Value_2__c,
															VCPL_Sample_PH6_Value_3__c,VCPL_Sample_PH6_Value_4__c,
															VCPL_Sample_PH6_Value_5__c,VCPL_Sample_PH6_Value_6__c,
															VCPL_Sample_PH6_Value_7__c
															from VCPL_Customer_Plan__c where VCPL_Month__c=:strMonth and 
															VCPL_Financial_Year__c=:strFinancialYear 
															and VCPL_Customer_Account__c in:setAccountID])
				{
					strOppkey = '';
					strOppkey += objOpportunity.VCPL_Customer_Account__c+'-'+objOpportunity.VCPL_Month__c+'-'+objOpportunity.VCPL_Financial_Year__c;
					
					if(!mapofOpportunity.containskey(strOppkey))
					{
						mapofOpportunity.put(strOppkey,objOpportunity);
					}	
				}
				if(lstAccount != NULL && !lstAccount.isEmpty())
				{
					string strAcckey;
					map<Integer,String> mapofMonths = VCPL_MonthlySalesPlanController.getMonthName();
					map<String,Integer> mapofMonthsequence = VCPL_MonthlySalesPlanController.getMonthSequence();
					string strCurrentMonth = mapofMonths.get(system.today().month());
					string  SelectedMonth = strMonth;
					
					Integer intCurrentMonthSequence = mapofMonthsequence.get(strCurrentMonth);
					Integer intSelectedMonthSequence = mapofMonthsequence.get(SelectedMonth);
					
					//For Same Month
					if(intSelectedMonthSequence == intCurrentMonthSequence)
					{
						disableSamplePH6value = false;
						//disablePotential = false;
					}
					//For Past Month
					else if(intSelectedMonthSequence < intCurrentMonthSequence)
					{
						disableSamplePH6value = true;
						//disablePotential = true;
					}
					//For Future Month
					else if(intSelectedMonthSequence > intCurrentMonthSequence)
					{
						disableSamplePH6value = true;
						//disablePotential = false;
					}
					
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					/////////////For User Profile/Role Check////////////////////////////////////////////////////////////////////////////
					/////////////get List of Profiles/Role for which it would be Readable and mark both CheckBoxes as true//////////////
					////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					for(Account objAccount : lstAccount)
					{
						strAcckey = '';
						strAcckey  = objAccount.ID+'-'+strMonth+'-'+strFinancialYear;
						
						if(mapofOpportunity.get(strAcckey) != NULL)
						{
							detailsWrapper objWrapper     = new detailsWrapper();
							objWrapper.strAccountName     = objAccount.Name;
							objWrapper.strOpportunityName = mapofOpportunity.get(strAcckey).Name;
							objWrapper.objOpportunity     = mapofOpportunity.get(strAcckey);
							objWrapper.samplePH6value1    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_1__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_1__c*1000:0;
							//objWrapper.potential1         = mapofOpportunity.get(strAcckey).VCPL_Potential_1__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_1__c:0;
							objWrapper.samplePH6value2    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_2__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_2__c*1000:0;
							//objWrapper.potential2         = mapofOpportunity.get(strAcckey).VCPL_Potential_2__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_2__c:0;
							objWrapper.samplePH6value3    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_3__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_3__c*1000:0;
							//objWrapper.potential3         = mapofOpportunity.get(strAcckey).VCPL_Potential_3__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_3__c:0;
							objWrapper.samplePH6value4    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_4__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_4__c*1000:0;
							//objWrapper.potential4         = mapofOpportunity.get(strAcckey).VCPL_Potential_4__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_4__c:0;
							objWrapper.samplePH6value5    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_5__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_5__c*1000:0;
							//objWrapper.potential5         = mapofOpportunity.get(strAcckey).VCPL_Potential_5__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_5__c:0;
							objWrapper.samplePH6value6    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_6__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_6__c*1000:0;
							//objWrapper.potential6         = mapofOpportunity.get(strAcckey).VCPL_Potential_6__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_6__c:0;
							objWrapper.samplePH6value7    = mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_7__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Sample_PH6_Value_7__c*1000:0;
							//objWrapper.potential7        = mapofOpportunity.get(strAcckey).VCPL_Potential_7__c != NULL?mapofOpportunity.get(strAcckey).VCPL_Potential_7__c:0;
							objWrapper.isDisableSamplePH6value = disableSamplePH6value;
							//objWrapper.isDisablepotential = disablePotential;
							
							lstWrapper.add(objWrapper);
						}
						else
						{
							VCPL_Customer_Plan__c objOpportunity = new VCPL_Customer_Plan__c(VCPL_Customer_Account__c = objAccount.id,
																		 VCPL_Month__c = strMonth,
																		 VCPL_Financial_Year__c = strFinancialYear,
																		 //name=strMonth.substring(0,3)+'-'+getYear(strMonth)+'-'+objAccount.Ship_to_Code__c+'-'+'Monthly Plan',
																		 name=strMonth.substring(0,3)+'-'+VCPL_MonthlySalesPlanController.getYear(strMonth)+'-'+objAccount.VCPL_Account_ID__c+'-'+'Monthly Plan',
																		 VCPL_Sample_PH6_Value_1__c=0.0,
																		 //VCPL_Potential_1__c = 0.0,
																		 VCPL_Sample_PH6_Value_2__c=0.0,
																		 //VCPL_Potential_2__c = 0.0,
																		 VCPL_Sample_PH6_Value_3__c=0.0,
																		 //VCPL_Potential_3__c = 0.0,
																		 VCPL_Sample_PH6_Value_4__c=0.0,
																		 //VCPL_Potential_4__c = 0.0,
																		 VCPL_Sample_PH6_Value_5__c=0.0,
																		 //VCPL_Potential_5__c = 0.0,
																		 VCPL_Sample_PH6_Value_6__c=0.0,
																		 //VCPL_Potential_6__c =0.0,
																		 VCPL_Sample_PH6_Value_7__c=0.0,
																		 //VCPL_Potential_7__c =0.0,
																		 VCPL_Opportunity_Code__c = objAccount.VCPL_Account_ID__c+mapofMonthInInt.get(strMonth)+VCPL_MonthlySalesPlanController.getYear(strMonth).substring(2,4));
							
							detailsWrapper objWrapper     = new detailsWrapper();
							objWrapper.strAccountName     = objAccount.Name;
							objWrapper.strOpportunityName = objOpportunity.Name;
							objWrapper.objOpportunity     = objOpportunity;
							objWrapper.samplePH6value1    = objOpportunity.VCPL_Sample_PH6_Value_1__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_1__c:0;
							//objWrapper.potential1         = objOpportunity.VCPL_Potential_1__c != NULL?objOpportunity.VCPL_Potential_1__c:0;
							objWrapper.samplePH6value2    = objOpportunity.VCPL_Sample_PH6_Value_2__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_2__c:0;
							//objWrapper.potential2         = objOpportunity.VCPL_Potential_2__c != NULL?objOpportunity.VCPL_Potential_2__c:0;
							objWrapper.samplePH6value3    = objOpportunity.VCPL_Sample_PH6_Value_3__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_3__c:0;
							//objWrapper.potential3         = objOpportunity.VCPL_Potential_3__c != NULL?objOpportunity.VCPL_Potential_3__c:0;
							objWrapper.samplePH6value4    = objOpportunity.VCPL_Sample_PH6_Value_4__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_4__c:0;
							//objWrapper.potential4         = objOpportunity.VCPL_Potential_4__c != NULL?objOpportunity.VCPL_Potential_4__c:0;
							objWrapper.samplePH6value5    = objOpportunity.VCPL_Sample_PH6_Value_5__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_5__c:0;
							//objWrapper.potential5         = objOpportunity.VCPL_Potential_5__c != NULL?objOpportunity.VCPL_Potential_5__c:0;
							objWrapper.samplePH6value6    = objOpportunity.VCPL_Sample_PH6_Value_6__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_6__c:0;
							//objWrapper.potential6         = objOpportunity.VCPL_Potential_6__c != NULL?objOpportunity.VCPL_Potential_6__c:0;
							objWrapper.samplePH6value7    = objOpportunity.VCPL_Sample_PH6_Value_7__c != NULL?objOpportunity.VCPL_Sample_PH6_Value_7__c:0;
							//objWrapper.potential7        = objOpportunity.VCPL_Potential_7__c != NULL?objOpportunity.VCPL_Potential_7__c:0;
							objWrapper.isDisableSamplePH6value = disableSamplePH6value;
							//objWrapper.isDisablepotential = disablePotential;	
							
							lstWrapper.add(objWrapper);
						}
					}
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
    @AuraEnabled
    public static string saveOpportunity(string strResponse)
    {
    	string strStatus = 'Initiated';
    	
    	if(strResponse != NULL)
    	{
    		list<VCPL_Customer_Plan__c> lstOpportunity = new list<VCPL_Customer_Plan__c>();
    		
    		if(strResponse != NULL)
    		{
    			list<VCPL_CustomerSalesCaptureController.detailsWrapper> lstOpportunityWrapper=  (List<VCPL_CustomerSalesCaptureController.detailsWrapper>)JSON.deserialize(strResponse,List<VCPL_CustomerSalesCaptureController.detailsWrapper>.class);
				
				if(lstOpportunityWrapper != NULL && !lstOpportunityWrapper.isEmpty())
				{
					strStatus='Parsed';
					
					for(detailsWrapper objWrapper : lstOpportunityWrapper)
					{
						if(((objWrapper.samplePH6value1>0) 
    						|| (objWrapper.samplePH6value2>0) 
    						|| (objWrapper.samplePH6value3>0) 
    						|| (objWrapper.samplePH6value4>0) 
    						|| (objWrapper.samplePH6value5>0) 
    						|| (objWrapper.samplePH6value6>0) 
    						|| (objWrapper.samplePH6value7>0)) || (((objWrapper.samplePH6value1==0 || objWrapper.samplePH6value1 == NULL) 
    						|| (objWrapper.samplePH6value2==0 || objWrapper.samplePH6value2 == NULL) 
    						|| (objWrapper.samplePH6value3==0 || objWrapper.samplePH6value3==NULL) 
    						|| (objWrapper.samplePH6value4==0 || objWrapper.samplePH6value4==NULL) 
    						|| (objWrapper.samplePH6value5==0 || objWrapper.samplePH6value5 == NULL) 
    						|| (objWrapper.samplePH6value6==0 || objWrapper.samplePH6value6==NULL) 
    						|| (objWrapper.samplePH6value7==0 || objWrapper.samplePH6value7==NULL)) && objWrapper.objOpportunity.ID != NULL))
						{
							objWrapper.objOpportunity.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
							
							objWrapper.objOpportunity.VCPL_Sample_PH6_Value_1__c = objWrapper.samplePH6value1 != NULL?(objWrapper.samplePH6value1/1000):0;
	    					objWrapper.objOpportunity.VCPL_Sample_PH6_Value_2__c = objWrapper.samplePH6value2 != NULL?(objWrapper.samplePH6value2/1000):0;
	    					objWrapper.objOpportunity.VCPL_Sample_PH6_Value_3__c = objWrapper.samplePH6value3 != NULL?(objWrapper.samplePH6value3/1000):0;
	    					objWrapper.objOpportunity.VCPL_Sample_PH6_Value_4__c = objWrapper.samplePH6value4 != NULL?(objWrapper.samplePH6value4/1000):0;
	    					objWrapper.objOpportunity.VCPL_Sample_PH6_Value_5__c = objWrapper.samplePH6value5 != NULL?(objWrapper.samplePH6value5/1000):0;
	    					objWrapper.objOpportunity.VCPL_Sample_PH6_Value_6__c = objWrapper.samplePH6value6 != NULL?(objWrapper.samplePH6value6/1000):0;
	    					objWrapper.objOpportunity.VCPL_Sample_PH6_Value_7__c = objWrapper.samplePH6value7 != NULL?(objWrapper.samplePH6value7/1000):0;
	    					objWrapper.objOpportunity.VCPL_Actual_Sales__c = objWrapper.objOpportunity.VCPL_Sample_PH6_Value_1__c+objWrapper.objOpportunity.VCPL_Sample_PH6_Value_2__c+objWrapper.objOpportunity.VCPL_Sample_PH6_Value_3__c+objWrapper.objOpportunity.VCPL_Sample_PH6_Value_4__c+objWrapper.objOpportunity.VCPL_Sample_PH6_Value_5__c+objWrapper.objOpportunity.VCPL_Sample_PH6_Value_6__c+objWrapper.objOpportunity.VCPL_Sample_PH6_Value_7__c;
	    					
	    					lstOpportunity.add(objWrapper.objOpportunity);	
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
    	} 
    	return strStatus;
    }
    @AuraEnabled
    public static list<detailsWrapper> getSearchResults(string strSearchString,string strResponse)
    {
    	list<detailsWrapper> lstWrapper= new list<detailsWrapper>();
    	if(strResponse != NULL && strResponse != '')
    	{
    		list<VCPL_CustomerSalesCaptureController.detailsWrapper> lstOpportunityWrapper=  (List<VCPL_CustomerSalesCaptureController.detailsWrapper>)JSON.deserialize(strResponse,List<VCPL_CustomerSalesCaptureController.detailsWrapper>.class);
    		
    		if(lstOpportunityWrapper != NULL && !lstOpportunityWrapper.isEmpty())
    		{
    			if(strSearchString != NULL && strSearchString != '')
    			{
    				for(detailsWrapper objWrapper : lstOpportunityWrapper)
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