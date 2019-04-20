public without sharing class VCPL_IDCustomerPotentialController 
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
    public static detailsWrapper getData(string strFinancialYear,string strAccountID)
    {
    	detailsWrapper objDetailWrapper = new detailsWrapper();
        strFinancialYear=  VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    	if(strAccountID != NULL && strFinancialYear != NULL)
    	{
    		set<string> setofPH6Values = new set<string>{'Gas Engine Oils','Industrial Oils','Gear Oils','Antifreeze','Greases','HDDEO','Others'};
    		
    		list<Account> lstAccount = [select id,parentID,Ship_to_Code__c,name,VCPL_Account_ID__c,RecordTypeID from Account where id=:strAccountID limit 1];
    		
    		if(lstAccount != NULL && !lstAccount.isEmpty())
    		{
    			string strAccountPotentialKey = NULL;
    			map<string,Account_Potential__c> mapofAccountPotential = new map<string,Account_Potential__c>();
    			
    			for(Account_Potential__c objPotential : [select id,Account__c,AccPotentialCalculation__c,No_of_month_passed_in_Financial_Year__c,PH6_Qlikview__c,
    														Product_penetration__c,Potential_Volume_in_kL__c,Valvoline_Financial_Year__c,YTD_in_volume__c from 
    														Account_Potential__c where Account__c =:strAccountID and PH6_Qlikview__c in:setofPH6Values and 
    														Valvoline_Financial_Year__c =:strFinancialYear])
    			{
    				strAccountPotentialKey = '';
    				
    				strAccountPotentialKey = objPotential.Account__c+'-'+objPotential.PH6_Qlikview__c+'-'+strFinancialYear;
    				
    				if(!mapofAccountPotential.containskey(strAccountPotentialKey))
    				{
    					mapofAccountPotential.put(strAccountPotentialKey,objPotential);
    				}
    			}
    			
    			string strPH6Key1 = lstAccount[0].ID+'-'+'Gas Engine Oils'+'-'+strFinancialYear;
				string strPH6Key2 = lstAccount[0].ID+'-'+'Industrial Oils'+'-'+strFinancialYear;
				string strPH6Key3 = lstAccount[0].ID+'-'+'Gear Oils'+'-'+strFinancialYear;
				string strPH6Key4 = lstAccount[0].ID+'-'+'Antifreeze'+'-'+strFinancialYear;
				string strPH6Key5 = lstAccount[0].ID+'-'+'Greases'+'-'+strFinancialYear;
				string strPH6Key6 = lstAccount[0].ID+'-'+'HDDEO'+'-'+strFinancialYear;
				string strPH6Key7 = lstAccount[0].ID+'-'+'Others'+'-'+strFinancialYear;
				
				objDetailWrapper.strAccountID = lstAccount[0].ID;
				
				if(mapofAccountPotential.containskey(strPH6Key1) && mapofAccountPotential.get(strPH6Key1) != NULL && 
					mapofAccountPotential.get(strPH6Key1).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue1 = mapofAccountPotential.get(strPH6Key1).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID1 = mapofAccountPotential.get(strPH6Key1).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue1 = 0;
					objDetailWrapper.samplePH6PotentialvalueID1 = '';
				}
				
				if(mapofAccountPotential.containskey(strPH6Key2) && mapofAccountPotential.get(strPH6Key2) != NULL && 
					mapofAccountPotential.get(strPH6Key2).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue2 = mapofAccountPotential.get(strPH6Key2).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID2 = mapofAccountPotential.get(strPH6Key2).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue2 = 0;
					objDetailWrapper.samplePH6PotentialvalueID2 = '';
				}
				
				if(mapofAccountPotential.containskey(strPH6Key3) && mapofAccountPotential.get(strPH6Key3) != NULL && 
					mapofAccountPotential.get(strPH6Key3).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue3 = mapofAccountPotential.get(strPH6Key3).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID3 = mapofAccountPotential.get(strPH6Key3).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue3 = 0;
					objDetailWrapper.samplePH6PotentialvalueID3 = '';
				}
				
				if(mapofAccountPotential.containskey(strPH6Key4) && mapofAccountPotential.get(strPH6Key4) != NULL && 
					mapofAccountPotential.get(strPH6Key4).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue4 = mapofAccountPotential.get(strPH6Key4).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID4 = mapofAccountPotential.get(strPH6Key4).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue4 = 0;
					objDetailWrapper.samplePH6PotentialvalueID4 = '';
				}
				
				if(mapofAccountPotential.containskey(strPH6Key5) && mapofAccountPotential.get(strPH6Key5) != NULL && 
					mapofAccountPotential.get(strPH6Key5).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue5 = mapofAccountPotential.get(strPH6Key5).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID5 = mapofAccountPotential.get(strPH6Key5).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue5 = 0;
					objDetailWrapper.samplePH6PotentialvalueID5 = '';
				}
				
				if(mapofAccountPotential.containskey(strPH6Key6) && mapofAccountPotential.get(strPH6Key6) != NULL && 
					mapofAccountPotential.get(strPH6Key6).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue6 = mapofAccountPotential.get(strPH6Key6).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID6 = mapofAccountPotential.get(strPH6Key6).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue6 = 0;
					objDetailWrapper.samplePH6PotentialvalueID6 = '';
				}
				
				if(mapofAccountPotential.containskey(strPH6Key7) && mapofAccountPotential.get(strPH6Key7) != NULL && 
					mapofAccountPotential.get(strPH6Key7).Potential_Volume_in_kL__c != NULL)
				{
					objDetailWrapper.samplePH6Potentialvalue7 = mapofAccountPotential.get(strPH6Key7).Potential_Volume_in_kL__c*1000; 
					objDetailWrapper.samplePH6PotentialvalueID7 = mapofAccountPotential.get(strPH6Key7).ID;	
				}
				else
				{
					objDetailWrapper.samplePH6Potentialvalue7 = 0;
					objDetailWrapper.samplePH6PotentialvalueID7 = '';
				}
    		}
    	}
    	return objDetailWrapper;
    }
    @AuraEnabled
    public static string savePotential(string strResponse)
    {
    	string strStatus = 'Initiated';
    	
    	if(strResponse != NULL)
    	{
    		list<Account_Potential__c> lstToInsert = new list<Account_Potential__c>();
    		list<Account_Potential__c> lstToUpdate = new list<Account_Potential__c>();
    		
    		VCPL_IDCustomerPotentialController.detailsWrapper objWrapper=  (VCPL_IDCustomerPotentialController.detailsWrapper)JSON.deserialize(strResponse,VCPL_IDCustomerPotentialController.detailsWrapper.class);
    		
    		if(objWrapper != NULL)
    		{
    			strStatus='Parsed';
    			
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
						Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'Gas Engine Oils',objWrapper.samplePH6Potentialvalue1/1000);
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
							Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'Industrial Oils',objWrapper.samplePH6Potentialvalue2/1000);
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
							Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'Gear Oils',objWrapper.samplePH6Potentialvalue3/1000);
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
							Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'Antifreeze',objWrapper.samplePH6Potentialvalue4/1000);
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
							Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'Greases',objWrapper.samplePH6Potentialvalue5/1000);
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
							Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'HDDEO',objWrapper.samplePH6Potentialvalue6/1000);
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
							Account_Potential__c objAccountPotential = VCPL_CustomerPotentialCaptureController.createPotential(objWrapper.strAccountID,'Others',objWrapper.samplePH6Potentialvalue7/1000);
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
    	return strStatus;
    }
}