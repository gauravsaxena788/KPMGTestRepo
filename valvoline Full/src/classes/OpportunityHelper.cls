public with sharing class OpportunityHelper {
    
    public Static Date activationDate{get;set;}
        
    @AuraEnabled
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
    
    @AuraEnabled
    public static Integer findActualMonth(){
        date myDate = date.today();
        Integer startMon=myDate.month();
        Integer actualMonth = 13; // default value to month no month greater then this
        Integer day=myDate.day();
        
        // setting map with FiscalYearSettings record 
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        
        if(!fysLst.isEmpty()){
            // setting Fiscal year dymanic map for add month 
            FiscalYearSettings fys = fysLst.get(0);
            Map<Integer,Integer> monthsMap = new Map<Integer,Integer>();
            Integer index = 1;
            Integer startdt = fys.StartDate.Month();
            Integer enddt = fys.EndDate.Month();
            while(index <= 12 ){
                if(startdt == 12){
                    monthsMap.put(startdt,index);
                    startdt = 1 ;
                }else{
                    monthsMap.put(startdt,index);
                    startdt ++;
                }
                index ++;
            }            
            // filling month map
            //Map<Integer,Integer> monthsMap = new Map<Integer,Integer>{8=>11, 9=>12, 10=>1, 11=>2, 12=>3, 1=>4, 2=>5, 3=>6, 4=>7, 5=>8, 6=>9, 7=>10};
            Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
            Integer noofdays = Integer.valueOf(vu.LE_Open_Date_every_month__c);
            system.debug('number of days: '+noofdays);
            if(monthsMap.containsKey(startMon)){
                actualMonth = monthsMap.get(startMon);
                if(day>noofdays ){
                    actualMonth = startMon != 12 ? monthsMap.get(startMon+1) : monthsMap.get(1);
                }
            }
        }
        return actualMonth ;
    }
      
    // start code - added by madhuri on 22-08-17
    
    @AuraEnabled
    public static String findAllNew(String accId){
            String result;
            String currentUserId = UserInfo.getUserId();
            User userProfile = [select u.Profile.Name from User u where u.id = :currentUserId]; 
            Account acc = [select OwnerId from Account where Id =:accId];
                           
        if(currentUserId != acc.OwnerId && userProfile.Profile.Name != 'System Administrator'){
            system.debug('**if userProfile.Profile.Name*'+userProfile.Profile.Name); 
            result = 'result1';
        }
        else{
            List<FiscalYearSettings> fysLst =findFiscalYearSettings();
            List<Opportunity> lst = new List<Opportunity>();
            system.debug('**I am in else**'+fysLst );
            if(!fysLst.isEmpty()){
                FiscalYearSettings fys = fysLst.get(0);
                lst=[SELECT Id, Account_Potential__c, LY_GP__c, LY_GP_ltr__c, LY_Volume__c, Month_Actual__c,Month__c, Latest_Est_Volume__c, Latest_Est_GP_ltr__c,Latest_Est_GP__c, Planned_Volume__c, Planned_GP_Ltr__c, 
                       Planned_GP__c,MTD_Volume__c, MTD_GP_Ltr__c, MTD_GP__c, Financial_Year__c, Opportunity_Code__c, IsCreatedfromVF__c, MTD_Focussed_Volume__c, Account.Activation_Date__c  
                       FROM Opportunity  
                           where 
                           AccountId=:accId and recordtype.DeveloperName = 'Monthly_Plan' 
                           AND Financial_Year__c= :fys.name
                           order by Month_Actual__c ]; 
               system.debug('**lst**'+lst.size());
               if(lst.size()>0)
                   result = 'result2';
            } 
        }
        system.debug('**result**'+result);
        return result;
     
    }
    
   // end code - added by madhuri on 22-08-17
    
    @AuraEnabled
    public static List<opportunity> findAll(String accId){
        
        
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        List<Opportunity> lst = new List<Opportunity>();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            
            lst=[SELECT Id, Account_Potential__c, LY_GP__c, LY_GP_ltr__c, LY_Volume__c, Month_Actual__c,Month__c, Latest_Est_Volume__c, Latest_Est_GP_ltr__c,Latest_Est_GP__c, Planned_Volume__c, Planned_GP_Ltr__c, 
                   Planned_GP__c,MTD_Volume__c, MTD_GP_Ltr__c, MTD_GP__c, Financial_Year__c, Opportunity_Code__c, IsCreatedfromVF__c, MTD_Focussed_Volume__c, Account.Activation_Date__c  
                   FROM Opportunity  
                       where 
                       AccountId=:accId and recordtype.DeveloperName = 'Monthly_Plan' 
                       AND Financial_Year__c= :fys.name
                       //AND closeDate >= : fys.StartDate AND closeDate <= : fys.EndDate
                       order by Month_Actual__c ]; // and Month_Actual__c >= : actualMonth 
            
            for(Opportunity o: lst){
                system.debug('oppppp'+o.id);
            }
            
            if(lst.size()>0)
            {
                activationDate = lst[0].Account.Activation_Date__c;
            }
                                    
        }
        return lst;      
    }
    
        
    @AuraEnabled
    public static Account account_Details(String accId){
        
        Account acc=[SELECT Id, Name, Ship_to_Code__c, Activation_Date__c FROM Account WHERE Id=:accId LIMIT 1];
        
        return acc; 
    }
    
    @AuraEnabled
    public static String saveLatestEstimate(List<Opportunity> lst){
        String msg='';
        try{
            
            update lst;
            msg='Latest estimate has been saved.';
            
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            msg='There is some Error';
        }
        return msg;
    }
    
    /* @AuraEnabled
    public static Decimal getMtdgp() {
    
    AggregateResult[] groupedResults = [SELECT SUM(LY_Volume__c) mtdgp  FROM Opportunity where recordtype.DeveloperName = 'Monthly_Plan' ];
       Decimal mtdgp= (Decimal)groupedResults[0].get('mtdgp');
        system.debug('*****sum' +mtdgp); 
   return mtdgp;
   
   
    }*/
    
   
   //Added by Padmini
    
    @AuraEnabled
    public static Decimal getLyvol(String accId){
     
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     
      
    List<Opportunity> opp_Tmp = [SELECT LY_Volume__c FROM Opportunity where  AccountId= :accId and recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name order by Month_Actual__c];
    
     Decimal tempSum = 0.00;
     for(Opportunity opp1: opp_Tmp ){
       tempSum += opp1.LY_Volume__c;
     }
        system.debug('*******' + tempsum);
        return tempSum;
        
        
    }

     @AuraEnabled
    public static Decimal getLygpltr(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT LY_Volume__c ,LY_GP__c,LY_GP_ltr__c FROM Opportunity where  AccountId= :accId and recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     Decimal tempSum1 = 0.00;
     Decimal totalgpltr = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += (opp1.LY_GP__c*100000);
       tempSum1 += opp1.LY_Volume__c;
       
     }
     
     if(tempSum1==0.00)
         totalgpltr = 0.00;
     else
         totalgpltr = (((tempSum/100000)/tempSum1) *0.001)*100000;
     
     system.debug('lygp**'+tempSum );
     system.debug('lyvol**'+tempSum1 );
     system.debug('lygpltr**'+totalgpltr );
    // totalgpltr =0;
        return totalgpltr;
    }
    
    @AuraEnabled
    public static Decimal getAccpotential(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Account_Potential__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.Account_Potential__c;
     }
        return tempSum;
    }
    
    @AuraEnabled
    public static Decimal getMonthvol(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Planned_Volume__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.Planned_Volume__c;
     }
        return tempSum;
    }
    
    @AuraEnabled
    public static Decimal getMonthgpltr(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Planned_Volume__c,Planned_GP__c ,Planned_GP_Ltr__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     Decimal tempSum1 = 0.00;
     Decimal totalmonthgpltr = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.Planned_GP__c;
       tempSum1 += opp1.Planned_Volume__c;
     }
     
     if(tempSum1==0.00)
         totalmonthgpltr = 0.00;
     else
         totalmonthgpltr = (((tempSum/100000)/tempSum1) *0.001)*100000;
     
     return totalmonthgpltr;
    }
    
    @AuraEnabled
    public static Decimal getMonthgp(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Planned_GP__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.Planned_GP__c;
     }
        return tempSum/100000;
    }
    
    @AuraEnabled
    public static Decimal getLatestvol(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Latest_Est_Volume__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.Latest_Est_Volume__c;
     }
        return tempSum;
    }
    
    @AuraEnabled
    public static Decimal getLatestgpltr(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Latest_Est_Volume__c ,Latest_Est_GP__c ,Latest_Est_GP_ltr__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     Decimal tempSum1 = 0.00;
     Decimal totalSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
      
       tempSum1 += opp1.Latest_Est_Volume__c;
       tempSum += opp1.Latest_Est_GP__c;
       
     }
     
     if(tempSum1==0.00)
         totalSum = 0.00;
     else
         totalSum = (((tempSum/100000)/ tempSum1 )*0.001)*100000;
     
     system.debug('latest gp ltr: '+totalSum);
     return totalSum;
    }
    
    @AuraEnabled
    public static Decimal getLatestgp(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT Latest_Est_GP__c FROM Opportunity where AccountId= :accId and  recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.Latest_Est_GP__c;
       system.debug('Latest GP: '+tempSum/100000);
     }
     tempSum = tempSum/100000;
     return tempSum;
    }
    
    @AuraEnabled
    public static Decimal getActualvol(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT MTD_Volume__c FROM Opportunity where AccountId= :accId and recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.MTD_Volume__c;
     }
        return tempSum;
    }
    
    @AuraEnabled
    public static Decimal getActualgpltr(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT MTD_Volume__c,MTD_GP__c,MTD_GP_Ltr__c FROM Opportunity where AccountId= :accId and recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     Decimal tempSum1 = 0.00;
     Decimal totalSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += (opp1.MTD_GP__c*100000);
       tempSum1 += opp1.MTD_Volume__c;
       
     }
     
     if(tempSum1==0.00)
         totalSum = 0.00;
     else
         totalSum = (((tempSum/100000)/ tempSum1 )*0.001)*100000;
     
     return totalSum;
    }
    
    @AuraEnabled
    public static Decimal getActualgp(String accId){
     List<FiscalYearSettings> fysLst =findFiscalYearSettings();
     FiscalYearSettings fys = fysLst.get(0);
     List<Opportunity> opp_Tmp = [SELECT MTD_GP__c FROM Opportunity where AccountId= :accId and recordtype.DeveloperName = 'Monthly_Plan' and Financial_Year__c= :fys.name ];
     Decimal tempSum = 0.00;
     for(Opportunity opp1:opp_Tmp){
       tempSum += opp1.MTD_GP__c;
     }
        return tempSum;
    }
    
    
        @AuraEnabled
    public static List<Opportunity> getSumOfCreditsList(String accId){
    
    return null;

    }
    
    @AuraEnabled
    public static Boolean getEditableMonthlyPlan(){
         
        Boolean flg = false;
        system.debug('activation date: '+activationDate);
        Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
                            
        if(vu.For_new_Activation__c!=null && activationDate!=null)
        {
            activationDate = activationDate.addDays(Integer.valueOf(vu.For_new_Activation__c));
        }
        if((activationDate!=null && System.TODAY()<=activationDate) || System.TODAY()<=vu.Planned_Data_Open_Till__c)
        {
            flg = true;
        }
        
        system.debug('my flag: '+flg); 
        return flg;
    }
    
    @AuraEnabled
    public Static Boolean isEditableAllLE()
    {
        Boolean bl = false;
        Valvoline_Utility__c vu= Valvoline_Utility__c.getInstance();
        
        if(vu.Is_Editable_All_Latest_Estimate__c==true)
        {
            bl = true;
        }
        return bl;
    }

    
}