//=============================================================================================================
//Description: Controller For Sales Capture Component to capture Planned Sales and Latest Est. Sales
//============================================================================================================
public without sharing class VCPL_CumminsSalesCaptureController
{
    final static Id cdBranchRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    final static Id blissRecordTypeID = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
    final static Id secondarySalesRecordTypeID = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get('CD Secondary Sales').getRecordTypeId();
    final static Id cdCustomerID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
    final static string strCurrentFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    final static string strPrevsFinancialYear = string.valueof(integer.valueof(strCurrentFinancialYear)-1);
    final static Id branchCPRTID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
    final static Id dealerCPRTID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Dealer Customer').getRecordTypeId();
    static list<Id> salesPlanAdminProfile;
	
    //==========================================================================
	//Description: This Method is Used to get Branches List for the Dealer
	//========================================================================== 
    @AuraEnabled
    public static list<Account> getBranches(string strCDealerAccountID) 
    {
        if(strCDealerAccountID != null)
        { 
            list<Account> lstBranchAccounts = [select id,parentID,RecordTypeID,name from Account where parentID=:strCDealerAccountID 
                                               and RecordTypeID=:cdBranchRTID];
            
            if(lstBranchAccounts != NULL && !lstBranchAccounts.isEmpty())
            {
                return lstBranchAccounts;
            }			
        }
        else
        {
            ID userID = userinfo.getUserID();
            
            list<User> lstUser = [select id,ProfileID,Profile.Name,AccountID,VCPL_Contact_Role__c from User where id=:userID];
            
            if(lstUser != NULL && !lstUser.isEmpty())
            {
                list<Account> lstBranchAccounts = new list<Account>();
                list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
	                                                                VCPL_CD_ELP_Profile_Name__c,VCPL_CD_BH_Contact_Role_Name__c,
	                                                                VCPL_CD_ELP_Contact_Role_Name__c,VCPL_CD_HOD_Contact_Role_Name__c,VCPL_CD_HOD_Profile_Name__c 
	                                                                from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
                
                if(lstMetaData != NULL && !lstMetaData.isEmpty())
                {
                    if((lstUser[0].VCPL_Contact_Role__c != NULL 
            			&& lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Contact_Role_Name__c)) && 
                        lstUser[0].AccountID != NULL)
                    { 
                        lstBranchAccounts = [select id,parentID,RecordTypeID,name from Account where parentID=:lstUser[0].AccountID 
                                             and RecordTypeID=:cdBranchRTID];	
                    }
                     else if((lstUser[0].VCPL_Contact_Role__c != NULL && 
	                	lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_BH_Contact_Role_Name__c)) && 
                             lstUser[0].AccountID != NULL)
                    {
                        lstBranchAccounts = [select id,parentID,RecordTypeID,name from Account where ID=:lstUser[0].AccountID 
                                             and RecordTypeID=:cdBranchRTID];
                    }
                     else if(lstUser[0].VCPL_Contact_Role__c != NULL && 
		            	lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_ELP_Contact_Role_Name__c))
                    { 
                        list<VCPL_ELP_Assignment__c> lstELPAssignments = [select id,VCPL_Branch__c,VCPL_User__c,VCPL_isActive__c from 
                                                                          VCPL_ELP_Assignment__c where VCPL_User__c=:lstUser[0].ID 
                                                                          and VCPL_Branch__c != NULL and VCPL_isActive__c=true];
                        
                        if(lstELPAssignments != NULL && !lstELPAssignments.isEmpty())
                        {
                            set<ID> setBranchID = new set<ID>();
                            for(VCPL_ELP_Assignment__c objAssignment : lstELPAssignments)
                            {
                                if(objAssignment.VCPL_Branch__c != NULL)
                                {
                                    setBranchID.add(objAssignment.VCPL_Branch__c);
                                }
                            }
                            if(setBranchID != NULL && !setBranchID.isEmpty())
                            {
                                lstBranchAccounts = [select id,parentID,RecordTypeID,name from Account 
                                                     where id in:setBranchID 
                                                     and RecordTypeID=:cdBranchRTID];
                            }
                        }
                    }
                    else
                    {
                        lstBranchAccounts = [select id,parentID,RecordTypeID,name from Account where
                                             RecordTypeID=:cdBranchRTID limit 49999];
                    }
                    if(lstBranchAccounts != NULL && !lstBranchAccounts.isEmpty())
                    {
                        return lstBranchAccounts;
                    }
                    else
                    {
                        return NULL;
                    }
                }		
            }
        }
        return NULL;
    }
    public class DataWrapper
    {
        @AuraEnabled public string strAccountName;
        @AuraEnabled public Double plannedSales;
        @AuraEnabled public Double latestEstSales;
        @AuraEnabled public Double lastYearSalesVolume;
        @AuraEnabled public Double actualSales;
        @AuraEnabled public Double potential;
        @AuraEnabled public string strAssignmentClassification;
        @AuraEnabled public VCPL_Customer_Plan__c objcp;
        @AuraEnabled public Boolean plannedSalesLocked {
            get{
                if(salesPlanAdminProfile == null){
					salesPlanAdminProfile = new list<Id>();
					list<VCPL_System_Configuration__mdt> lstMetaData = [select VCPL_Cummins_Sales_Plan_Admin_Profile__c from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
					if(lstMetaData[0].VCPL_Cummins_Sales_Plan_Admin_Profile__c != null){
						list<String> lstProfile = lstMetaData[0].VCPL_Cummins_Sales_Plan_Admin_Profile__c.split(',');
						
						for(Profile objProfile : [SELECT Id from Profile where Name in : lstProfile]){
							salesPlanAdminProfile.add(objProfile.Id);
						}
					}
				}
				
                if(plannedSales != null && plannedSales > 0 && !salesPlanAdminProfile.contains(UserInfo.getProfileId()))
                    return true;
                else return false;
            }
            set;
        }
    }
    //==============================================================================================
	//Description: This Method is Used to get Dealer Account ID as per logged in User
	//==============================================================================================
    @AuraEnabled
    public static string getParentAccount()
    {
        Id userId = userinfo.getuserId();
        
        list<User> lstuser = [select id,AccountId,Profile.Name,VCPL_Contact_Role__c from User where Id=:userId];
        
        if(lstuser != NULL && !lstuser.isEmpty())
        {
            list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
                                                                VCPL_CD_ELP_Profile_Name__c,VCPL_CD_BH_Contact_Role_Name__c,
                                                                VCPL_CD_ELP_Contact_Role_Name__c,VCPL_CD_HOD_Contact_Role_Name__c,VCPL_CD_HOD_Profile_Name__c 
                                                                from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
            
            if(lstuser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Contact_Role_Name__c) || 
               lstuser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_ELP_Contact_Role_Name__c))
            {
                return lstuser[0].AccountId;
            }
            else if(lstuser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_BH_Contact_Role_Name__c))
            {
                list<Account> lstBranchAccount = [select id,parentId from Account where id=:lstuser[0].AccountId];
                
                if(lstBranchAccount != NULL && !lstBranchAccount.isEmpty())
                {
                    return lstBranchAccount[0].parentId;
                }	
            }
			
        }
        return Null;
    }
    //===========================================================================================================
	//Description: This Method is Used to get list of Customer Accounts for which Assignment has to be done . 
	//===========================================================================================================
    @AuraEnabled
    public static list<Account> getCustomers(string parentID)
    {
     	if(parentID != NULL)
        {
        	set<ID> setofIDs = new set<ID>();
        	for(VCPL_Dealer_Customer_Mapping__c objDCM : [select id,VCPL_Customer_Account__c,VCPL_Dealer_Account__c,
                                                          VCPL_Customer_Account__r.VCPL_Isgroupbyparent__c from 
                                                          VCPL_Dealer_Customer_Mapping__c 
                                                          where VCPL_Dealer_Account__c=:parentID and 
                                                          VCPL_Customer_Account__c != NULL 
                                                          limit 49999])
          	{
          		setofIDs.add(objDCM.VCPL_Customer_Account__c);
          	}
          	for(VCPL_Customer_Plan__c objCP : [select id,RecordTypeID,VCPL_CD_Customer__c from VCPL_Customer_Plan__c 
                                               where VCPL_CD_Customer__c Not in:setofIDs and RecordTypeID=:dealerCPRTID 
                                               and VCPL_Customer_Account__c=:parentID  limit 49999])
            {
                setofIDs.add(objCP.VCPL_CD_Customer__c);        
            }
            if(setofIDs != NULL && !setofIDs.isEmpty())
            {
            	list<Account> lstCustomerAccount = [select id,name,recordTypeID,parentID,
                    									VCPL_Isgroupbyparent__c,Is_Parent__c,VCPL_Current_Fin_Year_Total_Potential__c from Account 
                                                        where recordTypeID=:cdCustomerID 
                                                        and id in:setofIDs and VCPL_Isgroupbyparent__c=false  
                                                        order by name asc limit 49999];
            	
            	if(lstCustomerAccount != NULL && !lstCustomerAccount.isEmpty()) 
                {
                    return lstCustomerAccount;
                }
                else
                {
                    return NULL;
                }
            }
        }
        return NULL;
    }
    //===========================================================================================================
	//Description: This Method is Used to create wrapper Data for the component.  
	//===========================================================================================================
	//Changed on 4-10-2018 as per meeting at VCPL office to show others as a separate "Customer Plan"
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    public static list<DataWrapper> getData(string strBranchID,string parentId)
	{
		list<DataWrapper> lstWrapper = new list<DataWrapper>();
		
		if(strBranchID != NULL)
		{
			map<Id,Account> mapofBranch = new map<id,Account>();
	    		
			for(Account objAccount : [select id,name,VCPL_BC_Auto_Number__c from Account where ID =:strBranchID])
			{
				if(!mapofBranch.containsKey(objAccount.id))
					mapofBranch.put(objAccount.id,objAccount);
			}
			list<Account> lstCutomerAccounts = new list<Account>();
			
			if(parentID == NULL)
			{
				lstCutomerAccounts = getCustomers(getParentAccount());
			}
			else
			{
				lstCutomerAccounts = getCustomers(parentID);
			}
			map<string,Double> mapofAS = new map<string,Double>();
			map<string,Double> mapofLYS = new map<string,Double>();	
			Id parentAccountID = getParentAccount();
			if(lstCutomerAccounts != NULL && !lstCutomerAccounts.isEmpty())
			{
				set<ID> setofAccountID = new set<ID>();
				
				for(Account objAccount :lstCutomerAccounts)
				{
					setofAccountID.add(objAccount.Id);
				}
				if(setofAccountID != NULL && !setofAccountID.isEmpty())
				{
					map<string,VCPL_Customer_Plan__c> mapofCustomerPlan = new map<string,VCPL_Customer_Plan__c>();
					string strCPKey;
					
					//////////////////////////////////////////////////////////////////////
							
					//////////////////////////////////////////////////////////////////////
					for(VCPL_Customer_Plan__c objCP : [select id,VCPL_Financial_Year__c,VCPL_CD_Customer__c,
	                										VCPL_Last_Year_Sales_Vol__c,VCPL_Branch_Actual_Sales__c,RecordTypeID,
	                										VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_Customer_Account__r.parentID,
	                										VCPL_Dealer_Account__c,VCPL_Potential__c,
	                										VCPL_Branch__c,VCPL_Assignment_Classification__c,VCPL_ELP_Branch_Head__c,
	                										VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
	                										VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c,
	                										VCPL_Planned_sales__c,VCPL_Latest_Est_Sales__c from VCPL_Customer_Plan__c where 
	                										(VCPL_Financial_Year__c=:strPrevsFinancialYear or 
	                										VCPL_Financial_Year__c=:strCurrentFinancialYear) 
	                										and VCPL_CD_Customer__c in:setofAccountID and 
	                										RecordTypeID=:branchCPRTID and VCPL_Customer_Account__r.parentID != NULL 
	                										and VCPL_Customer_Account__c =: strBranchID])
					{
						if(!objCP.VCPL_Assignment_Classification__c.equalsIgnoreCase('Others'))
						{
							strCPKey ='';
							strCPKey = objcp.VCPL_Financial_Year__c+'-'+objcp.VCPL_CD_Customer__c+'-'+objcp.VCPL_Customer_Account__r.parentID+'-'+objcp.VCPL_Customer_Account__c;
							
							if(!mapofCustomerPlan.containsKey(strCPKey))
								mapofCustomerPlan.put(strCPKey,objCP);
						}
						else
						{
							string othersCPKey = objcp.VCPL_Financial_Year__c+'-'+objcp.VCPL_Customer_Account__c;
							
							if(!mapofAS.containsKey(othersCPKey))
							{
								mapofAS.put(othersCPKey,objCP.VCPL_Branch_Actual_Sales__c);
							}
							else
							{
								Double doubleAS = mapofAS.get(othersCPKey);
								doubleAS += objCP.VCPL_Branch_Actual_Sales__c;
								mapofAS.put(othersCPKey,doubleAS);
							}
							
							Double LYSales = 0;
							
							if(objCP.VCPL_Last_Year_IO_Sales_Volume__c != NULL)
							{
								LYSales += objCP.VCPL_Last_Year_IO_Sales_Volume__c;
							}
							if(objCP.VCPL_Last_Year_CO_Sales_Volume__c != NULL)
							{
								LYSales += objCP.VCPL_Last_Year_CO_Sales_Volume__c;
							}
							
							
							if(!mapofLYS.containsKey(othersCPKey))
							{
								mapofLYS.put(othersCPKey,LYSales);
							}
							else
							{
								Double doubleLY = mapofLYS.get(othersCPKey);
								doubleLY += LYSales;
								mapofLYS.put(othersCPKey,doubleLY);
							}
						}
					}
					
						if(parentID != NULL)
	                    {
	                        parentAccountID = parentID;
	                    }
						string strAccKey;
						string strPrevsYearAccKey;
						Double lyIOSales;
	                    Double lyCOSales;
						
						for(Account objAccount : lstCutomerAccounts)
						{
							strAccKey = '';
							strPrevsYearAccKey = '';
							lyIOSales = 0;
							lyCOSales =0;
							
							strAccKey = strCurrentFinancialYear+'-'+objAccount.Id+'-'+parentAccountID+'-'+strBranchID;
	                    	strPrevsYearAccKey = strPrevsFinancialYear+'-'+objAccount.Id+'-'+parentAccountID+'-'+strBranchID;
							
							if(mapofCustomerPlan.containsKey(strAccKey) && mapofCustomerPlan.get(strAccKey) != NULL)
							{
								dataWrapper objWrapper = new dataWrapper();
	                            objWrapper.strAccountName = objAccount.Name;
	                            
	                            objWrapper.potential = objAccount.VCPL_Current_Fin_Year_Total_Potential__c != NULL?objAccount.VCPL_Current_Fin_Year_Total_Potential__c:0;
	                            
	                            objWrapper.plannedSales = mapofCustomerPlan.get(strAccKey).VCPL_Planned_sales__c != NULL?
	                            							mapofCustomerPlan.get(strAccKey).VCPL_Planned_sales__c*1000:0;
	                            objWrapper.latestEstSales = mapofCustomerPlan.get(strAccKey).VCPL_Latest_Est_Sales__c != NULL?
	                            								mapofCustomerPlan.get(strAccKey).VCPL_Latest_Est_Sales__c*1000:0;
	                            
	                            lyIOSales = mapofCustomerPlan.get(strAccKey).VCPL_Last_Year_IO_Sales_Volume__c != NULL?
	                    					mapofCustomerPlan.get(strAccKey).VCPL_Last_Year_IO_Sales_Volume__c:0;
	                    		
	                    		lyCOSales = mapofCustomerPlan.get(strAccKey).VCPL_Last_Year_CO_Sales_Volume__c != NULL?
	                        					mapofCustomerPlan.get(strAccKey).VCPL_Last_Year_CO_Sales_Volume__c:0;
	                        					
	                            //objWrapper.lastYearSalesVolume = lyIOSales+lyCOSales;
                                objWrapper.lastYearSalesVolume = lyCOSales;
	                            
	                            //objWrapper.actualSales = mapofCustomerPlan.get(strAccKey).VCPL_Branch_Actual_Sales__c != NULL? mapofCustomerPlan.get(strAccKey).VCPL_Branch_Actual_Sales__c:0;
	                            objWrapper.actualSales = mapofCustomerPlan.get(strAccKey).VCPL_Branch_CO_Sales__c != NULL? mapofCustomerPlan.get(strAccKey).VCPL_Branch_CO_Sales__c:0;
	                            
                                objWrapper.strAssignmentClassification = mapofCustomerPlan.get(strAccKey).VCPL_Assignment_Classification__c;
	                            objWrapper.objcp = 	mapofCustomerPlan.get(strAccKey);
	                            
	                            lstWrapper.add(objWrapper);
							}
						}
						
					
				}
			}
			///////////////////////////////////////////////////
						map<string,VCPL_Customer_Plan__c> mapofOtherCP = new map<string,VCPL_Customer_Plan__c>(); 
						map<string,Double> mapofOtherSales = new map<string,Double>();
						map<string,Double> mapofOtherPotentials = new map<string,Double>();
						
						for(VCPL_Customer_Plan__c objCP : [select id,VCPL_Financial_Year__c,VCPL_Last_Year_Sales_Vol__c,VCPL_Branch_Actual_Sales__c,
															RecordTypeID,VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_CD_Customer__c,
															VCPL_Customer_Account__r.parentID,VCPL_Dealer_Account__c,VCPL_Potential__c,
															VCPL_CD_Customer__r.VCPL_Current_Fin_Year_Total_Potential__c,
	                										VCPL_Branch__c,VCPL_Assignment_Classification__c,VCPL_ELP_Branch_Head__c,
	                										VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
	                										VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c,
	                										VCPL_Planned_sales__c,VCPL_Latest_Est_Sales__c from VCPL_Customer_Plan__c 
	                										where VCPL_Customer_Account__c =:strBranchID and RecordTypeID=:branchCPRTID and 
															(VCPL_Financial_Year__c=:strCurrentFinancialYear or VCPL_Financial_Year__c=:strPrevsFinancialYear)  
															and VCPL_Assignment_Classification__c='Others'])
						{
							
							string strOtherCP = objCP.VCPL_Financial_Year__c+'-'+objCP.VCPL_Customer_Account__c;
							
							if(!mapofOtherCP.containsKey(strOtherCP))
							{
								mapofOtherCP.put(strOtherCP,objCP);
							}
							//////////////////////////////////////////////////////////////////////////////////////
							if(objCP.VCPL_CD_Customer__c != NULL && objCP.VCPL_CD_Customer__r.VCPL_Current_Fin_Year_Total_Potential__c != NULL)
							{
								if(!mapofOtherPotentials.containsKey(strOtherCP))
								{
									mapofOtherPotentials.put(strOtherCP,objCP.VCPL_CD_Customer__r.VCPL_Current_Fin_Year_Total_Potential__c);
								}
								else
								{
									Double otherPotentials = mapofOtherPotentials.get(strOtherCP);
									otherPotentials += objCP.VCPL_CD_Customer__r.VCPL_Current_Fin_Year_Total_Potential__c;
									mapofOtherPotentials.put(strOtherCP,otherPotentials);
								}
							}
							/////////////////////////////////////////////////////////////////////////////////////
							if(objCP.VCPL_CD_Customer__c != NULL && objCP.VCPL_Branch_Actual_Sales__c != NULL)
							{
								if(!mapofOtherSales.containsKey(strOtherCP))
								{
									mapofOtherSales.put(strOtherCP,objCP.VCPL_Branch_Actual_Sales__c);
								}
								else 
								{
									Double actualSales = mapofOtherSales.get(strOtherCP);
									//actualSales += objCP.VCPL_Branch_Actual_Sales__c;
									actualSales += objCP.VCPL_Branch_CO_Sales__c;
									mapofOtherSales.put(strOtherCP,actualSales);
								}
							}
						}
						if(mapofOtherCP.containsKey(strCurrentFinancialYear+'-'+strBranchID) && 
							mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID) != NULL)
						{
							dataWrapper objWrapper = new dataWrapper();
							
							objWrapper.potential = 0;
							objWrapper.lastYearSalesVolume = 0;
							if(mapofOtherPotentials.containsKey(strCurrentFinancialYear+'-'+strBranchID) 
								&& mapofOtherPotentials.get(strCurrentFinancialYear+'-'+strBranchID) != NULL)
							{
								objWrapper.potential = 	mapofOtherPotentials.get(strCurrentFinancialYear+'-'+strBranchID);
							}
							else
							{
								objWrapper.potential = 	0;
							}
							
							objWrapper.strAccountName = 'Others Customer Account';
							objWrapper.plannedSales = mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID).VCPL_Planned_sales__c != NULL?
														mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID).VCPL_Planned_sales__c*1000:0;
							objWrapper.latestEstSales = mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID).VCPL_Latest_Est_Sales__c != NULL?
															mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID).VCPL_Latest_Est_Sales__c *1000:0;
							
							if(mapofOtherSales.containsKey(strPrevsFinancialYear+'-'+strBranchID) && 
								mapofOtherSales.get(strPrevsFinancialYear+'-'+strBranchID) != NULL)
							{
								objWrapper.lastYearSalesVolume = mapofOtherSales.get(strPrevsFinancialYear+'-'+strBranchID);	
							}
							else
							{
								objWrapper.lastYearSalesVolume = 0;
							}
							
							if(mapofOtherSales.containsKey(strCurrentFinancialYear+'-'+strBranchID) && 
								mapofOtherSales.get(strCurrentFinancialYear+'-'+strBranchID) != NULL)
							{
								objWrapper.actualSales = mapofOtherSales.get(strCurrentFinancialYear+'-'+strBranchID);			
							}
							else
							{
								objWrapper.actualSales = 0;
							}
							objWrapper.strAssignmentClassification = mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID).VCPL_Assignment_Classification__c;
							
							objWrapper.objcp = mapofOtherCP.get(strCurrentFinancialYear+'-'+strBranchID);
							
							lstWrapper.add(objWrapper);
						}
						else
						{
							VCPL_Customer_Plan__c objCp = new VCPL_Customer_Plan__c(VCPL_Customer_Account__c = strBranchID,
																					VCPL_Financial_Year__c = strCurrentFinancialYear,
																					name = strCurrentFinancialYear+'-'+mapofBranch.get(strBranchID).VCPL_BC_Auto_Number__c,
																					VCPL_Last_Year_Sales_Vol__c=0,
	                    															VCPL_Planned_sales__c=0,
																					VCPL_Latest_Est_Sales__c=0,
	                    															VCPL_Assignment_Classification__c = 'Others',
																					VCPL_Dealer_Account__c=parentAccountID,
																					VCPL_Branch__c= strBranchID);
							
							objcp.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
							
							dataWrapper objWrapper = new dataWrapper();
							objWrapper.lastYearSalesVolume =0.0;
	                        objWrapper.strAccountName = 'Others Customer Account';
							///////////////////////////////////////////////
							if(mapofOtherPotentials.containsKey(strCurrentFinancialYear+'-'+strBranchID) 
								&& mapofOtherPotentials.get(strCurrentFinancialYear+'-'+strBranchID) != NULL)
							{
								objWrapper.potential = 	mapofOtherPotentials.get(strCurrentFinancialYear+'-'+strBranchID);
							}
							else
							{
								objWrapper.potential = 	0;
							}
							///////////////////////////////////////////////
							if(mapofOtherSales.containsKey(strPrevsFinancialYear+'-'+strBranchID) && 
								mapofOtherSales.get(strPrevsFinancialYear+'-'+strBranchID) != NULL)
							{
								objWrapper.lastYearSalesVolume = mapofOtherSales.get(strPrevsFinancialYear+'-'+strBranchID);	
							}
							else
							{
								objWrapper.lastYearSalesVolume = 0;
							}
							
							if(mapofOtherSales.containsKey(strCurrentFinancialYear+'-'+strBranchID) && 
								mapofOtherSales.get(strCurrentFinancialYear+'-'+strBranchID) != NULL)
							{
								objWrapper.actualSales = mapofAS.get(strCurrentFinancialYear+'-'+strBranchID);			
							}
							else
							{
								objWrapper.actualSales = 0;
							}
							objWrapper.plannedSales = objCp.VCPL_Planned_sales__c;
							objWrapper.latestEstSales = objCp.VCPL_Latest_Est_Sales__c;
							objWrapper.strAssignmentClassification = objCp.VCPL_Assignment_Classification__c;
							
							objWrapper.objcp = objCp;
							
							lstWrapper.add(objWrapper);
						}
						///////////////////////////////////////////////////
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
    //======================================================================================================================
	//Description: This Method is Used to filter Data based on Classification Selected and Customer Account Name typed. 
	//======================================================================================================================
    @AuraEnabled
    public static list<dataWrapper> getFilteredValues(string strResponse,string selectedClassification,string strSearchString)
    {
        list<dataWrapper> lstWrapper = new list<dataWrapper>();
        
        if(strResponse != NULL && selectedClassification != NULL)
        {
            list<dataWrapper> lstDataWrapper =  (List<dataWrapper>)JSON.deserialize(strResponse,List<dataWrapper>.class);
            
            if(lstDataWrapper != NULL && !lstDataWrapper.isEmpty())
            {
                if(!selectedClassification.equalsIgnorecase('All'))
                {
                    if(strSearchString == '')
                    {
                        for(dataWrapper objWrapper : lstDataWrapper)
                        {
                            if(objWrapper.strAssignmentClassification.equalsIgnoreCase(selectedClassification))
                            {
                                lstWrapper.add(objWrapper);
                            }
                        }
                    }
                    else
                    {
                        for(dataWrapper objWrapper : lstDataWrapper)
                        {
                            if(objWrapper.strAccountName.containsIgnoreCase(strSearchString) && 
                            	objWrapper.strAssignmentClassification.equalsIgnoreCase(selectedClassification))
                            {
                                lstWrapper.add(objWrapper);
                            }
                        }
                    }
                }
                else
                {
                    if(strSearchString == '')
                    {
                        return lstDataWrapper;
                    }
                    else
                    {
                        for(dataWrapper objWrapper : lstDataWrapper)
                        {
                            if(objWrapper.strAccountName.containsIgnoreCase(strSearchString))
                            {
                                lstWrapper.add(objWrapper);
                            }
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
    //===========================================================================================================
	//Description: This Method is Used for Save Functionality
	//===========================================================================================================
    @AuraEnabled
    public static string saveData(string strResponse)
    {
        string strStatus='Initiated';
        
        list<VCPL_Customer_Plan__c> lstCP = new list<VCPL_Customer_Plan__c>();
        
        if(strResponse != NULL)
        {
            list<VCPL_CumminsSalesCaptureController.DataWrapper> lstWrapper=  (List<VCPL_CumminsSalesCaptureController.DataWrapper>)JSON.deserialize(strResponse,List<VCPL_CumminsSalesCaptureController.DataWrapper>.class);
            
            if(lstWrapper != NULL && !lstWrapper.isEmpty())
            {
                strStatus='Parsed';
                
                for(DataWrapper objWrapper : lstWrapper)
                {
                    if((objWrapper.plannedSales > 0 || 
                        objWrapper.latestEstSales > 0) || 
                        (((objWrapper.plannedSales == 0 || objWrapper.plannedSales == NULL) || 
                        (objWrapper.latestEstSales == 0 || objWrapper.latestEstSales == NULL)) 
                        && objWrapper.objcp.Id != NULL))
                    {
                        objWrapper.objcp.VCPL_Planned_sales__c = objWrapper.plannedSales != NULL?objWrapper.plannedSales/1000:0;
                        objWrapper.objcp.VCPL_Latest_Est_Sales__c = objWrapper.latestEstSales != NULL?objWrapper.latestEstSales/1000:0;
                        objWrapper.objcp.VCPL_Is_Current_Financial_Year__c = true;
                        
                        lstCP.add(objWrapper.objcp);
                    }
                }
                if(lstCP != NULL && !lstCP.isEmpty())
                {
                    try {
                        upsert lstCP;
                        strStatus='Processed successfully';
                    }
                    catch(exception ex) {
                        strStatus = 'Error: ' + ex.getMessage();
                    }	
                }
            }
            
        }
        return strStatus;
    }
}