public class VCPL_SecondarySalesTriggerHandler 
{ 
    public static id idDealerCustRTId = Schema.SObjectType.VCPL_Secondary_Sales__c.getRecordTypeInfosByName().get('CD Secondary Sales').getRecordTypeId();
    Public Map < Integer, String > mapNameMonthNum = new Map < Integer, String > {
        1 => 'Jan',
        2 => 'Feb',
        3 => 'Mar',
        4 => 'Apr',
        5 => 'May',
        6 => 'Jun',
        7 => 'Jul',
        8 => 'Aug',
        9 => 'Sep',
        10 => 'Oct',
        11 => 'Nov',
        12 => 'Dec'
    };
    
    public void runTrigger()
    {
        if (Trigger.isBefore && Trigger.isInsert)
        {
            onBeforeInsert((List<VCPL_Secondary_Sales__c>) trigger.new);
        }
        if (Trigger.isAfter && Trigger.isInsert)
        {
            onAfterInsert((List<VCPL_Secondary_Sales__c>) trigger.new);
        }
        if (Trigger.isBefore && Trigger.isUpdate)
        {
            onBeforeUpdate((List<VCPL_Secondary_Sales__c>) trigger.new,(Map<Id, VCPL_Secondary_Sales__c>) trigger.OldMap);
        }
        if (Trigger.isAfter && Trigger.isUpdate)
        {
            onAfterUpdate((List<VCPL_Secondary_Sales__c>) trigger.new, (Map<Id, VCPL_Secondary_Sales__c>) trigger.OldMap); 
        }
    }
    public void onBeforeInsert(List<VCPL_Secondary_Sales__c> lstTriggerNew)
    {
        for(VCPL_Secondary_sales__c objSS: lstTriggerNew){
            if(!String.isBlank(objSS.VCPL_Month__c))
                objSS.VCPL_Month_Picklist__c = mapNameMonthNum.get(Integer.valueof(objSS.VCPL_Month__c));
            if(!String.isBlank(objSS.VCPL_Financial_Year__c))
                objSS.VCPL_Financial_Year_picklist__c = objSS.VCPL_Financial_Year__c;
        }
    }
    public void onAfterInsert(List<VCPL_Secondary_Sales__c> lstTriggerNew)
    {
        updateSales(lstTriggerNew,null);
    }
    public void onBeforeUpdate(List<VCPL_Secondary_Sales__c> lstTriggerNew,map<id,VCPL_Secondary_Sales__c> triggeroldmap)
    {
        for(VCPL_Secondary_sales__c objSS: lstTriggerNew){
            if(!String.isBlank(objSS.VCPL_Month__c) && objSS.VCPL_Month__c != triggeroldmap.get(objSS.Id).VCPL_Month__c)
                objSS.VCPL_Month_Picklist__c = mapNameMonthNum.get(Integer.valueof(objSS.VCPL_Month__c));
            if(!String.isBlank(objSS.VCPL_Financial_Year__c) && objSS.VCPL_Financial_Year__c != triggeroldmap.get(objSS.Id).VCPL_Financial_Year__c)
                objSS.VCPL_Financial_Year_picklist__c = objSS.VCPL_Financial_Year__c;
        }
    }
    public void onAfterUpdate(List<VCPL_Secondary_Sales__c> lstTriggerNew,map<id,VCPL_Secondary_Sales__c> triggeroldmap)
    {
        updateSales(lstTriggerNew,triggeroldmap);
    }
    private static void updateSales(list<VCPL_Secondary_Sales__c> lstTriggerNew,map<id,VCPL_Secondary_Sales__c> triggeroldmap)
    {
        if(lstTriggerNew != NULL && !lstTriggerNew.isEmpty())
        {
            set<String> fieldSet = new Set<String>();
            
            for(Schema.FieldSetMember fields :Schema.SObjectType.VCPL_Secondary_Sales__c.fieldSets.getMap().get('VCPL_Roll_up_Fields').getFields())
            {
                fieldSet.add(fields.getFieldPath());
            }
            if(fieldSet != NULL && !fieldSet.isEmpty())
            {
                set<ID> setDealerCustID = new set<ID>();
                set<String> setFY = new set<string>();
                for(VCPL_Secondary_Sales__c objSecondarySales : lstTriggerNew)
                {
                    if(objSecondarySales.RecordTypeId != NULL && objSecondarySales.RecordTypeId == idDealerCustRTId && 
                      objSecondarySales.VCPL_Financial_Year__c != NULL && objSecondarySales.VCPL_Dealer_Customer__c != NULL)
                    {
                        for(string str : fieldSet)
                        {
                            if(objSecondarySales.get(str) != NULL 
                               && (triggeroldmap == NULL || (triggeroldmap != NULL && triggeroldmap.get(objSecondarySales.ID).get(str) != objSecondarySales.get(str))))
                            {
                                setDealerCustID.add(objSecondarySales.VCPL_Dealer_Customer__c);
                                setFY.add(objSecondarySales.VCPL_Financial_Year__c);
                            }
                        }
                    }
                }
                if(!setDealerCustID.isEmpty() && !setFY.isEmpty())
                {
                    map<string,Double> mapofIOSales = new map<string,Double>(); 
                    map<string,Double> mapofCOSales = new map<string,Double>(); 
                    
                    string strKey;
                    for(VCPL_Secondary_Sales__c objSecondarySales : [select id,VCPL_CO_Sales__c,VCPL_IO_Sales__c,VCPL_Financial_Year__c,VCPL_Dealer_Customer__c
                                                                        from VCPL_Secondary_Sales__c where VCPL_Dealer_Customer__c in:setDealerCustID and
                                                                        VCPL_Financial_Year__c in:setFY])
                    {
                        strKey ='';
                        strKey = objSecondarySales.VCPL_Financial_Year__c+objSecondarySales.VCPL_Dealer_Customer__c;
                        if(objSecondarySales.VCPL_IO_Sales__c != NULL && objSecondarySales.VCPL_IO_Sales__c>0)
                        {
                            if(!mapofIOSales.containsKey(strKey))
                            {
                                mapofIOSales.put(strKey,objSecondarySales.VCPL_IO_Sales__c);
                            }
                            else
                            {
                                Double IOSales = mapofIOSales.get(strKey);
                                IOSales += objSecondarySales.VCPL_IO_Sales__c;
                                mapofIOSales.put(strKey,IOSales);
                                
                            }
                        }
                        if(objSecondarySales.VCPL_CO_Sales__c != NULL && objSecondarySales.VCPL_CO_Sales__c>0)
                        {
                            if(!mapofCOSales.containsKey(strKey))
                            {
                                mapofCOSales.put(strKey,objSecondarySales.VCPL_CO_Sales__c);
                            }
                            else
                            {
                                Double IOSales = mapofCOSales.get(strKey);
                                IOSales += objSecondarySales.VCPL_CO_Sales__c;
                                mapofCOSales.put(strKey,IOSales);
                            }
                        }
                    }
                    string strFinancialYear = VCPL_MonthlySalesPlanController.getCurrentFinancialYear();
                    list<VCPL_Customer_Plan__c> lstCP  = new  list<VCPL_Customer_Plan__c>();
                    for(VCPL_Secondary_Sales__c objSecondarySales : lstTriggerNew)
                    {
                        if(objSecondarySales.RecordTypeId != NULL && objSecondarySales.RecordTypeId == idDealerCustRTId && 
                            objSecondarySales.VCPL_Financial_Year__c != NULL && objSecondarySales.VCPL_Dealer_Customer__c != NULL)
                        {
                            VCPL_Customer_Plan__c objCP = new VCPL_Customer_Plan__c(ID = objSecondarySales.VCPL_Dealer_Customer__c);
                            
                            if(mapofIOSales.containsKey(strFinancialYear+objCP.ID) && mapofIOSales.get(strFinancialYear+objCP.ID) != NULL)
                            {
                                objCP.VCPL_Dealer_IO_Sales__c = mapofIOSales.get(strFinancialYear+objCP.ID);
                            }
                            if(mapofCOSales.containsKey(strFinancialYear+objCP.ID) && mapofCOSales.get(strFinancialYear+objCP.ID) != NULL)
                            {
                                objCP.VCPL_Dealer_CO_Sales__c = mapofCOSales.get(strFinancialYear+objCP.ID);
                            }
                            lstCP.add(objCP);
                        }
                    }
                    if(lstCP != NULL && !lstCP.isEmpty())
                    {
                        
                        map<id,VCPL_Customer_Plan__c> accmap = new map<id,VCPL_Customer_Plan__c>();

                        //put all the values from the list to map. 
                        accmap.putall(lstCP);
                        if(accmap.size()>0){
                        update accmap.values();
                        }
                    }
                }
            }
        }
    }
}