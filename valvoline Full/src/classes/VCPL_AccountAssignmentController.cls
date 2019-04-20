public without sharing class VCPL_AccountAssignmentController
{
    public static Id cdCustomerID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
    public static Id cdBranchRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    public static Id branchCPRTID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
    public static string strCurrentFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
    public static string strPrevsFinancialYear = string.valueof(integer.valueof(strCurrentFinancialYear)-1);
    
    public class dataWrapper
    {
        @AuraEnabled public string strAccountName;
        @AuraEnabled public Double lastYearVolume;
        @AuraEnabled public Double potentialLYDifference;
        @AuraEnabled public string strAssignmentClassification;
        @AuraEnabled public string assignedToID;
        @AuraEnabled public string assignedToName;
        @AuraEnabled public VCPL_Customer_Plan__c objcp;
        @AuraEnabled public list<Contact> lstContacts;
    }
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
    @AuraEnabled
    public static list<Account> getCustomers(string strAccountID)
    {
        string strDealerAccountID ='';
        
        if(strAccountID == NULL)
        {
            strDealerAccountID = getParentAccount();
        }
        else
        {
            strDealerAccountID = strAccountID;
        }
        if(strDealerAccountID != NULL)
        {
            list<Account> lstCustomerAccount = [select id,name,recordTypeID,parentID from Account 
                                                where 
                                                //parentID=:strDealerAccountID and       //Commented as Cummins Customer wont have Parent ;confirmed by sumit  
                                                recordTypeID=:cdCustomerID limit 49999];
            
            if(lstCustomerAccount != NULL && !lstCustomerAccount.isEmpty())
            {
                return lstCustomerAccount;
            }
        }
        return NULL;
    }
    @AuraEnabled
    public static list<Contact> getELPBranchHeads(string strAccountID)
    {
        Id userId = userinfo.getuserId();
        
        if(userId != NULL)
        {
            list<VCPL_System_Configuration__mdt> lstMetaData = [select id,DeveloperName,VCPL_CD_BH_Profile_Name__c,
                                                                VCPL_CD_ELP_Profile_Name__c,
                                                                VCPL_CD_HOD_Profile_Name__c from VCPL_System_Configuration__mdt 
                                                                where DeveloperName='VCPL_System_Configuration'];
            
            if(lstMetaData != NULL && !lstMetaData.isEmpty())
            {
                list<User> lstUser = [select id,AccountId,ProfileId,Profile.Name from User where Id=:userId];
                
                if(lstUser != NULL && !lstUser.isEmpty())
                {
                    if(lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_CD_HOD_Profile_Name__c) && 
                        lstUser[0].AccountID != NULL)
                    {
                        list<Account> lstBranchAccounts = [select id,parentID,RecordTypeID from Account where parentID=:lstUser[0].AccountID 
                                                           and RecordTypeID=:cdBranchRTID];
                        
                        if(lstBranchAccounts != NULL && !lstBranchAccounts.isEmpty())
                        {
                            set<ID> setAccountID = new set<ID>();
                            for(Account objAccount : lstBranchAccounts)
                            {
                                setAccountID.add(objAccount.ID);
                            }
                            if(setAccountID != NULL && !setAccountID.isEmpty())
                            {
                                list<Contact> lstContacts = [select id,name,AccountID from Contact where AccountId in:setAccountID];
                                
                                if(lstContacts != NULL && !lstContacts.isEmpty())
                                {
                                    return lstContacts;
                                }
                                else
                                {
                                    return NULL;
                                }
                            }
                        }
                    }
                    else if((lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_CD_BH_Profile_Name__c) || 
                             lstUser[0].Profile.Name.equalsIgnoreCase(lstMetaData[0].VCPL_CD_ELP_Profile_Name__c)) && 
                             lstUser[0].AccountID != NULL)
                    {
                        list<Contact> lstContacts = [select id,AccountID,name from Contact where AccountID=:lstUser[0].AccountId];
                        
                        if(lstContacts != NULL && !lstContacts.isEmpty())
                        {
                            return lstContacts;
                        }
                        else
                        {
                            return NULL;
                        }
                    }
                    else if(lstUser[0].Profile.Name.equalsIgnoreCase('System Administrator'))
                    {
                        list<Contact> lstContact = [select id,AccountID,Account.RecordTypeID,Name from Contact 
                                                    where Account.RecordTypeID=:cdBranchRTID and Account.parentID=:strAccountID];
                        
                        if(lstContact != NULL && !lstContact.isEmpty())
                        {
                            return lstContact;
                        }
                        else
                        {
                            return NULL;
                        }
                    }
                }
            }
        }
        return NULL;
    }
    @AuraEnabled
    public static list<dataWrapper> getData(string strPrimaryAccountID)
    {
        list<dataWrapper> lstWrapper = new list<dataWrapper>();
        
            list<Account> lstCutomerAccounts = getCustomers(strPrimaryAccountID);
            
            if(lstCutomerAccounts != NULL && !lstCutomerAccounts.isEmpty())
            {
                set<ID> setofAccountID = new set<ID>();
                for(Account objAccount : lstCutomerAccounts)
                {
                    setofAccountID.add(objAccount.ID);
                }
                if(setofAccountID != NULL && !setofAccountID.isEmpty())
                {
                    map<string,VCPL_Customer_Plan__c> mapofPrevsYearOppty = new map<string,VCPL_Customer_Plan__c>();
                    string strPrevsYearKey;
                    
                    for(VCPL_Customer_Plan__c objcp : [select id,VCPL_Financial_Year__c,VCPL_Customer_Account__c,VCPL_Last_Year_Sales_Vol__c,
                                                                VCPL_Actual_Sales__c,RecordTypeID,VCPL_Customer_Account__r.Name,
                                                                VCPL_Potential__c,VCPL_Assignment_Classification__c from VCPL_Customer_Plan__c 
                                                                where VCPL_Financial_Year__c=:strPrevsFinancialYear and VCPL_Customer_Account__c in:setofAccountID 
                                                                and RecordTypeID=:branchCPRTID])
                    {
                        strPrevsYearKey = '';
                        strPrevsYearKey = objcp.VCPL_Financial_Year__c+'-'+objcp.VCPL_Customer_Account__c;
                        
                        if(!mapofPrevsYearOppty.containskey(strPrevsYearKey))
                            mapofPrevsYearOppty.put(strPrevsYearKey,objcp);
                    } 
                    
                    string strCurrentYearOppKey;
                    map<string,VCPL_Customer_Plan__c> mapofCurrentYearOppty = new map<string,VCPL_Customer_Plan__c>();
                    for(VCPL_Customer_Plan__c objcp : [select id,VCPL_Customer_Account__c,name,VCPL_Branch__c,VCPL_Branch__r.Name,VCPL_ELP_Branch_Head__c,
                                                      VCPL_Last_Year_Sales_Vol__c,VCPL_ELP_Branch_Head__r.Name,recordTypeID,VCPL_Assignment_Classification__c,
                                                      VCPL_Financial_Year__c from VCPL_Customer_Plan__c where VCPL_Customer_Account__c in:setofAccountID 
                                                      and RecordTypeID=:branchCPRTID and VCPL_Financial_Year__c=:strCurrentFinancialYear])
                    {
                        strCurrentYearOppKey ='';
                        strCurrentYearOppKey =  objcp.VCPL_Financial_Year__c+'-'+objcp.VCPL_Customer_Account__c;
                        
                        if(!mapofCurrentYearOppty.containsKey(strCurrentYearOppKey))
                            mapofCurrentYearOppty.put(strCurrentYearOppKey,objcp);
                    }
                    
                    string strAccKey;
                    string strPrevsYearAccKey;
                    Double potentialDiff;
                    for(Account objAccount : lstCutomerAccounts)
                    {
                        strAccKey = '';
                        strAccKey = strCurrentFinancialYear+'-'+objAccount.id;
                        strPrevsYearAccKey = strPrevsFinancialYear+'-'+objAccount.id;
                        
                        if(mapofCurrentYearOppty.containskey(strAccKey) && mapofCurrentYearOppty.get(strAccKey) != NULL)
                        {
                            dataWrapper objWrapper = new dataWrapper();
                            objWrapper.lastYearVolume =0.0;
                            objWrapper.potentialLYDifference =0.0;
                            objWrapper.strAccountName = objAccount.Name;
                            objWrapper.lastYearVolume = mapofCurrentYearOppty.get(strAccKey).VCPL_Last_Year_Sales_Vol__c != NULL?mapofCurrentYearOppty.get(strAccKey).VCPL_Last_Year_Sales_Vol__c:0;
                            
                            if(mapofPrevsYearOppty != NULL && !mapofPrevsYearOppty.isEmpty() 
                               && mapofPrevsYearOppty.containsKey(strPrevsYearAccKey) && mapofPrevsYearOppty.get(strPrevsYearAccKey) != NULL)
                            {
                                potentialDiff = 0;
                                potentialDiff = mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Potential__c != NULL?mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Potential__c:0-mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Actual_Sales__c != NULL?mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Actual_Sales__c:0;
                                objWrapper.potentialLYDifference = potentialDiff != NULL?potentialDiff:0;
                            }
                            else
                            {
                                objWrapper.potentialLYDifference = objWrapper.lastYearVolume-0;
                            }
                            objWrapper.strAssignmentClassification = mapofCurrentYearOppty.get(strAccKey).VCPL_Assignment_Classification__c;
                            objWrapper.assignedToID = mapofCurrentYearOppty.get(strAcckey).VCPL_ELP_Branch_Head__c;
                            objWrapper.assignedToName = mapofCurrentYearOppty.get(strAcckey).VCPL_ELP_Branch_Head__r.Name;
                            objWrapper.objcp = mapofCurrentYearOppty.get(strAcckey);
                            objWrapper.lstContacts = getELPBranchHeads(strPrimaryAccountID);    
                            
                            lstWrapper.add(objWrapper);
                        }
                        else
                        {
                            VCPL_Customer_Plan__c objcp = new VCPL_Customer_Plan__c(VCPL_Customer_Account__c = objAccount.Id,
                                                                                     VCPL_Financial_Year__c = strCurrentFinancialYear,
                                                                                     name = strCurrentFinancialYear+'-'+objAccount.Name,
                                                                                     VCPL_Last_Year_Sales_Vol__c=0,
                                                                                     VCPL_Potential__c=0,
                                                                                     VCPL_Assignment_Classification__c = 'Others');
                            
                            if(mapofPrevsYearOppty != NULL && !mapofPrevsYearOppty.isEmpty() 
                               && mapofPrevsYearOppty.containsKey(strPrevsYearAccKey) && mapofPrevsYearOppty.get(strPrevsYearAccKey) != NULL)
                            {                                               
                                objcp.VCPL_Last_Year_Sales_Vol__c = mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Actual_Sales__c != NULL?mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Actual_Sales__c:0;
                            }
                            objcp.RecordTypeID = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
                            dataWrapper objWrapper = new dataWrapper();
                            objWrapper.lastYearVolume = 0.0;
                            objWrapper.potentialLYDifference=0.0;
                            objWrapper.strAccountName = objAccount.Name;
                            objWrapper.lastYearVolume = objcp.VCPL_Last_Year_Sales_Vol__c;
                            
                            if(mapofPrevsYearOppty != NULL && !mapofPrevsYearOppty.isEmpty() 
                               && mapofPrevsYearOppty.containsKey(strPrevsYearAccKey) && mapofPrevsYearOppty.get(strPrevsYearAccKey) != NULL)
                            {
                                potentialDiff = 0;
                                potentialDiff = mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Potential__c != NULL?mapofPrevsYearOppty.get(strPrevsYearAccKey).VCPL_Potential__c:0-objWrapper.lastYearVolume;
                                objWrapper.potentialLYDifference = potentialDiff != NULL?potentialDiff:0;
                            }
                            else
                            {
                                objWrapper.potentialLYDifference = objWrapper.lastYearVolume - 0.0;
                            }
                            objWrapper.strAssignmentClassification = objcp.VCPL_Assignment_Classification__c;
                            objWrapper.assignedToID = objcp.VCPL_ELP_Branch_Head__c;
                            objWrapper.assignedToName =objcp.VCPL_ELP_Branch_Head__r.Name;
                            objWrapper.objcp = objcp;
                            objWrapper.lstContacts = getELPBranchHeads(strPrimaryAccountID);
                            
                            lstWrapper.add(objWrapper);
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
                            if(objWrapper.strAccountName.containsIgnoreCase(strSearchString) && objWrapper.strAssignmentClassification.equalsIgnoreCase(selectedClassification))
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
    @AuraEnabled
    public static string saveData(string strResponse)
    {
        string strStatus='Initiate';
        
        if(strResponse != NULL)
        {
            list<dataWrapper> lstDataWrapper =  (List<dataWrapper>)JSON.deserialize(strResponse,List<dataWrapper>.class);
            
            if(lstDataWrapper != NULL && !lstDataWrapper.isEmpty())
            {
                list<VCPL_Customer_Plan__c> lstOpportunity = new list<VCPL_Customer_Plan__c>();
                map<ID,ID> mapofContact = new map<Id,ID>();
                map<ID,ID> mapofContactwrtDealer = new map<Id,ID>();
                set<ID> setofContactID = new set<ID>();
                for(dataWrapper objWrapper : lstDataWrapper)
                {
                    if(objWrapper.assignedToID != 'NULL')
                    {
                        setofContactID.add(objWrapper.assignedToID);
                    }
                }
                if(setofContactID != NULL && !setofContactID.isEmpty())
                {
                    for(Contact objContact : [select id,AccountID,account.parentID from Contact where id in:setofContactID])
                    {
                        mapofContact.put(objContact.ID,objContact.AccountID);
                        
                        if(objContact.account.parentID != NULL)
                        {
                            mapofContactwrtDealer.put(objContact.ID,objContact.account.parentID);
                        } 
                    }
                }
                for(dataWrapper objWrapper : lstDataWrapper)
                {
                    objWrapper.objcp.VCPL_Assignment_Classification__c = objWrapper.strAssignmentClassification;
                    if(objWrapper.assignedToID != 'NULL')
                    {
                        objWrapper.objcp.VCPL_ELP_Branch_Head__c = objWrapper.assignedToID;
                        
                        if(mapofContact != NULL && !mapofContact.isEmpty() && mapofContact.containsKey(objWrapper.assignedToID) && 
                            mapofContact.get(objWrapper.assignedToID) != NULL)
                        {
                            objWrapper.objcp.VCPL_Branch__c= mapofContact.get(objWrapper.assignedToID);     
                        }
                        if(mapofContactwrtDealer != NULL && !mapofContactwrtDealer.isEmpty() && mapofContactwrtDealer.containskey(objWrapper.assignedToID) 
                            && mapofContactwrtDealer.get(objWrapper.assignedToID) != NULL)
                        {
                            objWrapper.objcp.VCPL_Dealer_Account__c = mapofContactwrtDealer.get(objWrapper.assignedToID);
                        }
                    }
                    else
                    {
                        objWrapper.objcp.VCPL_ELP_Branch_Head__c = null;
                        objWrapper.objcp.VCPL_Branch__c = null;
                    }
                    
                    lstOpportunity.add(objWrapper.objcp);
                }
                if(lstOpportunity != NULL && !lstOpportunity.isEmpty())
                {
                    try
                    {
                        strStatus = 'Processed';
                        upsert lstOpportunity;
                    }
                    catch(exception e)
                    {
                        strStatus = 'error: '+e.getmessage();
                    }
                }
            }
        }
        return strStatus;
    }
}