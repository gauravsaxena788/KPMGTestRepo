public class AccountMonthlyPlanController {

    public Static String currentUserName{get;set;}
    public Static String currentUserId{get;set;}
    public Static String fysYear{get;set;}
    public String fyear{get;set;}
    //public Id primaryaccRecordTypeId{get;set;}
    public List<String> primaryRecordTypeIds{get;set;}
    
    public String accountId{get;set;}
    
    public list<WrapperAccount> wrapaccountList{get;set;}
    
    public AccountMonthlyPlanController()
    {
        //primaryaccRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'VCPL_Primary_Account' AND sObjectType = 'Account'].Id;
        
        ////// get list of Primary Account Record types ///////
        primaryRecordTypeIds = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
        
        getBasicDetails();
        wrapaccountList = new List<WrapperAccount>();
        getAllAccounts();
    }

    public static List<FiscalYearSettings> findFiscalYearSettings()
    {
        set<Id> FiscalYearSettingsIds= new set<Id>();
        for(period p : [select id, FiscalYearSettingsId from period where StartDate <= today AND EndDate >= today AND Type = 'Month'])
        {
            FiscalYearSettingsIds.add(p.FiscalYearSettingsId);
        }
        List<FiscalYearSettings> fysLst = [SELECT Id, StartDate, PeriodId, EndDate, Name 
                                            FROM FiscalYearSettings 
                                            WHERE Id IN : FiscalYearSettingsIds LIMIT 1];
        if(!fysLst.isEmpty())
        {
            return fysLst;
        }
        return new List<FiscalYearSettings>();
    }
    
    public static void getBasicDetails()
    {        
        currentUserId = UserInfo.getUserId();
        system.debug('cuid: '+currentUserId);
                
        User u = [select Name from User u where u.id = :currentUserId];
        currentUserName = u.Name;
        
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        if(!fysLst.isEmpty())
        {
            FiscalYearSettings fys = fysLst.get(0);
            fysYear = fys.Name;            
        }
    }
    
    public PageReference updateMonthlyOpportunity()
    {
        List<Opportunity> updateOptyList = new List<Opportunity>();
        List<Account> updateAccList = new List<Account>();
        Map<Id, String> AccountIdMap = new Map<Id, String>();
        
        getBasicDetails();
        
        for(WrapperAccount uopty: wrapaccountList)
        {
            AccountIdMap.put(uopty.accList.Id, uopty.annualplanAUS+','+uopty.annualplanLUB);
        }
        
        system.debug('Account Map: '+AccountIdMap);
        system.debug('fysyear: '+fysYear);
        
        List<Account> accList = [Select Id, (Select Id, Account.Id, Planned_AUS_Volume__c, Planned_Lubes_Volume__c from Opportunities where 
                                      Financial_Year__c=:fysYear AND RecordType.DeveloperName=:'Monthly_Plan')
                                      
                          From Account Where Id IN: AccountIdMap.keySet() AND Status__c!='Draft' AND RecordTypeId IN: primaryRecordTypeIds];
        
        
        for(Account act: accList)                 
        {
             system.debug('act: '+act.Opportunities);
             String plannedvaluestr = AccountIdMap.get(act.Id);
             String[] plannedstrarr = plannedvaluestr.split(',');
             
                          
             act.ANNUAL_PLAN_AUS__c = Decimal.valueOf(plannedstrarr[0]);
             act.ANNUAL_PLAN_LUBES__c = Decimal.valueOf(plannedstrarr[1]);
             
             for(Opportunity opt: act.Opportunities)
             {
                 String str = AccountIdMap.get(opt.Account.Id);
                 String[] strarr = str.split(',');
                 
                 Decimal plannedausvalue = Decimal.valueOf(strarr[0]);
                 Decimal plannedlubvalue = Decimal.valueOf(strarr[1]);
                 
                 opt.Planned_AUS_Volume__c = (plannedausvalue==0.0? 0.0 : plannedausvalue/12);
                 opt.Planned_Lubes_Volume__c = (plannedlubvalue==0.0? 0.0 : plannedlubvalue/12);
                 
                 updateOptyList.add(opt);
             }
             
             
        }
                
        system.debug('opty list: '+updateOptyList);
        
        if(updateOptyList.size()>0)
        {
            update accList;
            update updateOptyList;
        }             
        
        //alertrender = true;
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,' Record Saved Successfully.'));
        return null;
    }
    
    public PageReference getAllAccounts()
    {
        PageReference pg = new PageReference('/AccountMonthlyPlan');
        pg.setRedirect(true); 
        currentUserId = UserInfo.getUserId();
        
        List<Account> accountList = [Select Id, Name, Ship_to_Code__c, ShippingCity, ANNUAL_PLAN_AUS__c, ANNUAL_PLAN_LUBES__c, 
                                     Total_Account_Potential__c, LY_AUS_Vol__c, LY_Lubes_Vol__c 
                                     FROM Account where Account.OwnerId=:currentUserId AND Status__c!='Draft' AND RecordTypeId IN: primaryRecordTypeIds];
                                     
        
        wrapaccountList = new List<WrapperAccount>();
        
        for(Account acc: accountList)
        {
            WrapperAccount wro =new WrapperAccount(acc, acc.ANNUAL_PLAN_AUS__c, acc.ANNUAL_PLAN_LUBES__c);
            wrapaccountList.add(wro);
        }
        
        return null;
    }
    
     //Wrapper class
    public class WrapperAccount{
        
        public Account accList{get;set;}
        public Decimal annualplanAUS{get;set;}
        public Decimal annualplanLUB{get;set;}
                
        public WrapperAccount(Account acc, Decimal apAUS, Decimal apLUB)
        {            
            accList = acc;
            annualplanAUS = apAUS;
            annualplanLUB = apLUB;
        }
    }
    
}