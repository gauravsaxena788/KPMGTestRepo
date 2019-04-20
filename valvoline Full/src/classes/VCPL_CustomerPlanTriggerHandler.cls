public without sharing class VCPL_CustomerPlanTriggerHandler 
{    
    public static id idCARecordType = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Dealer Customer').getRecordTypeId();
    public static id idBCRecordType = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Branch Customer').getRecordTypeId();
    public static id idBARecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cummins Dealer Branch').getRecordTypeId();
    public static id idMPRecordType = Schema.SObjectType.VCPL_Customer_Plan__c.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
    public static Id idAccCARecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CD-Customer').getRecordTypeId();
    
    public void runTrigger()
    {
        if(Trigger.isBefore && Trigger.isInsert)
        {
            onBeforeInsert((List<VCPL_Customer_Plan__c>) trigger.new);
        }
        if(Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((List<VCPL_Customer_Plan__c>) trigger.new);
        }
        if(Trigger.isAfter && Trigger.isUpdate)
        {
            onAfterUpdate((List<VCPL_Customer_Plan__c>) trigger.new, (Map<Id, VCPL_Customer_Plan__c>) trigger.OldMap); 
        }
    }
    public void onBeforeInsert(List<VCPL_Customer_Plan__c> lstTriggerNew)
    {
        tagDCM(lstTriggerNew);
    }
    public void onAfterInsert(List<VCPL_Customer_Plan__c> lstTriggerNew)
    {
        updateRollUpsDealercustomer(lstTriggerNew,null);
        updateRollupsForCustomerAccount(lstTriggerNew,null);
        updateIdAccounts(lstTriggerNew,null);
    }
    public void onAfterUpdate(List<VCPL_Customer_Plan__c> lstTriggerNew,map<id,VCPL_Customer_Plan__c> triggeroldmap)
    {
        updateRollUpsDealercustomer(lstTriggerNew,triggeroldmap);
        updateRollupsForCustomerAccount(lstTriggerNew,triggeroldmap);
        updateIdAccounts(lstTriggerNew,triggeroldmap);
    }
    private static void updateRollUpsDealercustomer(List<VCPL_Customer_Plan__c> lstTriggerNew,map<id,VCPL_Customer_Plan__c> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<ID> setDealerId = new set<Id>();
            set<string> setFY = new set<string>();
            
            for(VCPL_Customer_Plan__c objCP : lstTriggerNew)
            {
                if(objCP.RecordTypeId != NULL && objCP.RecordTypeId == idCARecordType 
                && objCP.VCPL_Customer_Account__c != NULL && objCP.VCPL_Financial_Year__c != NULL && objCP.VCPL_Potential__c != NULL && 
                (triggeroldmap == NULL || (triggeroldmap != NULL && triggeroldmap.get(objCP.Id).VCPL_Potential__c != objCP.VCPL_Potential__c)))
                {
                    setDealerId.add(objCP.VCPL_Customer_Account__c);
                    setFY.add(objCP.VCPL_Financial_Year__c);
                }
            }
            system.debug('@@setDealerId: '+setDealerId);
            system.debug('@@setFY:'+setFY);
            if(!setDealerId.isEmpty() && !setFY.isEmpty())
            {
                map<string,Double> mapofPotential = new map<string,Double>();
                string strKey;
                
                for(VCPL_Customer_Plan__c objCP : [select id,VCPL_Dealer_IO_Sales__c,VCPL_Dealer_CO_Sales__c,VCPL_Potential__c,
                    VCPL_Financial_Year__c,VCPL_Customer_Account__c,VCPL_Last_Year_Sales_Vol__c 
                    from VCPL_Customer_Plan__c where VCPL_Customer_Account__c in:setDealerId 
                and VCPL_Financial_Year__c in:setFY LIMIT 50000])
                {
                    system.debug('@@customerplanlist: '+objCP);
                    strKey = '';
                    strKey = objCP.VCPL_Financial_Year__c+objCP.VCPL_Customer_Account__c;
                    if(objCP.VCPL_Potential__c != NULL)
                    {
                        if(!mapofPotential.containsKey(strKey))
                        {
                            mapofPotential.put(strKey,objCP.VCPL_Potential__c);
                        }
                        else
                        {
                            Double potential = mapofPotential.get(strKey);
                            potential += objCP.VCPL_Potential__c;
                            mapofPotential.put(strKey,potential);
                        }
                    }
                }
                string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
                list<Account> lstAccount = new list<Account>();
                
                if(mapofPotential != NULL && !mapofPotential.isEmpty())
                {
                    for(Account objAccount : [select id from Account where id in:setDealerId])
                    {
                        if(mapofPotential.containsKey(strFinancialYear+objAccount.Id) && 
                        mapofPotential.get(strFinancialYear+objAccount.Id) != NULL)
                        {
                            objAccount.VCPL_Current_Fin_Year_Total_Potential__c =   mapofPotential.get(strFinancialYear+objAccount.Id);
                            lstAccount.add(objAccount);
                        }
                    }
                    if(lstAccount != NULL && !lstAccount.isEmpty())
                    {
                        map<id,account> accmap = new map<id,account>();
                        accmap.putall(lstAccount);
                        if(accmap.size()>0){
                            update accmap.values();
                        }
                    }
                }
            }
        }
    }
    
    private static void updateRollupsForCustomerAccount(List<VCPL_Customer_Plan__c> lstTriggerNew,map<id,VCPL_Customer_Plan__c> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<String> fieldSet = new Set<String>();
            
            for(Schema.FieldSetMember fields :Schema.SObjectType.VCPL_Customer_Plan__c.fieldSets.getMap().get('VCPL_Branch_Roll_up_Fields').getFields())
            {
                fieldSet.add(fields.getFieldPath());
            }
            if(fieldSet != NULL && !fieldSet.isEmpty())
            {
                set<Id> setCustomerAccountId = new set<Id>();
                set<string> setFY = new set<string>();
                for(VCPL_Customer_Plan__c objCP : lstTriggerNew)
                {
                    if(objCP.RecordTypeId != NULL && objCP.RecordTypeId == idBCRecordType 
                    && objCP.VCPL_CD_Customer__c != NULL && objCP.VCPL_Financial_Year__c != NULL)
                    {
                        for(string str : fieldSet)
                        {
                            if(objCP.get(str) != NULL 
                            && (triggeroldmap == NULL || (triggeroldmap != NULL && triggeroldmap.get(objCP.ID).get(str) != objCP.get(str))))
                            {
                                setCustomerAccountId.add(objCP.VCPL_CD_Customer__c);
                                setFY.add(objCP.VCPL_Financial_Year__c);
                            }
                        }
                    }
                }
                if(!setCustomerAccountId.isEmpty() && !setFY.isEmpty())
                {
                    system.debug('======setCustomerAccountId=='+setCustomerAccountId);
                    map<string,Double> mapofIOSales = new map<string,Double>();
                    map<string,Double> mapofCOSales = new map<string,Double>();
                    map<string,Double> mapofPlannedSales = new map<string,Double>();
                    map<string,Double> mapofLatestEstSales = new map<string,Double>();
                    map<string,Double> mapofLY = new map<string,Double>();
                    map<string,Double> mapofLYIOSale = new map<string,Double>();
                    map<string,Double> mapofLYCOSale = new map<string,Double>();
                    
                    string strKey;
                    
                    for(VCPL_Customer_Plan__c objCP : [select id,VCPL_Branch_IO_Sales__c,VCPL_Branch_Actual_Sales__c,
                        VCPL_Branch_CO_Sales__c,VCPL_Planned_sales__c,VCPL_Latest_Est_Sales__c,
                        VCPL_CD_Customer__c,VCPL_Financial_Year__c,
                        VCPL_Last_Year_Sales_Vol__c,VCPL_Last_Yr_Ind_Oil_Sales_Volume_in_KL__c,
                        VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c
                        from VCPL_Customer_Plan__c 
                        where VCPL_CD_Customer__c in:setCustomerAccountId 
                    and VCPL_Financial_Year__c in:setFY])
                    {
                        strKey='';
                        strKey = objCP.VCPL_Financial_Year__c+objCP.VCPL_CD_Customer__c;
                        
                        if(objCP.VCPL_Last_Yr_Ind_Oil_Sales_Volume_in_KL__c != NULL)
                        {
                            if(!mapofLYIOSale.containsKey(strKey))
                            {
                                mapofLYIOSale.put(strKey,objCP.VCPL_Last_Yr_Ind_Oil_Sales_Volume_in_KL__c);
                            }
                            else
                            {
                                Double lyIOSales = mapofLYIOSale.get(strKey);
                                lyIOSales += objCP.VCPL_Last_Yr_Ind_Oil_Sales_Volume_in_KL__c;
                                mapofLYIOSale.put(strKey,lyIOSales);
                            }
                        }
                        if(objCP.VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c != NULL)
                        {
                            if(!mapofLYCOSale.containsKey(strKey))
                            {
                                mapofLYCOSale.put(strKey,objCP.VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c);
                            }
                            else
                            {
                                Double coSales = mapofLYCOSale.get(strKey);
                                coSales += objCP.VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c;
                                mapofLYCOSale.put(strKey,coSales);
                            }
                        }
                        if(objCP.VCPL_Branch_IO_Sales__c != NULL)
                        {
                            if(!mapofIOSales.containskey(strKey))
                            {
                                mapofIOSales.put(strKey,objCP.VCPL_Branch_IO_Sales__c);
                            }
                            else
                            {
                                Double ioSales=mapofIOSales.get(strKey);
                                ioSales += objCP.VCPL_Branch_IO_Sales__c;
                                mapofIOSales.put(strKey,ioSales);
                            }
                        }
                        if(objCP.VCPL_Last_Year_Sales_Vol__c != NULL)
                        {
                            if(!mapofLY.containsKey(strKey))
                            {
                                mapofLY.put(strKey,objCP.VCPL_Last_Year_Sales_Vol__c);
                            }
                            else
                            {
                                Double lySales=mapofLY.get(strKey);
                                lySales += objCP.VCPL_Last_Year_Sales_Vol__c;
                                mapofLY.put(strKey,lySales);
                            } 
                        }
                        if(objCP.VCPL_Branch_CO_Sales__c != NULL)
                        {
                            if(!mapofCOSales.containskey(strKey))
                            {
                                mapofCOSales.put(strKey,objCP.VCPL_Branch_CO_Sales__c);
                            }
                            else
                            {
                                Double coSales=mapofCOSales.get(strKey);
                                coSales += objCP.VCPL_Branch_CO_Sales__c;
                                mapofCOSales.put(strKey,coSales);
                            }
                        }
                        if(objCP.VCPL_Planned_sales__c != NULL)
                        {
                            
                            if(!mapofPlannedSales.containskey(strKey))
                            {
                                mapofPlannedSales.put(strKey,objCP.VCPL_Planned_sales__c);
                            }
                            else
                            {
                                Double pSales=mapofPlannedSales.get(strKey);
                                pSales += objCP.VCPL_Planned_sales__c;
                                mapofPlannedSales.put(strKey,pSales);
                            }
                        }
                        if(objCP.VCPL_Latest_Est_Sales__c != NULL)
                        {
                            
                            if(!mapofLatestEstSales.containskey(strKey))
                            {
                                mapofLatestEstSales.put(strKey,objCP.VCPL_Latest_Est_Sales__c);
                            }
                            else 
                            {
                                Double pSales=mapofLatestEstSales.get(strKey);
                                pSales += objCP.VCPL_Latest_Est_Sales__c;
                                mapofLatestEstSales.put(strKey,pSales);
                            }
                        }
                    }
                    string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
                    list<Account> lstAccount= new list<ACcount>();
                    
                    for(Account objCustomerAccount : [select id,parentID from Account where id in:setCustomerAccountId])
                    {
                        if(mapofLatestEstSales.containsKey(strFinancialYear+objCustomerAccount.ID) 
                        && mapofLatestEstSales.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_Customer_Account_CD_Lat_Est_Sales__c =  mapofLatestEstSales.get(strFinancialYear+objCustomerAccount.ID);
                        }
                        if(mapofPlannedSales.containsKey(strFinancialYear+objCustomerAccount.ID) 
                        && mapofPlannedSales.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_Customer_Account_CD_Planned_Sales__c =  mapofPlannedSales.get(strFinancialYear+objCustomerAccount.ID);
                        }
                        if(mapofCOSales.containsKey(strFinancialYear+objCustomerAccount.ID) 
                        && mapofCOSales.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_Customer_Account_CD_CO_Sales__c =   mapofCOSales.get(strFinancialYear+objCustomerAccount.ID);
                        }
                        if(mapofIOSales.containsKey(strFinancialYear+objCustomerAccount.ID) 
                        && mapofIOSales.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_Customer_Account_CD_IO_Sales__c =   mapofIOSales.get(strFinancialYear+objCustomerAccount.ID);
                        }
                        if(mapofLY.containskey(strFinancialYear+objCustomerAccount.ID) && 
                        mapofLY.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_Customer_Account_CD_LY_Volume__c=mapofLY.get(strFinancialYear+objCustomerAccount.ID); 
                        }
                        if(mapofLYIOSale.containskey(strFinancialYear+objCustomerAccount.ID) && 
                        mapofLYIOSale.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_LY_Customer_Account_Ind_Oil_Sales__c     = mapofLYIOSale.get(strFinancialYear+objCustomerAccount.ID);
                        }
                        if(mapofLYCOSale.containskey(strFinancialYear+objCustomerAccount.ID) && 
                        mapofLYCOSale.get(strFinancialYear+objCustomerAccount.ID) != NULL)
                        {
                            objCustomerAccount.VCPL_LY_Cust_Account_Cummins_Oil_Sales__c = mapofLYCOSale.get(strFinancialYear+objCustomerAccount.ID);
                        }
                        system.debug('===objCustomerAccount===='+objCustomerAccount);
                        lstAccount.add(objCustomerAccount);
                    }
                    if(lstAccount != NULL && !lstAccount.isEmpty())
                    {
                        system.debug(lstAccount.size()+'===lstAccount==='+lstAccount);
                        map<id,account> accmap = new map<id,account>();
                        accmap.putall(lstAccount);
                        
                        if(accmap.size() > 0)
                        {
                            update accmap.values();
                            
                            set<Id> setParentID = new set<Id>();
                            for(Account objAcount : accmap.values())
                            {
                                if(objAcount.parentId != NULL)
                                {
                                    setParentID.add(objAcount.parentId);
                                }
                            }
                            if(setParentID != NULL && !setParentID.isEmpty())
                            {
                                map<Id,Double> mapofTotalIOSales = new map<Id,Double>();
                                map<Id,Double> mapofTotalCOSales = new map<Id,Double>();
                                map<Id,Double> mapofTotalLYIOSales = new map<Id,Double>();
                                map<Id,Double> mapofTotalLYCOSales = new map<Id,Double>();
                                
                                for(Account objAccount : [select id,RecordTypeID,VCPL_Customer_Account_CD_IO_Sales__c,
                                    VCPL_Customer_Account_CD_CO_Sales__c,
                                    VCPL_LY_Customer_Account_Ind_Oil_Sales__c, 
                                    VCPL_LY_Cust_Account_Cummins_Oil_Sales__c,parentID
                                    from Account where 
                                parentID in:setParentID and RecordTypeID=:idAccCARecordType])
                                {
                                    if(objAccount.VCPL_Customer_Account_CD_IO_Sales__c != NULL)
                                    {
                                        if(!mapofTotalIOSales.containsKey(objAccount.parentID))
                                        {
                                            mapofTotalIOSales.put(objAccount.parentID,objAccount.VCPL_Customer_Account_CD_IO_Sales__c);
                                        }
                                        else
                                        {
                                            Double totalIOSales = mapofTotalIOSales.get(objAccount.parentID);
                                            totalIOSales += objAccount.VCPL_Customer_Account_CD_IO_Sales__c;
                                            mapofTotalIOSales.put(objAccount.parentID,totalIOSales);    
                                        }
                                    }
                                    if(objAccount.VCPL_Customer_Account_CD_CO_Sales__c != NULL)
                                    {
                                        if(!mapofTotalCOSales.containsKey(objAccount.parentID))
                                        {
                                            mapofTotalCOSales.put(objAccount.parentID,objAccount.VCPL_Customer_Account_CD_CO_Sales__c);
                                        }
                                        else
                                        {
                                            Double totalCOSales = mapofTotalCOSales.get(objAccount.parentID);
                                            totalCOSales += objAccount.VCPL_Customer_Account_CD_CO_Sales__c;
                                            mapofTotalCOSales.put(objAccount.parentID,totalCOSales);
                                        }
                                    }
                                    if(objAccount.VCPL_LY_Customer_Account_Ind_Oil_Sales__c != NULL)
                                    {
                                        if(!mapofTotalLYIOSales.containsKey(objAccount.parentID))
                                        {
                                            mapofTotalLYIOSales.put(objAccount.parentID,objAccount.VCPL_LY_Customer_Account_Ind_Oil_Sales__c);
                                        }
                                        else
                                        {
                                            Double totalLYIOSales = mapofTotalLYIOSales.get(objAccount.parentID);
                                            totalLYIOSales += objAccount.VCPL_LY_Customer_Account_Ind_Oil_Sales__c;
                                            mapofTotalLYIOSales.put(objAccount.parentID,totalLYIOSales);
                                        }
                                    }
                                    if(objAccount.VCPL_LY_Cust_Account_Cummins_Oil_Sales__c != NULL)
                                    {
                                        if(!mapofTotalLYCOSales.containsKey(objAccount.parentID))
                                        {
                                            mapofTotalLYCOSales.put(objAccount.parentID,objAccount.VCPL_LY_Cust_Account_Cummins_Oil_Sales__c);
                                        }
                                        else
                                        {
                                            Double totalLYCOSales = mapofTotalLYCOSales.get(objAccount.parentID);
                                            totalLYCOSales += objAccount.VCPL_LY_Cust_Account_Cummins_Oil_Sales__c;
                                            mapofTotalLYCOSales.put(objAccount.parentID,totalLYCOSales);
                                        }
                                    }
                                }
                                list<Account> lstParentAccount = new list<Account>();
                                for(Account objAccount : [select id from Account where id in:setParentID])
                                {
                                    if(mapofTotalLYCOSales.containsKey(objAccount.Id) && 
                                    mapofTotalLYCOSales.get(objAccount.Id) != NULL)
                                    {
                                        objAccount.VCPL_LY_Total_Cust_Account_CO_Sales__c = mapofTotalLYCOSales.get(objAccount.Id)/1000;
                                    }
                                    if(mapofTotalLYIOSales.containsKey(objAccount.Id) && 
                                    mapofTotalLYIOSales.get(objAccount.Id) != NULL)
                                    {
                                        objAccount.VCPL_LY_Total_Cust_Account_IO_Sales__c = mapofTotalLYIOSales.get(objAccount.Id)/1000;    
                                    }
                                    if(mapofTotalCOSales.containsKey(objAccount.Id) && 
                                    mapofTotalCOSales.get(objAccount.Id) != NULL)
                                    {
                                        objAccount.VCPL_Total_Cust_Account_CO_Sales__c = mapofTotalCOSales.get(objAccount.Id)/1000; 
                                    }
                                    if(mapofTotalIOSales.containsKey(objAccount.Id) && 
                                    mapofTotalIOSales.get(objAccount.Id) != NULL)
                                    {
                                        objAccount.VCPL_Total_Cust_Account_IO_Sales__c = mapofTotalIOSales.get(objAccount.Id)/1000; 
                                    }
                                    lstParentAccount.add(objAccount);
                                }
                                if(lstParentAccount != NULL && !lstParentAccount.isEmpty())
                                {
                                    update lstParentAccount;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    private static void updateIdAccounts(list<VCPL_Customer_Plan__c> lstTriggerNew,map<Id,VCPL_Customer_Plan__c> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<String> fieldSet = new Set<String>();
            
            for(Schema.FieldSetMember fields :Schema.SObjectType.VCPL_Customer_Plan__c.fieldSets.getMap().get('VCPL_Monthly_Plan_Fields').getFields())
            {
                fieldSet.add(fields.getFieldPath());
            }
            set<string> setFY = new set<string>();
            set<Id> setAccountID = new set<Id>();
            if(fieldSet != NULL && !fieldSet.isEmpty())
            {
                for(VCPL_Customer_Plan__c objCP : lstTriggerNew)
                {
                    if(objCP.RecordTypeID != NULL && objCP.RecordTypeId == idMPRecordType && 
                    objCP.VCPL_Financial_Year__c != NULL && objCP.VCPL_Customer_Account__c != NULL)
                    {
                        setFY.add(objCP.VCPL_Financial_Year__c);
                        setAccountID.add(objCP.VCPL_Customer_Account__c);
                    }
                }
                if(!setFY.isEmpty() && !setAccountID.isEmpty())
                {
                    map<string,Double> mapofPlannedSales = new map<string,Double>();
                    map<string,Double> mapofLatestEstSales = new map<string,Double>();
                    map<string,Double> mapofActualSales = new map<string,Double>();
                    map<string,Double> mapofLYSales = new map<string,Double>();
                    map<string,Double> mapofPH61 = new map<string,Double>();
                    map<string,Double> mapofPH62 = new map<string,Double>();
                    map<string,Double> mapofPH63 = new map<string,Double>();
                    map<string,Double> mapofPH64 = new map<string,Double>();
                    map<string,Double> mapofPH65 = new map<string,Double>();
                    map<string,Double> mapofPH66 = new map<string,Double>();
                    map<string,Double> mapofPH67 = new map<string,Double>();
                    
                    //////////////////////
                    map<string,Double> mapofPlannedSalesMonthly = new map<string,Double>();
                    map<string,Double> mapofLatestEstSalesMonthly = new map<string,Double>();
                    map<string,Double> mapofActualSalesMonthly = new map<string,Double>();
                    map<string,Double> mapofLYSalesMonthly = new map<string,Double>();
                    map<string,Double> mapofPH61Monthly = new map<string,Double>();
                    map<string,Double> mapofPH62Monthly = new map<string,Double>();
                    map<string,Double> mapofPH63Monthly = new map<string,Double>();
                    map<string,Double> mapofPH64Monthly = new map<string,Double>();
                    map<string,Double> mapofPH65Monthly = new map<string,Double>();
                    map<string,Double> mapofPH66Monthly = new map<string,Double>();
                    map<string,Double> mapofPH67Monthly = new map<string,Double>();
                    
                    //////////////////
                    string strKey;
                    
                    map<Integer,String> mapofMonth = VCPL_MonthlySalesPlanController.getMonthName();
                    string strCurrentMonth = mapofMonth.get(system.today().month());
                    
                    for(VCPL_Customer_Plan__c objCp : [select id,VCPL_Financial_Year__c,VCPL_Customer_Account__c,
                        VCPL_Planned_sales__c,VCPL_Latest_Est_Sales__c,VCPL_Actual_Sales__c,
                        VCPL_Last_Year_Sales_Vol__c,VCPL_Sample_PH6_Value_1__c,
                        VCPL_Sample_PH6_Value_2__c,VCPL_Sample_PH6_Value_3__c,
                        VCPL_Sample_PH6_Value_4__c,VCPL_Sample_PH6_Value_5__c,
                        VCPL_Sample_PH6_Value_6__c,VCPL_Sample_PH6_Value_7__c,VCPL_Month__c 
                        from VCPL_Customer_Plan__c where 
                        VCPL_Financial_Year__c in:setFY and 
                    VCPL_Customer_Account__c in:setAccountID])
                    {
                        strKey ='';
                        strKey = objCp.VCPL_Financial_Year__c+objCp.VCPL_Customer_Account__c;
                        /////////////month/////////////////////////////////////////
                        if(strCurrentMonth == objCp.VCPL_Month__c)
                        {
                            if(objCp.VCPL_Sample_PH6_Value_7__c != NULL)
                            {
                                if(!mapofPH67Monthly.containsKey(strKey))
                                {
                                    mapofPH67Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_7__c); 
                                }
                                else
                                {
                                    Double PH67 = mapofPH67Monthly.get(strKey);
                                    PH67 += objCp.VCPL_Sample_PH6_Value_7__c;
                                    mapofPH67Monthly.put(strKey,PH67);
                                }   
                            }
                            if(objCp.VCPL_Sample_PH6_Value_6__c != NULL)
                            {
                                if(!mapofPH66Monthly.containsKey(strKey))
                                {
                                    mapofPH66Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_6__c); 
                                }
                                else
                                {
                                    Double PH66 = mapofPH66Monthly.get(strKey);
                                    PH66 += objCp.VCPL_Sample_PH6_Value_6__c;
                                    mapofPH66Monthly.put(strKey,PH66);
                                }   
                            }
                            if(objCp.VCPL_Sample_PH6_Value_5__c != NULL)
                            {
                                if(!mapofPH65Monthly.containsKey(strKey))
                                {
                                    mapofPH65Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_5__c); 
                                }
                                else
                                {
                                    Double PH65 = mapofPH65Monthly.get(strKey);
                                    PH65 += objCp.VCPL_Sample_PH6_Value_5__c;
                                    mapofPH65Monthly.put(strKey,PH65);
                                }   
                            }
                            if(objCp.VCPL_Sample_PH6_Value_4__c != NULL)
                            {
                                if(!mapofPH64Monthly.containsKey(strKey))
                                {
                                    mapofPH64Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_4__c); 
                                }
                                else
                                {
                                    Double PH64 = mapofPH64Monthly.get(strKey);
                                    PH64 += objCp.VCPL_Sample_PH6_Value_4__c;
                                    mapofPH64Monthly.put(strKey,PH64);
                                }   
                            }
                            if(objCp.VCPL_Sample_PH6_Value_3__c != NULL)
                            {
                                if(!mapofPH63Monthly.containsKey(strKey))
                                {
                                    mapofPH63Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_3__c); 
                                }
                                else
                                {
                                    Double PH63 = mapofPH63Monthly.get(strKey);
                                    PH63 += objCp.VCPL_Sample_PH6_Value_3__c;
                                    mapofPH63Monthly.put(strKey,PH63);
                                }   
                            }
                            if(objCp.VCPL_Sample_PH6_Value_1__c != NULL)
                            {
                                if(!mapofPH61Monthly.containsKey(strKey))
                                {
                                    mapofPH61Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_1__c); 
                                }
                                else
                                {
                                    Double PH61 = mapofPH61Monthly.get(strKey);
                                    PH61 += objCp.VCPL_Sample_PH6_Value_1__c;
                                    mapofPH61Monthly.put(strKey,PH61);
                                }   
                            }
                            if(objCp.VCPL_Sample_PH6_Value_2__c != NULL)
                            {
                                if(!mapofPH62Monthly.containsKey(strKey))
                                {
                                    mapofPH62Monthly.put(strKey,objCp.VCPL_Sample_PH6_Value_2__c); 
                                }
                                else
                                {
                                    Double PH62 = mapofPH62Monthly.get(strKey);
                                    PH62 += objCp.VCPL_Sample_PH6_Value_2__c;
                                    mapofPH62Monthly.put(strKey,PH62);
                                }   
                            }
                            if(objCp.VCPL_Last_Year_Sales_Vol__c != NULL)
                            {
                                if(!mapofLYSales.containsKey(strKey))
                                {
                                    mapofLYSales.put(strKey,objCp.VCPL_Last_Year_Sales_Vol__c); 
                                }
                                else
                                {
                                    Double LYSales = mapofLYSales.get(strKey);
                                    LYSales += objCp.VCPL_Last_Year_Sales_Vol__c;
                                    mapofLYSales.put(strKey,LYSales);
                                }
                            }
                            if(objCp.VCPL_Actual_Sales__c != NULL)
                            {
                                if(!mapofActualSalesMonthly.containsKey(strKey))
                                {
                                    mapofActualSalesMonthly.put(strKey,objCp.VCPL_Actual_Sales__c);    
                                }
                                else
                                {
                                    Double actualSales = mapofActualSalesMonthly.get(strKey);
                                    actualSales += objCp.VCPL_Actual_Sales__c;
                                    mapofActualSalesMonthly.put(strKey,actualSales);
                                }
                            }
                            if(objCp.VCPL_Planned_sales__c != NULL)
                            {
                                if(!mapofPlannedSalesMonthly.containsKey(strKey))
                                {
                                    mapofPlannedSalesMonthly.put(strKey,objCp.VCPL_Planned_sales__c);  
                                }
                                else
                                {
                                    Double plannedSales = mapofPlannedSalesMonthly.get(strKey);
                                    plannedSales += objCp.VCPL_Planned_sales__c;
                                    mapofPlannedSalesMonthly.put(strKey,plannedSales);
                                }
                            }
                            if(objCp.VCPL_Latest_Est_Sales__c != NULL)
                            {
                                if(!mapofLatestEstSalesMonthly.containsKey(strKey))
                                {
                                    mapofLatestEstSalesMonthly.put(strKey,objCp.VCPL_Latest_Est_Sales__c); 
                                }
                                else
                                {
                                    Double LESales = mapofLatestEstSalesMonthly.get(strKey);
                                    LESales += objCp.VCPL_Latest_Est_Sales__c;
                                    mapofLatestEstSalesMonthly.put(strKey,LESales);
                                }
                            }   
                        }
                        ////////////////////////////////////////////////
                        if(objCp.VCPL_Sample_PH6_Value_7__c != NULL)
                        {
                            if(!mapofPH67.containsKey(strKey))
                            {
                                mapofPH67.put(strKey,objCp.VCPL_Sample_PH6_Value_7__c); 
                            }
                            else
                            {
                                Double PH67 = mapofPH67.get(strKey);
                                PH67 += objCp.VCPL_Sample_PH6_Value_7__c;
                                mapofPH67.put(strKey,PH67);
                            }   
                        }
                        if(objCp.VCPL_Sample_PH6_Value_6__c != NULL)
                        {
                            if(!mapofPH66.containsKey(strKey))
                            {
                                mapofPH66.put(strKey,objCp.VCPL_Sample_PH6_Value_6__c); 
                            }
                            else
                            {
                                Double PH66 = mapofPH66.get(strKey);
                                PH66 += objCp.VCPL_Sample_PH6_Value_6__c;
                                mapofPH66.put(strKey,PH66);
                            }   
                        }
                        if(objCp.VCPL_Sample_PH6_Value_5__c != NULL)
                        {
                            if(!mapofPH65.containsKey(strKey))
                            {
                                mapofPH65.put(strKey,objCp.VCPL_Sample_PH6_Value_5__c); 
                            }
                            else
                            {
                                Double PH65 = mapofPH65.get(strKey);
                                PH65 += objCp.VCPL_Sample_PH6_Value_5__c;
                                mapofPH65.put(strKey,PH65);
                            }   
                        }
                        if(objCp.VCPL_Sample_PH6_Value_4__c != NULL)
                        {
                            if(!mapofPH64.containsKey(strKey))
                            {
                                mapofPH64.put(strKey,objCp.VCPL_Sample_PH6_Value_4__c); 
                            }
                            else
                            {
                                Double PH64 = mapofPH64.get(strKey);
                                PH64 += objCp.VCPL_Sample_PH6_Value_4__c;
                                mapofPH64.put(strKey,PH64);
                            }   
                        }
                        if(objCp.VCPL_Sample_PH6_Value_3__c != NULL)
                        {
                            if(!mapofPH63.containsKey(strKey))
                            {
                                mapofPH63.put(strKey,objCp.VCPL_Sample_PH6_Value_3__c); 
                            }
                            else
                            {
                                Double PH63 = mapofPH63.get(strKey);
                                PH63 += objCp.VCPL_Sample_PH6_Value_3__c;
                                mapofPH63.put(strKey,PH63);
                            }   
                        }
                        if(objCp.VCPL_Sample_PH6_Value_1__c != NULL)
                        {
                            if(!mapofPH61.containsKey(strKey))
                            {
                                mapofPH61.put(strKey,objCp.VCPL_Sample_PH6_Value_1__c); 
                            }
                            else
                            {
                                Double PH61 = mapofPH61.get(strKey);
                                PH61 += objCp.VCPL_Sample_PH6_Value_1__c;
                                mapofPH61.put(strKey,PH61);
                            }   
                        }
                        if(objCp.VCPL_Sample_PH6_Value_2__c != NULL)
                        {
                            if(!mapofPH62.containsKey(strKey))
                            {
                                mapofPH62.put(strKey,objCp.VCPL_Sample_PH6_Value_2__c); 
                            }
                            else
                            {
                                Double PH62 = mapofPH62.get(strKey);
                                PH62 += objCp.VCPL_Sample_PH6_Value_2__c;
                                mapofPH62.put(strKey,PH62);
                            }   
                        }
                        if(objCp.VCPL_Last_Year_Sales_Vol__c != NULL)
                        {
                            if(!mapofLYSales.containsKey(strKey))
                            {
                                mapofLYSales.put(strKey,objCp.VCPL_Last_Year_Sales_Vol__c); 
                            }
                            else
                            {
                                Double LYSales = mapofLYSales.get(strKey);
                                LYSales += objCp.VCPL_Last_Year_Sales_Vol__c;
                                mapofLYSales.put(strKey,LYSales);
                            }
                        }
                        if(objCp.VCPL_Actual_Sales__c != NULL)
                        {
                            if(!mapofActualSales.containsKey(strKey))
                            {
                                mapofActualSales.put(strKey,objCp.VCPL_Actual_Sales__c);    
                            }
                            else
                            {
                                Double actualSales = mapofActualSales.get(strKey);
                                actualSales += objCp.VCPL_Actual_Sales__c;
                                mapofActualSales.put(strKey,actualSales);
                            }
                        }
                        if(objCp.VCPL_Planned_sales__c != NULL)
                        {
                            if(!mapofPlannedSales.containsKey(strKey))
                            {
                                mapofPlannedSales.put(strKey,objCp.VCPL_Planned_sales__c);  
                            }
                            else
                            {
                                Double plannedSales = mapofPlannedSales.get(strKey);
                                plannedSales += objCp.VCPL_Planned_sales__c;
                                mapofPlannedSales.put(strKey,plannedSales);
                            }
                        }
                        if(objCp.VCPL_Latest_Est_Sales__c != NULL)
                        {
                            if(!mapofLatestEstSales.containsKey(strKey))
                            {
                                mapofLatestEstSales.put(strKey,objCp.VCPL_Latest_Est_Sales__c); 
                            }
                            else
                            {
                                Double LESales = mapofLatestEstSales.get(strKey);
                                LESales += objCp.VCPL_Latest_Est_Sales__c;
                                mapofLatestEstSales.put(strKey,LESales);
                            }
                        }                                   
                    }
                    string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
                    list<Account> lstAccountToUpdate = new list<Account>();
                    
                    for(Account objAccount : [select id from Account where Id in:setAccountID])
                    {
                        if(mapofPlannedSales.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPlannedSales.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Planned_Sales__c=mapofPlannedSales.get(strFinancialYear+objAccount.ID);         
                        }
                        if(mapofLatestEstSales.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofLatestEstSales.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Latest_Est_Sale__c=mapofLatestEstSales.get(strFinancialYear+objAccount.ID);         
                        }
                        if(mapofActualSales.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofActualSales.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Actual_Sale_Vol__c=mapofActualSales.get(strFinancialYear+objAccount.ID);        
                        }
                        if(mapofLYSales.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofLYSales.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Previous_Fiscal_Year_Sales_Volume__c=mapofLYSales.get(strFinancialYear+objAccount.ID);      
                        }
                        if(mapofPH61.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH61.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Engine_Oil_Sale__c=mapofPH61.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH62.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH62.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Industrial_Oil__c = mapofPH62.get(strFinancialYear+objAccount.ID);      
                        }
                        if(mapofPH63.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH63.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Gear_Oil_Sales__c = mapofPH63.get(strFinancialYear+objAccount.ID);      
                        }
                        if(mapofPH64.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH64.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_AntiFreeze_Sale__c   = mapofPH64.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH65.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH65.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Grease_Sales__c   = mapofPH64.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH66.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH66.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_AUS_32_Sales__c   = mapofPH65.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH67.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH67.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Fiscal_Year_Others_Sales__c  = mapofPH66.get(strFinancialYear+objAccount.ID);       
                        }
                        /////////////////////////////////
                        if(mapofPlannedSalesMonthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPlannedSalesMonthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Planned_Sales__c = mapofPlannedSalesMonthly.get(strFinancialYear+objAccount.ID);         
                        }
                        if(mapofLatestEstSalesMonthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofLatestEstSalesMonthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Latest_Est_Sales__c=mapofLatestEstSalesMonthly.get(strFinancialYear+objAccount.ID);         
                        }
                        if(mapofActualSalesMonthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofActualSalesMonthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Actual_Sales__c=mapofActualSalesMonthly.get(strFinancialYear+objAccount.ID);        
                        }
                        if(mapofPH61Monthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH61Monthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Engine_Oil_Sales__c=mapofPH61Monthly.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH62Monthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH62Monthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Industrial_Oil_Sales__c = mapofPH62Monthly.get(strFinancialYear+objAccount.ID);      
                        }
                        if(mapofPH63.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH63.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Gear_Oil_Sales__c  = mapofPH63.get(strFinancialYear+objAccount.ID);      
                        }
                        if(mapofPH64Monthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH64Monthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Anti_Freeze_Sales__c   = mapofPH64Monthly.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH65Monthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH65Monthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Grease_Sales__c   = mapofPH64Monthly.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH66Monthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH66Monthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_AUS_32_Sales__c  = mapofPH65Monthly.get(strFinancialYear+objAccount.ID);       
                        }
                        if(mapofPH67Monthly.containsKey(strFinancialYear+objAccount.ID) && 
                        mapofPH67Monthly.get(strFinancialYear+objAccount.ID) != NULL)
                        {
                            objAccount.VCPL_Current_Month_Others_Sales__c  = mapofPH66Monthly.get(strFinancialYear+objAccount.ID);       
                        }
                        
                        /////////////////////////////
                        lstAccountToUpdate.add(objAccount);
                    }
                    if(lstAccountToUpdate != NULL && !lstAccountToUpdate.isEmpty())
                    {
                        update lstAccountToUpdate;
                    }
                }
            }
        }
    }
    private static void tagDCM(list<VCPL_Customer_Plan__c> lstTriggerNew)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<string> setofKeys = new set<string>();
            set<Id> setBranchID = new set<Id>();
            map<Id,Id> mapofBranch = new map<Id,Id>();
            
            
            string strcurrentFY = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
            string lastFY = String.valueOf(Integer.valueOf(strcurrentFY)-1);
            
            for(VCPL_Customer_Plan__c objCP : lstTriggerNew)
            {
                objCP.VCPL_Is_Current_Financial_Year__c = objCP.VCPL_Financial_Year__c == strcurrentFY ? true : false;
                objCP.VCPL_Last_Financial_Year__c = objCP.VCPL_Financial_Year__c == lastFY ? true : false;
                
                if(objCP.RecordTypeID != NULL && objCP.RecordTypeID == idCARecordType 
                && objCP.VCPL_Customer_Account__c != NULL && objCP.VCPL_CD_Customer__c != NULL)
                {
                    setofKeys.add(string.valueof(objCP.VCPL_Customer_Account__c).substring(0,15)+'-'+string.valueof(objCP.VCPL_CD_Customer__c).substring(0,15));    
                }
                else if(objCP.RecordTypeID != NULL && objCP.RecordTypeID == idBCRecordType 
                && objCP.VCPL_Customer_Account__c != NULL && objCP.VCPL_CD_Customer__c != NULL)
                {
                    setBranchID.add(objCP.VCPL_Customer_Account__c);
                }
            }
            if(setBranchID != NULL && !setBranchID.isEmpty())
            {
                for(Account objBranch : [select id,parentID from Account where Id in:setBranchID])
                {
                    if(!mapofBranch.containsKey(objBranch.Id))
                    mapofBranch.put(objBranch.Id,objBranch.parentID);
                }
                if(mapofBranch != NULL && !mapofBranch.isEmpty())
                {
                    for(VCPL_Customer_Plan__c objCP : lstTriggerNew)
                    {
                        if(objCP.RecordTypeID != NULL && objCP.RecordTypeID == idBCRecordType 
                        && objCP.VCPL_Customer_Account__c != NULL && objCP.VCPL_CD_Customer__c != NULL && mapofBranch.containsKey(objCP.VCPL_Customer_Account__c) && 
                        mapofBranch.get(objCP.VCPL_Customer_Account__c) != NULL)
                        {
                            setofKeys.add(string.valueof(mapofBranch.get(objCP.VCPL_Customer_Account__c)).substring(0,15)+'-'+string.valueof(objCP.VCPL_CD_Customer__c).substring(0,15));
                        }
                    }
                }
            }
            if(setofKeys != NULL && !setofKeys.isEmpty())
            {
                map<string,VCPL_Dealer_Customer_Mapping__c> mapofDCM = new map<string,VCPL_Dealer_Customer_Mapping__c>();
                for(VCPL_Dealer_Customer_Mapping__c objMapping : [select id,VCPL_Key_Field__c from 
                    VCPL_Dealer_Customer_Mapping__c where 
                VCPL_Key_Field__c in:setofKeys])
                {
                    if(!mapofDCM.containsKey(objMapping.VCPL_Key_Field__c))
                    mapofDCM.put(objMapping.VCPL_Key_Field__c,objMapping);
                }
                if(mapofDCM != NULL && !mapofDCM.isEmpty())
                {
                    string strKey;
                    for(VCPL_Customer_Plan__c objCP : lstTriggerNew)
                    {
                        if(objCP.RecordTypeID != NULL && objCP.VCPL_Customer_Account__c != NULL && objCP.VCPL_CD_Customer__c != NULL)
                        {
                            strKey ='';
                            
                            if(objCP.RecordTypeID == idCARecordType)
                            {
                                strKey = string.valueof(objCP.VCPL_Customer_Account__c).substring(0,15)+'-'+string.valueof(objCP.VCPL_CD_Customer__c).substring(0,15);
                            }
                            else if(objCP.RecordTypeID == idBCRecordType && mapofBranch.containsKey(objCP.VCPL_Customer_Account__c) && 
                            mapofBranch.get(objCP.VCPL_Customer_Account__c) != NULL)
                            {
                                strKey = string.valueof(mapofBranch.get(objCP.VCPL_Customer_Account__c)).substring(0,15)+'-'+string.valueof(objCP.VCPL_CD_Customer__c).substring(0,15);
                            }
                            if(strKey != '')
                            {
                                if(mapofDCM.containsKey(strKey) && mapofDCM.get(strKey) != NULL)
                                {
                                    objCP.VCPL_Dealer_Customer_Mapping__c = mapofDCM.get(strKey).Id;
                                }
                            }   
                        }
                    }
                }
            }
        }
    }
}