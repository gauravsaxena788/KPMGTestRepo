//=======================================
//Description: Controller For AVD-QVD(CO)
//=======================================
public without sharing class VCPL_AVDQVDCOController 
{
	final static Id cdRecordTypeID = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('Cummins').getRecordTypeId();
	final static Id idBranchRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    final static Id idDealerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VCPL_Cummins_Dealer').getRecordTypeId();
	
	//=========================================================================
	//Description: This Method is used to fetch Dealers based on logged in User
	//=========================================================================
	@AuraEnabled
	public static list<Account> getDealers()
	{
		ID userID = userinfo.getUserId();
		
		list<User> lstUser = [select id,ProfileID,Profile.Name,AccountID,VCPL_Contact_Role__c from User where id=:userID];
		list<Account> lstAccounts = new list<Account>();
		
		list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
                                                            VCPL_CD_ELP_Profile_Name__c,VCPL_CD_BH_Contact_Role_Name__c,
                                                            VCPL_CD_ELP_Contact_Role_Name__c,VCPL_CD_HOD_Contact_Role_Name__c,VCPL_CD_HOD_Profile_Name__c,
                                                            VCPL_NSH_Profile_Name__c,VCPL_SM_Profile_Name__c,VCPL_TBM_Profile_Name__c 
                                                            from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
                                                                
		if(lstUser != NULL && !lstUser.isEmpty())
		{
			if(lstUser[0].Profile.Name.equalsIgnoreCase('System Administrator') 
				|| lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_NSH_Profile_Name__c))
			{
				lstAccounts = [select id,name,BU_Name__c,Indutry_Segment__c,Market_Segment__c,Is_Parent__c from Account 
												where BU_Name__c='C&I' and 
												Indutry_Segment__c='Cummins Dealer' and Is_Parent__c='Y' AND RecordTypeId =:idDealerRecordType];
			}
			else if(lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_SM_Profile_Name__c))
			{
				list<AccountTeamMember> lstAccountTeamMember = [select id,AccountId,UserId,Account.BU_Name__c,
                                                                Account.Indutry_Segment__c,Account.Market_Segment__c,
                                                                Account.Is_Parent__c from AccountTeamMember 
                                                                where UserId=:userID 
                                                                and Account.BU_Name__c='C&I' 
                                                                and Account.Indutry_Segment__c='Cummins Dealer' and 
                                                                Account.Is_Parent__c='Y' AND Account.RecordTypeId =:idDealerRecordType];
                                                                
                 if(lstAccountTeamMember != NULL && !lstAccountTeamMember.isEmpty())
                 {
                 	set<ID> setAccountID = new set<ID>();
                 	
                 	for(AccountTeamMember objTeamMember : lstAccountTeamMember)
                 	{
                 		setAccountID.add(objTeamMember.AccountId);
                 	}
                 	if(setAccountID != NULL && !setAccountID.isEmpty())
                 	{
                 		lstAccounts = [select id,name,BU_Name__c,Indutry_Segment__c,Market_Segment__c from 
													Account where id in:setAccountID];
                 	}
                 }
			}
			else if(lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_TBM_Profile_Name__c))
			{
				lstAccounts = [select id,name,ownerID,Indutry_Segment__c,BU_Name__c,Is_Parent__c from Account 
								where 
								ownerID=:lstUser[0].ID and 
								BU_Name__c='C&I' and 
								Indutry_Segment__c='Cummins Dealer' and Is_Parent__c='Y' AND RecordTypeId =:idDealerRecordType];
			}
			else if(lstMetaData != NULL && !lstMetaData.isEmpty() && 
				(lstUser[0].VCPL_Contact_Role__c != NULL && (lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Contact_Role_Name__c) || 
				lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_ELP_Contact_Role_Name__c))) && 
				lstUser[0].AccountID != NULL)
			{
				lstAccounts = [select id,name,Indutry_Segment__c,BU_Name__c,Is_Parent__c from Account where 
											id=:lstUser[0].AccountID];
			}
			else if((lstUser[0].VCPL_Contact_Role__c != NULL && 
	            lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_BH_Contact_Role_Name__c)) && 
            	lstUser[0].AccountID != NULL)
			{
				list<Account> lstBranchAccount = [select id,name,parentId from Account where id =:lstUser[0].AccountID];
					
				if(lstBranchAccount != NULL && !lstBranchAccount.isEmpty())
				{
					lstAccounts = [select id,name,Indutry_Segment__c,BU_Name__c,Is_Parent__c 
												from Account where id=:lstBranchAccount[0].parentId];
				}
			}
			
		}
		if(lstAccounts != NULL && !lstAccounts.isEmpty())
		{
			return lstAccounts;
		}
		else
		{
			return NULL;
		}
	}
	//===========================================================================
	//Description: This Method is used to fetch Configs from AVD-QVD/BLIS records
	//===========================================================================
	@AuraEnabled
	public static list<string> getConfigs()
	{
		list<VCPL_AVD_QVD__c> lstAVDQVDs = [select id,VCPL_Fiscal_Year__c,RecordTypeID 
    										from VCPL_AVD_QVD__c where VCPL_Fiscal_Year__c != NULL 
    										and RecordTypeID =:cdRecordTypeID order by VCPL_Fiscal_Year__c limit 49999];
    	
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
    //===================================================================
    //This Method is used to get Picklist Data's i.e. Dealers and Configs 
    //===================================================================
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
    //=========================================================================
	//Description: This Method is Used to create wrapper Data for the component.  
	//=========================================================================
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
    	
    	objWrapper.totalIncentiveEarned =0.0;
    	
    	if(strprimaryAccountID != NULL && configYear != NULL)
    	{
    		strprimaryAccountID = strprimaryAccountID.substring(0,15);
    		
    		string strCurrentFYear = VCPL_AVDQVDCommon.getCurrentFinancialYear();
    		string strprevsFYear = string.valueOf(integer.valueOf(configYear)-1); 
    		
    		list<OpportunityLineItem > lstCurrentYearOpportunity = new list<OpportunityLineItem >();
    		list<OpportunityLineItem > lstPrevsYearOpportunity = new list<OpportunityLineItem >();
    		
    		list<VCPL_AVD_QVD__c> lstConfig = [select id,VCPL_Growth_Slab_1_In_Percentage__c,VCPL_Fiscal_Year__c,
												VCPL_Growth_Slab_2_In_Percentage__c,VCPL_Growth_Slab_3_In_Percentage__c,
												VCPL_Growth_Slab_4_In_Percentage__c,VCPL_Incentive_Slab_1_AVD_In_R_L__c,
												VCPL_Incentive_Slab_1_QVD_In_R_L__c,VCPL_Incentive_Slab_2_AVD_In_R_L__c,
												VCPL_Incentive_Slab_2_QVD_In_R_L__c,VCPL_Incentive_Slab_3_AVD_In_R_L__c,
												VCPL_Incentive_Slab_3_QVD_In_R_L__c,VCPL_Incentive_Slab_4_AVD_In_R_L__c,
												VCPL_Incentive_Slab_4_QVD_In_R_L__c from VCPL_AVD_QVD__c where 
												VCPL_Fiscal_Year__c=:configYear and recordTypeID=:cdRecordTypeID];
			
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
    		
    		map<string,Double> mapofCurrentYearOppty = new map<string,Double>();
    		
    		if(configYear != NULL && configYear != '')
    		{
    			lstCurrentYearOpportunity = [select id,Quantity,VCPL_Financial_Year__c,VCPL_Dealer_ID__c,
    											VCPL_Quarter__c,VCPL_Opportunity_Stage__c,VCPL_PH6_QlikView__c from 
    											OpportunityLineItem  where VCPL_Financial_Year__c =:configYear 
    											and VCPL_Quarter__c != NULL and VCPL_Dealer_ID__c=:strprimaryAccountID 
    											and VCPL_PH6_QlikView__c='Cummins Oil'];
    			
    			if(lstCurrentYearOpportunity != NULL && !lstCurrentYearOpportunity.isEmpty())
    			{
    				Double currentSalesQuarter=null; 
    				
    				for(OpportunityLineItem objOppty : lstCurrentYearOpportunity)
    				{
    					if(objOppty.Quantity != NULL)
    					{
    						if(!mapofCurrentYearOppty.containsKey(objOppty.VCPL_Quarter__c))
    						{
    							mapofCurrentYearOppty.put(objOppty.VCPL_Quarter__c,objOppty.Quantity);
    						}
    						else
    						{
    							currentSalesQuarter = 0;
    							currentSalesQuarter = mapofCurrentYearOppty.get(objOppty.VCPL_Quarter__c);
    							currentSalesQuarter += objOppty.Quantity;
    							mapofCurrentYearOppty.put(objOppty.VCPL_Quarter__c,currentSalesQuarter);
    						}
    					}
    				}
    			}
    			else
    			{
    				///Added on 26-9-18 as Sales may come from Branch Also as per Sumit Banarji//////////
    				set<Id> setBranchIDs = new set<Id>();
    				for(Account objAccount : [select id,RecordTypeID from Account where 
    											RecordTypeID =: idBranchRecordType])
    				{
    					setBranchIDs.add(objAccount.Id);
    				}
    				if(setBranchIDs != NULL && !setBranchIDs.isEmpty())
    				{
    					for(OpportunityLineItem objLineItem : [select id,Quantity,VCPL_Financial_Year__c,VCPL_Dealer_ID__c,
				    											VCPL_Quarter__c,VCPL_Opportunity_Stage__c,VCPL_PH6_QlikView__c,
				    											Opportunity.Opportunity_Id__r.AccountID from OpportunityLineItem  
				    											where VCPL_Financial_Year__c =:configYear and VCPL_Quarter__c != NULL and 
				    											Opportunity.Opportunity_Id__r.AccountID in:setBranchIDs 
				    											and VCPL_PH6_QlikView__c ='Cummins Oil' and Quantity != NULL])
						{
							if(!mapofCurrentYearOppty.containsKey(objLineItem.VCPL_Quarter__c))
    						{
    							mapofCurrentYearOppty.put(objLineItem.VCPL_Quarter__c,objLineItem.Quantity);
    						}
    						else
    						{
    							Double currentSalesQuarter = 0;
    							currentSalesQuarter = mapofCurrentYearOppty.get(objLineItem.VCPL_Quarter__c);
    							currentSalesQuarter += objLineItem.Quantity;
    							mapofCurrentYearOppty.put(objLineItem.VCPL_Quarter__c,currentSalesQuarter);
    						}	
						}
    				}
    				/////////////////////////////////////////////////////////////////////////////////////
    			}
    		}
    		map<string,Double> mapofPrevsoppty = new map<string,Double>();
    		if(strprevsFYear != NULL && strprevsFYear != '')
    		{
    			lstPrevsYearOpportunity = [select id,Quantity,VCPL_Financial_Year__c,VCPL_Dealer_ID__c,
    											VCPL_Quarter__c,VCPL_Opportunity_Stage__c,VCPL_PH6_QlikView__c from 
    											OpportunityLineItem where VCPL_Financial_Year__c =:strprevsFYear 
    											and VCPL_Quarter__c != NULL and VCPL_Dealer_ID__c=:strprimaryAccountID 
    											and VCPL_PH6_QlikView__c='Cummins Oil'];
    			
    			if(lstPrevsYearOpportunity != NULL && !lstPrevsYearOpportunity.isEmpty())
    			{
    				Double PrevSalesQuarter=null;
    				for(OpportunityLineItem objPrevs : lstPrevsYearOpportunity)
    				{
    					if(objPrevs.Quantity != NULL)
    					{
	    					if(!mapofPrevsoppty.containskey(objPrevs.VCPL_Quarter__c))
	    					{
	    						mapofPrevsoppty.put(objPrevs.VCPL_Quarter__c,objPrevs.Quantity);
	    					}
	    					else
	    					{
	    						PrevSalesQuarter = 0;
	    						PrevSalesQuarter = mapofPrevsoppty.get(objPrevs.VCPL_Quarter__c);
	    						PrevSalesQuarter += objPrevs.Quantity;
	    						mapofPrevsoppty.put(objPrevs.VCPL_Quarter__c,PrevSalesQuarter);
	    					}
    					}
    				}
    			}
    			else
    			{
    				///Added on 26-9-18 as Sales may come from Branch Also as per Sumit Banarji//////////
    				set<Id> setBranchIDs = new set<Id>();
    				for(Account objAccount : [select id,RecordTypeID from Account where 
    											RecordTypeID =: idBranchRecordType])
    				{
    					setBranchIDs.add(objAccount.Id);
    				}
    				if(setBranchIDs != NULL && !setBranchIDs.isEmpty())
    				{
    					for(OpportunityLineItem objLineItem : [select id,Quantity,VCPL_Financial_Year__c,VCPL_Dealer_ID__c,
				    											VCPL_Quarter__c,VCPL_Opportunity_Stage__c,VCPL_PH6_QlikView__c,
				    											Opportunity.Opportunity_Id__r.AccountID from OpportunityLineItem  
				    											where VCPL_Financial_Year__c =:configYear and VCPL_Quarter__c != NULL and 
				    											Opportunity.Opportunity_Id__r.AccountID in:setBranchIDs 
				    											and VCPL_PH6_QlikView__c ='Cummins Oil' and Quantity != NULL])
						{
							if(!mapofCurrentYearOppty.containsKey(objLineItem.VCPL_Quarter__c))
    						{
    							mapofCurrentYearOppty.put(objLineItem.VCPL_Quarter__c,objLineItem.Quantity);
    						}
    						else
    						{
    							Double currentSalesQuarter = 0;
    							currentSalesQuarter = mapofCurrentYearOppty.get(objLineItem.VCPL_Quarter__c);
    							currentSalesQuarter += objLineItem.Quantity;
    							mapofCurrentYearOppty.put(objLineItem.VCPL_Quarter__c,currentSalesQuarter);
    						}	
						}
    				}
    				/////////////////////////////////////////////////////////////////////////////////////
    			}
    		}
    		if(mapofPrevsoppty != NULL && !mapofPrevsoppty.isEmpty() && lstConfig != NULL && !lstConfig.isEmpty())
    		{
    			if(mapofPrevsoppty.containsKey('Q1') && mapofPrevsoppty.get('Q1') != NULL)
    			{
    				objWrapper.lastYearQ1Sales = mapofPrevsoppty.get('Q1')*1000;
    				
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
    			if(mapofPrevsoppty.containsKey('Q2') && mapofPrevsoppty.get('Q2') != NULL)
    			{
    				objWrapper.lastYearQ2Sales = mapofPrevsoppty.get('Q2')*1000;
    						
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
    			if(mapofPrevsoppty.containsKey('Q3') && mapofPrevsoppty.get('Q3') != NULL)
    			{
    				objWrapper.lastYearQ3Sales = mapofPrevsoppty.get('Q3')*1000;
    						
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
    			if(mapofPrevsoppty.containsKey('Q4') && mapofPrevsoppty.get('Q4') != NULL)
    			{
    				objWrapper.lastYearQ4Sales = mapofPrevsoppty.get('Q4')*1000;
    						
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
					objWrapper.CurrentYearTotalSalesRs1PerLiter = objWrapper.lastYearQ4Sales1Percent - objWrapper.CurrentYearTotalSales;
					objWrapper.CurrentYearTotalSalesRs2PerLiter = objWrapper.lastYearQ4Sales4Percent - objWrapper.CurrentYearTotalSales;
					objWrapper.CurrentYearTotalSalesRs4PerLiter = objWrapper.lastYearQ4Sales7Percent - objWrapper.CurrentYearTotalSales;
					objWrapper.CurrentYearTotalSalesRs6PerLiter = objWrapper.lastYearQ4Sales10Percent - objWrapper.CurrentYearTotalSales;
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
					objWrapper.CurrentYearTotalSalesRs6PerLiterCost = objWrapper.CurrentYearTotalSalesRs6PerLiter*lstConfig[0].VCPL_Incentive_Slab_4_AVD_In_R_L__c;
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
    		
    		if(lstCurrentYearOpportunity != NULL && !lstCurrentYearOpportunity.isEmpty())
    		{
				for(OpportunityLineItem  objOpportunity : lstCurrentYearOpportunity)
				{
					if(objOpportunity.VCPL_Opportunity_Stage__c=='Closed' && 
    					objOpportunity.Quantity != NULL)	
					{
						if(!mapofClosedOpportunities.containskey(objOpportunity.VCPL_Quarter__c))
						{
							mapofClosedOpportunities.put(objOpportunity.VCPL_Quarter__c,objOpportunity.Quantity);
						}
						else
						{
							closedOpptyAmount = 0;
							closedOpptyAmount  = mapofClosedOpportunities.get(objOpportunity.VCPL_Quarter__c);
							closedOpptyAmount += objOpportunity.Quantity;
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
					if(strCurrentFYear == configYear)
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
				   	objWrapper.totalIncentiveEarned = objWrapper.Q1Incentive+objWrapper.Q2Incentive+objWrapper.Q3Incentive+objWrapper.Q4Incentive+objWrapper.totalIncentive;
				}
    		}
    	}
    	return objWrapper;
    } 
}