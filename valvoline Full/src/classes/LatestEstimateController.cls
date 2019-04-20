global with sharing class LatestEstimateController{
    
    public Static String currentUserName{get;set;}
    public Static String currentUserId{get;set;}
    public Static String fysYear{get;set;}
    
    public String accountId{get;set;}
    public Boolean tablerender{get;set;}
    public Boolean alertrender{get;set;}
    public Boolean alertrender2{get;set;}
    
    public String selectedtype{get;set;}
        
    Public List<Opportunity> opList{get;set;}
    Public List<Opportunity> opList2{get;set;}
    
    public Boolean isLubes{get;set;}
    public Boolean isAus{get;set;}
    
    public String accountname{get;set;}

    public list<WrapperOpportunity> wrapoptyList{get;set;}
    public list<WrapperOpportunity2> wrapoptyList2{get;set;}
           
    public LatestEstimateController()
    {
        accountId = ApexPages.currentPage().getParameters().get('recordId');
        system.debug('***accountId'+accountId);
                
        wrapoptyList = new List<WrapperOpportunity>();
        wrapoptyList2 = new List<WrapperOpportunity2>();
        
        getBasicDetails();      
        opList = new List<Opportunity>();
        opList2 = new List<Opportunity>();
        alertrender = false;
        alertrender2 = false;
        
        isAus = false;
        isLubes = true;
        
        selectedtype = 'LUBES';
        getOpportunityList();
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
        PageReference pg = new PageReference('/LatestEstimate?recordId='+accountId);
        pg.setRedirect(true);
        getBasicDetails();
        
        /////// get account name /////////////
        List<Account> accList = [Select Id, Name from Account Where Id=:accountId];
        if(accList.size()>0)
            accountname = accList[0].Name;
                
        if(selectedtype=='LUBES')
            return getOpportunityMonthly();
        else
            return getOpportunityMonthly2();    
    }
    
     public PageReference getOpportunityMonthly(){
        
        PageReference pg = new PageReference('/LatestEstimate?recordId='+accountId);
        pg.setRedirect(true); 
        currentUserId = UserInfo.getUserId();
        
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        List<Opportunity> lst = new List<Opportunity>();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            
            opList=[SELECT Id, Name, Account.BillingCity, Account.Ship_to_Code__c, Account_Potential__c, LY_GP__c, LY_GP_ltr__c, 
                    LY_Volume__c, Month_Actual__c,Month__c, Latest_Est_Volume__c, Latest_Est_GP_ltr__c,Latest_Est_GP__c, 
                    Planned_Volume__c, Planned_GP_Ltr__c, Planned_GP__c,MTD_Volume__c, MTD_GP_Ltr__c, MTD_GP__c, Financial_Year__c, 
                    MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_Ltr_Lubes__c, MTD_NSP_Ltr_AUS__c, CloseDate, Average_Close_Date__c,  
                    Latest_Est_AUS_Volume__c, Latest_Est_Lubes_Volume__c, LE_NSP_Ltr_AUS__c, LE_NSP_Ltr_Lubes__c,   
                    Account.LY_AUS_Vol__c, Account.LY_Lubes_Vol__c, Account.LY_NSP_Ltr_AUS__c, Account.LY_NSP_Ltr_Lubes__c, 
                    Opportunity_Code__c, IsCreatedfromVF__c, MTD_Focussed_Volume__c, Account.Name, Account.Id, End_Close_Date__c,
                    Planned_AUS_Volume__c, Planned_Lubes_Volume__c, Planned_NSP_Ltr_AUS__c, Planned_NSP_Ltr_Lubes__c,
                    Account.Account_Potential_AUS__c, Account.Account_Potential_Lubes__c, LY_AUS_Vol__c, LY_Lubes_Vol__c, 
                    LY_NSP_Ltr_AUS__c, LY_NSP_Ltr_Lubes__c, MTD_NSP_ltr_Lubesformula__c, MTD_NSP_ltr_AUSformula__c   
                    FROM Opportunity  
                    where 
                    OwnerId=:currentUserId and recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Financial_Year__c= :fys.name AND AccountId=:accountId ORDER BY Month_Actual__c
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
            
            Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
            Integer noofdays = Integer.valueOf(vu.LE_Open_Date_every_month__c);
            
            for(Opportunity o: opList){
                
                system.debug('oppppp'+o.id);
                
                isdisabled=false;
                
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
                
                WrapperOpportunity wro =new WrapperOpportunity(o, isdisabled);
                wrapoptyList.add(wro);
                system.debug('WrapOptyList: '+wrapoptyList);               
            }
            
        }
       
        return null;      
    }
       
       
       /////////// AUS Data List
       
       public PageReference getOpportunityMonthly2(){
        
        PageReference pg = new PageReference('/LatestEstimate?recordId='+accountId);
        pg.setRedirect(true); 
        currentUserId = UserInfo.getUserId();
        
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        List<Opportunity> lst = new List<Opportunity>();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            
            opList2=[SELECT Id, Name, Account.BillingCity, Account.Ship_to_Code__c, Account_Potential__c, LY_GP__c, LY_GP_ltr__c, 
                    LY_Volume__c, Month_Actual__c,Month__c, Latest_Est_Volume__c, Latest_Est_GP_ltr__c,Latest_Est_GP__c, 
                    Planned_Volume__c, Planned_GP_Ltr__c, Planned_GP__c,MTD_Volume__c, MTD_GP_Ltr__c, MTD_GP__c, Financial_Year__c, 
                    MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_Ltr_Lubes__c, MTD_NSP_Ltr_AUS__c, Average_Close_Date__c, 
                    Latest_Est_AUS_Volume__c, Latest_Est_Lubes_Volume__c, LE_NSP_Ltr_AUS__c, LE_NSP_Ltr_Lubes__c, CloseDate, 
                    Account.LY_AUS_Vol__c, Account.LY_Lubes_Vol__c, Account.LY_NSP_Ltr_AUS__c, Account.LY_NSP_Ltr_Lubes__c, 
                    Opportunity_Code__c, IsCreatedfromVF__c, MTD_Focussed_Volume__c, Account.Name, Account.Id, End_Close_Date__c,
                    Planned_AUS_Volume__c, Planned_Lubes_Volume__c, Planned_NSP_Ltr_AUS__c, Planned_NSP_Ltr_Lubes__c, 
                    Account.Account_Potential_AUS__c, Account.Account_Potential_Lubes__c, MTD_NSP_ltr_Lubesformula__c, MTD_NSP_ltr_AUSformula__c, 
                    LY_AUS_Vol__c, LY_Lubes_Vol__c, LY_NSP_Ltr_AUS__c, LY_NSP_Ltr_Lubes__c     
                    FROM Opportunity  
                    where 
                    OwnerId=:currentUserId and recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Financial_Year__c= :fys.name AND AccountId=:accountId ORDER BY Month_Actual__c
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
            
            Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
            Integer noofdays = Integer.valueOf(vu.LE_Open_Date_every_month__c);
            
            for(Opportunity o: opList2){
                
                system.debug('oppppp'+o.id);
                
                isdisabled2=false;
                
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
                
                WrapperOpportunity2 wro =new WrapperOpportunity2(o, isdisabled2);
                wrapoptyList2.add(wro);
                system.debug('WrapOptyList: '+wrapoptyList2);               
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
          
        public PageReference updateopp()
        {
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
                
        
    //Wrapper class
    public class WrapperOpportunity{
        
        public Opportunity opptyList{get;set;}
        public Boolean isDisable{get;set;}
                
        public WrapperOpportunity(Opportunity op, Boolean flag){
            
            opptyList = op;
            isDisable = flag;            
        }
    }
    
    public class WrapperOpportunity2{
        
        public Opportunity opptyList2{get;set;}
        public Boolean isDisable2{get;set;}
                
        public WrapperOpportunity2(Opportunity op, Boolean flag){
            
            opptyList2 = op;
            isDisable2 = flag;                
        }
    }
    
}