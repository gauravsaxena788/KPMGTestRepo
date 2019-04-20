//==========================================================================
//Description: Controller For Target Assignment Lightning Component
//==========================================================================
public without sharing class VCPL_TargetAssignmentController 
{
    final static Id cdBranchRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    final static Id blissRecordTypeID = Schema.SObjectType.VCPL_AVD_QVD__c.getRecordTypeInfosByName().get('BLIS').getRecordTypeId();
    final static Id secondarySalFesRecordTypeID = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get('CD Secondary Sales').getRecordTypeId();
    final static Id cdCustomerID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
    final static string strCurrentFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    final static string strPrevsFinancialYear = string.valueof(integer.valueof(strCurrentFinancialYear)-1);
    final static Id branchCPRTID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
    final static Id dealerCPRTID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Dealer Customer').getRecordTypeId();
    public static map<id,list<Account>> mapofAccounts = new map<id,list<Account>>();
    
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
    //==============================================================================================
    //Description: This Method is Used to get all ELP's/Branch head List for the selected Branch
    //==============================================================================================
    @AuraEnabled
    public static list<Contact> getELPBranchHeads(string strAccountID)
    {
        list<Contact> lstContact = new list<Contact>();
        if(strAccountID != NULL && strAccountID !='')
        {
            lstcontact = [select id,name,AccountID from Contact where AccountID=:strAccountID];
            
            list<VCPL_ELP_Assignment__c> lstELPAssignments = [select id,VCPL_Branch__c,VCPL_User__c,VCPL_isActive__c,VCPL_User__r.ContactId from 
                                                              VCPL_ELP_Assignment__c where VCPL_Branch__c =:strAccountID 
                                                              and VCPL_isActive__c=true 
                                                              and VCPL_User__r.ContactId != NULL];
            
            if(lstELPAssignments != NULL && !lstELPAssignments.isEmpty())
            {
                set<ID> setContactId = new set<ID>();
                for(VCPL_ELP_Assignment__c objAssignment : lstELPAssignments)
                {
                    setContactId.add(objAssignment.VCPL_User__r.ContactId); 
                }
                if(setContactId != NULL && !setContactId.isEmpty())
                {
                    for(Contact objContact : [select id,name,AccountID from Contact where id in:setContactId])
                    {
                        lstcontact.add(objContact);
                    }
                }
            }
        }
        if(lstcontact != NULL && !lstcontact.isEmpty())
        {
            map<id,Contact> conmap = new map<id,Contact>();
            
            conmap.putall(lstcontact);
            
            if(conmap.size()>0)
            {
                return conmap.values();
            }
            else
            {
                return NULL;
            }
        }
        else
        {
            return NULL;
        }
    }
    public class DataWrapper
    {
        @AuraEnabled public string strAccountName;
        @AuraEnabled public Account objCdAccount;
        @AuraEnabled public Double lastYearVolume;
        @AuraEnabled public Double potential;
        @AuraEnabled public Double potentialLYDifference;
        @AuraEnabled public string strAssignmentClassification;
        @AuraEnabled public string assignedToID;
        @AuraEnabled public string assignedToName;
        @AuraEnabled public boolean isGroupedParent;
        @AuraEnabled public list<Contact> lstContacts;
        @AuraEnabled public Account branchAccount;
        @AuraEnabled public boolean childExists;
    }
    //==============================================================================================
    //Description: This Method is Used to get Dealer Account ID as per logged in User
    //==============================================================================================
    @AuraEnabled
    public static string getParentAccount()
    {
        Id userId = userinfo.getuserId();
        String returndelaerId ;
        list<User> lstUser = [select id,ProfileID,Profile.Name,AccountID, VCPL_Contact_Role__c , Account.ParentId from User where id=:userID and 
                              AccountID != NULL];
        system.debug('====lstUser====='+lstUser);
        if(lstuser != NULL && !lstuser.isEmpty())
        {
            list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
                                                                VCPL_CD_ELP_Profile_Name__c,VCPL_CD_BH_Contact_Role_Name__c,
                                                                VCPL_CD_ELP_Contact_Role_Name__c,VCPL_CD_HOD_Contact_Role_Name__c,VCPL_CD_HOD_Profile_Name__c 
                                                                from VCPL_System_Configuration__mdt where DeveloperName='VCPL_System_Configuration'];
            
            if(lstuser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Contact_Role_Name__c) || 
               lstuser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_ELP_Contact_Role_Name__c))
            {
                returndelaerId = lstuser[0].AccountId;
            }
            else if(lstuser[0].VCPL_Contact_Role__c.equalsIgnoreCase(lstMetaData[0].VCPL_CD_BH_Contact_Role_Name__c))
                returndelaerId = lstuser[0].Account.ParentId;
        }
        return returndelaerId;
    }
    //===========================================================================================================
    //Description: This Method is Used to get list of Customer Accounts for which Assignment has to be done . 
    //===========================================================================================================
    @AuraEnabled
    public static list<Account> getCustomers(string parentID)
    {
        list<Account> lstCustAccount = new list<Account>();
        
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
                system.debug('@@@@'+objDCM.VCPL_Customer_Account__c+'@@@@@@'+objDCM.Id);
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
                set<id> setParentID = new set<Id>();
                for(Account objCA : [select id,name,recordTypeID,parentID,
                                     VCPL_Isgroupbyparent__c,Is_Parent__c,VCPL_Current_Fin_Year_Total_Potential__c from Account 
                                     where recordTypeID=:cdCustomerID and id in:setofIDs and VCPL_Isgroupbyparent__c=false order by name])
                {
                    system.debug('@@@@objCA'+objCA.Id);
                    if(objCA.ParentID == NULL && objCA.Is_Parent__c=='Y')
                    {
                        lstCustAccount.add(objCA);
                    }
                    else
                    {
                        setParentID.add(objCA.ParentID);
                    }
                }
                if(setParentID != NULL && !setParentID.isEmpty())
                {
                    for(Account objParentCA : [select id,name,recordTypeID,parentID,
                                                 VCPL_Isgroupbyparent__c,Is_Parent__c,VCPL_Current_Fin_Year_Total_Potential__c from Account 
                                                 where recordTypeID=:cdCustomerID and id in:setParentID and VCPL_Isgroupbyparent__c=true order by name ])
                     {
                        lstCustAccount.add(objParentCA);    
                     }
                }
            }
        }
        if(lstCustAccount != NULL && !lstCustAccount.isEmpty())
        {
            return lstCustAccount;
        }
        else
        {
            return NULL;
        }
    }
    //===========================================================================================================
    //Description: This Method is Used to create wrapper Data for the component.  
    //===========================================================================================================
    //Code Changed on 18-9-18 due to parent child introduction
    //============================================================================================================
    @AuraEnabled
    public static list<DataWrapper> getData(string strBranchID,string parentID)
    {
        list<DataWrapper> lstWrapper = new list<DataWrapper>();
        
        if(strBranchID != NULL && strBranchID != '')
        {
            map<Id,Account> mapofBranch = new map<id,Account>();
            for(Account objAccount : [select id,name,VCPL_BC_Auto_Number__c  
                                      from Account where ID =:strBranchID])
            {
                if(!mapofBranch.containsKey(objAccount.id))
                    mapofBranch.put(objAccount.id,objAccount);
            }
            list<Contact> lstContacts =  getELPBranchHeads(strBranchID);
            list<Account> lstCutomerAccounts = new list<Account>();
            if(parentID == NULL)
            {
                lstCutomerAccounts = getCustomers(getParentAccount());
            }
            else
            {
                lstCutomerAccounts = getCustomers(parentID);
            }
            if(lstCutomerAccounts != NULL && !lstCutomerAccounts.isEmpty())
            {
                set<ID> setofGroupedParentAccountID = new set<ID>();
                set<Id> setofParentAccountID = new set<Id>();
                Id parentAccountID = getParentAccount();
                for(Account objAccount : lstCutomerAccounts)
                {
                    if(objAccount.VCPL_Isgroupbyparent__c)
                    {
                        setofGroupedParentAccountID.add(objAccount.Id);
                    }
                    else if(!objAccount.VCPL_Isgroupbyparent__c && objAccount.Is_Parent__c == 'Y')
                    {
                        setofParentAccountID.add(objAccount.Id);
                    }
                }
                
                map<string,list<VCPL_Customer_Plan__c>> mapofGroupedCustomerPlan = new map<string,list<VCPL_Customer_Plan__c>>();
                if(setofGroupedParentAccountID != NULL && !setofGroupedParentAccountID.isEmpty())
                {
                    string strCP;
                    for(VCPL_Customer_Plan__c objGrouped : [select id,VCPL_Financial_Year__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.ParentID,
                                                            VCPL_Last_Year_Sales_Vol__c,VCPL_Actual_Sales__c,RecordTypeID,
                                                            VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_Customer_Account__r.parentID,VCPL_Dealer_Account__c,
                                                            VCPL_Potential__c,VCPL_Branch__c,VCPL_Assignment_Classification__c,VCPL_ELP_Branch_Head__c,
                                                            VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
                                                            VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c   
                                                            from VCPL_Customer_Plan__c where (VCPL_Financial_Year__c=:strPrevsFinancialYear or 
                                                            VCPL_Financial_Year__c=:strCurrentFinancialYear) and VCPL_CD_Customer__r.ParentID in:setofGroupedParentAccountID 
                                                            and VCPL_Customer_Account__c =: strBranchID])
                    {
                        strCP = '';
                        strCP = objGrouped.VCPL_Financial_Year__c+'-'+objGrouped.VCPL_CD_Customer__r.ParentID+'-'+objGrouped.VCPL_Customer_Account__r.parentID+'-'+objGrouped.VCPL_Customer_Account__c;

                        if(!mapofGroupedCustomerPlan.containsKey(strCP))
                            mapofGroupedCustomerPlan.put(strCP,new list<VCPL_Customer_Plan__c>());
                        mapofGroupedCustomerPlan.get(strCP).add(objGrouped);        
                    }
                }
                map<string,VCPL_Customer_Plan__c> mapofParentCustomerPlan = new map<string,VCPL_Customer_Plan__c>();
                if(setofParentAccountID != NULL && !setofParentAccountID.isEmpty())
                {
                    string strCP;
                    for(VCPL_Customer_Plan__c objParent : [select id,VCPL_Financial_Year__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.ParentID,
                                                           VCPL_Last_Year_Sales_Vol__c,VCPL_Actual_Sales__c,RecordTypeID,
                                                           VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_Customer_Account__r.parentID,VCPL_Dealer_Account__c,
                                                           VCPL_Potential__c,VCPL_Branch__c,VCPL_Assignment_Classification__c,VCPL_ELP_Branch_Head__c,
                                                           VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
                                                           VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c   
                                                           from VCPL_Customer_Plan__c where (VCPL_Financial_Year__c=:strPrevsFinancialYear or 
                                                           VCPL_Financial_Year__c=:strCurrentFinancialYear) and VCPL_CD_Customer__c in:setofParentAccountID 
                                                           and VCPL_Customer_Account__c =: strBranchID ])
                    {
                        strCP = '';
                        strCP = objParent.VCPL_Financial_Year__c+'-'+objParent.VCPL_CD_Customer__c+'-'+objParent.VCPL_Customer_Account__r.parentID+'-'+objParent.VCPL_Customer_Account__c;
                        
                        if(!mapofParentCustomerPlan.containsKey(strCP))
                            mapofParentCustomerPlan.put(strCP,objParent);
                    }
                }
                if(parentID != NULL)
                {
                    parentAccountID = parentID;
                }
                string strAccKey;
                string strPrevsYearAccKey;
                Double potentialDiff;
                Double lypotential;
                Double lyIOSales;
                Double lyCOSales;
                
                for(Account objAccount : lstCutomerAccounts)
                {
                    strAccKey ='';
                    strPrevsYearAccKey ='';
                    potentialDiff =0;
                    lypotential =0;
                    lyIOSales =0;
                    lyCOSales=0;
                    
                    dataWrapper objWrapper = new dataWrapper();
                    objWrapper.strAccountName = objAccount.Name;
                    objWrapper.lastYearVolume = 0;
                    objWrapper.potential = 0;
                    objWrapper.potentialLYDifference =0;
                    objWrapper.strAssignmentClassification = 'Others';
                    objWrapper.assignedToID = '';
                    objWrapper.assignedToName = '';
                    objWrapper.lstContacts = lstContacts;
                    objWrapper.branchAccount = mapofBranch.get(strBranchID);
                    objWrapper.childExists = false;
                    objWrapper.objCdAccount = objAccount;
                    
                    if(objAccount.VCPL_Isgroupbyparent__c)
                    {
                        objWrapper.isGroupedParent = true;
                        
                        strAccKey = strCurrentFinancialYear+'-'+objAccount.Id+'-'+parentAccountID+'-'+strBranchID;
                        strPrevsYearAccKey = strPrevsFinancialYear+'-'+objAccount.Id+'-'+parentAccountID+'-'+strBranchID;

                        if(mapofGroupedCustomerPlan.containsKey(strAccKey) && mapofGroupedCustomerPlan.get(strAccKey) != NULL)
                        {
                            objWrapper.strAssignmentClassification = mapofGroupedCustomerPlan.get(strAccKey)[0].VCPL_Assignment_Classification__c;
                            objWrapper.assignedToID = mapofGroupedCustomerPlan.get(strAccKey)[0].VCPL_ELP_Branch_Head__c;
                            objWrapper.assignedToName = mapofGroupedCustomerPlan.get(strAcckey)[0].VCPL_ELP_Branch_Head__r.Name;
                            
                            if(mapofGroupedCustomerPlan.get(strAcckey).size()>0)
                            {
                                objWrapper.childExists = true;
                            }
                            /*for(VCPL_Customer_Plan__c objCP : mapofGroupedCustomerPlan.get(strAccKey))
                            {
                                lyIOSales += objCP.VCPL_Last_Year_IO_Sales_Volume__c != NULL?objCP.VCPL_Last_Year_IO_Sales_Volume__c:0;
                                lyCOSales += objCP.VCPL_Last_Year_CO_Sales_Volume__c != NULL?objCP.VCPL_Last_Year_CO_Sales_Volume__c:0;
                            }*/
                        }
                        if(mapofGroupedCustomerPlan.containsKey(strPrevsYearAccKey) && mapofGroupedCustomerPlan.get(strPrevsYearAccKey) != NULL)
                        {
                            for(VCPL_Customer_Plan__c objCP : mapofGroupedCustomerPlan.get(strPrevsYearAccKey))
                            {
                                lypotential += objCP.VCPL_Potential__c != NULL?objCP.VCPL_Potential__c:0;
                                lyIOSales += objCP.VCPL_Branch_IO_Sales__c != NULL?objCP.VCPL_Branch_IO_Sales__c:0;
                                lyCOSales += objCP.VCPL_Branch_CO_Sales__c != NULL?objCP.VCPL_Branch_CO_Sales__c:0;
                            }
                        }
                        //objWrapper.lastYearVolume = lyIOSales+lyCOSales;
                        objWrapper.lastYearVolume = lyCOSales;
                        objWrapper.potential = lypotential;
                        objWrapper.potentialLYDifference = lypotential - objWrapper.lastYearVolume;
                    }
                    else if(!objAccount.VCPL_Isgroupbyparent__c && objAccount.Is_Parent__c == 'Y')
                    {
                        objWrapper.isGroupedParent = false;
                        
                        strAccKey = strCurrentFinancialYear+'-'+objAccount.Id+'-'+parentAccountID+'-'+strBranchID;
                        strPrevsYearAccKey = strPrevsFinancialYear+'-'+objAccount.Id+'-'+parentAccountID+'-'+strBranchID;
                        
                        if(mapofParentCustomerPlan.containsKey(strAccKey) && mapofParentCustomerPlan.get(strAccKey) != NULL)
                        {
                            objWrapper.strAssignmentClassification = mapofParentCustomerPlan.get(strAccKey).VCPL_Assignment_Classification__c;
                            objWrapper.assignedToID = mapofParentCustomerPlan.get(strAccKey).VCPL_ELP_Branch_Head__c;
                            objWrapper.assignedToName = mapofParentCustomerPlan.get(strAcckey).VCPL_ELP_Branch_Head__r.Name;
                            
                            if(mapofParentCustomerPlan.containsKey(strPrevsYearAccKey) != NULL && mapofParentCustomerPlan.get(strPrevsYearAccKey) != NULL)
                            {       
                            	lyIOSales = mapofParentCustomerPlan.get(strPrevsYearAccKey).VCPL_Branch_IO_Sales__c != NULL?
                                mapofParentCustomerPlan.get(strPrevsYearAccKey).VCPL_Branch_IO_Sales__c:0;
                            
                            	lyCOSales = mapofParentCustomerPlan.get(strPrevsYearAccKey).VCPL_Branch_CO_Sales__c != NULL?
                                mapofParentCustomerPlan.get(strPrevsYearAccKey).VCPL_Branch_CO_Sales__c:0;
                        	}
                            if(mapofParentCustomerPlan.get(strPrevsYearAccKey) != NULL && mapofParentCustomerPlan.get(strPrevsYearAccKey) != NULL)
                            {
                                lypotential = mapofParentCustomerPlan.get(strPrevsYearAccKey).VCPL_Potential__c != NULL?
                                    mapofParentCustomerPlan.get(strPrevsYearAccKey).VCPL_Potential__c:0;
                            }
                            //objWrapper.lastYearVolume = lyIOSales+lyCOSales;
                            objWrapper.lastYearVolume = lyCOSales;
                            objWrapper.potential = lypotential;
                            objWrapper.potentialLYDifference = lypotential - objWrapper.lastYearVolume;
                        }
                    }
                    lstWrapper.add(objWrapper);
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
        string strStatus;
        
        if(strResponse != NULL)
        {
            strStatus = 'Initiate';
            list<VCPL_Customer_Plan__c> lstCP = new list<VCPL_Customer_Plan__c>();
            list<dataWrapper> lstDataWrapper =  (List<dataWrapper>)JSON.deserialize(strResponse,List<dataWrapper>.class);
            strStatus = 'parsed';
            
            if(lstDataWrapper != NULL && !lstDataWrapper.isEmpty())
            {
                set<Id> setCustomerId = new set<Id>(); 
                set<Id> setBranchId = new set<Id>();
                set<ID> setofAccountID = new set<Id>();
                
                for(dataWrapper objWrapper : lstDataWrapper)
                {
                    if(objWrapper.isGroupedParent)
                    {
                        setofAccountID.add(objWrapper.objCdAccount.Id);
                    }
                }
                if(setofAccountID != NULL && !setofAccountID.isEmpty())
                {
                    for(Account objChildAccount : [select id,name,ParentId,VCPL_Isgroupbyparent__c,Is_Parent__c,VCPL_Current_Fin_Year_Total_Potential__c
                                                     from Account 
                                                   where recordTypeID=:cdCustomerID and ParentId in:setofAccountID])
                    {
                        if(!mapofAccounts.containsKey(objChildAccount.ParentId))
                            mapofAccounts.put(objChildAccount.ParentId,new list<Account>());
                        mapofAccounts.get(objChildAccount.ParentId).add(objChildAccount);           
                    }
                }
                for(dataWrapper objWrapper : lstDataWrapper)
                {
                    if(objWrapper.isGroupedParent)
                    {
                        if(mapofAccounts.containsKey(objWrapper.objCdAccount.Id) && mapofAccounts.get(objWrapper.objCdAccount.Id) != NULL)
                        {
                            for(Account objChildCDAccount : mapofAccounts.get(objWrapper.objCdAccount.Id))
                            {
                                setCustomerId.add(objChildCDAccount.Id);//Adding all Child Customer Accounts
                            }
                        }
                    }
                    else
                    {
                        setCustomerId.add(objWrapper.objCdAccount.Id);//Adding the Cd Account not having parent
                    }
                    if(objWrapper.branchAccount.Id != NULL)
                    {
                        setBranchId.add(objWrapper.branchAccount.Id);
                    }
                }
                if(setCustomerId != NULL && !setCustomerId.isEmpty() &&  setBranchId != Null && !setBranchId.isEmpty())
                {
                    strStatus = 'got all Child Accounts to be processed';
                    
                    string strKey;
                    
                    map<string,VCPL_Customer_Plan__c> mapofCP = new map<string,VCPL_Customer_Plan__c>();

                    for(VCPL_Customer_Plan__c objCP : [select id,VCPL_Financial_Year__c,VCPL_CD_Customer__c,VCPL_CD_Customer__r.ParentID,
                                                       VCPL_Last_Year_Sales_Vol__c,VCPL_Actual_Sales__c,RecordTypeID,
                                                       VCPL_Customer_Account__c,VCPL_Customer_Account__r.Name,VCPL_Customer_Account__r.parentID,
                                                       VCPL_Dealer_Account__c,VCPL_Potential__c,VCPL_Branch__c,VCPL_Assignment_Classification__c,
                                                       VCPL_ELP_Branch_Head__c,VCPL_Last_Year_CO_Sales_Volume__c,VCPL_Last_Year_IO_Sales_Volume__c,
                                                       VCPL_ELP_Branch_Head__r.Name,VCPL_Branch_IO_Sales__c,VCPL_Branch_CO_Sales__c   
                                                       from VCPL_Customer_Plan__c where VCPL_CD_Customer__c in:setCustomerId 
                                                       and VCPL_Customer_Account__c in:setBranchId and RecordTypeID=:branchCPRTID and 
                                                       (VCPL_Financial_Year__c=:strCurrentFinancialYear 
                                                        or VCPL_Financial_Year__c=:strPrevsFinancialYear)])
                    {
                        strKey = '';
                        strKey = objCP.VCPL_Financial_Year__c+'-'+objCP.VCPL_CD_Customer__c+'-'+objCP.VCPL_Customer_Account__c;

                        if(!mapofCP.containsKey(strKey))
                            mapofCP.put(strKey,objCP);
                    }
                    
                    string strAccKey;
                    string strPrevsAccKey;
                    for(dataWrapper objWrapper : lstDataWrapper)
                    {
                        if(!objWrapper.isGroupedParent)
                        {
                            strAccKey = '';
                            strPrevsAccKey = '';
                            strAccKey =  strCurrentFinancialYear+'-'+objWrapper.objCdAccount.Id+'-'+objWrapper.branchAccount.Id;
                            strPrevsAccKey = strPrevsFinancialYear+'-'+objWrapper.objCdAccount.Id+'-'+objWrapper.branchAccount.Id;

                            if(mapofCP.containsKey(strAccKey) && mapofCP.get(strAccKey) != NULL)
                            {
                                VCPL_Customer_Plan__c objExistingCP = new VCPL_Customer_Plan__c(Id = mapofCP.get(strAccKey).Id);
                                objExistingCP.VCPL_Assignment_Classification__c = objWrapper.strAssignmentClassification;
                                objExistingCP.VCPL_Is_Current_Financial_Year__c = true;

                                if(objWrapper.assignedToID != NULL && objWrapper.assignedToID != '' && objWrapper.assignedToID != 'NULL')
                                {
                                    objExistingCP.VCPL_ELP_Branch_Head__c = objWrapper.assignedToID;
                                }
                                else
                                {
                                    objExistingCP.VCPL_ELP_Branch_Head__c = null;
                                }
                                lstCP.add(objExistingCP);
                            }
                            else
                            {
                                VCPL_Customer_Plan__c objcp = new VCPL_Customer_Plan__c(VCPL_Customer_Account__c = objWrapper.branchAccount.Id,
                                                                                        VCPL_CD_Customer__c = objWrapper.objCdAccount.Id,
                                                                                        VCPL_Financial_Year__c = strCurrentFinancialYear,
                                                                                        name = strCurrentFinancialYear+'-'+objWrapper.objCdAccount.Name+'-'+
                                                                                        objWrapper.branchAccount.VCPL_BC_Auto_Number__c,
                                                                                        VCPL_Assignment_Classification__c = objWrapper.strAssignmentClassification
                                                                                       );
                                
                                objcp.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
                                objcp.VCPL_Is_Current_Financial_Year__c = true;
                                objcp.VCPL_Potential__c = objWrapper.objCdAccount.VCPL_Current_Fin_Year_Total_Potential__c != NULL?
                                                            objWrapper.objCdAccount.VCPL_Current_Fin_Year_Total_Potential__c:NULL;
                                if(objWrapper.assignedToID != NULL && objWrapper.assignedToID != '' && objWrapper.assignedToID != 'NULL')
                                {
                                    objcp.VCPL_ELP_Branch_Head__c = objWrapper.assignedToID;
                                }
                                else
                                {
                                    objcp.VCPL_ELP_Branch_Head__c = null;
                                }
                                if(mapofCP.containsKey(strPrevsAccKey) && mapofCP.get(strPrevsAccKey) != NULL)
                                {
                                    objcp.VCPL_Last_Year_IO_Sales_Volume__c = mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c != NULL?
                                        mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c:0;
                                    
                                    objcp.VCPL_Last_Year_CO_Sales_Volume__c = mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c != NULL?
                                        mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c:0;
                                    
                                    objcp.VCPL_Last_Year_Sales_Vol__c = objcp.VCPL_Last_Year_IO_Sales_Volume__c+objcp.VCPL_Last_Year_CO_Sales_Volume__c;
                                }
                                lstCP.add(objcp);
                            }
                        }
                        else
                        {
                            if(mapofAccounts.containsKey(objWrapper.objCdAccount.Id) && mapofAccounts.get(objWrapper.objCdAccount.Id) != NULL)
                            {
                                for(Account objAccount : mapofAccounts.get(objWrapper.objCdAccount.Id))
                                {
                                    strAccKey =  strCurrentFinancialYear+'-'+objAccount.Id+'-'+objWrapper.branchAccount.Id;
                                    strPrevsAccKey = strPrevsFinancialYear+'-'+objAccount.Id+'-'+objWrapper.branchAccount.Id;
                                    
                                    if(mapofCP.containsKey(strAccKey) && mapofCP.get(strAccKey) != NULL)
                                    {
                                        VCPL_Customer_Plan__c objExistingCP = new VCPL_Customer_Plan__c(Id = mapofCP.get(strAccKey).Id);
                                        objExistingCP.VCPL_Assignment_Classification__c = objWrapper.strAssignmentClassification;
                                        objExistingCP.VCPL_Is_Current_Financial_Year__c = true;
                                        objExistingCP.VCPL_Potential__c = objAccount.VCPL_Current_Fin_Year_Total_Potential__c != NULL?objAccount.VCPL_Current_Fin_Year_Total_Potential__c:0;
                                        if(objWrapper.assignedToID != NULL && objWrapper.assignedToID != '' && objWrapper.assignedToID != 'NULL')
                                        {
                                            objExistingCP.VCPL_ELP_Branch_Head__c = objWrapper.assignedToID;
                                        }
                                        else
                                        {
                                            objExistingCP.VCPL_ELP_Branch_Head__c = null;
                                        }
                                        lstCP.add(objExistingCP);
                                    }
                                    else
                                    {
                                        VCPL_Customer_Plan__c objcp = new VCPL_Customer_Plan__c(VCPL_Customer_Account__c = objWrapper.branchAccount.Id,
                                                                                                VCPL_CD_Customer__c = objAccount.Id,
                                                                                                VCPL_Financial_Year__c = strCurrentFinancialYear,
                                                                                                name = strCurrentFinancialYear+'-'+objAccount.Name+'-'+
                                                                                                objWrapper.branchAccount.VCPL_BC_Auto_Number__c,
                                                                                                VCPL_Last_Year_Sales_Vol__c=0,
                                                                                                VCPL_Last_Year_IO_Sales_Volume__c = 0,
                                                                                                VCPL_Last_Year_CO_Sales_Volume__c = 0,
                                                                                                VCPL_Potential__c = 0,
                                                                                                VCPL_Assignment_Classification__c = objWrapper.strAssignmentClassification
                                                                                               );
                                        
                                        objcp.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
                                        objcp.VCPL_Is_Current_Financial_Year__c = true;
                                        objcp.VCPL_Potential__c = objAccount.VCPL_Current_Fin_Year_Total_Potential__c != NULL?objAccount.VCPL_Current_Fin_Year_Total_Potential__c:0;
                                        if(objWrapper.assignedToID != NULL && objWrapper.assignedToID != '' && objWrapper.assignedToID != 'NULL')
                                        {
                                            objcp.VCPL_ELP_Branch_Head__c = objWrapper.assignedToID;
                                        }
                                        else
                                        {
                                            objcp.VCPL_ELP_Branch_Head__c = null;
                                        }
                                        if(mapofCP.containsKey(strPrevsAccKey) && mapofCP.get(strPrevsAccKey) != NULL)
                                        {
                                            objcp.VCPL_Last_Year_IO_Sales_Volume__c = mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c != NULL?
                                                mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c:0;
                                            
                                            objcp.VCPL_Last_Year_CO_Sales_Volume__c = mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c != NULL?
                                                mapofCP.get(strPrevsAccKey).VCPL_Branch_IO_Sales__c:0;
                                            
                                            objcp.VCPL_Last_Year_Sales_Vol__c = objcp.VCPL_Last_Year_IO_Sales_Volume__c+objcp.VCPL_Last_Year_CO_Sales_Volume__c;
                                        }
                                        lstCP.add(objcp);   
                                    }
                                }
                            }
                        }
                    }
                    if(lstCP != NULL && !lstCP.isEmpty())
                    {
                        try
                        {
                            strStatus = 'Processed';
                            upsert lstCP;
                        }
                        catch(exception e)
                        {
                            strStatus = 'error: '+e.getmessage();
                        }
                    }
                }
            }
        }
        return strStatus;
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
                            if(objWrapper.strAccountName.containsIgnoreCase(strSearchString) 
                                && objWrapper.strAssignmentClassification.equalsIgnoreCase(selectedClassification))
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
}