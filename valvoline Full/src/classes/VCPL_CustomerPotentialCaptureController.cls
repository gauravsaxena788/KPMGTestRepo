public without sharing class VCPL_CustomerPotentialCaptureController 
{
    public class getDetailsWrapper
    {
    	@AuraEnabled public string strUsersName;
    	@AuraEnabled public string strFinancialYear;
    }
    @AuraEnabled
    public static getDetailsWrapper getDetails()
    {
    	getDetailsWrapper objWrapper = new getDetailsWrapper();
    	
    	objWrapper.strUsersName = VCPL_MonthlySalesPlanController.getloggedInUsername();
    	objWrapper.strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    	Integer previousYear = integer.valueOf(objWrapper.strFinancialYear)-1; 
    	objWrapper.strFinancialYear = string.valueof(previousYear)+'-'+objWrapper.strFinancialYear.substring(objWrapper.strFinancialYear.length()-2);
    	
    	return objWrapper;
    }
    public class detailsWrapper
    {
    	@AuraEnabled public string strAccountName;
    	@AuraEnabled public Id strAccountID;
    	@AuraEnabled public Double samplePH6Potentialvalue1;
    	@AuraEnabled public string samplePH6PotentialvalueID1;
    	@AuraEnabled public Double samplePH6Potentialvalue2;
    	@AuraEnabled public string samplePH6PotentialvalueID2;
    	@AuraEnabled public Double samplePH6Potentialvalue3;
    	@AuraEnabled public string samplePH6PotentialvalueID3;
    	@AuraEnabled public Double samplePH6Potentialvalue4;
    	@AuraEnabled public string samplePH6PotentialvalueID4;
    	@AuraEnabled public Double samplePH6Potentialvalue5;
    	@AuraEnabled public string samplePH6PotentialvalueID5;
    	@AuraEnabled public Double samplePH6Potentialvalue6;
    	@AuraEnabled public string samplePH6PotentialvalueID6;
    	@AuraEnabled public Double samplePH6Potentialvalue7;
    	@AuraEnabled public string samplePH6PotentialvalueID7;
    }
    @AuraEnabled
    public static list<detailsWrapper> getData(string strFinancialYear,string strAccountID)
    {
    	list<detailsWrapper> lstWrapper = new list<detailsWrapper>();
        strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    	if(strFinancialYear != NULL && strFinancialYear != '')
    	{
    		set<string> setofPH6Values = new set<string>{'Gas Engine Oils','Industrial Oils','Gear Oils','Antifreeze','Greases','HDDEO','Others'};//HDDEO MISSING//
    		set<Id> setAccountID = new set<Id>();
    	   	list<Account> lstAccount = new list<Account>();
    		Id idCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ID-Customer').getRecordTypeId();
    		
    		if(strAccountID == NULL || strAccountID == '')
    		{
    			setAccountID = VCPL_MonthlySalesPlanController.getChildAccounts();
    			lstAccount = VCPL_MonthlySalesPlanController.getAccountList();
    		}
    		else
    		{
    			lstAccount = [select id,parentID,Ship_to_Code__c,name,VCPL_Account_ID__c,RecordTypeID from Account where parentID=:strAccountID 
    							and RecordTypeID=:idCustomerRecordType];
    			if(lstAccount != NULL && !lstAccount.isEmpty())
    			{
    				for(Account objAccount : lstAccount)
    				{
    					setAccountID.add(objAccount.id);
    				}
    			}
    		}
    		if(strFinancialYear != NULL && setAccountID != NULL)
    		{
    			string strAccountPotentialKey = NULL;
    			
    			map<string,Account_Potential__c> mapofAccountPotential = new map<string,Account_Potential__c>();
    			
    			for(Account_Potential__c objPotential : [select id,Account__c,AccPotentialCalculation__c,No_of_month_passed_in_Financial_Year__c,PH6_Qlikview__c,
    														Product_penetration__c,Potential_Volume_in_kL__c,Valvoline_Financial_Year__c,YTD_in_volume__c from 
    														Account_Potential__c where Account__c in:setAccountID and PH6_Qlikview__c in:setofPH6Values and 
    														Valvoline_Financial_Year__c =:strFinancialYear])
				{
					strAccountPotentialKey = '';
					strAccountPotentialKey = objPotential.Account__c+'-'+objPotential.PH6_Qlikview__c+'-'+objPotential.Valvoline_Financial_Year__c;
					
					if(!mapofAccountPotential.containskey(strAccountPotentialKey))
					{
						mapofAccountPotential.put(strAccountPotentialKey,objPotential);
					}	
				}
				
				if(lstAccount != NULL && !lstAccount.isEmpty())
				{
					string strPH6Key1 = null;
					string strPH6Key2 = null;
					string strPH6Key3 = null;
					string strPH6Key4 = null;
					string strPH6Key5 = null;
					string strPH6Key6 = null;
					string strPH6Key7 = null;
					
					for(Account objAccount : lstAccount)
					{
						strPH6Key1 = '';
						strPH6Key2 = '';
						strPH6Key3 = '';
						strPH6Key4 = '';
						strPH6Key5 = '';
						strPH6Key6 = '';
						strPH6Key7 = '';
						
						strPH6Key1 = objAccount.ID+'-'+'Gas Engine Oils'+'-'+strFinancialYear;
						strPH6Key2 = objAccount.ID+'-'+'Industrial Oils'+'-'+strFinancialYear;
						strPH6Key3 = objAccount.ID+'-'+'Gear Oils'+'-'+strFinancialYear;
						strPH6Key4 = objAccount.ID+'-'+'Antifreeze'+'-'+strFinancialYear;
						strPH6Key5 = objAccount.ID+'-'+'Greases'+'-'+strFinancialYear;
						strPH6Key6 = objAccount.ID+'-'+'HDDEO'+'-'+strFinancialYear;
						strPH6Key7 = objAccount.ID+'-'+'Others'+'-'+strFinancialYear;
						
						
						
						detailsWrapper objDetailWrapper = new detailsWrapper();
						objDetailWrapper.strAccountName = objAccount.Name;
						objDetailWrapper.strAccountID = objAccount.ID;
						if(mapofAccountPotential.containsKey(strPH6Key1) && mapofAccountPotential.get(strPH6Key1) != NULL 
							&& mapofAccountPotential.get(strPH6Key1).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue1 = mapofAccountPotential.get(strPH6Key1).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID1 = mapofAccountPotential.get(strPH6Key1).ID;
						}
						else 
						{
							objDetailWrapper.samplePH6Potentialvalue1 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID1 = '';
						}
						
						if(mapofAccountPotential.containsKey(strPH6Key2) && mapofAccountPotential.get(strPH6Key2) != NULL 
							&& mapofAccountPotential.get(strPH6Key2).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue2 = mapofAccountPotential.get(strPH6Key2).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID2 = mapofAccountPotential.get(strPH6Key2).ID;
						}
						else
						{
							objDetailWrapper.samplePH6Potentialvalue2 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID2 = '';
						}
						
						if(mapofAccountPotential.containsKey(strPH6Key3) && mapofAccountPotential.get(strPH6Key3) != NULL 
							&& mapofAccountPotential.get(strPH6Key3).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue3 = mapofAccountPotential.get(strPH6Key3).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID3 = mapofAccountPotential.get(strPH6Key3).ID;
						}
						else
						{
							objDetailWrapper.samplePH6Potentialvalue3 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID3 = '';
						}
						
						if(mapofAccountPotential.containsKey(strPH6Key4) && mapofAccountPotential.get(strPH6Key4) != NULL 
							&& mapofAccountPotential.get(strPH6Key4).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue4 = mapofAccountPotential.get(strPH6Key4).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID4 = mapofAccountPotential.get(strPH6Key4).ID;
						}
						else
						{
							objDetailWrapper.samplePH6Potentialvalue4 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID4 = '';
						}
						
						if(mapofAccountPotential.containsKey(strPH6Key5) && mapofAccountPotential.get(strPH6Key5) != NULL 
							&& mapofAccountPotential.get(strPH6Key5).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue5 = mapofAccountPotential.get(strPH6Key5).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID5 = mapofAccountPotential.get(strPH6Key5).ID;
						}
						else
						{
							objDetailWrapper.samplePH6Potentialvalue5 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID5 = '';
						}
						
						if(mapofAccountPotential.containsKey(strPH6Key6) && mapofAccountPotential.get(strPH6Key6) != NULL 
							&& mapofAccountPotential.get(strPH6Key6).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue6 = mapofAccountPotential.get(strPH6Key6).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID6 = mapofAccountPotential.get(strPH6Key6).ID;
						}
						else
						{
							objDetailWrapper.samplePH6Potentialvalue6 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID6 = '';
						}
						
						if(mapofAccountPotential.containsKey(strPH6Key7) && mapofAccountPotential.get(strPH6Key7) != NULL 
							&& mapofAccountPotential.get(strPH6Key7).Potential_Volume_in_kL__c != NULL)
						{
							objDetailWrapper.samplePH6Potentialvalue7 = mapofAccountPotential.get(strPH6Key7).Potential_Volume_in_kL__c*1000; 
							objDetailWrapper.samplePH6PotentialvalueID7 = mapofAccountPotential.get(strPH6Key7).ID;
						}
						else
						{
							objDetailWrapper.samplePH6Potentialvalue7 = 0.00;
							objDetailWrapper.samplePH6PotentialvalueID7 = '';
						}
						
						lstWrapper.add(objDetailWrapper); 
						
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
    public static string saveDate(string strResponse)
    {
    	string strStatus='Initiated';
    	
    	if(strResponse != NULL)
    	{
    		list<Account_Potential__c> lstToInsert = new list<Account_Potential__c>();
    		list<Account_Potential__c> lstToUpdate = new list<Account_Potential__c>();
    		
    		list<VCPL_CustomerPotentialCaptureController.detailsWrapper> lstOpportunityWrapper=  (List<VCPL_CustomerPotentialCaptureController.detailsWrapper>)JSON.deserialize(strResponse,List<VCPL_CustomerPotentialCaptureController.detailsWrapper>.class);
    		
    		if(lstOpportunityWrapper != NULL && !lstOpportunityWrapper.isEmpty())
    		{
    			strStatus='Parsed';
    			
    			for(detailsWrapper objWrapper : lstOpportunityWrapper)
    			{
    				if(objWrapper.samplePH6Potentialvalue1>0 || ((objWrapper.samplePH6Potentialvalue1 ==0 || objWrapper.samplePH6Potentialvalue1 == NULL) && objWrapper.samplePH6PotentialvalueID1 != ''))
    				{
    					if(objWrapper.samplePH6PotentialvalueID1 != '')
    					{
    						Account_Potential__c objAccountPotential = new Account_Potential__c();
    						objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID1;
    						objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue1 != NULL?(objWrapper.samplePH6Potentialvalue1/1000):0;
    						
    						lstToUpdate.add(objAccountPotential);
    					}
    					else
    					{
    						Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'Gas Engine Oils',objWrapper.samplePH6Potentialvalue1/1000);
    						lstToInsert.add(objAccountPotential);
    					}
    				}
    				
    				if(objWrapper.samplePH6Potentialvalue2>0 || ((objWrapper.samplePH6Potentialvalue2 ==0 || objWrapper.samplePH6Potentialvalue2 ==NULL) && objWrapper.samplePH6PotentialvalueID2 != ''))
					{
						if(objWrapper.samplePH6PotentialvalueID2 != '')
						{
							Account_Potential__c objAccountPotential = new Account_Potential__c();
							objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID2;
							objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue2 != NULL?(objWrapper.samplePH6Potentialvalue2/1000):0;
							
							lstToUpdate.add(objAccountPotential);
						}
						else
						{
							Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'Industrial Oils',objWrapper.samplePH6Potentialvalue2/1000);
							lstToInsert.add(objAccountPotential);
						}
					}
					
					if(objWrapper.samplePH6Potentialvalue3>0 || ((objWrapper.samplePH6Potentialvalue3 ==0 || objWrapper.samplePH6Potentialvalue3 == NULL) && objWrapper.samplePH6PotentialvalueID3 != ''))
					{
						if(objWrapper.samplePH6PotentialvalueID3 != '')
						{
							Account_Potential__c objAccountPotential = new Account_Potential__c();
							objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID3;
							objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue3 != NULL?(objWrapper.samplePH6Potentialvalue3/1000):0;
							
							lstToUpdate.add(objAccountPotential);
						}
						else
						{
							Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'Gear Oils',objWrapper.samplePH6Potentialvalue3/1000);
							lstToInsert.add(objAccountPotential);
						}
					}
					
					if(objWrapper.samplePH6Potentialvalue4>0 || ((objWrapper.samplePH6Potentialvalue4 ==0 || objWrapper.samplePH6Potentialvalue4 ==NULL) && objWrapper.samplePH6PotentialvalueID4 != ''))
					{
						if(objWrapper.samplePH6PotentialvalueID4 != '')
						{
							Account_Potential__c objAccountPotential = new Account_Potential__c();
							objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID4;
							objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue4 != NULL?(objWrapper.samplePH6Potentialvalue4/1000):0;
							
							lstToUpdate.add(objAccountPotential);
						}
						else
						{
							Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'Antifreeze',objWrapper.samplePH6Potentialvalue4/1000);
							lstToInsert.add(objAccountPotential);
						}
					}
					
					if(objWrapper.samplePH6Potentialvalue5>0 || ((objWrapper.samplePH6Potentialvalue5 ==0 || objWrapper.samplePH6Potentialvalue5 == NULL) && objWrapper.samplePH6PotentialvalueID5 != ''))
					{
						if(objWrapper.samplePH6PotentialvalueID5 != '')
						{
							Account_Potential__c objAccountPotential = new Account_Potential__c();
							objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID5;
							objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue5 != NULL?(objWrapper.samplePH6Potentialvalue5/1000):0;
							
							lstToUpdate.add(objAccountPotential);
						}
						else
						{
							Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'Greases',objWrapper.samplePH6Potentialvalue5/1000);
							lstToInsert.add(objAccountPotential);
						}
					}
					
					if(objWrapper.samplePH6Potentialvalue6>0 || ((objWrapper.samplePH6Potentialvalue6 ==0 || objWrapper.samplePH6Potentialvalue6 == null) && objWrapper.samplePH6PotentialvalueID6 != ''))
					{
						if(objWrapper.samplePH6PotentialvalueID6 != '')
						{
							Account_Potential__c objAccountPotential = new Account_Potential__c();
							objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID6;
							objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue6 != NULL?(objWrapper.samplePH6Potentialvalue6/1000):0;
							
							lstToUpdate.add(objAccountPotential);
						}
						else
						{
							Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'HDDEO',objWrapper.samplePH6Potentialvalue6/1000);
							lstToInsert.add(objAccountPotential);
						}
					}
					
					if(objWrapper.samplePH6Potentialvalue7>0 || ((objWrapper.samplePH6Potentialvalue7 ==0 || objWrapper.samplePH6Potentialvalue7 == NULL) && objWrapper.samplePH6PotentialvalueID7 != ''))
					{
						if(objWrapper.samplePH6PotentialvalueID7 != '')
						{
							Account_Potential__c objAccountPotential = new Account_Potential__c();
							objAccountPotential.Id = objWrapper.samplePH6PotentialvalueID7;
							objAccountPotential.Potential_Volume_in_kL__c = objWrapper.samplePH6Potentialvalue7 != NULL?(objWrapper.samplePH6Potentialvalue7/1000):0;
							
							lstToUpdate.add(objAccountPotential);
						}
						else
						{
							Account_Potential__c objAccountPotential = createPotential(objWrapper.strAccountID,'Others',objWrapper.samplePH6Potentialvalue7/1000);
							lstToInsert.add(objAccountPotential);
						}
					}
    			}
    			if(lstToInsert != NULL && !lstToInsert.isEmpty())
    			{
    				try {
    					Database.DMLOptions dml = new Database.DMLOptions();
						dml.DuplicateRuleHeader.AllowSave = true;
						 
						list<Database.SaveResult> sr = Database.insert(lstToInsert, dml); 
    					strStatus='Processed successfully';
    				}
    				catch(exception ex)
    				{
    					strStatus = 'Error: ' + ex.getMessage();
    				}
    			}
    			
    			if(lstToUpdate != NULL && !lstToUpdate.isEmpty())
    			{
    				try {
    					update lstToUpdate;
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
    public static Account_Potential__c createPotential(string strAccountid,string strPH6,Double potential)
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
    @AuraEnabled
    public static list<detailsWrapper> getSearchResults(string strSearchString,string strResponse)
    {
		list<detailsWrapper> lstWrapper= new list<detailsWrapper>();
		
		if(strResponse != NULL && strResponse != '')
		{
			list<VCPL_CustomerPotentialCaptureController.detailsWrapper> lstOpportunityWrapper=  (List<VCPL_CustomerPotentialCaptureController.detailsWrapper>)JSON.deserialize(strResponse,List<VCPL_CustomerPotentialCaptureController.detailsWrapper>.class);
			
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