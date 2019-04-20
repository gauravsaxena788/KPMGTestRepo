public without sharing class VCPL_AVDQVDIDController 
{
	public static Id RecordTypeID = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('ID').getRecordTypeId();
	@AuraEnabled
	public static list<Account> getDealers()
	{
		ID userID = userinfo.getUserId();
		
		list<User> lstUser = [select id,ProfileID,Profile.Name from User where id=:userID];
		
		if(lstUser != NULL && !lstUser.isEmpty())
		{
			if(lstUser[0].Profile.Name.equalsIgnoreCase('System Administrator') 
			|| lstUser[0].Profile.Name.equalsIgnoreCase('NSH'))
			{
				list<Account> lstAccounts = [select id,name,BU_Name__c,Indutry_Segment__c,Market_Segment__c,Is_Parent__c from Account 
												where BU_Name__c='C&I' and 
												Market_Segment__c='Industrial Distributor' and Is_Parent__c='Y'];
				
				if(lstAccounts != NULL && !lstAccounts.isEmpty())
				{
					return lstAccounts;
				}
			}
			else if(lstUser[0].Profile.Name.equalsIgnoreCase('SM'))
			{
				list<AccountTeamMember> lstAccountTeamMember = [select id,AccountId,UserId,Account.BU_Name__c,
                                                                Account.Indutry_Segment__c,Account.Market_Segment__c from 
                                                                AccountTeamMember where UserId=:userID 
                                                                and Account.BU_Name__c='C&I' 
                                                                and Account.Market_Segment__c='Industrial Distributor'];
				
				if(lstAccountTeamMember != NULL && !lstAccountTeamMember.isEmpty())
				{
					set<ID> setAccountID = new set<ID>();
					for(AccountTeamMember objTeam : lstAccountTeamMember)
					{
						setAccountID.add(objTeam.AccountId);
					}
					if(setAccountID != NULL && !setAccountID.isEmpty())
					{
						list<Account> lstAccount = [select id,name,BU_Name__c,Indutry_Segment__c,Market_Segment__c,Is_Parent__c from 
													Account where id in:setAccountID and Is_Parent__c='Y'];
						
						if(lstAccount != NULL && !lstAccount.isEmpty())
						{
							return lstAccount;
						}
					}
				}
			}
			else if(lstUser[0].Profile.Name.equalsIgnoreCase('TBM'))
			{
				list<Account> lstAccount = [select id,name,ownerID,Is_Parent__c from Account where ownerID=:lstUser[0].ID and 
											BU_Name__c='C&I' and 
											Market_Segment__c='Industrial Distributor' and Is_Parent__c='Y'];
											
				if(lstAccount != NULL && !lstAccount.isEmpty())
				{
					return lstAccount;
				}
			}
		}
		return NULL;
	} 
	@AuraEnabled
    public static list<string> getConfigs()
    {
    	
    	list<VCPL_AVD_QVD__c> lstAVDQVDs = [select id,VCPL_Fiscal_Year__c,RecordTypeID 
    										from VCPL_AVD_QVD__c where VCPL_Fiscal_Year__c != NULL 
    										and RecordTypeID =:RecordTypeID limit 49999];
    	
    	list<string> lstConfigs = new list<string>();
    	if(lstAVDQVDs != NULL && !lstAVDQVDs.isEmpty())
    	{
    		for(VCPL_AVD_QVD__c obj : lstAVDQVDs)
    		{
    			if(!lstConfigs.contains(obj.VCPL_Fiscal_Year__c))
    			{
    				lstConfigs.add(obj.VCPL_Fiscal_Year__c);
    			}
    		}
    	}
    	if(lstConfigs != NULL && !lstConfigs.isEmpty())
    	{
    		return lstConfigs;
    	}
    	else
    	{
    		return NULL;
    	}
    }
    public class picklistWrapper
    {
    	@AuraEnabled public list<Account> lstAccounts;
    	@AuraEnabled public list<string> lstConfigs;
    }
    @AuraEnabled
    public static picklistWrapper getpicklistvalues()
    {
    	picklistWrapper obj = new picklistWrapper();
    	obj.lstAccounts = getDealers();
    	obj.lstConfigs = getConfigs();
    	
    	return obj;
    }
    public class DataWrapper
    {
    	@AuraEnabled public Double lastYearQ1Sales;
    	@AuraEnabled public Double lastYearQ1Sales1Percent;
    	@AuraEnabled public Double lastYearQ1Sales1Cost;
    	@AuraEnabled public Double lastYearQ1Sales4Percent;
    	@AuraEnabled public Double lastYearQ1Sales4Cost;
    	@AuraEnabled public Double lastYearQ1Sales7Percent;
    	@AuraEnabled public Double lastYearQ1Sales7Cost;
    	@AuraEnabled public Double lastYearQ1Sales10Percent;
    	@AuraEnabled public Double lastYearQ1Sales10Cost;
    	@AuraEnabled public Double lastYearQ2Sales;
    	@AuraEnabled public Double lastYearQ2Sales1Percent;
        @AuraEnabled public Double lastYearQ2Sales1Cost;
    	@AuraEnabled public Double lastYearQ2Sales4Percent;
        @AuraEnabled public Double lastYearQ2Sales4Cost;
    	@AuraEnabled public Double lastYearQ2Sales7Percent;
        @AuraEnabled public Double lastYearQ2Sales7Cost;
    	@AuraEnabled public Double lastYearQ2Sales10Percent;
        @AuraEnabled public Double lastYearQ2Sales10Cost;
    	@AuraEnabled public Double lastYearQ3Sales;
    	@AuraEnabled public Double lastYearQ3Sales1Percent;
        @AuraEnabled public Double lastYearQ3Sales1Cost;
    	@AuraEnabled public Double lastYearQ3Sales4Percent;
        @AuraEnabled public Double lastYearQ3Sales4Cost;
    	@AuraEnabled public Double lastYearQ3Sales7Percent;
        @AuraEnabled public Double lastYearQ3Sales7Cost;
    	@AuraEnabled public Double lastYearQ3Sales10Percent;
        @AuraEnabled public Double lastYearQ3Sales10Cost;
    	@AuraEnabled public Double lastYearQ4Sales;
    	@AuraEnabled public Double lastYearQ4Sales1Percent;
        @AuraEnabled public Double lastYearQ4Sales1Cost;
    	@AuraEnabled public Double lastYearQ4Sales4Percent;
        @AuraEnabled public Double lastYearQ4Sales4Cost;
    	@AuraEnabled public Double lastYearQ4Sales7Percent;
        @AuraEnabled public Double lastYearQ4Sales7Cost;
    	@AuraEnabled public Double lastYearQ4Sales10Percent;
        @AuraEnabled public Double lastYearQ4Sales10Cost;
        @AuraEnabled public Double lastYearTotalSales;
        @AuraEnabled public Double lastYearTotalSales1Percent;
        @AuraEnabled public Double lastYearTotalSales1Cost;
        @AuraEnabled public Double lastYearTotalSales4Percent;
        @AuraEnabled public Double lastYearTotalSales4Cost;
        @AuraEnabled public Double lastYearTotalSales7Percent;
        @AuraEnabled public Double lastYearTotalSales7Cost;
        @AuraEnabled public Double lastYearTotalSales10Percent;
        @AuraEnabled public Double lastYearTotalSales10Cost;
    	@AuraEnabled public Double CurrentYearQ1Sales;
    	@AuraEnabled public Double QVDQ1Rs1PerLiter;
    	@AuraEnabled public Double QVDQ1Rs2PerLiter;   	
    	@AuraEnabled public Double QVDQ1Rs4PerLiter;
    	@AuraEnabled public Double QVDQ1Rs6PerLiter;
    	@AuraEnabled public Double QVDQ1Rs1PerLiterCost;
    	@AuraEnabled public Double QVDQ1Rs2PerLiterCost;   	
    	@AuraEnabled public Double QVDQ1Rs4PerLiterCost;
    	@AuraEnabled public Double QVDQ1Rs6PerLiterCost;
    	@AuraEnabled public Double CurrentYearQ2Sales;
    	@AuraEnabled public Double QVDQ2Rs1PerLiter;
    	@AuraEnabled public Double QVDQ2Rs1PerLiterCost;
    	@AuraEnabled public Double QVDQ2Rs2PerLiter;   
    	@AuraEnabled public Double QVDQ2Rs2PerLiterCost;   
    	@AuraEnabled public Double QVDQ2Rs4PerLiter;
    	@AuraEnabled public Double QVDQ2Rs4PerLiterCost;
    	@AuraEnabled public Double QVDQ2Rs6PerLiter;
    	@AuraEnabled public Double QVDQ2Rs6PerLiterCost;
    	@AuraEnabled public Double CurrentYearQ3Sales;
    	@AuraEnabled public Double QVDQ3Rs1PerLiter;
    	@AuraEnabled public Double QVDQ3Rs1PerLiterCost;
    	@AuraEnabled public Double QVDQ3Rs2PerLiter;   
    	@AuraEnabled public Double QVDQ3Rs2PerLiterCost;	
    	@AuraEnabled public Double QVDQ3Rs4PerLiter;
    	@AuraEnabled public Double QVDQ3Rs4PerLiterCost;
    	@AuraEnabled public Double QVDQ3Rs6PerLiter;
    	@AuraEnabled public Double QVDQ3Rs6PerLiterCost;
    	@AuraEnabled public Double CurrentYearQ4Sales;
    	@AuraEnabled public Double QVDQ4Rs1PerLiter;
    	@AuraEnabled public Double QVDQ4Rs1PerLiterCost;
    	@AuraEnabled public Double QVDQ4Rs2PerLiter;   
    	@AuraEnabled public Double QVDQ4Rs2PerLiterCost;   	
    	@AuraEnabled public Double QVDQ4Rs4PerLiter;
    	@AuraEnabled public Double QVDQ4Rs4PerLiterCost;
    	@AuraEnabled public Double QVDQ4Rs6PerLiter;
    	@AuraEnabled public Double QVDQ4Rs6PerLiterCost;
    	@AuraEnabled public Double CurrentYearTotalSales;
    	@AuraEnabled public Double CurrentYearTotalSalesRs1PerLiter;
    	@AuraEnabled public Double CurrentYearTotalSalesRs1PerLiterCost;
    	@AuraEnabled public Double CurrentYearTotalSalesRs2PerLiter; 
    	@AuraEnabled public Double CurrentYearTotalSalesRs2PerLiterCost;  	
    	@AuraEnabled public Double CurrentYearTotalSalesRs4PerLiter;
    	@AuraEnabled public Double CurrentYearTotalSalesRs4PerLiterCost;
    	@AuraEnabled public Double CurrentYearTotalSalesRs6PerLiter;
    	@AuraEnabled public Double CurrentYearTotalSalesRs6PerLiterCost;
    	@AuraEnabled public string growthSlab1Label;
    	@AuraEnabled public string growthSlab2Label;
    	@AuraEnabled public string growthSlab3Label;
    	@AuraEnabled public string growthSlab4Label;
    	@AuraEnabled public string incentiveSlab1QVDLabel;
    	@AuraEnabled public string incentiveSlab2QVDLabel;
    	@AuraEnabled public string incentiveSlab3QVDLabel;
    	@AuraEnabled public string incentiveSlab4QVDLabel;
    	@AuraEnabled public string incentiveSlab1AVDLabel;
    	@AuraEnabled public string incentiveSlab2AVDLabel;
    	@AuraEnabled public string incentiveSlab3AVDLabel;
    	@AuraEnabled public string incentiveSlab4AVDLabel;
    	@AuraEnabled public Double Q1ClosedSales;
    	@AuraEnabled public Double Q2ClosedSales;
    	@AuraEnabled public Double Q3ClosedSales;
    	@AuraEnabled public Double Q4ClosedSales;
    	@AuraEnabled public Double totalClosedSales;
    	@AuraEnabled public Double Q1Incentive;
    	@AuraEnabled public Double Q2Incentive;
    	@AuraEnabled public Double Q3Incentive;
    	@AuraEnabled public Double Q4Incentive;
    	@AuraEnabled public Double totalIncentive;
		@AuraEnabled public Double totalIncentiveEarned;
    }
    @AuraEnabled
    public static DataWrapper getData(string strprimaryAccountID,string configYear)
    {
    	DataWrapper objWrapper = new DataWrapper();
    	
    	objWrapper.lastYearQ1Sales = 0.0;
    	objWrapper.lastYearQ1Sales1Percent = 0.0;
    	objWrapper.lastYearQ1Sales1Cost = 0.0;
    	objWrapper.lastYearQ1Sales4Percent=0.0;
    	objWrapper.lastYearQ1Sales4Cost = 0.0;
    	objWrapper.lastYearQ1Sales7Percent = 0.0;
    	objWrapper.lastYearQ1Sales7Cost = 0.0;
    	objWrapper.lastYearQ1Sales10Percent = 0.0;
    	objWrapper.lastYearQ1Sales10Cost = 0.0;
    	
    	objWrapper.lastYearQ2Sales = 0.0;
    	objWrapper.lastYearQ2Sales1Percent = 0.0;
    	objWrapper.lastYearQ2Sales1Cost = 0.0;
    	objWrapper.lastYearQ2Sales4Percent=0.0;
    	objWrapper.lastYearQ2Sales4Cost = 0.0;
    	objWrapper.lastYearQ2Sales7Percent = 0.0;
    	objWrapper.lastYearQ2Sales7Cost = 0.0;
    	objWrapper.lastYearQ2Sales10Percent = 0.0;
    	objWrapper.lastYearQ2Sales10Cost = 0.0;
    	
    	objWrapper.lastYearQ3Sales = 0.0;
    	objWrapper.lastYearQ3Sales1Percent = 0.0;
    	objWrapper.lastYearQ3Sales1Cost = 0.0;
    	objWrapper.lastYearQ3Sales4Percent=0.0;
    	objWrapper.lastYearQ3Sales4Cost = 0.0;
    	objWrapper.lastYearQ3Sales7Percent = 0.0;
    	objWrapper.lastYearQ3Sales7Cost = 0.0;
    	objWrapper.lastYearQ3Sales10Percent = 0.0;
    	objWrapper.lastYearQ3Sales10Cost = 0.0;
    	
    	objWrapper.lastYearQ4Sales = 0.0;
    	objWrapper.lastYearQ4Sales1Percent = 0.0;
    	objWrapper.lastYearQ4Sales1Cost = 0.0;
    	objWrapper.lastYearQ4Sales4Percent=0.0;
    	objWrapper.lastYearQ4Sales4Cost = 0.0;
    	objWrapper.lastYearQ4Sales7Percent = 0.0;
    	objWrapper.lastYearQ4Sales7Cost = 0.0;
    	objWrapper.lastYearQ4Sales10Percent = 0.0;
    	objWrapper.lastYearQ4Sales10Cost = 0.0;
    	objWrapper.lastYearQ4Sales10Cost = 0.0;
    	
    	objWrapper.lastYearTotalSales = 0.0;
    	objWrapper.lastYearTotalSales1Percent = 0.0;
    	objWrapper.lastYearTotalSales1Cost = 0.0;
    	objWrapper.lastYearTotalSales4Percent = 0.0;
    	objWrapper.lastYearTotalSales4Cost = 0.0;
    	objWrapper.lastYearTotalSales7Percent = 0.0;
    	objWrapper.lastYearTotalSales7Cost = 0.0;
    	objWrapper.lastYearTotalSales10Percent = 0.0;
    	objWrapper.lastYearTotalSales10Cost = 0.0;
    	
    	objWrapper.QVDQ1Rs1PerLiter = 0.0;
    	objWrapper.QVDQ1Rs1PerLiterCost = 0.0;
    	objWrapper.QVDQ1Rs2PerLiter = 0.0;
    	objWrapper.QVDQ1Rs2PerLiterCost = 0.0;
    	objWrapper.QVDQ1Rs4PerLiter = 0.0;
    	objWrapper.QVDQ1Rs4PerLiterCost = 0.0;
    	objWrapper.QVDQ1Rs6PerLiter = 0.0;
    	objWrapper.QVDQ1Rs6PerLiterCost = 0.0;
    	
    	objWrapper.QVDQ2Rs1PerLiter = 0.0;
    	objWrapper.QVDQ2Rs1PerLiterCost = 0.0;
    	objWrapper.QVDQ2Rs2PerLiter = 0.0;
    	objWrapper.QVDQ2Rs2PerLiterCost = 0.0;
    	objWrapper.QVDQ2Rs4PerLiter = 0.0;
    	objWrapper.QVDQ2Rs4PerLiterCost = 0.0;
    	objWrapper.QVDQ2Rs6PerLiter = 0.0;
    	objWrapper.QVDQ2Rs6PerLiterCost = 0.0;
    	
    	objWrapper.QVDQ3Rs1PerLiter = 0.0;
    	objWrapper.QVDQ3Rs1PerLiterCost = 0.0;
    	objWrapper.QVDQ3Rs2PerLiter = 0.0;
    	objWrapper.QVDQ3Rs2PerLiterCost = 0.0;
    	objWrapper.QVDQ3Rs4PerLiter = 0.0;
    	objWrapper.QVDQ3Rs4PerLiterCost = 0.0;
    	objWrapper.QVDQ3Rs6PerLiter = 0.0;
    	objWrapper.QVDQ3Rs6PerLiterCost = 0.0;
    	
    	objWrapper.QVDQ4Rs1PerLiter = 0.0;
    	objWrapper.QVDQ4Rs1PerLiterCost = 0.0;
    	objWrapper.QVDQ4Rs2PerLiter = 0.0;
    	objWrapper.QVDQ4Rs2PerLiterCost = 0.0;
    	objWrapper.QVDQ4Rs4PerLiter = 0.0;
    	objWrapper.QVDQ4Rs4PerLiterCost = 0.0;
    	objWrapper.QVDQ4Rs6PerLiter = 0.0;
    	objWrapper.QVDQ4Rs6PerLiterCost = 0.0;
    	
    	objWrapper.CurrentYearQ1Sales = 0.0;
    	objWrapper.CurrentYearQ2Sales = 0.0;
    	objWrapper.CurrentYearQ3Sales = 0.0;
    	objWrapper.CurrentYearQ4Sales = 0.0;
    	objWrapper.CurrentYearTotalSales = 0.0;
    	
    	objWrapper.CurrentYearTotalSalesRs1PerLiter = 0.0;
    	objWrapper.CurrentYearTotalSalesRs2PerLiter = 0.0;
    	objWrapper.CurrentYearTotalSalesRs4PerLiter = 0.0;
    	objWrapper.CurrentYearTotalSalesRs6PerLiter = 0.0;
    	
    	objWrapper.CurrentYearTotalSalesRs1PerLiterCost = 0.0;
    	objWrapper.CurrentYearTotalSalesRs2PerLiterCost = 0.0;
    	objWrapper.CurrentYearTotalSalesRs4PerLiterCost = 0.0;
    	objWrapper.CurrentYearTotalSalesRs6PerLiterCost = 0.0;
    	
    	objWrapper.growthSlab1Label = '';
    	objWrapper.growthSlab2Label = '';
    	objWrapper.growthSlab3Label = '';
    	objWrapper.growthSlab4Label = '';
    	objWrapper.incentiveSlab1QVDLabel = '';
    	objWrapper.incentiveSlab2QVDLabel = '';
    	objWrapper.incentiveSlab3QVDLabel = '';
    	objWrapper.incentiveSlab4QVDLabel = '';
    	objWrapper.incentiveSlab1AVDLabel = '';
    	objWrapper.incentiveSlab2AVDLabel = '';
    	objWrapper.incentiveSlab3AVDLabel = '';
    	objWrapper.incentiveSlab4AVDLabel = '';
    	
    	objWrapper.Q1ClosedSales =0.0;
    	objWrapper.Q2ClosedSales =0.0;
    	objWrapper.Q3ClosedSales =0.0;
    	objWrapper.Q4ClosedSales =0.0;
    	
    	objWrapper.totalClosedSales = 0.0;
    	
    	objWrapper.Q1Incentive = 0.0;
    	objWrapper.Q2Incentive = 0.0;
    	objWrapper.Q3Incentive = 0.0;
    	objWrapper.Q4Incentive = 0.0;
    	
    	objWrapper.totalIncentive =0.0;
		objWrapper.totalIncentiveEarned=0.0;
    	
    	if(strprimaryAccountID != NULL && configYear != NULL)
    	{
    		strprimaryAccountID = strprimaryAccountID.substring(0,15);
    		
    		string strCurrentFYear = VCPL_AVDQVDCommon.getCurrentFinancialYear();
    		
    		list<Opportunity> lstCurrentYearOpportunity = new list<Opportunity>();
    		
    		list<VCPL_AVD_QVD__c> lstConfig = [select id,VCPL_Growth_Slab_1_In_Percentage__c,VCPL_Fiscal_Year__c,
												VCPL_Growth_Slab_2_In_Percentage__c,VCPL_Growth_Slab_3_In_Percentage__c,
												VCPL_Growth_Slab_4_In_Percentage__c,VCPL_Incentive_Slab_1_AVD_In_R_L__c,
												VCPL_Incentive_Slab_1_QVD_In_R_L__c,VCPL_Incentive_Slab_2_AVD_In_R_L__c,
												VCPL_Incentive_Slab_2_QVD_In_R_L__c,VCPL_Incentive_Slab_3_AVD_In_R_L__c,
												VCPL_Incentive_Slab_3_QVD_In_R_L__c,VCPL_Incentive_Slab_4_AVD_In_R_L__c,
												VCPL_Incentive_Slab_4_QVD_In_R_L__c from VCPL_AVD_QVD__c where 
												VCPL_Fiscal_Year__c=:configYear and recordTypeID=:RecordTypeID];
			
			objWrapper.growthSlab1Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c)+'% - '+string.valueof(Double.valueof(lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c)-0.01)+'%';
    		objWrapper.growthSlab2Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c)+'% - '+string.valueof(Double.valueof(lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c)-0.01)+'%';
    		objWrapper.growthSlab3Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c)+'% - '+string.valueof(Double.valueof(lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c)-0.01)+'%';
    		objWrapper.growthSlab4Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c)+'% AND ABOVE';
    		objWrapper.incentiveSlab1QVDLabel = 'QVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab2QVDLabel = 'QVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab3QVDLabel = 'QVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab4QVDLabel = 'QVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab1AVDLabel = 'AVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_1_AVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab2AVDLabel = 'AVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_2_AVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab3AVDLabel = 'AVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_3_AVD_In_R_L__c)+'/L';
    		objWrapper.incentiveSlab4AVDLabel = 'AVD: RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_4_AVD_In_R_L__c)+'/L';
    		
    		if(configYear != NULL && configYear != '')
    		{
    			lstCurrentYearOpportunity = [select id,LY_Volume__c,MTD_Volume__c,Financial_Year__c,AccountID,
    											VCPL_Quarter__c,StageName from Opportunity where 
    											Financial_Year__c =:configYear and VCPL_Quarter__c != NULL and 
    											AccountID=:strprimaryAccountID];
    			
    			if(lstCurrentYearOpportunity != NULL && !lstCurrentYearOpportunity.isEmpty())
    			{
    				map<string,Double> mapofCurrentYearOppty = new map<string,Double>();
    				map<string,Double> mapofPrevYearOppty = new map<string,Double>();
    				Double currentSalesQuarter=null; 
    				Double PrevSalesQuarter=null;
    				
    				for(Opportunity objOpportunity : lstCurrentYearOpportunity)
    				{
    					if(objOpportunity.MTD_Volume__c != NULL)
    					{
    						if(!mapofCurrentYearOppty.containskey(objOpportunity.VCPL_Quarter__c))
    						{
    							mapofCurrentYearOppty.put(objOpportunity.VCPL_Quarter__c,objOpportunity.MTD_Volume__c);
    						}
    						else
    						{
    							currentSalesQuarter = 0;
    							currentSalesQuarter = mapofCurrentYearOppty.get(objOpportunity.VCPL_Quarter__c);
    							currentSalesQuarter += objOpportunity.MTD_Volume__c;
    							mapofCurrentYearOppty.put(objOpportunity.VCPL_Quarter__c,currentSalesQuarter);
    						}
    					}
    					
    					if(objOpportunity.LY_Volume__c != NULL)
    					{
    						if(!mapofPrevYearOppty.containsKey(objOpportunity.VCPL_Quarter__c))
							{
								mapofPrevYearOppty.put(objOpportunity.VCPL_Quarter__c,objOpportunity.LY_Volume__c);
							}
							else
							{
								PrevSalesQuarter = 0;
								PrevSalesQuarter = mapofPrevYearOppty.get(objOpportunity.VCPL_Quarter__c);
								PrevSalesQuarter += objOpportunity.LY_Volume__c;
								mapofPrevYearOppty.put(objOpportunity.VCPL_Quarter__c,PrevSalesQuarter);	
							}
    					}
    				}
    				
    				if(mapofPrevYearOppty != NULL && !mapofPrevYearOppty.isEmpty() && lstConfig != NULL && !lstConfig.isEmpty())
    				{
    					if(mapofPrevYearOppty.containsKey('Q1') && mapofPrevYearOppty.get('Q1') != NULL)
    					{
    						objWrapper.lastYearQ1Sales = mapofPrevYearOppty.get('Q1')*1000;
    						
    						if(objWrapper.lastYearQ1Sales > 0)
    						{
    							objWrapper.lastYearQ1Sales1Percent = objWrapper.lastYearQ1Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ1Sales1Cost = objWrapper.lastYearQ1Sales1Percent*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    							objWrapper.lastYearQ1Sales4Percent = objWrapper.lastYearQ1Sales *((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ1Sales4Cost = objWrapper.lastYearQ1Sales4Percent*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    							objWrapper.lastYearQ1Sales7Percent = objWrapper.lastYearQ1Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ1Sales7Cost = objWrapper.lastYearQ1Sales7Percent*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    							objWrapper.lastYearQ1Sales10Percent = objWrapper.lastYearQ1Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ1Sales10Cost = objWrapper.lastYearQ1Sales10Percent*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c; 
    							
    							objWrapper.lastYearTotalSales += objWrapper.lastYearQ1Sales;
    							
    							objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ1Sales1Percent;
    							objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ1Sales4Percent;
    							objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ1Sales7Percent;
    							objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ1Sales10Percent;
    						}
    					}
    					if(mapofPrevYearOppty.containsKey('Q2') && mapofPrevYearOppty.get('Q2') != NULL)
    					{
    						objWrapper.lastYearQ2Sales = mapofPrevYearOppty.get('Q2')*1000;
    						
    						if(objWrapper.lastYearQ2Sales > 0)
    						{
    							objWrapper.lastYearQ2Sales1Percent = objWrapper.lastYearQ2Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ2Sales1Cost = objWrapper.lastYearQ2Sales1Percent*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    							objWrapper.lastYearQ2Sales4Percent = objWrapper.lastYearQ2Sales * ((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ2Sales4Cost = objWrapper.lastYearQ2Sales4Percent*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    							objWrapper.lastYearQ2Sales7Percent = objWrapper.lastYearQ2Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ2Sales7Cost = objWrapper.lastYearQ2Sales7Percent*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    							objWrapper.lastYearQ2Sales10Percent = objWrapper.lastYearQ2Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ2Sales10Cost = objWrapper.lastYearQ2Sales10Percent*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c; 
    							
    							objWrapper.lastYearTotalSales += objWrapper.lastYearQ2Sales;
    							
    							objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ2Sales1Percent;
    							objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ2Sales4Percent;
    							objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ2Sales7Percent;
    							objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ2Sales10Percent;
    						}
    					}
    					if(mapofPrevYearOppty.containsKey('Q3') && mapofPrevYearOppty.get('Q3') != NULL)
    					{
    						objWrapper.lastYearQ3Sales = mapofPrevYearOppty.get('Q3')*1000;
    						
    						if(objWrapper.lastYearQ3Sales > 0)
    						{
    							objWrapper.lastYearQ3Sales1Percent = objWrapper.lastYearQ3Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ3Sales1Cost = objWrapper.lastYearQ3Sales1Percent*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    							objWrapper.lastYearQ3Sales4Percent = objWrapper.lastYearQ3Sales * ((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ3Sales4Cost = objWrapper.lastYearQ3Sales4Percent*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    							objWrapper.lastYearQ3Sales7Percent = objWrapper.lastYearQ3Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ3Sales7Cost = objWrapper.lastYearQ3Sales7Percent*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    							objWrapper.lastYearQ3Sales10Percent = objWrapper.lastYearQ3Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ3Sales10Cost = objWrapper.lastYearQ3Sales10Percent*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c; 
    							
    							objWrapper.lastYearTotalSales += objWrapper.lastYearQ3Sales;
    							
    							objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ3Sales1Percent;
    							objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ3Sales4Percent;
    							objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ3Sales7Percent;
    							objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ3Sales10Percent;
    						}
    					}
    					if(mapofPrevYearOppty.containsKey('Q4') && mapofPrevYearOppty.get('Q4') != NULL)
    					{
    						objWrapper.lastYearQ4Sales = mapofPrevYearOppty.get('Q4')*1000;
    						
    						if(objWrapper.lastYearQ4Sales > 0)
    						{
    							objWrapper.lastYearQ4Sales1Percent = objWrapper.lastYearQ4Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ4Sales1Cost = objWrapper.lastYearQ4Sales1Percent*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    							objWrapper.lastYearQ4Sales4Percent = objWrapper.lastYearQ4Sales * ((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ4Sales4Cost = objWrapper.lastYearQ4Sales4Percent*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    							objWrapper.lastYearQ4Sales7Percent = objWrapper.lastYearQ4Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ4Sales7Cost = objWrapper.lastYearQ4Sales7Percent*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    							objWrapper.lastYearQ4Sales10Percent = objWrapper.lastYearQ4Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
    							objWrapper.lastYearQ4Sales10Cost = objWrapper.lastYearQ4Sales10Percent*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c; 
    							
    							objWrapper.lastYearTotalSales += objWrapper.lastYearQ4Sales;
    							
    							objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ4Sales1Percent;
    							objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ4Sales4Percent;
    							objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ4Sales7Percent;
    							objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ4Sales10Percent;
    						}
    					}
    					objWrapper.lastYearTotalSales1Cost = objWrapper.lastYearTotalSales1Percent*lstConfig[0].VCPL_Incentive_Slab_1_AVD_In_R_L__c;
    					objWrapper.lastYearTotalSales4Cost = objWrapper.lastYearTotalSales4Percent*lstConfig[0].VCPL_Incentive_Slab_2_AVD_In_R_L__c;
    					objWrapper.lastYearTotalSales7Cost = objWrapper.lastYearTotalSales7Percent*lstConfig[0].VCPL_Incentive_Slab_3_AVD_In_R_L__c;
    					objWrapper.lastYearTotalSales10Cost = objWrapper.lastYearTotalSales10Percent*lstConfig[0].VCPL_Incentive_Slab_4_AVD_In_R_L__c;
    				}
    				if(mapofCurrentYearOppty != NULL && !mapofCurrentYearOppty.isEmpty())
    				{
    					
    					if(mapofCurrentYearOppty.containsKey('Q1') && mapofCurrentYearOppty.get('Q1') != NULL)
    					{
    						objWrapper.CurrentYearQ1Sales = mapofCurrentYearOppty.get('Q1')*1000;
    						objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ1Sales;
    						
    						if(objWrapper.CurrentYearQ1Sales > 0)
    						{
    							objWrapper.QVDQ1Rs1PerLiter = objWrapper.lastYearQ1Sales1Percent-objWrapper.CurrentYearQ1Sales;
    							objWrapper.QVDQ1Rs2PerLiter = objWrapper.lastYearQ1Sales4Percent-objWrapper.CurrentYearQ1Sales;
    							objWrapper.QVDQ1Rs4PerLiter = objWrapper.lastYearQ1Sales7Percent-objWrapper.CurrentYearQ1Sales;
    							objWrapper.QVDQ1Rs6PerLiter = objWrapper.lastYearQ1Sales10Percent-objWrapper.CurrentYearQ1Sales;
    						}
    					} 
    					if(mapofCurrentYearOppty.containsKey('Q2') && mapofCurrentYearOppty.get('Q2') != NULL)
    					{
    						objWrapper.CurrentYearQ2Sales = mapofCurrentYearOppty.get('Q2')*1000;
    						objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ2Sales;
    						
    						if(objWrapper.CurrentYearQ2Sales > 0)
    						{
    							objWrapper.QVDQ2Rs1PerLiter = objWrapper.lastYearQ2Sales1Percent-objWrapper.CurrentYearQ2Sales;
    							objWrapper.QVDQ2Rs2PerLiter = objWrapper.lastYearQ2Sales4Percent-objWrapper.CurrentYearQ2Sales;
    							objWrapper.QVDQ2Rs4PerLiter = objWrapper.lastYearQ2Sales7Percent-objWrapper.CurrentYearQ2Sales;
    							objWrapper.QVDQ2Rs6PerLiter = objWrapper.lastYearQ2Sales10Percent-objWrapper.CurrentYearQ2Sales;
    						}
    					}
    					if(mapofCurrentYearOppty.containsKey('Q3') && mapofCurrentYearOppty.get('Q3') != NULL)
    					{
    						objWrapper.CurrentYearQ3Sales = mapofCurrentYearOppty.get('Q3')*1000;
    						objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ3Sales;
    						
    						if(objWrapper.CurrentYearQ3Sales > 0)
    						{
    							objWrapper.QVDQ3Rs1PerLiter = objWrapper.lastYearQ3Sales1Percent-objWrapper.CurrentYearQ3Sales;
    							objWrapper.QVDQ3Rs2PerLiter = objWrapper.lastYearQ3Sales4Percent-objWrapper.CurrentYearQ3Sales;
    							objWrapper.QVDQ3Rs4PerLiter = objWrapper.lastYearQ3Sales7Percent-objWrapper.CurrentYearQ3Sales;
    							objWrapper.QVDQ3Rs6PerLiter = objWrapper.lastYearQ3Sales10Percent-objWrapper.CurrentYearQ3Sales;
    						}
    						
    					}
    					if(mapofCurrentYearOppty.containsKey('Q4') && mapofCurrentYearOppty.get('Q4') != NULL)
    					{
    						objWrapper.CurrentYearQ4Sales = mapofCurrentYearOppty.get('Q4')*1000;
    						objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ4Sales;
    						
    						if(objWrapper.CurrentYearQ4Sales > 0)
    						{
    							objWrapper.QVDQ4Rs1PerLiter = objWrapper.lastYearQ4Sales1Percent-objWrapper.CurrentYearQ4Sales;
    							objWrapper.QVDQ4Rs2PerLiter = objWrapper.lastYearQ4Sales4Percent-objWrapper.CurrentYearQ4Sales;
    							objWrapper.QVDQ4Rs4PerLiter = objWrapper.lastYearQ4Sales7Percent-objWrapper.CurrentYearQ4Sales;
    							objWrapper.QVDQ4Rs6PerLiter = objWrapper.lastYearQ4Sales10Percent-objWrapper.CurrentYearQ4Sales;
    						}
    					}
    					if(objWrapper.CurrentYearTotalSales > 0)
    					{
    						objWrapper.CurrentYearTotalSalesRs1PerLiter = objWrapper.lastYearTotalSales1Percent - objWrapper.CurrentYearTotalSales;
    						objWrapper.CurrentYearTotalSalesRs2PerLiter = objWrapper.lastYearTotalSales4Percent - objWrapper.CurrentYearTotalSales;
    						objWrapper.CurrentYearTotalSalesRs4PerLiter = objWrapper.lastYearTotalSales7Percent - objWrapper.CurrentYearTotalSales;
    						objWrapper.CurrentYearTotalSalesRs6PerLiter = objWrapper.lastYearTotalSales10Percent - objWrapper.CurrentYearTotalSales;
    					}
    					if(objWrapper.QVDQ1Rs6PerLiter >= 0)
    					{
    						objWrapper.QVDQ1Rs6PerLiterCost = (objWrapper.CurrentYearQ1Sales+objWrapper.QVDQ1Rs6PerLiter)*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ1Rs6PerLiterCost = objWrapper.CurrentYearQ1Sales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					
    					if(objWrapper.QVDQ1Rs4PerLiter >= 0)
    					{
    						objWrapper.QVDQ1Rs4PerLiterCost = (objWrapper.CurrentYearQ1Sales+objWrapper.QVDQ1Rs4PerLiter)*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ1Rs4PerLiterCost = objWrapper.QVDQ1Rs6PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ1Rs2PerLiter >= 0)
    					{
    						objWrapper.QVDQ1Rs2PerLiterCost = (objWrapper.CurrentYearQ1Sales+objWrapper.QVDQ1Rs2PerLiter)*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ1Rs2PerLiterCost = objWrapper.QVDQ1Rs4PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ1Rs1PerLiter >= 0)
    					{
    						objWrapper.QVDQ1Rs1PerLiterCost = (objWrapper.CurrentYearQ1Sales+objWrapper.QVDQ1Rs1PerLiter)*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ1Rs1PerLiterCost = 	objWrapper.QVDQ1Rs2PerLiterCost;
    					}
    					
    					////
    					if(objWrapper.QVDQ2Rs6PerLiter >= 0)
    					{
    						objWrapper.QVDQ2Rs6PerLiterCost = (objWrapper.CurrentYearQ2Sales+objWrapper.QVDQ2Rs6PerLiter)*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ2Rs6PerLiterCost = objWrapper.CurrentYearQ2Sales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					
    					if(objWrapper.QVDQ2Rs4PerLiter >= 0)
    					{
    						objWrapper.QVDQ2Rs4PerLiterCost = (objWrapper.CurrentYearQ2Sales+objWrapper.QVDQ2Rs4PerLiter)*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ2Rs4PerLiterCost = objWrapper.QVDQ2Rs6PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ2Rs2PerLiter >= 0)
    					{
    						objWrapper.QVDQ2Rs2PerLiterCost = (objWrapper.CurrentYearQ2Sales+objWrapper.QVDQ2Rs2PerLiter)*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ2Rs2PerLiterCost = objWrapper.QVDQ2Rs4PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ2Rs1PerLiter >= 0)
    					{
    						objWrapper.QVDQ2Rs1PerLiterCost = (objWrapper.CurrentYearQ2Sales+objWrapper.QVDQ2Rs1PerLiter)*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ2Rs1PerLiterCost = 	objWrapper.QVDQ2Rs2PerLiterCost;
    					}
    					////
    					if(objWrapper.QVDQ3Rs6PerLiter >= 0)
    					{
    						objWrapper.QVDQ3Rs6PerLiterCost = (objWrapper.CurrentYearQ3Sales+objWrapper.QVDQ3Rs6PerLiter)*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ3Rs6PerLiterCost = objWrapper.CurrentYearQ3Sales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					
    					if(objWrapper.QVDQ3Rs4PerLiter >= 0)
    					{
    						objWrapper.QVDQ3Rs4PerLiterCost = (objWrapper.CurrentYearQ3Sales+objWrapper.QVDQ3Rs4PerLiter)*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ3Rs4PerLiterCost = objWrapper.QVDQ3Rs6PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ3Rs2PerLiter >= 0)
    					{
    						objWrapper.QVDQ3Rs2PerLiterCost = (objWrapper.CurrentYearQ3Sales+objWrapper.QVDQ3Rs2PerLiter)*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ3Rs2PerLiterCost = objWrapper.QVDQ3Rs4PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ3Rs1PerLiter >= 0)
    					{
    						objWrapper.QVDQ3Rs1PerLiterCost = (objWrapper.CurrentYearQ3Sales+objWrapper.QVDQ3Rs1PerLiter)*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ3Rs1PerLiterCost = 	objWrapper.QVDQ3Rs2PerLiterCost;
    					}
    					///////
    					if(objWrapper.QVDQ4Rs6PerLiter >= 0)
    					{
    						objWrapper.QVDQ4Rs6PerLiterCost = (objWrapper.CurrentYearQ4Sales+objWrapper.QVDQ4Rs6PerLiter)*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ4Rs6PerLiterCost = objWrapper.CurrentYearQ4Sales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
    					}
    					
    					if(objWrapper.QVDQ4Rs4PerLiter >= 0)
    					{
    						objWrapper.QVDQ4Rs4PerLiterCost = (objWrapper.CurrentYearQ4Sales+objWrapper.QVDQ4Rs4PerLiter)*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ4Rs4PerLiterCost = objWrapper.QVDQ4Rs6PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ4Rs2PerLiter >= 0)
    					{
    						objWrapper.QVDQ4Rs2PerLiterCost = (objWrapper.CurrentYearQ4Sales+objWrapper.QVDQ4Rs2PerLiter)*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ4Rs2PerLiterCost = objWrapper.QVDQ4Rs4PerLiterCost;
    					}
    					
    					if(objWrapper.QVDQ4Rs1PerLiter >= 0)
    					{
    						objWrapper.QVDQ4Rs1PerLiterCost = (objWrapper.CurrentYearQ4Sales+objWrapper.QVDQ4Rs1PerLiter)*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.QVDQ4Rs1PerLiterCost = 	objWrapper.QVDQ4Rs2PerLiterCost;
    					}
    					
    					if(objWrapper.CurrentYearTotalSalesRs6PerLiter>0)
    					{
    						objWrapper.CurrentYearTotalSalesRs6PerLiterCost = (objWrapper.CurrentYearTotalSalesRs6PerLiter+objWrapper.CurrentYearTotalSales)*lstConfig[0].VCPL_Incentive_Slab_4_AVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.CurrentYearTotalSalesRs6PerLiterCost = objWrapper.CurrentYearTotalSales*lstConfig[0].VCPL_Incentive_Slab_4_AVD_In_R_L__c;
    					}
    					if(objWrapper.CurrentYearTotalSalesRs4PerLiter>0)
    					{
    						objWrapper.CurrentYearTotalSalesRs4PerLiterCost = (objWrapper.CurrentYearTotalSalesRs4PerLiter+objWrapper.CurrentYearTotalSales)*lstConfig[0].VCPL_Incentive_Slab_3_AVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.CurrentYearTotalSalesRs4PerLiterCost = objWrapper.CurrentYearTotalSalesRs6PerLiterCost;
    					}
    					if(objWrapper.CurrentYearTotalSalesRs2PerLiter>0)
    					{
    						objWrapper.CurrentYearTotalSalesRs2PerLiterCost = (objWrapper.CurrentYearTotalSalesRs2PerLiter+objWrapper.CurrentYearTotalSales)*lstConfig[0].VCPL_Incentive_Slab_2_AVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.CurrentYearTotalSalesRs2PerLiterCost = objWrapper.CurrentYearTotalSalesRs4PerLiterCost;
    					}
    					if(objWrapper.CurrentYearTotalSalesRs1PerLiter>0)
    					{
    						objWrapper.CurrentYearTotalSalesRs1PerLiterCost = (objWrapper.CurrentYearTotalSalesRs1PerLiter+objWrapper.CurrentYearTotalSales)*lstConfig[0].VCPL_Incentive_Slab_1_AVD_In_R_L__c;
    					}
    					else
    					{
    						objWrapper.CurrentYearTotalSalesRs1PerLiterCost = objWrapper.CurrentYearTotalSalesRs2PerLiterCost;
    					}
    				}
    				map<string,Double> mapofClosedOpportunities = new map<string,Double>();
    				map<Integer,string> mapofCurrentQuarter = VCPL_AVDQVDCommon.getMonthQuarter();
    				string CurrentQuarter = mapofCurrentQuarter.get(system.today().month());
    				Double closedOpptyAmount;
    				
    				for(Opportunity objOpportunity : lstCurrentYearOpportunity)
    				{
    					if(objOpportunity.StageName=='Closed' && 
    						objOpportunity.MTD_Volume__c != NULL)
    					{
    						if(!mapofClosedOpportunities.containskey(objOpportunity.VCPL_Quarter__c))
    						{
    							mapofClosedOpportunities.put(objOpportunity.VCPL_Quarter__c,objOpportunity.MTD_Volume__c);
    						}
    						else
    						{
    							closedOpptyAmount = 0;
    							closedOpptyAmount = mapofClosedOpportunities.get(objOpportunity.VCPL_Quarter__c);
    							closedOpptyAmount += objOpportunity.MTD_Volume__c;
    							mapofClosedOpportunities.put(objOpportunity.VCPL_Quarter__c,closedOpptyAmount);
    						}
    					}
    				}
    				if(mapofClosedOpportunities != NULL && !mapofClosedOpportunities.isEmpty())
    				{
    					
    					if(mapofClosedOpportunities.containsKey('Q1') && mapofClosedOpportunities.get('Q1') != NULL)
    					{
    						objWrapper.Q1ClosedSales = mapofClosedOpportunities.get('Q1')*1000;
    					}
    					
    					if(mapofClosedOpportunities.containsKey('Q2') && mapofClosedOpportunities.get('Q2') != NULL)
    					{
    						objWrapper.Q2ClosedSales = mapofClosedOpportunities.get('Q2')*1000;
    					}
    					if(mapofClosedOpportunities.containsKey('Q3') && mapofClosedOpportunities.get('Q3') != NULL)
    					{
    						objWrapper.Q3ClosedSales = mapofClosedOpportunities.get('Q3')*1000;
    					}
    					if(mapofClosedOpportunities.containsKey('Q4') && mapofClosedOpportunities.get('Q4') != NULL)
    					{
    						objWrapper.Q4ClosedSales = mapofClosedOpportunities.get('Q4')*1000;
    					}
    					///F Year Check///////////////
    					if(integer.valueof(strCurrentFYear) >= integer.valueof(configYear))
    					{
	    					if(CurrentQuarter.equalsIgnoreCase('Q1'))
	    					{
	    						objWrapper.Q1ClosedSales = 0.0;
	    						objWrapper.Q2ClosedSales = 0.0;
	    						objWrapper.Q3ClosedSales = 0.0;
	    						objWrapper.Q4ClosedSales = 0.0;
	    					}
	    					else if(CurrentQuarter.equalsIgnoreCase('Q2'))
	    					{
	    						objWrapper.Q2ClosedSales = 0.0;
	    						objWrapper.Q3ClosedSales = 0.0;
	    						objWrapper.Q4ClosedSales = 0.0;
	    					}
	    					else if(CurrentQuarter.equalsIgnoreCase('Q3'))
	    					{
	    						objWrapper.Q3ClosedSales = 0.0;
	    						objWrapper.Q4ClosedSales = 0.0;
	    					}
	    					else if(CurrentQuarter.equalsIgnoreCase('Q4'))
	    					{
	    						objWrapper.Q4ClosedSales = 0.0;
	    					}
    					} 
    					////////////////////
    					
    					objWrapper.totalClosedSales = objWrapper.Q1ClosedSales+objWrapper.Q2ClosedSales+objWrapper.Q3ClosedSales+objWrapper.Q4ClosedSales;
    					
    					if(objWrapper.Q1ClosedSales < objWrapper.lastYearQ1Sales1Percent)
    					{
    						objWrapper.Q1Incentive = 0.0;
    					}
    					else
    					{
							if(objWrapper.Q1ClosedSales>=objWrapper.lastYearQ1Sales1Percent &&
								 objWrapper.Q1ClosedSales < objWrapper.lastYearQ1Sales4Percent)
						 	{
						 		objWrapper.Q1Incentive = objWrapper.Q1ClosedSales*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;	
						 	}
						 	else
						 	{
						 		if(objWrapper.Q1ClosedSales >= objWrapper.lastYearQ1Sales4Percent && 
						 		objWrapper.Q1ClosedSales < objWrapper.lastYearQ1Sales7Percent)
						 		{
						 			objWrapper.Q1Incentive = objWrapper.Q1ClosedSales*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
						 		}
						 		else
						 		{
						 			if(objWrapper.Q1ClosedSales >= objWrapper.lastYearQ1Sales7Percent && 
						 				objWrapper.Q1ClosedSales  < objWrapper.lastYearQ1Sales10Percent)
					 				{
					 					objWrapper.Q1Incentive =objWrapper.Q1ClosedSales*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
					 				}
					 				else
					 				{
					 					objWrapper.Q1Incentive =objWrapper.Q1ClosedSales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
					 				}
						 	 	}
						    }
    				   	}
    				   	/////
    				   	if(objWrapper.Q2ClosedSales < objWrapper.lastYearQ2Sales1Percent)
    					{
    						objWrapper.Q2Incentive = 0.0;
    					}
    					else
    					{
							if(objWrapper.Q2ClosedSales>=objWrapper.lastYearQ2Sales1Percent &&
								 objWrapper.Q2ClosedSales < objWrapper.lastYearQ2Sales4Percent)
						 	{
						 		objWrapper.Q2Incentive = objWrapper.Q2ClosedSales*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;	
						 	}
						 	else
						 	{
						 		if(objWrapper.Q2ClosedSales >= objWrapper.lastYearQ2Sales4Percent && 
						 			objWrapper.Q2ClosedSales < objWrapper.lastYearQ2Sales7Percent)
						 		{
						 			objWrapper.Q2Incentive = objWrapper.Q2ClosedSales*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
						 		}
						 		else
						 		{
						 			if(objWrapper.Q2ClosedSales >= objWrapper.lastYearQ2Sales7Percent && 
						 				objWrapper.Q2ClosedSales  < objWrapper.lastYearQ2Sales10Percent)
					 				{
					 					objWrapper.Q2Incentive =objWrapper.Q2ClosedSales*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
					 				}
					 				else
					 				{
					 					objWrapper.Q2Incentive =objWrapper.Q2ClosedSales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
					 				}
						 	 	}
						    }
    				   	}
    				   	/////
    				   	if(objWrapper.Q3ClosedSales < objWrapper.lastYearQ3Sales1Percent)
    					{
    						objWrapper.Q3Incentive = 0.0;
    					}
    					else
    					{
							if(objWrapper.Q3ClosedSales>=objWrapper.lastYearQ3Sales1Percent &&
								 objWrapper.Q3ClosedSales < objWrapper.lastYearQ3Sales4Percent)
						 	{
						 		objWrapper.Q3Incentive = objWrapper.Q3ClosedSales*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;	
						 	}
						 	else
						 	{
						 		if(objWrapper.Q3ClosedSales >= objWrapper.lastYearQ3Sales4Percent && 
						 			objWrapper.Q3ClosedSales < objWrapper.lastYearQ3Sales7Percent)
						 		{
						 			objWrapper.Q3Incentive = objWrapper.Q3ClosedSales*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
						 		}
						 		else
						 		{
						 			if(objWrapper.Q3ClosedSales >= objWrapper.lastYearQ3Sales7Percent && 
						 				objWrapper.Q3ClosedSales  < objWrapper.lastYearQ3Sales10Percent)
					 				{
					 					objWrapper.Q3Incentive =objWrapper.Q3ClosedSales*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
					 				}
					 				else
					 				{
					 					objWrapper.Q3Incentive =objWrapper.Q3ClosedSales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
					 				}
						 	 	}
						    }
    				   	}
    				   	/////
    				   	if(objWrapper.Q4ClosedSales < objWrapper.lastYearQ4Sales1Percent)
    					{
    						objWrapper.Q4Incentive = 0.0;
    					}
    					else
    					{
							if(objWrapper.Q4ClosedSales>=objWrapper.lastYearQ4Sales1Percent &&
								 objWrapper.Q4ClosedSales < objWrapper.lastYearQ4Sales4Percent)
						 	{
						 		objWrapper.Q4Incentive = objWrapper.Q4ClosedSales*lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c;	
						 	}
						 	else
						 	{
						 		if(objWrapper.Q4ClosedSales >= objWrapper.lastYearQ4Sales4Percent && 
						 			objWrapper.Q4ClosedSales < objWrapper.lastYearQ4Sales7Percent)
						 		{
						 			objWrapper.Q4Incentive = objWrapper.Q4ClosedSales*lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c;
						 		}
						 		else
						 		{
						 			if(objWrapper.Q4ClosedSales >= objWrapper.lastYearQ4Sales7Percent && 
						 				objWrapper.Q4ClosedSales  < objWrapper.lastYearQ4Sales10Percent)
					 				{
					 					objWrapper.Q4Incentive =objWrapper.Q4ClosedSales*lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c;
					 				}
					 				else
					 				{
					 					objWrapper.Q4Incentive =objWrapper.Q4ClosedSales*lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c;
					 				}
						 	 	}
						    }
    				   	}
    				   	////
    				   	if(objWrapper.totalClosedSales < objWrapper.lastYearTotalSales1Percent)
    					{
    						objWrapper.totalIncentive = 0.0;
    					}
    					else
    					{
							if(objWrapper.totalClosedSales >= objWrapper.lastYearTotalSales1Percent &&
								 objWrapper.totalClosedSales < objWrapper.lastYearTotalSales4Percent)
						 	{
						 		objWrapper.totalIncentive = objWrapper.totalClosedSales*lstConfig[0].VCPL_Incentive_Slab_1_AVD_In_R_L__c;	
						 	}
						 	else
						 	{
						 		if(objWrapper.totalClosedSales >= objWrapper.lastYearTotalSales4Percent && 
						 			objWrapper.totalClosedSales < objWrapper.lastYearTotalSales7Percent)
						 		{
						 			objWrapper.totalIncentive = objWrapper.totalClosedSales*lstConfig[0].VCPL_Incentive_Slab_2_AVD_In_R_L__c;
						 		}
						 		else
						 		{
						 			if(objWrapper.totalClosedSales >= objWrapper.lastYearTotalSales7Percent && 
						 				objWrapper.totalClosedSales  < objWrapper.lastYearTotalSales10Percent)
					 				{
					 					objWrapper.totalIncentive =objWrapper.totalClosedSales*lstConfig[0].VCPL_Incentive_Slab_3_AVD_In_R_L__c;
					 				}
					 				else
					 				{
					 					objWrapper.totalIncentive =objWrapper.totalClosedSales*lstConfig[0].VCPL_Incentive_Slab_4_AVD_In_R_L__c;
					 				}
						 	 	}
						    }
    				   	}
    				
    				}
					objWrapper.totalIncentiveEarned = objWrapper.Q1Incentive+objWrapper.Q2Incentive+objWrapper.Q3Incentive+objWrapper.Q4Incentive+objWrapper.totalIncentive;
    			}
    		}
    	}
    	return objWrapper;
    }
}