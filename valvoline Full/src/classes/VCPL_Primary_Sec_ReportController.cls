public class VCPL_Primary_Sec_ReportController {
    
    public static List<string> listofMonth = new List<string>{'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep'};
    
    public transient List<list<primSecData>> listPrimSecData{
        get{
            
            List<list<primSecData>> prSec = new list<list<primSecData>>();
            integer counter = 0;
            
            list<primSecData> prSecTemp = new list<primSecData>();
            
            for(list<primSecData> objPrim : setupPrimarySecData().values()){
                for(primSecData obj : objPrim){
                    
                    if(counter < 1000)
                    {
                        prSecTemp.add(obj);
                        counter++;
                    }
                    else
                    {
                        prSec.add(prSecTemp);
                        prSecTemp = new list<primSecData>();
                        prSecTemp.add(obj);
                        counter = 0;
                    }
                }
            }
            
            if(prSec.size() == 0){
                prSec.add(prSecTemp);
            }
            
            return prSec;
        }
        set;
    }
    
    /*
        public transient list<primSecData> listPrimSecData {
        get{
        list<primSecData> prSecTemp = new list<primSecData>();
        
        for(list<primSecData> objPrim : setupPrimarySecData().values()){
        prSecTemp.addAll(objPrim);
        }
        
        return prSecTemp;
        }
        set;
        }
    */
    
    @AuraEnabled
    public static string primarySecData(){
        return JSON.serialize(setupPrimarySecData());
    }
    
    
    public static map<String, list<primSecData>> setupPrimarySecData(){
        
        system.debug(listofMonth[0]);
        string strCurrentFY = VCPL_AVDQVDCommon.getCurrentFinancialYear();
        string strprevsFY = string.valueOf(integer.valueOf(strCurrentFY)-1);
        /*
        list<AggregateResult> lstPrimarySales = [SELECT Monthly_Plan_Month__c Month,  Account.Parent.Name DealerName, Financial_Year__c FY, SUM(MTD_Volume__c) TotalVolume
            FROM Opportunity 
            where RecordType.Name = 'Monthly Plan' 
            and Account.ParentId != null
            and Account.Parent.RecordType.DeveloperName = 'VCPL_Cummins_Dealer'
            and (Financial_Year__c =: strCurrentFY or Financial_Year__c =:strprevsFY)
        Group by Monthly_Plan_Month__c, Account.Parent.Name, Financial_Year__c];
        
        list<AggregateResult> lstSecSales = [SELECT VCPL_Month_Picklist__c Month,  VCPL_Branch_Customer__r.VCPL_Customer_Account__r.Parent.Name DealerName, VCPL_Financial_Year_picklist__c FY, SUM(VCPL_Cummins_Oil_Sales_in_KL__c) TotalVolume
            FROM VCPL_Secondary_Sales__c
            WHERE (VCPL_Financial_Year_picklist__c =: strCurrentFY or VCPL_Financial_Year_picklist__c =:strprevsFY)
        Group by VCPL_Month_Picklist__c, VCPL_Branch_Customer__r.VCPL_Customer_Account__r.Parent.Name, VCPL_Financial_Year_picklist__c];
        */
        map<String, map<String,primSecData>> MonthWiseData = getMonthData();
        
        map<String, list<primSecData>> MonthWiseDataList = new map<String, list<primSecData>>();
        
        //if(lstPrimarySales != null && lstPrimarySales.size() > 0) {
            for(AggregateResult objAG : [SELECT Monthly_Plan_Month__c Month,  Account.Parent.Name DealerName, Financial_Year__c FY, SUM(MTD_Volume__c) TotalVolume
                                            FROM Opportunity 
                                            where RecordType.Name = 'Monthly Plan' 
                                            and Account.ParentId != null
                                            and Account.Parent.RecordType.DeveloperName = 'VCPL_Cummins_Dealer'
                                            and (Financial_Year__c =: strCurrentFY or Financial_Year__c =:strprevsFY)
        Group by Monthly_Plan_Month__c, Account.Parent.Name, Financial_Year__c]) {
                map<String, primSecData> mapDealerData = MonthWiseData.get((String)objAG.get('Month'));
                
                primSecData dealerData = new primSecData();
                
                if(mapDealerData.ContainsKey((String)objAG.get('DealerName'))){
                    dealerData = mapDealerData.get((String)objAG.get('DealerName'));
                }
                
                dealerData.month = (String)objAG.get('Month');
                dealerData.dealerName = (String)objAG.get('DealerName');
                
                if((String)objAG.get('FY') == strCurrentFY){
                    dealerData.primSalesCY = ((Decimal)objAG.get('TotalVolume'))/1000;
                }
                else if((String)objAG.get('FY') == strprevsFY) {
                    dealerData.primSaleslY = ((Decimal)objAG.get('TotalVolume'))/1000;
                }
                
                mapDealerData.put((String)objAG.get('DealerName'), dealerData);
                MonthWiseData.put((String)objAG.get('Month'),mapDealerData);
            }
        //}
        
        //if(lstSecSales != null && lstSecSales.size() > 0) {
            for(AggregateResult objAG : [SELECT VCPL_Month_Picklist__c Month,  VCPL_Branch_Customer__r.VCPL_Customer_Account__r.Parent.Name DealerName, VCPL_Financial_Year_picklist__c FY, SUM(VCPL_Cummins_Oil_Sales_in_KL__c) TotalVolume
                                            FROM VCPL_Secondary_Sales__c
                                            WHERE (VCPL_Financial_Year_picklist__c =: strCurrentFY or VCPL_Financial_Year_picklist__c =:strprevsFY)
                                        Group by VCPL_Month_Picklist__c, VCPL_Branch_Customer__r.VCPL_Customer_Account__r.Parent.Name, VCPL_Financial_Year_picklist__c]) {
                map<String,primSecData> mapDealerData = MonthWiseData.get((String)objAG.get('Month'));
                
                primSecData dealerData = new primSecData();
                
                if(mapDealerData.ContainsKey((String)objAG.get('DealerName'))){
                    dealerData = mapDealerData.get((String)objAG.get('DealerName'));
                }
                
                dealerData.month = (String)objAG.get('Month');
                dealerData.dealerName = (String)objAG.get('DealerName');
                
                if((String)objAG.get('FY') == strCurrentFY){
                    dealerData.secSalesCY = (Decimal)objAG.get('TotalVolume');
                }
                else if((String)objAG.get('FY') == strprevsFY) {
                    dealerData.secSaleslY = (Decimal)objAG.get('TotalVolume');
                }
                
                mapDealerData.put((String)objAG.get('DealerName'), dealerData);
                MonthWiseData.put((String)objAG.get('Month'),mapDealerData);
            }
        //}
        
        for(String objMon : listofMonth){
            MonthWiseDataList.put(objMon, MonthWiseData.get(objMon).values());
        }
        
        return MonthWiseDataList;
    }
    
    public static map<String, map<String,primSecData>> getMonthData(){
        map<String, map<String,primSecData>> tempMonthWiseData = new map<String, map<String,primSecData>>();
        
        for(String objMon : listofMonth){
            tempMonthWiseData.put(objMon, new map<String,primSecData>());
        }
        
        return tempMonthWiseData;
    }
    
    public class primSecData {
        public string month {get;set;}
        public String dealerName {get;set;}
        public Decimal primSaleslY {get;set;}
        public Decimal primSalesCY {get;set;}
        public Decimal secSaleslY {get;set;}
        public Decimal secSalesCY {get;set;}
        
        public primSecData(){
            primSaleslY = 0;
            primSalesCY = 0;
            secSaleslY = 0;
            secSalesCY = 0;
        }
    }
}