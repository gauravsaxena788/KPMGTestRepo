global with sharing class MonthlyLatestEstimateClone{
    
    public Static String currentUserName{get;set;}
    public Static String currentUserId{get;set;}
    public Static String fysYear{get;set;}
    //public Boolean tablerender{get;set;}
    public Boolean alertrender{get;set;}
    public Boolean alertrender2{get;set;}
    
    public String selectedtype{get;set;}
    public String selectedmonth{get;set;}
   
    
    Public List<Opportunity> opList{get;set;}
    Public List<Opportunity> opList2{get;set;}
    
    public Boolean isLubes{get;set;}
    public Boolean isAus{get;set;}

    public list<WrapperOpportunity> wrapoptyList{get;set;}
    public list<WrapperOpportunity2> wrapoptyList2{get;set;}
    public MAP<id,Decimal> accVolMAP= new MAP<id,Decimal>();
    public MAP<id,Decimal> accNSPMAP= new MAP<id,Decimal>();
    
    public List<string> primaryRecordTypeIds{get;set;}
               
    public MonthlyLatestEstimateClone()
    {
        ////// get list of Primary Account Record types ///////
        primaryRecordTypeIds = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
    
        wrapoptyList = new List<WrapperOpportunity>();
        wrapoptyList2 = new List<WrapperOpportunity2>();
        
        //findFiscalYearSettings();
        getBasicDetails();      
        opList = new List<Opportunity>();
        opList2 = new List<Opportunity>();
        alertrender = false;
        alertrender2 = false;
        
        isAus = false;
        isLubes = true;
    } 
    
  
   public static List<FiscalYearSettings> findFiscalYearSettings(){
        set<Id> FiscalYearSettingsIds= new set<Id>();
        for(period p : [select id, FiscalYearSettingsId from period where StartDate <= today AND EndDate >= today AND Type = 'Month']){
            FiscalYearSettingsIds.add(p.FiscalYearSettingsId);
        }
        List<FiscalYearSettings> fysLst = [SELECT Id, StartDate, PeriodId, EndDate, Name 
                                            FROM FiscalYearSettings 
                                            WHERE Id IN : FiscalYearSettingsIds LIMIT 1];
        if(!fysLst.isEmpty()){
            return fysLst;
        }
        return new List<FiscalYearSettings>();
    }
    
    public static void getBasicDetails(){
        
        currentUserId = UserInfo.getUserId();
        system.debug('cuid: '+currentUserId);
        User u = [select Name from User u where u.id = :currentUserId];
        currentUserName = u.Name;
        
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            fysYear = fys.Name;
        }
    }
    
    public PageReference getOpportunityList()
    {
        PageReference pg = new PageReference('/Monthly_Latest_Estimate');
        pg.setRedirect(true);
        
        getBasicDetails();
        //system.debug('selected month: '+selectedmonth);
        //system.debug('selected type: '+selectedtype);
        if(selectedtype=='LUBES')
            return getOpportunityMonthly();
        else
            return getOpportunityMonthly2();    
    }
    
     public PageReference getOpportunityMonthly(){
        
        PageReference pg = new PageReference('/Monthly_Latest_Estimate');
        pg.setRedirect(true); 
        currentUserId = UserInfo.getUserId();
        system.debug('selected month: '+selectedmonth);
        system.debug('current userid: '+currentUserId);      
        MAP<id,opportunity> lubesMAp= new MAP<id,opportunity>();
        MAP<id,boolean> lubesDisableMAp= new MAP<id,boolean>();
        Date startDt = System.Today();
        Date endDt = System.Today();
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        List<Opportunity> lst = new List<Opportunity>();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            
            opList=[SELECT Id, Name, Account.ShippingCity, Account.Ship_to_Code__c, Account_Potential__c, LY_GP__c, LY_GP_ltr__c, 
                    LY_Volume__c, Month_Actual__c,Month__c, Latest_Est_Volume__c, Latest_Est_GP_ltr__c,Latest_Est_GP__c, 
                    Planned_Volume__c, Planned_GP_Ltr__c, Planned_GP__c,MTD_Volume__c, MTD_GP_Ltr__c, MTD_GP__c, Financial_Year__c, 
                    MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_ltr_Lubesformula__c, MTD_NSP_ltr_AUSformula__c, CloseDate, Average_Close_Date__c,  
                    Latest_Est_AUS_Volume__c, Latest_Est_Lubes_Volume__c, LE_NSP_Ltr_AUS__c, LE_NSP_Ltr_Lubes__c,  
                    Account.LY_AUS_Vol__c, Account.LY_Lubes_Vol__c, Account.LY_NSP_Ltr_AUS__c, Account.LY_NSP_Ltr_Lubes__c, 
                    Opportunity_Code__c, IsCreatedfromVF__c, MTD_Focussed_Volume__c, Account.Name, Account.Id, End_Close_Date__c,Avg_no_of_month__c,
                    Account.Account_Potential_AUS__c, Account.Account_Potential_Lubes__c, Account.LY_NSP_Ltr_AUSformula__c, Account.LY_NSP_Ltr_Lubesformula__c  
                    FROM Opportunity  
                    where 
                    OwnerId=:currentUserId and recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Account.RecordTypeId IN: primaryRecordTypeIds 
                    AND Financial_Year__c= :fys.name AND Month__c=:selectedmonth AND Account.Dormant_Status__c=false
                ]; 
            system.debug('opList: '+opList);
            
            wrapoptyList = new List<WrapperOpportunity>();
            
            Map<Integer, Integer> monthMap = new Map<Integer, Integer>();
            monthMap.put(1, 4);
            monthMap.put(2, 5);
            monthMap.put(3, 6);
            monthMap.put(4, 7);
            monthMap.put(5, 8);
            monthMap.put(6, 9);
            monthMap.put(7, 10);
            monthMap.put(8, 11);
            monthMap.put(9, 12);
            monthMap.put(10, 1);
            monthMap.put(11, 2);
            monthMap.put(12, 3);
            
            Date dt = System.Today(); //Date.valueOf('2017-9-8');
            Integer currentMonth = dt.Month();
            Integer currentDate = dt.Day();
            system.debug('Month: '+currentMonth+' Date: '+currentDate);
            Boolean isdisabled;
            Decimal lubesvolumeaverage;
            Decimal lubesnspltraverage;
            
            Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
            Integer noofdays = Integer.valueOf(vu.LE_Open_Date_every_month__c);
            
            for(Opportunity o: opList){
                
                system.debug('oppppp'+o.id);
                
                isdisabled=false;
                lubesvolumeaverage = 0.0;
                lubesnspltraverage = 0.0;
                if(currentDate > noofdays)
                {
                    if(o.Month_Actual__c <= monthMap.get(currentMonth))
                        isdisabled = true;
                    else
                        isdisabled = false;
                }
                else
                {
                    if(o.Month_Actual__c >= monthMap.get(currentMonth))
                        isdisabled = false;
                    else
                        isdisabled = true;
                }
                lubesMAp.put(o.accountid, o);
                lubesDisableMAp.put(o.accountid, isdisabled);
                startDt=o.Average_Close_Date__c;
                endDt=o.End_Close_Date__c;
                            
            }
            getLast3MonthsAverage(startDt, endDt, lubesMAp.keySet(), 'Lubes');
                if(lubesMAp.keySet()!=NULL)
                {
                    for(id accid: lubesMAp.keySet()){
                            Decimal vol=accVolMAP.get(accid)==null? 0 : accVolMAP.get(accid)/lubesMAp.get(accid).Avg_no_of_month__c;
                            Decimal nsp=accNSPMAP.get(accid)==null? 0 : accNSPMAP.get(accid)/lubesMAp.get(accid).Avg_no_of_month__c;
                            WrapperOpportunity wro =new WrapperOpportunity(lubesMAp.get(accid), lubesDisableMAp.get(accid), vol, nsp);    
                            wrapoptyList.add(wro);
                    }
                                        
                    wrapoptyList.sort();
                    system.debug('WrapOptyList: '+wrapoptyList);   
                }
                
            
        }
       
        return null;      
    }
       
       
       /////////// AUS Data List
       
       public PageReference getOpportunityMonthly2(){
        
        PageReference pg = new PageReference('/Monthly_Latest_Estimate');
        pg.setRedirect(true); 
        currentUserId = UserInfo.getUserId();
        system.debug('selected month: '+selectedmonth);
        system.debug('current userid: '+currentUserId);      
        system.debug('current userid: '+currentUserId);      
        MAP<id,opportunity> AusMAp= new MAP<id,opportunity>();
        MAP<id,boolean> AusDisableMAp= new MAP<id,boolean>();
        Date startDt = System.Today();
        Date endDt = System.Today();
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        List<Opportunity> lst = new List<Opportunity>();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            
            opList2=[SELECT Id, Name, Account.ShippingCity, Account.Ship_to_Code__c, Account_Potential__c, LY_GP__c, LY_GP_ltr__c, 
                    LY_Volume__c, Month_Actual__c,Month__c, Latest_Est_Volume__c, Latest_Est_GP_ltr__c,Latest_Est_GP__c, 
                    Planned_Volume__c, Planned_GP_Ltr__c, Planned_GP__c,MTD_Volume__c, MTD_GP_Ltr__c, MTD_GP__c, Financial_Year__c, 
                    MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_ltr_Lubesformula__c, MTD_NSP_ltr_AUSformula__c, Average_Close_Date__c, 
                    Latest_Est_AUS_Volume__c, Latest_Est_Lubes_Volume__c, LE_NSP_Ltr_AUS__c, LE_NSP_Ltr_Lubes__c, CloseDate, 
                    Account.LY_AUS_Vol__c, Account.LY_Lubes_Vol__c, Account.LY_NSP_Ltr_AUS__c, Account.LY_NSP_Ltr_Lubes__c, 
                    Opportunity_Code__c, IsCreatedfromVF__c, MTD_Focussed_Volume__c, Account.Name, Account.Id, End_Close_Date__c,Avg_no_of_month__c,
                    Account.Account_Potential_AUS__c, Account.Account_Potential_Lubes__c, Account.LY_NSP_Ltr_AUSformula__c, Account.LY_NSP_Ltr_Lubesformula__c   
                    FROM Opportunity  
                    where 
                    OwnerId=:currentUserId and recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Account.RecordTypeId IN: primaryRecordTypeIds 
                    AND Financial_Year__c= :fys.name AND Month__c=:selectedmonth AND Account.Dormant_Status__c=false
                ]; 
            system.debug('opList: '+opList2);
            
            wrapoptyList2 = new List<WrapperOpportunity2>();
            
            Map<Integer, Integer> monthMap = new Map<Integer, Integer>();
            monthMap.put(1, 4);
            monthMap.put(2, 5);
            monthMap.put(3, 6);
            monthMap.put(4, 7);
            monthMap.put(5, 8);
            monthMap.put(6, 9);
            monthMap.put(7, 10);
            monthMap.put(8, 11);
            monthMap.put(9, 12);
            monthMap.put(10, 1);
            monthMap.put(11, 2);
            monthMap.put(12, 3);
            
            Date dt = System.Today(); //Date.valueOf('2017-9-8');
            Integer currentMonth = dt.Month();
            Integer currentDate = dt.Day();
            system.debug('Month: '+currentMonth+' Date: '+currentDate);
            Boolean isdisabled2;
            Decimal ausvolumeaverage;
            Decimal ausnspltraverage;
            
            Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
            Integer noofdays = Integer.valueOf(vu.LE_Open_Date_every_month__c);
            
            for(Opportunity o: opList2){
                
                system.debug('oppppp'+o.id);
                
                isdisabled2=false;
                ausvolumeaverage = 0.0;
                ausnspltraverage = 0.0;
                if(currentDate > noofdays)
                {
                    if(o.Month_Actual__c <= monthMap.get(currentMonth))
                        isdisabled2 = true;
                    else
                        isdisabled2 = false;
                }
                else
                {
                    if(o.Month_Actual__c >= monthMap.get(currentMonth))
                        isdisabled2 = false;
                    else
                        isdisabled2 = true;
                }
                AusMAp.put(o.accountid,o);
                AusDisableMAp.put(o.accountid,isdisabled2);
                startDt=o.Average_Close_Date__c;
                endDt=o.End_Close_Date__c;
                              
            }
            getLast3MonthsAverage(startDt, endDt, AusMAp.keySet(), 'AUS');
                if(ausMAp.keySet()!=NULL){
                    for(id accid: ausMAp.keySet()){
                            Decimal vol=accVolMAP.get(accid)==null? 0 : accVolMAP.get(accid)/AusMAp.get(accid).Avg_no_of_month__c;
                            Decimal nsp=accNSPMAP.get(accid)==null? 0 : accNSPMAP.get(accid)/AusMAp.get(accid).Avg_no_of_month__c;
                            WrapperOpportunity2 wro =new WrapperOpportunity2(AusMAp.get(accid), AusDisableMAp.get(accid), vol,nsp);    
                            wrapoptyList2.add(wro);
                    }
                    wrapoptyList2.sort();
                    system.debug('WrapOptyList2: '+wrapoptyList2);
                }
            
        }
       
        return null;   
          
    }
   
       
       //picklist for months
       public List<selectOption> gettypelist() {
            
            List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
            
            options.add(new SelectOption('LUBES', 'LUBES'));
            options.add(new SelectOption('AUS','AUS'));
            
            return options; //return the picklist options
        }
   
    
        //picklist for months
        public List<selectOption> getmonthlist() {
            
            List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
            options.add(new SelectOption('None','--None--'));
            options.add(new SelectOption('Oct', 'October'));
            options.add(new SelectOption('Nov', 'November'));
            options.add(new SelectOption('Dec', 'December'));
            options.add(new SelectOption('Jan', 'January'));
            options.add(new SelectOption('Feb', 'February'));
            options.add(new SelectOption('Mar', 'March'));
            options.add(new SelectOption('Apr', 'April'));
            options.add(new SelectOption('May', 'May'));
            options.add(new SelectOption('Jun', 'June'));
            options.add(new SelectOption('Jul', 'July'));
            options.add(new SelectOption('Aug', 'August'));
            options.add(new SelectOption('Sep', 'September'));
            
            return options; //return the picklist options
        }   
    
       
        public PageReference updateopp()
        {
            //wrapoptyList 
            //update opList;
            List<Opportunity> updateOptyList = new List<Opportunity>();
            for(WrapperOpportunity uopty: wrapoptyList){
                
                updateOptyList.add(uopty.opptyList);
            }
            
            if(updateOptyList.size()>0)
            {
                update updateOptyList;
            }
            alertrender = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Saved Successfully.'));
            return null;
        }
        
        public PageReference updateopp2()
        {
            //wrapoptyList 
            //update opList;
            List<Opportunity> updateOptyList2 = new List<Opportunity>();
            for(WrapperOpportunity2 uopty: wrapoptyList2){
                
                updateOptyList2.add(uopty.opptyList2);
            }
            
            if(updateOptyList2.size()>0)
            {
                update updateOptyList2;
            }
            alertrender2 = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Saved Successfully.'));
            return null;
        }
        
        
        public PageReference cancel()
        {        
            return null;
        }
        
        public PageReference checkListType()
        {
            system.debug('selected type: '+selectedtype);
            system.debug('isAus: '+isAus);
            system.debug('isLubes: '+isLubes);        
            if(selectedtype=='LUBES')
            {
                isLubes = true;
                isAus = false;
            }
            else if(selectedtype=='AUS')
            {
                isAus = true;
                isLubes = false;
            }
            else
            {
                isAus = false;
                isLubes = false;
            }
            
            getOpportunityList();
                
            return null;
        }
                
        public void getLast3MonthsAverage(Date avgcdate, Date cdate, Set<id> accid, String type)
        {
            accVolMAP=new MAP<id,decimal>();
            accNSPMAP=new MAP<id,decimal>();
            system.debug('avg close date: '+avgcdate);
            system.debug('close date: '+cdate);
            List<Opportunity> opList = [SELECT Id, Name, Account.BillingCity, Account.Ship_to_Code__c, Account_Potential__c, 
                                        Financial_Year__c, MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_ltr_Lubesformula__c, 
                                        MTD_NSP_ltr_AUSformula__c, Account.Name, Account.Id 
                                        FROM Opportunity  
                                        where 
                                        OwnerId=:currentUserId and recordtype.DeveloperName = 'Monthly_Plan' 
                                        AND Account.RecordTypeId IN: primaryRecordTypeIds  
                                        AND CloseDate>=:avgcdate AND CloseDate<=:cdate AND AccountId IN :accid ORDER BY CloseDate];
                                        
            system.debug('opList Size : '+opList.size());
            system.debug('opList : '+opList);
            if(opList.size()>0)
            {
                //Added by MG
                for(opportunity o: opList)
                {
                    
                    if(type=='Lubes')
                    {
                        if(!accVolMAP.containsKey(o.accountid)){
                            accVolMAP.put(o.accountid,0);
                            accNSPMAP.put(o.accountid,0);
                        }   
                        accVolMAP.put(o.accountid,accVolMAP.get(o.accountid)+(o.MTD_NON_AUS_Volume__c==null? 0 : o.MTD_NON_AUS_Volume__c)); 
                        accNSPMAP.put(o.accountid,accNSPMAP.get(o.accountid)+(o.MTD_NSP_ltr_Lubesformula__c==null? 0 : o.MTD_NSP_ltr_Lubesformula__c)); 
                    }
                    else
                    {
                        if(!accVolMAP.containsKey(o.accountid)){
                            accVolMAP.put(o.accountid,0);
                            accNSPMAP.put(o.accountid,0);
                        }   
                        accVolMAP.put(o.accountid,accVolMAP.get(o.accountid)+(o.MTD_AUS_Volume__c==null? 0 : o.MTD_AUS_Volume__c)); 
                        accNSPMAP.put(o.accountid,accNSPMAP.get(o.accountid)+(o.MTD_NSP_ltr_AUSformula__c==null? 0 : o.MTD_NSP_ltr_AUSformula__c));
                    }
                }
            }
        }
        
        
    //Wrapper class
    global class WrapperOpportunity implements Comparable{
        
        public Opportunity opptyList{get;set;}
        public Boolean isDisable{get;set;}
        
        public Decimal lubesvolumeaverage{get;set;}
        public Decimal lubesnspltraverage{get;set;}
                
        public WrapperOpportunity(Opportunity op, Boolean flag, Decimal d1, Decimal d2){
            
            opptyList = op;
            isDisable = flag;
            lubesvolumeaverage = d1;
            lubesnspltraverage = d2;
        }
        
        global Integer compareTo(Object objToCompare) 
        {
            system.debug('In Compare: '+this.lubesvolumeaverage);
            WrapperOpportunity wp2=(WrapperOpportunity)(objToCompare);
            if (this.lubesvolumeaverage == wp2.lubesvolumeaverage) return 0;
            if (this.lubesvolumeaverage == null) return 1;
            if (wp2.lubesvolumeaverage == null) return -1;
            
            return (this.lubesvolumeaverage > wp2.lubesvolumeaverage) ? -1 : 1;
            
            
            
            /*
            
            WrapperOpportunity wp2=(WrapperOpportunity)(objToCompare);
            if(this.lubesvolumeaverage > wp2.lubesvolumeaverage)
            {           return Integer.valueOf(((WrapperOpportunity)objToCompare).lubesvolumeaverage - lubesvolumeaverage);}
            if(this.lubesvolumeaverage < wp2.lubesvolumeaverage)
            {  return Integer.valueOf(((WrapperOpportunity)objToCompare).lubesvolumeaverage);}
            
               return 0; */
           
        }
    }
    
    global class WrapperOpportunity2 implements Comparable{
        
        public Opportunity opptyList2{get;set;}
        public Boolean isDisable2{get;set;}
        
        public Decimal ausvolumeaverage{get;set;}
        public Decimal ausnspltraverage{get;set;}
        
        public WrapperOpportunity2(Opportunity op, Boolean flag, Decimal d1, Decimal d2){
            
            opptyList2 = op;
            isDisable2 = flag;
            ausvolumeaverage = d1;
            ausnspltraverage = d2;
        }
        
        global Integer compareTo(Object objToCompare) 
        {
            system.debug('In Compare: '+this.ausvolumeaverage);
            WrapperOpportunity2 wp=(WrapperOpportunity2)(objToCompare);
                        
            if (this.ausvolumeaverage == wp.ausvolumeaverage) return 0;
            if (this.ausvolumeaverage == null) return 1;
            if (wp.ausvolumeaverage == null) return -1;
            
            return (this.ausvolumeaverage > wp.ausvolumeaverage) ? -1 : 1;
            
            
            /*
            if(this.ausvolumeaverage > wp2.ausvolumeaverage)
            {  return Integer.valueOf(((WrapperOpportunity2)objToCompare).ausvolumeaverage - ausvolumeaverage);}
            if(this.ausvolumeaverage < wp2.ausvolumeaverage)
            { return Integer.valueOf(((WrapperOpportunity2)objToCompare).ausvolumeaverage);}
            
                return 0;*/
            
            
            
        }
    }
    
}