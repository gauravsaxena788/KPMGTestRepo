public class VCPL_BLISController 
{
    final static Id blissRecordTypeID = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
    final static Id secondarySalesRecordTypeID = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get('CD Secondary Sales').getRecordTypeId();
    final static Id cdBranchRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    final static Id cumminsDealerRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer').getRecordTypeId();
    
    @AuraEnabled
    public static list<Account> getDealers()
    {
        ID userID = userinfo.getUserId();
        list<Account> lstDealerAccounts = new list<Account>();
        list<User> lstUser = [select id,ProfileID,Profile.Name,AccountID,VCPL_Contact_Role__c from User where id=:userID];
        
        list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
                                                                VCPL_CD_ELP_Profile_Name__c,VCPL_CD_BH_Contact_Role_Name__c,VCPL_NSH_Profile_Name__c,
                                                                VCPL_CD_ELP_Contact_Role_Name__c,VCPL_CD_HOD_Contact_Role_Name__c,VCPL_CD_HOD_Profile_Name__c 
                                                                from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
        
        if(lstMetaData != NULL && !lstMetaData.isEmpty())
        {
            if((lstUser[0].VCPL_Contact_Role__c != NULL 
                        && lstUser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Contact_Role_Name__c)) && 
                        lstUser[0].AccountID != NULL)
            {
                lstDealerAccounts = [select id,name from Account where ID=:lstUser[0].AccountID];   
            }
            else if(lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_NSH_Profile_Name__c) || 
                lstUser[0].Profile.Name.equalsIgnoreCase('System Administrator'))
            {
                lstDealerAccounts = [select id,name,BU_Name__c,Indutry_Segment__c,Market_Segment__c,Is_Parent__c 
                                                from Account where BU_Name__c='C&I' and Indutry_Segment__c='Cummins Dealer'  
                                                and Is_Parent__c='Y' and RecordTypeID=:cumminsDealerRTID order by createdDate desc limit 49999];
            }
            else {
                //Code Added by Sumit to give access to bliss to all internal user.
                lstDealerAccounts = [select id,name,BU_Name__c,Indutry_Segment__c,Market_Segment__c,Is_Parent__c 
                                                from Account where BU_Name__c='C&I' and Indutry_Segment__c='Cummins Dealer'  
                                                and Is_Parent__c='Y' and RecordTypeID=:cumminsDealerRTID order by createdDate desc limit 49999];
            }
        }
        if(lstDealerAccounts != NULL && !lstDealerAccounts.isEmpty())
        {
            return lstDealerAccounts;
        }
        else
        {
            return NULL; 
        }
    }
    @AuraEnabled
    public static list<VCPL_BLIS_Group__c> getBLISgroups(string strDealerID)
    {
        list<VCPL_BLIS_Group__c> lstBLISGroups = new list<VCPL_BLIS_Group__c>();
        if(strDealerID != NULL)
        {
            lstBLISGroups = [select id,name,VCPL_Dealer__c,VCPL_Status__c from VCPL_BLIS_Group__c 
                                where VCPL_Dealer__c=:strDealerID and VCPL_Status__c='Approved'];
        }
        if(lstBLISGroups != NULL && !lstBLISGroups.isEmpty())
        {
            return lstBLISGroups;
        }
        else
        {
            return NULL;
        }   
    }
    @AuraEnabled
    public static list<Account> getbranches(string strDealerID)
    {
        list<Account> lstAccounts = new list<Account>();
        list<VCPL_BLIS_Group__c> lstBlisGroup = getBLISgroups(strDealerID);
        set<Id> setGroupId = new set<Id>();
        set<Id> setBranchId = new set<Id>();
        if(lstBlisGroup != NULL && !lstBlisGroup.isEmpty())
        {
            for(VCPL_BLIS_Group__c objGroup : lstBlisGroup)
            {
                setGroupId.add(objGroup.Id);
            }
        }
        if(setGroupId != NULL && !setGroupId.isEmpty())
        {
            for(VCPL_Group_Branch__c objGB : [select id,VCPL_BLIS_Group__c,VCPL_Branch__c from VCPL_Group_Branch__c where 
                                                VCPL_BLIS_Group__c in:setGroupId and VCPL_Branch__c != NULL])
            {
                setBranchId.add(objGB.VCPL_Branch__c);
            }
        }
        if(strDealerID != NULL)
        {
            lstAccounts = [select id,name,RecordTypeID,parentID from Account where RecordTypeID=:cdBranchRTID and 
                                            parentID=:strDealerID and Id Not in:setBranchId];
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
    @AuraEnabled
    public static list<VCPL_AVD_QVD__c> getConfigs()
    {
        list<VCPL_AVD_QVD__c> lstAVDQVDs = [select id,VCPL_Fiscal_Year__c,RecordTypeID 
                                            from VCPL_AVD_QVD__c where VCPL_Fiscal_Year__c != NULL 
                                            and RecordTypeID =:blissRecordTypeID limit 49999];
        
        list<VCPL_AVD_QVD__c> lstConfigs = new list<VCPL_AVD_QVD__c>();
        if(lstAVDQVDs != NULL && !lstAVDQVDs.isEmpty())
        {
            for(VCPL_AVD_QVD__c obj : lstAVDQVDs)
            {
                lstConfigs.add(obj);
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
        @AuraEnabled public list<VCPL_AVD_QVD__c> lstConfigs;
    }
    @AuraEnabled
    public static picklistWrapper getPicklists()
    {
        picklistWrapper objPickWrapper = new picklistWrapper();
        
        objPickWrapper.lstAccounts = getDealers();
        objPickWrapper.lstConfigs = getConfigs();
        
        return objPickWrapper;
    }
    public class DataWrapper
    {
        @AuraEnabled public Double lastYearQ1Sales;
        @AuraEnabled public Double lastYearQ1Sales1Percent;
        @AuraEnabled public Double lastYearQ1Sales4Percent;
        @AuraEnabled public Double lastYearQ1Sales7Percent;
        @AuraEnabled public Double lastYearQ1Sales10Percent;
        @AuraEnabled public Double lastYearQ2Sales;
        @AuraEnabled public Double lastYearQ2Sales1Percent;
        @AuraEnabled public Double lastYearQ2Sales4Percent;
        @AuraEnabled public Double lastYearQ2Sales7Percent;
        @AuraEnabled public Double lastYearQ2Sales10Percent;
        @AuraEnabled public Double lastYearQ3Sales;
        @AuraEnabled public Double lastYearQ3Sales1Percent;
        @AuraEnabled public Double lastYearQ3Sales4Percent;
        @AuraEnabled public Double lastYearQ3Sales7Percent;
        @AuraEnabled public Double lastYearQ3Sales10Percent;
        @AuraEnabled public Double lastYearQ4Sales;
        @AuraEnabled public Double lastYearQ4Sales1Percent;
        @AuraEnabled public Double lastYearQ4Sales4Percent;
        @AuraEnabled public Double lastYearQ4Sales7Percent;
        @AuraEnabled public Double lastYearQ4Sales10Percent;
        @AuraEnabled public Double lastYearTotalSales;
        @AuraEnabled public Double lastYearTotalSales1Percent;
        @AuraEnabled public Double lastYearTotalSales4Percent;
        @AuraEnabled public Double lastYearTotalSales7Percent;
        @AuraEnabled public Double lastYearTotalSales10Percent;
        @AuraEnabled public Double CurrentYearQ1Sales;
        @AuraEnabled public Double QVDQ1Rs1PerLiter;
        @AuraEnabled public Double QVDQ1Rs2PerLiter;    
        @AuraEnabled public Double QVDQ1Rs4PerLiter;
        @AuraEnabled public Double QVDQ1Rs6PerLiter;
        @AuraEnabled public Double CurrentYearQ2Sales;
        @AuraEnabled public Double QVDQ2Rs1PerLiter;
        @AuraEnabled public Double QVDQ2Rs2PerLiter;   
        @AuraEnabled public Double QVDQ2Rs4PerLiter;
        @AuraEnabled public Double QVDQ2Rs6PerLiter;
        @AuraEnabled public Double CurrentYearQ3Sales;
        @AuraEnabled public Double QVDQ3Rs1PerLiter;
        @AuraEnabled public Double QVDQ3Rs2PerLiter;   
        @AuraEnabled public Double QVDQ3Rs4PerLiter;
        @AuraEnabled public Double QVDQ3Rs6PerLiter;
        @AuraEnabled public Double CurrentYearQ4Sales;
        @AuraEnabled public Double QVDQ4Rs1PerLiter;
        @AuraEnabled public Double QVDQ4Rs2PerLiter;   
        @AuraEnabled public Double QVDQ4Rs4PerLiter;
        @AuraEnabled public Double QVDQ4Rs6PerLiter;
        @AuraEnabled public Double CurrentYearTotalSales;
        @AuraEnabled public Double CurrentYearTotalSalesRs1PerLiter;
        @AuraEnabled public Double CurrentYearTotalSalesRs2PerLiter; 
        @AuraEnabled public Double CurrentYearTotalSalesRs4PerLiter;
        @AuraEnabled public Double CurrentYearTotalSalesRs6PerLiter;
        @AuraEnabled public string growthSlab1Label;
        @AuraEnabled public string growthSlab2Label;
        @AuraEnabled public string growthSlab3Label;
        @AuraEnabled public string growthSlab4Label;
        @AuraEnabled public string incentiveSlab1QVDLabel;
        @AuraEnabled public string incentiveSlab2QVDLabel;
        @AuraEnabled public string incentiveSlab3QVDLabel;
        @AuraEnabled public string incentiveSlab4QVDLabel;
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
    }
    @AuraEnabled
    public static DataWrapper getData(string strBlisGroupID,string strConfig,string strBranchID)
    {
        DataWrapper objWrapper = new DataWrapper();
        
        objWrapper.lastYearQ1Sales = 0.0;
        objWrapper.lastYearQ1Sales1Percent = 0.0;
        objWrapper.lastYearQ1Sales4Percent=0.0;
        objWrapper.lastYearQ1Sales7Percent = 0.0;
        objWrapper.lastYearQ1Sales10Percent = 0.0;

        objWrapper.lastYearQ2Sales = 0.0;
        objWrapper.lastYearQ2Sales1Percent = 0.0;
        objWrapper.lastYearQ2Sales4Percent=0.0;
        objWrapper.lastYearQ2Sales7Percent = 0.0;
        objWrapper.lastYearQ2Sales10Percent = 0.0;

        objWrapper.lastYearQ3Sales = 0.0;
        objWrapper.lastYearQ3Sales1Percent = 0.0;
        objWrapper.lastYearQ3Sales4Percent=0.0;
        objWrapper.lastYearQ3Sales7Percent = 0.0;
        objWrapper.lastYearQ3Sales10Percent = 0.0;
        
        objWrapper.lastYearQ4Sales = 0.0;
        objWrapper.lastYearQ4Sales1Percent = 0.0;
        objWrapper.lastYearQ4Sales4Percent=0.0;
        objWrapper.lastYearQ4Sales7Percent = 0.0;
        objWrapper.lastYearQ4Sales10Percent = 0.0;
        
        objWrapper.lastYearTotalSales = 0.0;
        objWrapper.lastYearTotalSales1Percent = 0.0;
        objWrapper.lastYearTotalSales4Percent = 0.0;
        objWrapper.lastYearTotalSales7Percent = 0.0;
        objWrapper.lastYearTotalSales10Percent = 0.0;
        
        objWrapper.QVDQ1Rs1PerLiter = 0.0;
        objWrapper.QVDQ1Rs2PerLiter = 0.0;
        objWrapper.QVDQ1Rs4PerLiter = 0.0;
        objWrapper.QVDQ1Rs6PerLiter = 0.0;
        
        objWrapper.QVDQ2Rs1PerLiter = 0.0;
        objWrapper.QVDQ2Rs2PerLiter = 0.0;
        objWrapper.QVDQ2Rs4PerLiter = 0.0;
        objWrapper.QVDQ2Rs6PerLiter = 0.0;
        
        objWrapper.QVDQ3Rs1PerLiter = 0.0;
        objWrapper.QVDQ3Rs2PerLiter = 0.0;
        objWrapper.QVDQ3Rs4PerLiter = 0.0;
        objWrapper.QVDQ3Rs6PerLiter = 0.0;
        
        objWrapper.QVDQ4Rs1PerLiter = 0.0;
        objWrapper.QVDQ4Rs2PerLiter = 0.0;
        objWrapper.QVDQ4Rs4PerLiter = 0.0;
        objWrapper.QVDQ4Rs6PerLiter = 0.0;
        
        objWrapper.CurrentYearQ1Sales = 0.0;
        objWrapper.CurrentYearQ2Sales = 0.0;
        objWrapper.CurrentYearQ3Sales = 0.0;
        objWrapper.CurrentYearQ4Sales = 0.0;
        objWrapper.CurrentYearTotalSales = 0.0;     
        
        objWrapper.CurrentYearTotalSalesRs1PerLiter = 0.0;
        objWrapper.CurrentYearTotalSalesRs2PerLiter = 0.0;
        objWrapper.CurrentYearTotalSalesRs4PerLiter = 0.0;
        objWrapper.CurrentYearTotalSalesRs6PerLiter = 0.0;
        
        objWrapper.growthSlab1Label = '';
        objWrapper.growthSlab2Label = '';
        objWrapper.growthSlab3Label = '';
        objWrapper.growthSlab4Label = '';
        objWrapper.incentiveSlab1QVDLabel = '';
        objWrapper.incentiveSlab2QVDLabel = '';
        objWrapper.incentiveSlab3QVDLabel = '';
        objWrapper.incentiveSlab4QVDLabel = '';
        
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
        
        if((strBlisGroupID != NULL || strBranchID != NULL) && strConfig != NULL)
        {
            string strCurrentFYear = VCPL_AVDQVDCommon.getCurrentFinancialYear();
            string strprevsFYear = string.valueOf(integer.valueOf(strConfig)-1); 
            
            list<VCPL_AVD_QVD__c> lstConfig = [select id,VCPL_Growth_Slab_1_In_Percentage__c,VCPL_Fiscal_Year__c,
                                                VCPL_Growth_Slab_2_In_Percentage__c,VCPL_Growth_Slab_3_In_Percentage__c,
                                                VCPL_Growth_Slab_4_In_Percentage__c,VCPL_Incentive_Slab_1_AVD_In_R_L__c,
                                                VCPL_Incentive_Slab_1_QVD_In_R_L__c,VCPL_Incentive_Slab_2_AVD_In_R_L__c,
                                                VCPL_Incentive_Slab_2_QVD_In_R_L__c,VCPL_Incentive_Slab_3_AVD_In_R_L__c,
                                                VCPL_Incentive_Slab_3_QVD_In_R_L__c,VCPL_Incentive_Slab_4_AVD_In_R_L__c,
                                                VCPL_Incentive_Slab_4_QVD_In_R_L__c from VCPL_AVD_QVD__c where 
                                                VCPL_Fiscal_Year__c=:strConfig and recordTypeID=:blissRecordTypeID];
            
            if(lstConfig != NULL && !lstConfig.isEmpty())
            {
                objWrapper.growthSlab1Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c)+'% - '+string.valueof(Double.valueof(lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c)-0.01)+'%';
                objWrapper.growthSlab2Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c)+'% - '+string.valueof(Double.valueof(lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c)-0.01)+'%';
                objWrapper.growthSlab3Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c)+'% - '+string.valueof(Double.valueof(lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c)-0.01)+'%';
                objWrapper.growthSlab4Label = string.valueof(lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c)+'% AND ABOVE';
                objWrapper.incentiveSlab1QVDLabel = 'RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_1_QVD_In_R_L__c)+'/L';
                objWrapper.incentiveSlab2QVDLabel = 'RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_2_QVD_In_R_L__c)+'/L';
                objWrapper.incentiveSlab3QVDLabel = 'RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_3_QVD_In_R_L__c)+'/L';
                objWrapper.incentiveSlab4QVDLabel = 'RS '+string.valueof(lstConfig[0].VCPL_Incentive_Slab_4_QVD_In_R_L__c)+'/L';
                
                set<Id> setBranchID = new set<Id>();
                
                if(strBranchID == NULL)
                {
                    for(VCPL_Group_Branch__c objGroupBranch : [select id,VCPL_BLIS_Group__c,VCPL_Branch__c from VCPL_Group_Branch__c
                                                                where VCPL_BLIS_Group__c=:strBlisGroupID and VCPL_Branch__c != NULL])
                    {
                        setBranchID.add(objGroupBranch.VCPL_Branch__c); 
                    }
                }
                else
                {
                    setBranchID.add(strBranchID);
                }
                if(setBranchID != NULL && !setBranchID.isEmpty())
                {
                    map<string,Double> mapofCurrentYearSecondarySales= new map<string,Double>();
                    Double currentYearSecondarySales;
                    Double prevsYearSecondarySales;
                    map<string,Double> mapofPrevsYearSecondarySales = new map<string,Double>();
                    for(VCPL_Secondary_Sales__c objSecondarySales : [select id,VCPL_Invoice_Date__c,RecordTypeID,
                                                                VCPL_CO_Sales__c,VCPL_Financial_Year__c,
                                                                VCPL_Quarter__c,VCPL_Branch_Customer__c,
                                                                VCPL_Branch_Customer__r.VCPL_Customer_Account__c  from 
                                                                VCPL_Secondary_Sales__c 
                                                                where VCPL_Financial_Year__c != NULL
                                                                and VCPL_Quarter__c != NULL 
                                                                and VCPL_CO_Sales__c != NULL and 
                                                                VCPL_Branch_Customer__r.VCPL_Customer_Account__c in:setBranchID 
                                                                and recordTypeID=:secondarySalesRecordTypeID])
                    {
                        if(objSecondarySales.VCPL_Financial_Year__c == strConfig)
                        {
                            if(!mapofCurrentYearSecondarySales.ContainsKey(objSecondarySales.VCPL_Quarter__c))
                            {
                                mapofCurrentYearSecondarySales.put(objSecondarySales.VCPL_Quarter__c,objSecondarySales.VCPL_CO_Sales__c);
                            }
                            else
                            {
                                currentYearSecondarySales = 0;
                                currentYearSecondarySales = mapofCurrentYearSecondarySales.get(objSecondarySales.VCPL_Quarter__c);
                                currentYearSecondarySales += objSecondarySales.VCPL_CO_Sales__c;
                                mapofCurrentYearSecondarySales.put(objSecondarySales.VCPL_Quarter__c,currentYearSecondarySales);
                            }
                        }
                        if(objSecondarySales.VCPL_Financial_Year__c == strprevsFYear)
                        {
                            if(!mapofPrevsYearSecondarySales.containsKey(objSecondarySales.VCPL_Quarter__c))
                            {
                                mapofPrevsYearSecondarySales.put(objSecondarySales.VCPL_Quarter__c,objSecondarySales.VCPL_CO_Sales__c);
                            }
                            else
                            {
                                prevsYearSecondarySales = 0;
                                prevsYearSecondarySales = mapofPrevsYearSecondarySales.get(objSecondarySales.VCPL_Quarter__c);
                                prevsYearSecondarySales +=  objSecondarySales.VCPL_CO_Sales__c;
                                mapofPrevsYearSecondarySales.put(objSecondarySales.VCPL_Quarter__c,prevsYearSecondarySales);
                            }
                        }
                    }
                    if(mapofPrevsYearSecondarySales != NULL && !mapofPrevsYearSecondarySales.isEmpty())
                    {
                        if(mapofPrevsYearSecondarySales.containskey('Q1') && mapofPrevsYearSecondarySales.get('Q1') != NULL)
                        {
                            objWrapper.lastYearQ1Sales = mapofPrevsYearSecondarySales.get('Q1');
                            
                            if(objWrapper.lastYearQ1Sales > 0)
                            {
                                objWrapper.lastYearQ1Sales1Percent = objWrapper.lastYearQ1Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ1Sales4Percent = objWrapper.lastYearQ1Sales *((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ1Sales7Percent = objWrapper.lastYearQ1Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ1Sales10Percent = objWrapper.lastYearQ1Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
                                
                                objWrapper.lastYearTotalSales += objWrapper.lastYearQ1Sales;
                                
                                objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ1Sales1Percent;
                                objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ1Sales4Percent;
                                objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ1Sales7Percent;
                                objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ1Sales10Percent;     
                            }
                        }
                        if(mapofPrevsYearSecondarySales.containskey('Q2') && mapofPrevsYearSecondarySales.get('Q2') != NULL)
                        {
                            objWrapper.lastYearQ2Sales = mapofPrevsYearSecondarySales.get('Q2');
                            
                            if(objWrapper.lastYearQ2Sales > 0)
                            {
                                objWrapper.lastYearQ2Sales1Percent = objWrapper.lastYearQ2Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ2Sales4Percent = objWrapper.lastYearQ2Sales * ((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ2Sales7Percent = objWrapper.lastYearQ2Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ2Sales10Percent = objWrapper.lastYearQ2Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
                                
                                objWrapper.lastYearTotalSales += objWrapper.lastYearQ2Sales;
                                
                                objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ2Sales1Percent;
                                objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ2Sales4Percent;
                                objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ2Sales7Percent;
                                objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ2Sales10Percent;
                            }
                        }
                        if(mapofPrevsYearSecondarySales.containsKey('Q3') && mapofPrevsYearSecondarySales.get('Q3') != NULL)
                        {
                            objWrapper.lastYearQ3Sales = mapofPrevsYearSecondarySales.get('Q3');
                                    
                            if(objWrapper.lastYearQ3Sales > 0)
                            {
                                objWrapper.lastYearQ3Sales1Percent = objWrapper.lastYearQ3Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ3Sales4Percent = objWrapper.lastYearQ3Sales * ((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ3Sales7Percent = objWrapper.lastYearQ3Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ3Sales10Percent = objWrapper.lastYearQ3Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
                                
                                objWrapper.lastYearTotalSales += objWrapper.lastYearQ3Sales;
                                
                                objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ3Sales1Percent;
                                objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ3Sales4Percent;
                                objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ3Sales7Percent;
                                objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ3Sales10Percent;
                            }
                        }
                        if(mapofPrevsYearSecondarySales.containsKey('Q4') && mapofPrevsYearSecondarySales.get('Q4') != NULL)
                        {
                            objWrapper.lastYearQ4Sales = mapofPrevsYearSecondarySales.get('Q4');
                                    
                            if(objWrapper.lastYearQ4Sales > 0)
                            {
                                objWrapper.lastYearQ4Sales1Percent = objWrapper.lastYearQ4Sales*((lstConfig[0].VCPL_Growth_Slab_1_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ4Sales4Percent = objWrapper.lastYearQ4Sales * ((lstConfig[0].VCPL_Growth_Slab_2_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ4Sales7Percent = objWrapper.lastYearQ4Sales*((lstConfig[0].VCPL_Growth_Slab_3_In_Percentage__c/100)+1);
                                objWrapper.lastYearQ4Sales10Percent = objWrapper.lastYearQ4Sales*((lstConfig[0].VCPL_Growth_Slab_4_In_Percentage__c/100)+1);
                                
                                objWrapper.lastYearTotalSales += objWrapper.lastYearQ4Sales;
                                
                                objWrapper.lastYearTotalSales1Percent += objWrapper.lastYearQ4Sales1Percent;
                                objWrapper.lastYearTotalSales4Percent  += objWrapper.lastYearQ4Sales4Percent;
                                objWrapper.lastYearTotalSales7Percent  += objWrapper.lastYearQ4Sales7Percent;
                                objWrapper.lastYearTotalSales10Percent  += objWrapper.lastYearQ4Sales10Percent;
                            }
                        }
                    }
                    if(mapofCurrentYearSecondarySales != NULL && !mapofCurrentYearSecondarySales.isEmpty())
                    {
                        if(mapofCurrentYearSecondarySales.containsKey('Q1') && mapofCurrentYearSecondarySales.get('Q1') != NULL)
                        {
                            objWrapper.CurrentYearQ1Sales = mapofCurrentYearSecondarySales.get('Q1');
                            objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ1Sales;
                            objWrapper.Q1ClosedSales = mapofCurrentYearSecondarySales.get('Q1');
                            
                            if(objWrapper.CurrentYearQ1Sales > 0)
                            {
                                objWrapper.QVDQ1Rs1PerLiter = objWrapper.lastYearQ1Sales1Percent-objWrapper.CurrentYearQ1Sales;
                                objWrapper.QVDQ1Rs2PerLiter = objWrapper.lastYearQ1Sales4Percent-objWrapper.CurrentYearQ1Sales;
                                objWrapper.QVDQ1Rs4PerLiter = objWrapper.lastYearQ1Sales7Percent-objWrapper.CurrentYearQ1Sales;
                                objWrapper.QVDQ1Rs6PerLiter = objWrapper.lastYearQ1Sales10Percent-objWrapper.CurrentYearQ1Sales;
                            }
                        }
                        if(mapofCurrentYearSecondarySales.containsKey('Q2') && mapofCurrentYearSecondarySales.get('Q2') != NULL)
                        {
                            objWrapper.CurrentYearQ2Sales = mapofCurrentYearSecondarySales.get('Q2');
                            objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ2Sales;
                            objWrapper.Q2ClosedSales = mapofCurrentYearSecondarySales.get('Q2');
                            
                            if(objWrapper.CurrentYearQ2Sales > 0)
                            {
                                objWrapper.QVDQ2Rs1PerLiter = objWrapper.lastYearQ2Sales1Percent-objWrapper.CurrentYearQ2Sales;
                                objWrapper.QVDQ2Rs2PerLiter = objWrapper.lastYearQ2Sales4Percent-objWrapper.CurrentYearQ2Sales;
                                objWrapper.QVDQ2Rs4PerLiter = objWrapper.lastYearQ2Sales7Percent-objWrapper.CurrentYearQ2Sales;
                                objWrapper.QVDQ2Rs6PerLiter = objWrapper.lastYearQ2Sales10Percent-objWrapper.CurrentYearQ2Sales;
                            }
                        }
                        if(mapofCurrentYearSecondarySales.containsKey('Q3') && mapofCurrentYearSecondarySales.get('Q3') != NULL)
                        {
                            objWrapper.CurrentYearQ3Sales = mapofCurrentYearSecondarySales.get('Q3');
                            objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ3Sales;
                            objWrapper.Q3ClosedSales = mapofCurrentYearSecondarySales.get('Q3');
                            
                            if(objWrapper.CurrentYearQ3Sales > 0)
                            {
                                objWrapper.QVDQ3Rs1PerLiter = objWrapper.lastYearQ3Sales1Percent-objWrapper.CurrentYearQ3Sales;
                                objWrapper.QVDQ3Rs2PerLiter = objWrapper.lastYearQ3Sales4Percent-objWrapper.CurrentYearQ3Sales;
                                objWrapper.QVDQ3Rs4PerLiter = objWrapper.lastYearQ3Sales7Percent-objWrapper.CurrentYearQ3Sales;
                                objWrapper.QVDQ3Rs6PerLiter = objWrapper.lastYearQ3Sales10Percent-objWrapper.CurrentYearQ3Sales;
                            }
                        }
                        if(mapofCurrentYearSecondarySales.containsKey('Q4') && mapofCurrentYearSecondarySales.get('Q4') != NULL)
                        {
                            objWrapper.CurrentYearQ4Sales = mapofCurrentYearSecondarySales.get('Q4');
                            objWrapper.CurrentYearTotalSales += objWrapper.CurrentYearQ4Sales;
                            objWrapper.Q4ClosedSales = mapofCurrentYearSecondarySales.get('Q4');
                            if(objWrapper.CurrentYearQ4Sales > 0)
                            {
                                objWrapper.QVDQ4Rs1PerLiter = objWrapper.lastYearQ4Sales1Percent-objWrapper.CurrentYearQ4Sales;
                                objWrapper.QVDQ4Rs2PerLiter = objWrapper.lastYearQ4Sales4Percent-objWrapper.CurrentYearQ4Sales;
                                objWrapper.QVDQ4Rs4PerLiter = objWrapper.lastYearQ4Sales7Percent-objWrapper.CurrentYearQ4Sales;
                                objWrapper.QVDQ4Rs6PerLiter = objWrapper.lastYearQ4Sales10Percent-objWrapper.CurrentYearQ4Sales;
                            }
                        }
                        objWrapper.CurrentYearTotalSalesRs1PerLiter = objWrapper.QVDQ1Rs1PerLiter+
                                                                    objWrapper.QVDQ2Rs1PerLiter+
                                                                    objWrapper.QVDQ3Rs1PerLiter+
                                                                    objWrapper.QVDQ4Rs1PerLiter;
                        objWrapper.CurrentYearTotalSalesRs2PerLiter = objWrapper.QVDQ1Rs2PerLiter+objWrapper.QVDQ2Rs2PerLiter+objWrapper.QVDQ3Rs2PerLiter+objWrapper.QVDQ4Rs2PerLiter;
                        objWrapper.CurrentYearTotalSalesRs4PerLiter = objWrapper.QVDQ1Rs4PerLiter+objWrapper.QVDQ2Rs4PerLiter+objWrapper.QVDQ3Rs4PerLiter+objWrapper.QVDQ4Rs4PerLiter;
                        objWrapper.CurrentYearTotalSalesRs6PerLiter = objWrapper.QVDQ1Rs6PerLiter+objWrapper.QVDQ2Rs6PerLiter+objWrapper.QVDQ3Rs6PerLiter+objWrapper.QVDQ4Rs6PerLiter;
                    }
                    if(integer.valueof(strCurrentFYear) >= integer.valueof(strConfig))
                    {
                        map<Integer,string> mapofCurrentQuarter = VCPL_AVDQVDCommon.getMonthQuarter();
                        string CurrentQuarter = mapofCurrentQuarter.get(system.today().month());
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
                        objWrapper.totalIncentive = objWrapper.Q1Incentive+objWrapper.Q2Incentive+objWrapper.Q3Incentive+objWrapper.Q4Incentive;
                
                    }
                }
            }
        }
        
        return objWrapper;
    }
    
}