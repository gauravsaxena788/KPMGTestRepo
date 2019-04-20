Global with sharing class PMTreport{

    public List<string> accountRecordType;
    public String periodtype{get;set;}
    public Static String currentUserId{get;set;}
    public Static String currentUserName{get;set;}
    public Static String fysYear{get;set;}
    Public List<Opportunity> opList{get;set;}
    public Static String cumminSegment{get;set;}
    public Static String industrialSegment{get;set;}
    public Static String infraSegment{get;set;}
    public Static String PowergenSegment{get;set;}
    public Static String IndusDirSegment{get;set;}
    public Static String InfraDirSegment{get;set;}


////////////////////////////////////////////////////////Lubes Volume //////////////////////////////////////////////////////////
    
    public Transient list<WrapperCumminsMTD> lubesCumminsWrapListMTD{get;set;}
    public Transient list<WrapperCumminsLY> lubesCumminsWrapListLY{get;set;}
    public Transient list<WrapperCumminsEst> lubesCumminsWrapListEst{get;set;}
    
    public Transient list<WrapperIndustrialMTD> lubesIndustrialWrapListMTD{get;set;}
    public Transient list<WrapperIndustrialLY> lubesIndustrialWrapListLY{get;set;}
    public Transient list<WrapperIndustrialEst> lubesIndustrialWrapListEst{get;set;}
    
    public  list<aopWrapper> aopWrapperList{get;set;}
    public  list<aopWrapperGp> aopGpWrapperList{get;set;}
    public  list<aopWrapperGpPerL> aopGpPerLWrapperList{get;set;}
    public  list<cogWrapper> cogMovementWrapperList{get;set;}
    
    public Transient list<WrapperInfraMTD> lubesInfraWrapListMTD{get;set;}
    public Transient list<WrapperInfraLY> lubesInfraWrapListLY{get;set;}
    public Transient list<WrapperInfraEst> lubesInfraWrapListEst{get;set;}
    
    public Transient list<WrapperPowergenMTD> lubesPowergenWrapListMTD{get;set;}
    public Transient list<WrapperPowergenLY> lubesPowergenWrapListLY{get;set;}
    public Transient list<WrapperPowergenEst> lubesPowergenWrapListEst{get;set;} 
    
    public Transient list<WrapperIndusDirMTD> lubesIndusDirWrapListMTD{get;set;}
    public Transient list<WrapperIndusDirLY> lubesIndusDirWrapListLY{get;set;}
    public Transient list<WrapperIndusDirEst> lubesIndusDirWrapListEst{get;set;}
    
    public Transient list<WrapperInfraDirMTD> lubesInfraDirWrapListMTD{get;set;}
    public Transient list<WrapperInfraDirLY> lubesInfraDirWrapListLY{get;set;}
    public Transient list<WrapperInfraDirEst> lubesInfraDirWrapListEst{get;set;}

//////////////////////////////////////////////////////////End Of Lubes Volume/////////////////////////////////////////////////

    public Transient list<WrapperCumminsGPMTD> lubesCumminsGPWrapListMTD{get;set;}
    public Transient list<WrapperCumminsGPLY> lubesCumminsGPWrapListLY {get;set;}
    public Transient list<WrapperCumminsGPEst> lubesCumminsGPWrapListEst {get;set;}
    
    public Transient list<WrapperIndustrialGPMTD> lubesIndustrialGPWrapListMTD  {get;set;}
    public Transient list<WrapperIndustrialGPLY> lubesIndustrialGPWrapListLY  {get;set;}
    public Transient list<WrapperIndustrialGPEst> lubesIndustrialGPWrapListEst  {get;set;}
    
    public Transient list<WrapperInfraGPMTD> lubesInfraGPWrapListMTD  {get;set;}
    public Transient list<WrapperInfraGPLY> lubesInfraGPWrapListLY  {get;set;}
    public Transient list<WrapperInfraGPEst> lubesInfraGPWrapListEst  {get;set;}
    
    public Transient list<WrapperPowergenGPMTD> lubesPowergenGPWrapListMTD  {get;set;}
    public Transient list<WrapperPowergenGPLY> lubesPowergenGPWrapListLY  {get;set;}
    public Transient list<WrapperPowergenGPEst> lubesPowergenGPWrapListEst  {get;set;}
    
    public Transient list<WrapperIndusDirGPMTD> lubesIndusDirGPWrapListMTD  {get;set;}
    public Transient list<WrapperIndusDirGPLY> lubesIndusDirGPWrapListLY  {get;set;}
    public Transient list<WrapperIndusDirGPEst> lubesIndusDirGPWrapListEst  {get;set;}
    
    public Transient list<WrapperInfraDirGPMTD> lubesInfraDirGPWrapListMTD  {get;set;}
    public Transient list<WrapperInfraDirGPLY> lubesInfraDirGPWrapListLY  {get;set;}
    public Transient list<WrapperInfraDirGPEst> lubesInfraDirGPWrapListEst  {get;set;}
    
    
    
    public map<string , string> monthVsCount {get ; set ;}
    
    
//////////////////////////////////////////////////////////End Of Gp Lubes Volume/////////////////////////////////////////////////        
   
   
    public Transient list<WrapperCumminsGPperLMTD> lubesCumminsGPperLWrapListMTD{get;set;}
    public Transient list<WrapperCumminsGPperLLY> lubesCumminsGPperLWrapListLY {get;set;}
    public Transient list<WrapperCumminsGPperLEst> lubesCumminsGPperLWrapListEst {get;set;}
    
    public Transient list<WrapperIndustrialGPperLMTD> lubesIndustrialGPperLWrapListMTD  {get;set;}
    public Transient list<WrapperIndustrialGPperLLY> lubesIndustrialGPperLWrapListLY  {get;set;}
    public Transient list<WrapperIndustrialGPperLEst> lubesIndustrialGPperLWrapListEst  {get;set;}
    
    public Transient list<WrapperInfraGPperLMTD> lubesInfraGPperLWrapListMTD  {get;set;}
    public Transient list<WrapperInfraGPperLLY> lubesInfraGPperLWrapListLY  {get;set;}
    public Transient list<WrapperInfraGPperLEst> lubesInfraGPperLWrapListEst  {get;set;}
    
    public Transient list<WrapperPowergenGPperLMTD> lubesPowergenGPperLWrapListMTD  {get;set;}
    public Transient list<WrapperPowergenGPperLLY> lubesPowergenGPperLWrapListLY  {get;set;}
    public Transient list<WrapperPowergenGPperLEst> lubesPowergenGPperLWrapListEst  {get;set;}
    
    public Transient list<WrapperIndusDirGPperLMTD> lubesIndusDirGPperLWrapListMTD  {get;set;}
    public Transient list<WrapperIndusDirGPperLLY> lubesIndusDirGPperLWrapListLY  {get;set;}
    public Transient list<WrapperIndusDirGPperLEst> lubesIndusDirGPperLWrapListEst  {get;set;}
    
    public Transient list<WrapperInfraDirGPperLMTD> lubesInfraDirGPperLWrapListMTD  {get;set;}
    public Transient list<WrapperInfraDirGPperLLY> lubesInfraDirGPperLWrapListLY  {get;set;}
    public Transient list<WrapperInfraDirGPperLEst> lubesInfraDirGPperLWrapListEst  {get;set;}
   
 //////////////////////////////////////////////////////////End Of Gp/L Lubes Volume/////////////////////////////////////////////////  
 
 
    public list<WrapperCumminsNSPperLMTD> lubesCumminsNSPperLWrapListMTD{get;set;}
    public list<WrapperCumminsNSPperLLY> lubesCumminsNSPperLWrapListLY {get;set;}
    public list<WrapperCumminsNSPperLEst> lubesCumminsNSPperLWrapListEst {get;set;}
    public list<WrapperCumminsNSPperLPrice> lubesCumminsNSPperLWrapListPrice {get;set;}
    
    public list<WrapperIndustrialNSPperLMTD> lubesIndustrialNSPperLWrapListMTD  {get;set;}
    public list<WrapperIndustrialNSPperLLY> lubesIndustrialNSPperLWrapListLY  {get;set;}
    public list<WrapperIndustrialNSPperLEst> lubesIndustrialNSPperLWrapListEst  {get;set;}
    public list<WrapperIndustrialNSPperLPrice> lubesIndustrialNSPperLWrapListPrice  {get;set;}
    
    public list<WrapperInfraNSPperLMTD> lubesInfraNSPperLWrapListMTD  {get;set;}
    public list<WrapperInfraNSPperLLY> lubesInfraNSPperLWrapListLY  {get;set;}
    public list<WrapperInfraNSPperLEst> lubesInfraNSPperLWrapListEst  {get;set;}
    public list<WrapperInfraNSPperLPrice> lubesInfraNSPperLWrapListPrice  {get;set;}
    
    public list<WrapperPowergenNSPperLMTD> lubesPowergenNSPperLWrapListMTD  {get;set;}
    public list<WrapperPowergenNSPperLLY> lubesPowergenNSPperLWrapListLY  {get;set;}
    public list<WrapperPowergenNSPperLEst> lubesPowergenNSPperLWrapListEst  {get;set;}
    public list<WrapperPowergenNSPperLPrice> lubesPowergenNSPperLWrapListPrice  {get;set;}
    
    public list<WrapperIndusDirNSPperLMTD> lubesIndusDirNSPperLWrapListMTD  {get;set;}
    public list<WrapperIndusDirNSPperLLY> lubesIndusDirNSPperLWrapListLY  {get;set;}
    public list<WrapperIndusDirNSPperLEst> lubesIndusDirNSPperLWrapListEst  {get;set;}
    public list<WrapperIndusDirNSPperLPrice> lubesIndusDirNSPperLWrapListPrice  {get;set;}
    
    public list<WrapperInfraDirNSPperLMTD> lubesInfraDirNSPperLWrapListMTD  {get;set;}
    public list<WrapperInfraDirNSPperLLY> lubesInfraDirNSPperLWrapListLY  {get;set;}
    public list<WrapperInfraDirNSPperLEst> lubesInfraDirNSPperLWrapListEst  {get;set;}
    public list<WrapperInfraDirNSPperLPrice> lubesInfraDirNSPperLWrapListPrice  {get;set;}
   
 //////////////////////////////////////////////////////////End Of NSP/L Lubes Volume/////////////////////////////////////////////////  
    
    
    public  list<string> monthList{get;set;}
    public PMTreport(){
        monthVsCount =  new map<string , string>();
        accountRecordType = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
        getBasicDetails();      
        opList = new List<Opportunity>();
        checkPeriodType();
        monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};
        getOpportunityList(monthList);
    }
     //picklist for period
   public List<selectOption> getperiodtypelist() {
        
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        options.add(new SelectOption('H1', 'H1'));
        options.add(new SelectOption('H2','H2'));
        options.add(new SelectOption('T1', 'T1'));
        options.add(new SelectOption('T2','T2'));
        options.add(new SelectOption('T3', 'T3'));
        options.add(new SelectOption('T4','T4    '));
        options.add(new SelectOption('Q1', 'Q1'));
        options.add(new SelectOption('Q2','Q2'));
        
        return options; //return the picklist options
    }
     public PageReference checkPeriodType()
        {
            
            if(periodtype=='H1')
            {
                monthList = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar'};

                getOpportunityList(monthList);
            }
            else if(periodtype =='H2')
            {
                 monthList = new list<string>{'Apr','May','Jun','Jul','Aug','Sep'};

                getOpportunityList(monthList );
            }
            else if(periodtype =='T1')
            {
                 monthList = new list<string>{'Oct','Nov','Dec'};

                getOpportunityList(monthList );
            }
            else if(periodtype =='T2')
            {
                 monthList = new list<string>{'Jan','Feb','Mar'};

                getOpportunityList(monthList );
            }
            else if(periodtype =='T3')
            {
                 monthList = new list<string>{'Apr','May','Jun'};

                getOpportunityList(monthList );
            }
            else if(periodtype =='T4')
            {
                 monthList = new list<string>{'Jul','Aug','Sep'};

                getOpportunityList(monthList );
            }
            else if(periodtype =='Q1')
            {
                 monthList = new list<string>{'Oct','Nov','Dec','Jan'};

                getOpportunityList(monthList );
            }
            else if(periodtype =='Q2')
            {
                 monthList = new list<string>{'Feb','Mar','Apr','May'};

                getOpportunityList(monthList );
            }
                
            return null;
        }
        
    public PageReference getOpportunityList(list<string> monthString)
    {
        PageReference pg = new PageReference('/Monthly_Latest_Estimate');
        pg.setRedirect(true);
        
        getBasicDetails();
        
        return getOpportunityMonthly(monthString);
        
    }
    
    public static void getBasicDetails(){
        
        currentUserId = UserInfo.getUserId();
        User u = [select Name from User u where u.id = :currentUserId];
        currentUserName = u.Name;
        
        //FiscalYearSettings
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            fysYear = fys.Name;
        }
    }
    
     public PageReference getOpportunityMonthly(list<string> monthString){
        PageReference pg = new PageReference('/Monthly_Latest_Estimate');
        pg.setRedirect(true); 
        currentUserId = UserInfo.getUserId();
        
        List<FiscalYearSettings> fysLst =findFiscalYearSettings();
        List<Opportunity> lst = new List<Opportunity>();
        if(!fysLst.isEmpty()){
            FiscalYearSettings fys = fysLst.get(0);
            
            
            ////////////////////////////////////////////// Start Of Aop AND COGS Movement ////////////////////////////////////////////////////////
            
            aopWrapperList = new list<aopWrapper>();
            aopGpWrapperList = new list<aopWrapperGp>();
            aopGpPerLWrapperList = new list<aopWrapperGpPerL>();
            cogMovementWrapperList = new list<cogWrapper>();
            list<cogWrapper> cogMovementTemp = new list<cogWrapper>();
            
            map<string,decimal> mapOfMonthVsTotalLubes = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsTotalLubesGp = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsTotalLubesGpPerL = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsTotalCOGSValue = new map<string,decimal>();//where AOP_Plan_User__c =: currentUserId
            
            //list< AOP_Line__c > aopList = [select id, AOP_Plan_User__c, Month__c, AOP_Regional_Vol_in_kL__c, AOP_National_Vol_in_kL__c,Monthly_AOP_Regional_Lubes_GP_Ltr__c, Monthly_AOP_National_Lubes_GP_Ltr__c, AOP_Regional_GP__c, AOP_National_GP__c from AOP_Line__c where AOP__r.Valvoline_Financial_Year__c = :fys.name];  
            
            //system.debug(aopList);
            decimal aopcountLubes = 0.0;
            decimal aopcountLubesGp = 0.0;
            decimal aopcountLubesGpPerL = 0.0;
            for(AOP_Line__c aopObj : [select id, AOP_Plan_User__c, Month__c, AOP_Regional_Vol_in_kL__c, AOP_National_Vol_in_kL__c,Monthly_AOP_Regional_Lubes_GP_Ltr__c, Monthly_AOP_National_Lubes_GP_Ltr__c, AOP_Regional_GP__c, AOP_National_GP__c from AOP_Line__c where AOP__r.Valvoline_Financial_Year__c = :fys.name]){
                
                
                if(aopObj.AOP_Regional_Vol_in_kL__c + aopObj.AOP_National_Vol_in_kL__c == null){
                    aopcountLubes += 0.00;
                }
                else{
                    if(mapOfMonthVsTotalLubes.containsKey(aopObj.Month__c)){
                        aopcountLubes  += aopObj.AOP_Regional_Vol_in_kL__c + aopObj.AOP_National_Vol_in_kL__c + mapOfMonthVsTotalLubes.get(aopObj.Month__c);
                    }
                    else{
                        aopcountLubes  += aopObj.AOP_Regional_Vol_in_kL__c + aopObj.AOP_National_Vol_in_kL__c;
                    }
                }
                if(aopObj.AOP_Regional_GP__c + aopObj.AOP_National_GP__c == null){
                    aopcountLubesGp +=0.00;
                }
                else{
                    if(mapOfMonthVsTotalLubesGp.containsKey(aopObj.Month__c)){
                        aopcountLubesGp += aopObj.AOP_Regional_GP__c + aopObj.AOP_National_GP__c + mapOfMonthVsTotalLubesGp.get(aopObj.Month__c);
                    }
                    else{
                        aopcountLubesGp += aopObj.AOP_Regional_GP__c + aopObj.AOP_National_GP__c ;
                    }
                }
                if(aopObj.Monthly_AOP_Regional_Lubes_GP_Ltr__c + aopObj.Monthly_AOP_National_Lubes_GP_Ltr__c == null){
                    aopcountLubesGpPerL += 0.00;
                }
                else{
                    if(mapOfMonthVsTotalLubesGpPerL.containsKey(aopObj.Month__c)){
                        aopcountLubesGpPerL += aopObj.Monthly_AOP_Regional_Lubes_GP_Ltr__c + aopObj.Monthly_AOP_National_Lubes_GP_Ltr__c + mapOfMonthVsTotalLubesGpPerL.get(aopObj.Month__c);
                    }
                    else{
                        aopcountLubesGpPerL += aopObj.Monthly_AOP_Regional_Lubes_GP_Ltr__c + aopObj.Monthly_AOP_National_Lubes_GP_Ltr__c;
                    }
                }
                
                
                
                mapOfMonthVsTotalLubes.put(aopObj.Month__c,aopcountLubes);
                mapOfMonthVsTotalLubesGp.put(aopObj.Month__c,aopcountLubesGp);
                mapOfMonthVsTotalLubesGpPerL.put(aopObj.Month__c,aopcountLubesGpPerL);
                aopcountLubes = 0.0;
                aopcountLubesGp = 0.0;
                aopcountLubesGpPerL = 0.0;
                
            }  
            system.debug(mapOfMonthVsTotalLubes);
            //list<COGS_Movement__c> cogsList = [select id, COGS_Value__c, Financial_Yr__c, Monthly_Plan_Mon__c from COGS_Movement__c where Financial_Yr__c = :fys.name];            
            for(COGS_Movement__c cogsObj : [select id, COGS_Value__c, Financial_Yr__c, Monthly_Plan_Mon__c from COGS_Movement__c where Financial_Yr__c = :fys.name]){
                mapOfMonthVsTotalCOGSValue.put(cogsObj.Monthly_Plan_Mon__c,cogsObj.COGS_Value__c); 
            }
            
            
           set<string> blankMonthString = new set<string>();
           
            decimal constanvalue;
            set<string> test = new set<string>();
            list<string> s = new list<string>{'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep'};
            if(periodtype =='H2'){
                //monthString.clear();
                monthString =s ;
            }
           
            for(string str : monthString){
               constanvalue =0.00;
                if(mapOfMonthVsTotalCOGSValue.get(str) != null){
                    
                    if( mapOfMonthVsTotalCOGSValue.get(str)!=null){
                        constanvalue = mapOfMonthVsTotalCOGSValue.get(str);
                    } 
                    if(mapOfMonthVsTotalCOGSValue.containsKey(str) ){ 
                       if(!test.contains(str)){         
                                    cogWrapper cogObj = new cogWrapper();
                                    cogObj.cogsCount = constanvalue ;
                                    cogObj.monthName  = str ;
                                    cogMovementWrapperList.add(cogObj); 
                                    test.add(str);
                          }      
                         
                        for(integer i = monthString.indexOf(str)+1; i<monthString.size() ; i++){
                            system.debug(monthString[i]);
                            blankMonthString.add(monthString[i]); 
                           if(!mapOfMonthVsTotalCOGSValue.containsKey(monthString[i])){ 
                                 if(!test.contains(monthString[i])){         
                                    cogWrapper cogObj = new cogWrapper();
                                    cogObj.cogsCount = constanvalue ;
                                    cogObj.monthName  = monthString[i] ;
                                    cogMovementWrapperList.add(cogObj); 
                                    test.add(monthString[i]);
                                   }                                 
                             }else break;
                        } 
                    }                
              }else{
                        if(!test.contains(str)){ 
                        cogWrapper cogObj = new cogWrapper();
                        cogObj.cogsCount = constanvalue ;
                        cogObj.monthName  = str;
                        cogMovementWrapperList.add(cogObj); 
                        test.add(str);
                        }
                        }

            } 
            map<string, decimal> mapOfmonthVsUpdatedCogsValue = new map<string, decimal>();
            for(cogWrapper cogObj : cogMovementWrapperList ){
                mapOfmonthVsUpdatedCogsValue.put(cogObj.monthName , cogObj.cogsCount); 
            }
            system.debug(mapOfmonthVsUpdatedCogsValue);
            if(periodtype =='H2'){
                    monthString.clear();
                    monthString = new list<string>{'Apr','May','Jun','Jul','Aug','Sep'};
                   
                for(cogWrapper wr:cogMovementWrapperList){
                    if(monthString.contains(wr.monthName)){
                        cogMovementTemp.add(wr);
                    }
                }
                cogMovementWrapperList.clear();
                    cogMovementWrapperList= cogMovementTemp;
                 
            }
            
            system.debug(cogMovementWrapperList);
               
            for(string str : blankMonthString ){
                 mapOfMonthVsTotalCOGSValue.put(str,constanvalue); 
               
            } 
            
            for(string str : monthString){
                if(mapOfMonthVsTotalLubes.containsKey(str)){
                    aopWrapper wrapObj = new aopWrapper();
                    wrapObj.count = mapOfMonthVsTotalLubes.get(str);
                    aopWrapperList.add(wrapObj);
                }
                else{
                    aopWrapper wrapObj = new aopWrapper();
                    wrapObj.count = 0.00;
                    aopWrapperList.add(wrapObj);
                }
                if(mapOfMonthVsTotalLubesGp.containsKey(str)){
                    aopWrapperGp gpObj = new aopWrapperGp();
                    gpObj.count = mapOfMonthVsTotalLubesGp.get(str);
                    aopGpWrapperList.add(gpObj); 
                }
                else{
                    aopWrapperGp gpObj = new aopWrapperGp();
                    gpObj.count = 0.00;
                    aopGpWrapperList.add(gpObj); 
                }
                if(mapOfMonthVsTotalLubesGpPerL.containsKey(str)){
                    aopWrapperGpPerL gpPerLObj = new aopWrapperGpPerL();
                    gpPerLObj .count = mapOfMonthVsTotalLubesGpPerL.get(str);
                    aopGpPerLWrapperList.add(gpPerLObj);
                }
                else{
                    aopWrapperGpPerL gpPerLObj = new aopWrapperGpPerL();
                    gpPerLObj .count = 0.00;
                    aopGpPerLWrapperList.add(gpPerLObj);
                }
                
                
                
                /*
                if(mapOfMonthVsTotalCOGSValue.containsKey(str)){                 
                    cogWrapper cogObj = new cogWrapper();
                    cogObj.cogsCount = mapOfMonthVsTotalCOGSValue.get(str);
                    cogObj.monthName  = str;
                    cogMovementWrapperList.add(cogObj);
                }else{
                    cogWrapper cogObj = new cogWrapper();
                    cogObj.cogsCount = 0.00;//mapOfMonthVsTotalCOGSValue.get(str);
                    cogObj.monthName  = str;
                    cogMovementWrapperList.add(cogObj);
                } */
                 
            }
            
            ////////////////////////////////////////////// End Of Aop AND COGS Movement ////////////////////////////////////////////////////////   
            
           
           
           /////////////////////////////////////////////////// start of Lubes Volume (KL) ///////////////////////////////////////////
           
            lubesCumminsWrapListMTD = new List<WrapperCumminsMTD>();
            lubesCumminsWrapListLY = new List<WrapperCumminsLY>();
            lubesCumminsWrapListEst = new List<WrapperCumminsEst>();
            
            lubesIndustrialWrapListMTD  = new list<WrapperIndustrialMTD>();
            lubesIndustrialWrapListLY  = new list<WrapperIndustrialLY>();
            lubesIndustrialWrapListEst  = new list<WrapperIndustrialEst>();
            
            lubesInfraWrapListMTD  = new list<WrapperInfraMTD>();
            lubesInfraWrapListLY  = new list<WrapperInfraLY>();
            lubesInfraWrapListEst  = new list<WrapperInfraEst>();
            
            lubesPowergenWrapListMTD  = new list<WrapperPowergenMTD>();
            lubesPowergenWrapListLY  = new list<WrapperPowergenLY>();
            lubesPowergenWrapListEst  = new list<WrapperPowergenEst>();
            
            lubesIndusDirWrapListMTD  = new list<WrapperIndusDirMTD>();
            lubesIndusDirWrapListLY  = new list<WrapperIndusDirLY>();
            lubesIndusDirWrapListEst  = new list<WrapperIndusDirEst>();
            
            lubesInfraDirWrapListMTD  = new list<WrapperInfraDirMTD>();
            lubesInfraDirWrapListLY  = new list<WrapperInfraDirLY>();
            lubesInfraDirWrapListEst  = new list<WrapperInfraDirEst>();
            
            
            
            
            cumminSegment = 'Cummins Dealer';
            industrialSegment = 'Industrial -ID';
            infraSegment = 'Infra';
            PowergenSegment = 'Powergen';
            IndusDirSegment = 'Industrial - Direct';
            InfraDirSegment = 'Infra - Direct';
           
            map<string,decimal> mapOfMonthVsCumminMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsPowerMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusDirMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraDirMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirESTCount = new map<string,decimal>();
            
            
            //list<opportunity> oppList = [select account.Final_Segment__c, Latest_Est_Lubes_Volume__c, Monthly_Plan_Month__c, LY_Lubes_Vol__c, MTD_NON_AUS_Volume__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    //AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')]; 
            
           
                decimal mtdCumminCount = 0.00;
                decimal lyCumminCount = 0.00;
                decimal estCumminCount = 0.00;
                
                decimal mtdIndusCount = 0.00;
                decimal lyIndusCount = 0.00;
                decimal estIndusCount = 0.00;
                
                decimal mtdInfraCount = 0.00;
                decimal lyInfraCount = 0.00;
                decimal estInfraCount = 0.00;
                
                decimal mtdPowerCount = 0.00;
                decimal lyPowerCount = 0.00;
                decimal estPowerCount = 0.00;
                
                decimal mtdIndusDirCount = 0.00;
                decimal lyIndusDirCount = 0.00;
                decimal estIndusDirCount = 0.00;
                
                decimal mtdInfraDirCount = 0.00;
                decimal lyInfraDirCount = 0.00;
                decimal estInfraDirCount = 0.00;
            
            for(opportunity opt: [select account.Final_Segment__c, Latest_Est_Lubes_Volume__c, Monthly_Plan_Month__c, LY_Lubes_Vol__c, MTD_NON_AUS_Volume__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')]){
                
                
                if(opt.account.Final_Segment__c == 'Cummins Dealer'){
                    
                    if( mapOfMonthVsCumminMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdCumminCount += opt.MTD_NON_AUS_Volume__c + mapOfMonthVsCumminMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        mtdCumminCount += opt.MTD_NON_AUS_Volume__c;
                    }
                    
                    if(mapOfMonthVsCumminLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyCumminCount += opt.LY_Lubes_Vol__c + mapOfMonthVsCumminLYCount.get(opt.Monthly_Plan_Month__c);
                    } 
                    else{
                        lyCumminCount += opt.LY_Lubes_Vol__c;
                    }
                    if( mapOfMonthVsCumminESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estCumminCount += opt.Latest_Est_Lubes_Volume__c + mapOfMonthVsCumminESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estCumminCount += opt.Latest_Est_Lubes_Volume__c ;
                    }
                         mapOfMonthVsCumminMtdCount.put(opt.Monthly_Plan_Month__c,mtdCumminCount);
                         mapOfMonthVsCumminLYCount.put(opt.Monthly_Plan_Month__c,lyCumminCount);
                         mapOfMonthVsCumminESTCount.put(opt.Monthly_Plan_Month__c,estCumminCount);
                         mtdCumminCount = 0.00;
                         lyCumminCount = 0.00;
                         estCumminCount = 0.00;
                } 
                    
                if(opt.account.Final_Segment__c == 'Industrial - ID'){
                    if(mapOfMonthVsIndusMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdIndusCount += opt.MTD_NON_AUS_Volume__c + mapOfMonthVsIndusMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        mtdIndusCount += opt.MTD_NON_AUS_Volume__c;
                    }
                    if(mapOfMonthVsInfraLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyIndusCount += opt.LY_Lubes_Vol__c + mapOfMonthVsInfraLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyIndusCount += opt.LY_Lubes_Vol__c;
                    }
                    if(mapOfMonthVsIndusESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estIndusCount += opt.Latest_Est_Lubes_Volume__c + mapOfMonthVsIndusESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estIndusCount += opt.Latest_Est_Lubes_Volume__c;
                    }
                    
                    mapOfMonthVsIndusMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusCount);
                    mapOfMonthVsIndusLYCount.put(opt.Monthly_Plan_Month__c,lyIndusCount); 
                    mapOfMonthVsIndusESTCount.put(opt.Monthly_Plan_Month__c,estIndusCount);
                    mtdIndusCount = 0.0;
                    lyIndusCount = 0.0;
                    estIndusCount = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Infra - ID'){
                    if(mapOfMonthVsInfraMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdInfraCount += opt.MTD_NON_AUS_Volume__c + mapOfMonthVsInfraMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        mtdInfraCount += opt.MTD_NON_AUS_Volume__c;
                    }
                    if(mapOfMonthVsInfraLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyInfraCount += opt.LY_Lubes_Vol__c + mapOfMonthVsInfraLYCount.get(opt.Monthly_Plan_Month__c) ;
                    }
                    else{
                        lyInfraCount += opt.LY_Lubes_Vol__c;
                    }
                    if(mapOfMonthVsInfraESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estInfraCount += opt.Latest_Est_Lubes_Volume__c + mapOfMonthVsInfraESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estInfraCount += opt.Latest_Est_Lubes_Volume__c;
                    }
                    
                    mapOfMonthVsInfraMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraCount);
                    mapOfMonthVsInfraLYCount.put(opt.Monthly_Plan_Month__c,lyInfraCount);
                    mapOfMonthVsInfraESTCount.put(opt.Monthly_Plan_Month__c,estInfraCount);
                    mtdInfraCount = 0.0;
                    lyInfraCount = 0.0;
                    estInfraCount = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Powergen'){
                    if(mapOfMonthVsPowerMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdPowerCount += opt.MTD_NON_AUS_Volume__c + mapOfMonthVsPowerMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        mtdPowerCount += opt.MTD_NON_AUS_Volume__c;
                    }
                    if(mapOfMonthVsPowerLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyPowerCount += opt.LY_Lubes_Vol__c + mapOfMonthVsPowerLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyPowerCount += opt.LY_Lubes_Vol__c;
                    }
                    if(mapOfMonthVsPowerESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estPowerCount += opt.Latest_Est_Lubes_Volume__c + mapOfMonthVsPowerESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estPowerCount += opt.Latest_Est_Lubes_Volume__c;
                    }
                    
                    mapOfMonthVsPowerMtdCount.put(opt.Monthly_Plan_Month__c,mtdPowerCount);
                    mapOfMonthVsPowerLYCount.put(opt.Monthly_Plan_Month__c,lyPowerCount);
                    mapOfMonthVsPowerESTCount.put(opt.Monthly_Plan_Month__c,estPowerCount);
                    mtdPowerCount = 0.0;
                    lyPowerCount = 0.0;
                    estPowerCount = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Industrial - Direct'){
                    if(mapOfMonthVsIndusDirMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdIndusDirCount += opt.MTD_NON_AUS_Volume__c + mapOfMonthVsIndusDirMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        mtdIndusDirCount += opt.MTD_NON_AUS_Volume__c;
                    }
                    if(mapOfMonthVsIndusDirLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyIndusDirCount += opt.LY_Lubes_Vol__c + mapOfMonthVsIndusDirLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyIndusDirCount += opt.LY_Lubes_Vol__c;
                    }
                    if(mapOfMonthVsIndusDirESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.Latest_Est_Lubes_Volume__c != null){
                            estIndusDirCount += opt.Latest_Est_Lubes_Volume__c + mapOfMonthVsIndusDirESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estIndusDirCount += mapOfMonthVsIndusDirESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                    }
                    else{
                        if(opt.Latest_Est_Lubes_Volume__c != null){
                            estIndusDirCount += opt.Latest_Est_Lubes_Volume__c;
                        }
                        else{
                            estIndusDirCount += 0.00;
                        }
                    }
                    
                    
                    mapOfMonthVsIndusDirMtdCount.put(opt.Monthly_Plan_Month__c,mtdPowerCount);
                    mapOfMonthVsIndusDirLYCount.put(opt.Monthly_Plan_Month__c,lyPowerCount);
                    mapOfMonthVsIndusDirESTCount.put(opt.Monthly_Plan_Month__c,estPowerCount);
                    mtdIndusDirCount = 0.0;
                    lyIndusDirCount = 0.0;
                    estIndusDirCount = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Infra - Direct'){
                    if(mapOfMonthVsInfraDirMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdInfraDirCount += opt.MTD_NON_AUS_Volume__c + mapOfMonthVsInfraDirMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        mtdInfraDirCount += opt.MTD_NON_AUS_Volume__c;
                    }
                    if(mapOfMonthVsInfraDirLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyInfraDirCount += opt.LY_Lubes_Vol__c + mapOfMonthVsInfraDirLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyInfraDirCount += opt.LY_Lubes_Vol__c;
                    }
                    if(mapOfMonthVsInfraDirESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estInfraDirCount += opt.Latest_Est_Lubes_Volume__c + mapOfMonthVsInfraDirESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estInfraDirCount += opt.Latest_Est_Lubes_Volume__c;
                    }
                    
                    mapOfMonthVsInfraDirMtdCount.put(opt.Monthly_Plan_Month__c,mtdPowerCount);
                    mapOfMonthVsInfraDirLYCount.put(opt.Monthly_Plan_Month__c,lyPowerCount);
                    mapOfMonthVsInfraDirESTCount.put(opt.Monthly_Plan_Month__c,estPowerCount);
                    mtdInfraDirCount = 0.0;
                    lyInfraDirCount = 0.0;
                    estInfraDirCount = 0.0;
                }
            
            }
     ////////////////////////////////////////////////////////   End of Lubes Volume (KL)    /////////////////////////////////////////////////////////////////
     
     
     ////////////////////////////////////////////////////////   Start of GP Lubes /////////////////////////////////////////////////////////////////OwnerId=:currentUserId and
            lubesCumminsGPWrapListMTD = new List<WrapperCumminsGPMTD>();
            lubesCumminsGPWrapListLY = new List<WrapperCumminsGPLY>();
            lubesCumminsGPWrapListEst = new List<WrapperCumminsGPEst>();
            
            lubesIndustrialGPWrapListMTD  = new list<WrapperIndustrialGPMTD>();
            lubesIndustrialGPWrapListLY  = new list<WrapperIndustrialGPLY>();
            lubesIndustrialGPWrapListEst  = new list<WrapperIndustrialGPEst>();
            
            lubesInfraGPWrapListMTD  = new list<WrapperInfraGPMTD>();
            lubesInfraGPWrapListLY  = new list<WrapperInfraGPLY>();
            lubesInfraGPWrapListEst  = new list<WrapperInfraGPEst>();
            
            lubesPowergenGPWrapListMTD  = new list<WrapperPowergenGPMTD>();
            lubesPowergenGPWrapListLY  = new list<WrapperPowergenGPLY>();
            lubesPowergenGPWrapListEst  = new list<WrapperPowergenGPEst>();
            
            lubesIndusDirGPWrapListMTD  = new list<WrapperIndusDirGPMTD>();
            lubesIndusDirGPWrapListLY  = new list<WrapperIndusDirGPLY>();
            lubesIndusDirGPWrapListEst  = new list<WrapperIndusDirGPEst>();
            
            lubesInfraDirGPWrapListMTD  = new list<WrapperInfraDirGPMTD>();
            lubesInfraDirGPWrapListLY  = new list<WrapperInfraDirGPLY>();
            lubesInfraDirGPWrapListEst  = new list<WrapperInfraDirGPEst>();
            
            
            map<string,decimal> mapOfMonthVsCumminGPMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminGPLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminGPESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusGPMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusGPLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusGPESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraGPMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraGPLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraGPESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsPowerGPMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerGPLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerGPESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusDirGPMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirGPLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirGPESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraDirGPMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirGPLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirGPESTCount = new map<string,decimal>();
       
       
       
       
           //list<opportunity> oppListForGp = [select account.Final_Segment__c, MTD_GP_Lubes__c, Monthly_Plan_Month__c, LY_MTD_GP__c, Last_Month_Gp__c,Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c, NSP_change__c, Latest_Est_Lubes_Volume__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    //AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')];     
            
                decimal mtdCumminCountGp = 0.0;
                decimal lyCumminCountGp = 0.0;
                decimal estCumminCountGp = 0.0;
                
                decimal mtdIndusCountGp = 0.0;
                decimal lyIndusCountGp = 0.0;
                decimal estIndusCountGp = 0.0;
                
                decimal mtdInfraCountGp = 0.0;
                decimal lyInfraCountGp = 0.0;
                decimal estInfraCountGp = 0.0;
                
                decimal mtdPowerCountGp = 0.0;
                decimal lyPowerCountGp = 0.0;
                decimal estPowerCountGp = 0.0;
                
                decimal mtdIndusDirCountGp = 0.0;
                decimal lyIndusDirCountGp = 0.0;
                decimal estIndusDirCountGp = 0.0;
                
                decimal mtdInfraDirCountGp = 0.0;
                decimal lyInfraDirCountGp = 0.0;
                decimal estInfraDirCountGp = 0.0;
             
             for(opportunity opt: [select account.Final_Segment__c, MTD_GP_Lubes__c, Monthly_Plan_Month__c, LY_MTD_GP__c, Last_Month_Gp__c,Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c, NSP_change__c, Latest_Est_Lubes_Volume__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')] ){
                
                
                if(opt.account.Final_Segment__c == 'Cummins Dealer'){
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal estLubes = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp += opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange += opt.NSP_change__c;
                    }
                    if(opt.Latest_Est_Lubes_Volume__c == null){
                        estLubes  = 0.0;
                    }
                    else{
                        estLubes += opt.Latest_Est_Lubes_Volume__c;
                    }
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  += mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    
                    
                    if(mapOfMonthVsCumminGPMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.MTD_GP_Lubes__c !=null){
                            mtdCumminCountGp += opt.MTD_GP_Lubes__c + mapOfMonthVsCumminGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdCumminCountGp += mapOfMonthVsCumminGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                    }
                    else{
                        if(opt.MTD_GP_Lubes__c !=null){
                            mtdCumminCountGp += opt.MTD_GP_Lubes__c;
                        }
                        else{
                            mtdCumminCountGp += 0.00;
                        }
                    }
                    if(mapOfMonthVsCumminGPLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyCumminCountGp += opt.LY_MTD_GP__c + mapOfMonthVsCumminGPLYCount.get(opt.Monthly_Plan_Month__c) ;
                    }
                    else{
                        lyCumminCountGp += opt.LY_MTD_GP__c;
                    }
                    if(mapOfMonthVsCumminGPESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estCumminCountGp += (lastmonthOpp  - cogsValue    + nspChange )* estLubes *1000 + mapOfMonthVsCumminGPESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{                    
                        estCumminCountGp += (lastmonthOpp  - cogsValue    + nspChange )* estLubes *1000;
                    } 
                    
                    mapOfMonthVsCumminGPMtdCount.put(opt.Monthly_Plan_Month__c,mtdCumminCountGp);
                    mapOfMonthVsCumminGPLYCount.put(opt.Monthly_Plan_Month__c,lyCumminCountGp);
                    mapOfMonthVsCumminGPESTCount.put(opt.Monthly_Plan_Month__c,estCumminCountGp);
                    
                    mtdCumminCountGp = 0.0;
                    lyCumminCountGp = 0.0;
                    estCumminCountGp = 0.0;
                } 
                if(opt.account.Final_Segment__c == 'Industrial - ID'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal estLubes = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    if(opt.Latest_Est_Lubes_Volume__c == null){
                        estLubes  = 0.0;
                    }
                    else{
                        estLubes = opt.Latest_Est_Lubes_Volume__c;
                    }
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    
                    if(mapOfMonthVsIndusGPMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.MTD_GP_Lubes__c != null){
                            mtdIndusCountGp += opt.MTD_GP_Lubes__c + mapOfMonthVsIndusGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdIndusCountGp += mapOfMonthVsIndusGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                    }
                    else{
                        if(opt.MTD_GP_Lubes__c != null){
                            mtdIndusCountGp += opt.MTD_GP_Lubes__c;
                        }
                        else{
                            mtdIndusCountGp += 0.00;
                        }
                    }
                    if(mapOfMonthVsIndusGPLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyIndusCountGp += opt.LY_MTD_GP__c + mapOfMonthVsIndusGPLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyIndusCountGp += opt.LY_MTD_GP__c;
                    }
                    if(mapOfMonthVsIndusGPESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estIndusCountGp += (lastmonthOpp  - cogsValue      + nspChange )* estLubes *1000 + mapOfMonthVsIndusGPESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estIndusCountGp += (lastmonthOpp  - cogsValue      + nspChange )* estLubes *1000; 
                    }
                    
                    mapOfMonthVsIndusGPMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusCountGp);
                    mapOfMonthVsIndusGPLYCount.put(opt.Monthly_Plan_Month__c,lyIndusCountGp); 
                    mapOfMonthVsIndusGPESTCount.put(opt.Monthly_Plan_Month__c,estIndusCountGp);
                    mtdIndusCountGp = 0.0;
                    lyIndusCountGp = 0.0;
                    estIndusCountGp = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Infra - ID'){
                
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal estLubes = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    if(opt.Latest_Est_Lubes_Volume__c == null){
                        estLubes  = 0.0;
                    }
                    else{
                        estLubes = opt.Latest_Est_Lubes_Volume__c;
                    }
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    
                    if(mapOfMonthVsInfraGPMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.MTD_GP_Lubes__c != null){
                            mtdInfraCountGp += opt.MTD_GP_Lubes__c + mapOfMonthVsInfraGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdInfraCountGp +=  mapOfMonthVsInfraGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                    } 
                    else{
                        if(opt.MTD_GP_Lubes__c != null){
                            mtdInfraCountGp += opt.MTD_GP_Lubes__c;
                        }
                        else{
                            mtdInfraCountGp += 0.00;
                        }
                    }
                    if(mapOfMonthVsInfraGPLYCount.containsKey(opt.Monthly_Plan_Month__c)){                  
                        lyInfraCountGp += opt.LY_MTD_GP__c + mapOfMonthVsInfraGPLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyInfraCountGp += opt.LY_MTD_GP__c;
                    }
                    if(mapOfMonthVsInfraGPESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                       estInfraCountGp += (lastmonthOpp  - cogsValue      + nspChange )* estLubes *1000 + mapOfMonthVsInfraGPESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estInfraCountGp += (lastmonthOpp  - cogsValue      + nspChange )* estLubes *1000;
                    }
                    
                    
                    
                    mapOfMonthVsInfraGPMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraCountGp);
                    mapOfMonthVsInfraGPLYCount.put(opt.Monthly_Plan_Month__c,lyInfraCountGp);
                    mapOfMonthVsInfraGPESTCount.put(opt.Monthly_Plan_Month__c,estInfraCountGp);
                    mtdInfraCountGp = 0.0;
                    lyInfraCountGp = 0.0;
                    estInfraCountGp = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Powergen'){
                
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal estLubes = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    if(opt.Latest_Est_Lubes_Volume__c == null){
                        estLubes  = 0.0;
                    }
                    else{
                        estLubes = opt.Latest_Est_Lubes_Volume__c;
                    }
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    if(mapOfMonthVsPowerGPMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.MTD_GP_Lubes__c !=null ){
                            mtdPowerCountGp += opt.MTD_GP_Lubes__c + mapOfMonthVsPowerGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdPowerCountGp += mapOfMonthVsPowerGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                    }
                    else{
                        if(opt.MTD_GP_Lubes__c !=null ){
                            mtdPowerCountGp += opt.MTD_GP_Lubes__c;
                        }
                        else{
                            mtdPowerCountGp += 0.00;
                        }
                    }
                    if(mapOfMonthVsPowerGPLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyPowerCountGp += opt.LY_MTD_GP__c + mapOfMonthVsPowerGPLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyPowerCountGp += opt.LY_MTD_GP__c;
                    }
                    if(mapOfMonthVsPowerGPESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estPowerCountGp += (lastmonthOpp - cogsValue  + nspChange )* estLubes *1000 + mapOfMonthVsPowerGPESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estPowerCountGp += (lastmonthOpp - cogsValue      + nspChange )* estLubes *1000;
                    }
                    
                    mapOfMonthVsPowerGPMtdCount.put(opt.Monthly_Plan_Month__c,mtdPowerCountGp);
                    mapOfMonthVsPowerGPLYCount.put(opt.Monthly_Plan_Month__c,lyPowerCountGp);
                    mapOfMonthVsPowerGPESTCount.put(opt.Monthly_Plan_Month__c,estPowerCountGp);
                    mtdPowerCountGp = 0.0;
                    lyPowerCountGp = 0.0;
                    estPowerCountGp = 0.0;
                }
                
                if(opt.account.Final_Segment__c == 'Industrial - Direct'){
                
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal estLubes = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    if(opt.Latest_Est_Lubes_Volume__c == null){
                        estLubes  = 0.0;
                    }
                    else{
                        estLubes = opt.Latest_Est_Lubes_Volume__c;
                    }
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    if(mapOfMonthVsIndusDirGPMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.MTD_GP_Lubes__c != null ) {
                            mtdIndusDirCountGp += opt.MTD_GP_Lubes__c + mapOfMonthVsIndusDirGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdIndusDirCountGp +=  mapOfMonthVsIndusDirGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                    }
                    else{
                        if(opt.MTD_GP_Lubes__c != null ) {
                            mtdIndusDirCountGp += opt.MTD_GP_Lubes__c;
                        }
                        else{
                            mtdIndusDirCountGp += 0.00;
                        }
                    }
                    if(mapOfMonthVsIndusDirGPLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyIndusDirCountGp += opt.LY_MTD_GP__c + mapOfMonthVsIndusDirGPLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyIndusDirCountGp += opt.LY_MTD_GP__c;
                    }
                    if(mapOfMonthVsIndusDirGPESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estIndusDirCountGp += (lastmonthOpp - cogsValue  + nspChange )* estLubes *1000 + mapOfMonthVsIndusDirGPESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estIndusDirCountGp += (lastmonthOpp - cogsValue      + nspChange )* estLubes *1000;
                    }
                    
                    mapOfMonthVsIndusDirGPMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusDirCountGp);
                    mapOfMonthVsIndusDirGPLYCount.put(opt.Monthly_Plan_Month__c,lyIndusDirCountGp);
                    mapOfMonthVsIndusDirGPESTCount.put(opt.Monthly_Plan_Month__c,estIndusDirCountGp);
                    mtdIndusDirCountGp = 0.0;
                    lyIndusDirCountGp = 0.0;
                    estIndusDirCountGp = 0.0;
                }
                
                if(opt.account.Final_Segment__c == 'Infra - Direct'){
                
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal estLubes = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    if(opt.Latest_Est_Lubes_Volume__c == null){
                        estLubes  = 0.0;
                    }
                    else{  
                        estLubes = opt.Latest_Est_Lubes_Volume__c;
                    }
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    if(mapOfMonthVsInfraDirGPMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        if(opt.MTD_GP_Lubes__c != null){
                            mtdInfraDirCountGp += opt.MTD_GP_Lubes__c + mapOfMonthVsInfraDirGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdInfraDirCountGp +=  mapOfMonthVsInfraDirGPMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                    }
                    else{
                        if(opt.MTD_GP_Lubes__c != null){
                            mtdInfraDirCountGp += opt.MTD_GP_Lubes__c;
                        }
                        else{
                            mtdInfraDirCountGp +=  0.00;
                        }
                        
                    }
                    if(mapOfMonthVsInfraDirGPLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyInfraDirCountGp += opt.LY_MTD_GP__c + mapOfMonthVsInfraDirGPLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        lyInfraDirCountGp += opt.LY_MTD_GP__c;
                    }
                    if(mapOfMonthVsInfraDirGPESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estInfraDirCountGp += (lastmonthOpp - cogsValue  + nspChange )* estLubes *1000 + mapOfMonthVsInfraDirGPESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estInfraDirCountGp += (lastmonthOpp - cogsValue      + nspChange )* estLubes *1000;
                    }
                    
                    mapOfMonthVsInfraDirGPMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraDirCountGp);
                    mapOfMonthVsInfraDirGPLYCount.put(opt.Monthly_Plan_Month__c,lyInfraDirCountGp);
                    mapOfMonthVsInfraDirGPESTCount.put(opt.Monthly_Plan_Month__c,estInfraDirCountGp);
                    mtdInfraDirCountGp = 0.0;
                    lyInfraDirCountGp = 0.0;
                    estInfraDirCountGp = 0.0;
                }
            
            }

    ////////////////////////////////////////////////////////   End of GP Lubes  /////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////   start of GP/l Lubes  /////////////////////////////////////////////////////////////////
            
            lubesCumminsGPperLWrapListMTD = new List<WrapperCumminsGPperLMTD>();
            lubesCumminsGPperLWrapListLY = new List<WrapperCumminsGPperLLY>();
            lubesCumminsGPperLWrapListEst = new List<WrapperCumminsGPperLEst>();
            
            lubesIndustrialGPperLWrapListMTD  = new list<WrapperIndustrialGPperLMTD>();
            lubesIndustrialGPperLWrapListLY  = new list<WrapperIndustrialGPperLLY>();
            lubesIndustrialGPperLWrapListEst  = new list<WrapperIndustrialGPperLEst>();
            
            lubesInfraGPperLWrapListMTD  = new list<WrapperInfraGPperLMTD>();
            lubesInfraGPperLWrapListLY  = new list<WrapperInfraGPperLLY>();
            lubesInfraGPperLWrapListEst  = new list<WrapperInfraGPperLEst>();
            
            lubesPowergenGPperLWrapListMTD  = new list<WrapperPowergenGPperLMTD>();
            lubesPowergenGPperLWrapListLY  = new list<WrapperPowergenGPperLLY>();
            lubesPowergenGPperLWrapListEst  = new list<WrapperPowergenGPperLEst>();
            
            lubesIndusDirGPperLWrapListMTD  = new list<WrapperIndusDirGPperLMTD>();
            lubesIndusDirGPperLWrapListLY  = new list<WrapperIndusDirGPperLLY>();
            lubesIndusDirGPperLWrapListEst  = new list<WrapperIndusDirGPperLEst>();
            
            lubesInfraDirGPperLWrapListMTD  = new list<WrapperInfraDirGPperLMTD>();
            lubesInfraDirGPperLWrapListLY  = new list<WrapperInfraDirGPperLLY>();
            lubesInfraDirGPperLWrapListEst  = new list<WrapperInfraDirGPperLEst>(); 
            
            
            map<string,decimal> mapOfMonthVsCumminGPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminGPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminGPperLESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusGPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusGPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusGPperLESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraGPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraGPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraGPperLESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsPowerGPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerGPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerGPperLESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusDirGPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirGPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirGPperLESTCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraDirGPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirGPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirGPperLESTCount = new map<string,decimal>();
       
       
       
       
           //list<opportunity> oppListForGpperL = [select account.Final_Segment__c, Monthly_Plan_Month__c, LY_GP_ltr__c,  Last_Month_Gp_Ltr__c, MTD_GP_Ltr__c, Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c, NSP_change__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    //AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')];     
            
                
                
                decimal mtdCumminCountGpl = 0.0;
                decimal lyCumminCountGpl = 0.0;
                decimal estCumminCountGpl = 0.0;
                
                decimal mtdIndusCountGpl = 0.0;
                decimal lyIndusCountGpl = 0.0;
                decimal estIndusCountGpl = 0.0;
                
                decimal mtdInfraCountGpl = 0.0;
                decimal lyInfraCountGpl = 0.0;
                decimal estInfraCountGpl = 0.0;
                
                decimal mtdPowerCountGpl = 0.0;
                decimal lyPowerCountGpl = 0.0;
                decimal estPowerCountGpl = 0.0;
                
                decimal mtdIndusDirCountGpl = 0.0;
                decimal lyIndusDirCountGpl = 0.0;
                decimal estIndusDirCountGpl = 0.0;
                
                decimal mtdInfraDirCountGpl = 0.0;
                decimal lyInfraDirCountGpl = 0.0;
                decimal estInfraDirCountGpl = 0.0;
           
             for(opportunity opt: [select account.Final_Segment__c, Monthly_Plan_Month__c, LY_GP_ltr__c,  Last_Month_Gp_Ltr__c, MTD_GP_Ltr__c, Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c, NSP_change__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')]){
                
                
                if(opt.account.Final_Segment__c == 'Cummins Dealer'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){ 
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    
                    
                    if( opt.MTD_GP_Ltr__c != null && mapOfMonthVsCumminGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                        mtdCumminCountGpl += opt.MTD_GP_Ltr__c + mapOfMonthVsCumminGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        if(opt.MTD_GP_Ltr__c != null){
                            mtdCumminCountGpl += opt.MTD_GP_Ltr__c;
                        }
                        else{
                            mtdCumminCountGpl = 0.00;
                        }
                    }
                    if(opt.LY_GP_ltr__c != null && mapOfMonthVsCumminGPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                        lyCumminCountGpl += opt.LY_GP_ltr__c + mapOfMonthVsCumminGPperLLYCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        if(opt.LY_GP_ltr__c != null){
                            lyCumminCountGpl += opt.LY_GP_ltr__c;
                        }
                        else{
                            lyCumminCountGpl += 0.00;
                        }
                    }
                    if(mapOfMonthVsCumminGPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                        estCumminCountGpl += lastmonthOpp  - cogsValue      + nspChange + mapOfMonthVsCumminGPperLESTCount.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        estCumminCountGpl += lastmonthOpp  - cogsValue     + nspChange;
                    }
                    
                    mapOfMonthVsCumminGPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdCumminCountGpl);
                    mapOfMonthVsCumminGPperLLYCount.put(opt.Monthly_Plan_Month__c,lyCumminCountGpl);
                    mapOfMonthVsCumminGPperLESTCount.put(opt.Monthly_Plan_Month__c,estCumminCountGpl);
                    mtdCumminCountGpl = 0.0;
                    lyCumminCountGpl = 0.0;
                    estCumminCountGpl = 0.0;
                    
                } 
                
                if(opt.account.Final_Segment__c == 'Industrial - ID'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){ 
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    
                    
                    if(opt.MTD_GP_Ltr__c == null){
                        mtdIndusCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsIndusGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdIndusCountGpl += opt.MTD_GP_Ltr__c + mapOfMonthVsIndusGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdIndusCountGpl += opt.MTD_GP_Ltr__c;
                        }
                    }
                    if(opt.LY_GP_ltr__c == null){
                        lyIndusCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsIndusGPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyIndusCountGpl += opt.LY_GP_ltr__c + mapOfMonthVsIndusGPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyIndusCountGpl += opt.LY_GP_ltr__c;
                        }
                    }
                    if(opt.Last_Month_Gp_Ltr__c == null){
                        estIndusCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsIndusGPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estIndusCountGpl += lastmonthOpp  - cogsValue     + nspChange + mapOfMonthVsIndusGPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estIndusCountGpl += lastmonthOpp  - cogsValue     + nspChange;
                        }
                    }
                    
                    mapOfMonthVsIndusGPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusCountGpl);
                    mapOfMonthVsIndusGPperLLYCount.put(opt.Monthly_Plan_Month__c,lyIndusCountGpl); 
                    mapOfMonthVsIndusGPperLESTCount.put(opt.Monthly_Plan_Month__c,estIndusCountGpl);
                    
                     mtdIndusCountGpl = 0.0;
                    lyIndusCountGpl = 0.0;
                    estIndusCountGpl = 0.0;
                
                
                }
                if(opt.account.Final_Segment__c == 'Infra - ID'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){ 
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    
                    if(opt.MTD_GP_Ltr__c == null){
                        mtdInfraCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsInfraGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdInfraCountGpl += opt.MTD_GP_Ltr__c + mapOfMonthVsInfraGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdInfraCountGpl += opt.MTD_GP_Ltr__c;
                        }
                    } 
                    if(opt.LY_GP_ltr__c == null){
                        lyInfraCountGpl += 0.00;
                    }  
                    else{  
                        if(mapOfMonthVsInfraGPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyInfraCountGpl += opt.LY_GP_ltr__c + mapOfMonthVsInfraGPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        } 
                        else{             
                            lyInfraCountGpl += opt.LY_GP_ltr__c;
                        }
                    }
                    if(opt.Last_Month_Gp_Ltr__c == null){
                        estInfraCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsInfraGPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estInfraCountGpl += lastmonthOpp  - cogsValue      + nspChange + mapOfMonthVsInfraGPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estInfraCountGpl += lastmonthOpp  - cogsValue     + nspChange;
                        }
                    }
                    
                    mapOfMonthVsInfraGPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraCountGpl);
                    mapOfMonthVsInfraGPperLLYCount.put(opt.Monthly_Plan_Month__c,lyInfraCountGpl);
                    mapOfMonthVsInfraGPperLESTCount.put(opt.Monthly_Plan_Month__c,estInfraCountGpl);
                    
                     mtdInfraCountGpl = 0.0;
                     lyInfraCountGpl = 0.0;
                     estInfraCountGpl = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Powergen'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){ 
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    if(opt.MTD_GP_Ltr__c == null){
                        mtdPowerCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsPowerGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdPowerCountGpl += opt.MTD_GP_Ltr__c + mapOfMonthVsPowerGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdPowerCountGpl += opt.MTD_GP_Ltr__c;
                        }
                    }
                    if(opt.LY_GP_ltr__c == null){
                        lyPowerCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsPowerGPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyPowerCountGpl += opt.LY_GP_ltr__c + mapOfMonthVsPowerGPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyPowerCountGpl += opt.LY_GP_ltr__c;
                        }
                    }
                    if(opt.Last_Month_Gp_Ltr__c == null){
                        estPowerCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsPowerGPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estPowerCountGpl += lastmonthOpp  - cogsValue      + nspChange + mapOfMonthVsPowerGPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estPowerCountGpl += lastmonthOpp  - cogsValue      + nspChange;
                        }
                    }
                    
                    mapOfMonthVsPowerGPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdPowerCountGpl);
                    mapOfMonthVsPowerGPperLLYCount.put(opt.Monthly_Plan_Month__c,lyPowerCountGpl);
                    mapOfMonthVsPowerGPperLESTCount.put(opt.Monthly_Plan_Month__c,estPowerCountGpl);
                    
                    mtdPowerCountGpl = 0.0;
                    lyPowerCountGpl = 0.0;
                    estPowerCountGpl = 0.0;
                }
                
                if(opt.account.Final_Segment__c == 'Industrial - Direct'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){ 
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    if(opt.MTD_GP_Ltr__c == null){
                        mtdIndusDirCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsIndusDirGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdIndusDirCountGpl += opt.MTD_GP_Ltr__c + mapOfMonthVsIndusDirGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdIndusDirCountGpl += opt.MTD_GP_Ltr__c;
                        }
                    }
                    if(opt.LY_GP_ltr__c == null){
                        lyIndusDirCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsIndusDirGPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyIndusDirCountGpl += opt.LY_GP_ltr__c + mapOfMonthVsIndusDirGPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyIndusDirCountGpl += opt.LY_GP_ltr__c;
                        }
                    }
                    if(opt.Last_Month_Gp_Ltr__c == null){
                        estIndusDirCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsIndusDirGPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estIndusDirCountGpl += lastmonthOpp  - cogsValue      + nspChange + mapOfMonthVsIndusDirGPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estIndusDirCountGpl += lastmonthOpp  - cogsValue      + nspChange;
                        }
                    }
                    
                    mapOfMonthVsIndusDirGPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusDirCountGpl);
                    mapOfMonthVsIndusDirGPperLLYCount.put(opt.Monthly_Plan_Month__c,lyIndusDirCountGpl);
                    mapOfMonthVsIndusDirGPperLESTCount.put(opt.Monthly_Plan_Month__c,estIndusDirCountGpl);
                    
                    mtdIndusDirCountGpl = 0.0;
                    lyIndusDirCountGpl = 0.0;
                    estIndusDirCountGpl = 0.0;
                }
                
                if(opt.account.Final_Segment__c == 'Infra - Direct'){
                    
                    decimal lastmonthOpp = 0.0;
                    decimal nspChange = 0.0;
                    decimal cogsValue = 0.0;
                    
                    if(opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c == null){ 
                        lastmonthOpp = 0.0;
                    }
                    else{
                        lastmonthOpp = opt.Last_Month_Opportunity__r.MTD_GP_Ltr_Lubes__c;
                    }
                    if(opt.NSP_change__c == null){
                        nspChange = 0.0;
                    }
                    else{
                        nspChange = opt.NSP_change__c;
                    }
                    
                    if(mapOfmonthVsUpdatedCogsValue.containsKey(opt.Monthly_Plan_Month__c)){
                        cogsValue  = mapOfmonthVsUpdatedCogsValue.get(opt.Monthly_Plan_Month__c);
                    }
                    else{
                        cogsValue  = 0.0;
                    }
                    if(opt.MTD_GP_Ltr__c == null){
                        mtdInfraDirCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsInfraDirGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdInfraDirCountGpl += opt.MTD_GP_Ltr__c + mapOfMonthVsInfraDirGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdInfraDirCountGpl += opt.MTD_GP_Ltr__c;
                        }
                    }
                    if(opt.LY_GP_ltr__c == null){
                        lyInfraDirCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsInfraDirGPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyInfraDirCountGpl += opt.LY_GP_ltr__c + mapOfMonthVsInfraDirGPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyInfraDirCountGpl += opt.LY_GP_ltr__c;
                        }
                    }
                    if(opt.Last_Month_Gp_Ltr__c == null){
                        estInfraDirCountGpl += 0.00;
                    }
                    else{
                        if(mapOfMonthVsInfraDirGPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estInfraDirCountGpl += lastmonthOpp  - cogsValue      + nspChange + mapOfMonthVsInfraDirGPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estInfraDirCountGpl += lastmonthOpp  - cogsValue      + nspChange;
                        }
                    }
                    
                    mapOfMonthVsInfraDirGPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraDirCountGpl);
                    mapOfMonthVsInfraDirGPperLLYCount.put(opt.Monthly_Plan_Month__c,lyInfraDirCountGpl);
                    mapOfMonthVsInfraDirGPperLESTCount.put(opt.Monthly_Plan_Month__c,estInfraDirCountGpl);
                    
                    mtdInfraDirCountGpl = 0.0;
                    lyInfraDirCountGpl = 0.0;
                    estInfraDirCountGpl = 0.0;
                }
            
            }
    
    ////////////////////////////////////////////////////////   End of GP/l Lubes  /////////////////////////////////////////////////////////////////       
    
    ////////////////////////////////////////////////////////   start of NSP/l Lubes  /////////////////////////////////////////////////////////////////
            
            lubesCumminsNSPperLWrapListMTD = new List<WrapperCumminsNSPperLMTD>();
            lubesCumminsNSPperLWrapListLY = new List<WrapperCumminsNSPperLLY>();
            lubesCumminsNSPperLWrapListEst = new List<WrapperCumminsNSPperLEst>();
            lubesCumminsNSPperLWrapListprice = new List<WrapperCumminsNSPperLPrice>();
            
            lubesIndustrialNSPperLWrapListMTD  = new list<WrapperIndustrialNSPperLMTD>();
            lubesIndustrialNSPperLWrapListLY  = new list<WrapperIndustrialNSPperLLY>();
            lubesIndustrialNSPperLWrapListEst  = new list<WrapperIndustrialNSPperLEst>();
            lubesIndustrialNSPperLWrapListPrice  = new list<WrapperIndustrialNSPperLPrice>();
            
            lubesInfraNSPperLWrapListMTD  = new list<WrapperInfraNSPperLMTD>();
            lubesInfraNSPperLWrapListLY  = new list<WrapperInfraNSPperLLY>();
            lubesInfraNSPperLWrapListEst  = new list<WrapperInfraNSPperLEst>();
            lubesInfraNSPperLWrapListPrice  = new list<WrapperInfraNSPperLPrice>();
            
            lubesPowergenNSPperLWrapListMTD  = new list<WrapperPowergenNSPperLMTD>();
            lubesPowergenNSPperLWrapListLY  = new list<WrapperPowergenNSPperLLY>();
            lubesPowergenNSPperLWrapListEst  = new list<WrapperPowergenNSPperLEst>();
            lubesPowergenNSPperLWrapListPrice  = new list<WrapperPowergenNSPperLPrice>();
            
            lubesIndusDirNSPperLWrapListMTD  = new list<WrapperIndusDirNSPperLMTD>();
            lubesIndusDirNSPperLWrapListLY  = new list<WrapperIndusDirNSPperLLY>();
            lubesIndusDirNSPperLWrapListEst  = new list<WrapperIndusDirNSPperLEst>();
            lubesIndusDirNSPperLWrapListPrice  = new list<WrapperIndusDirNSPperLPrice>();  
            
            lubesInfraDirNSPperLWrapListMTD  = new list<WrapperInfraDirNSPperLMTD>();
            lubesInfraDirNSPperLWrapListLY  = new list<WrapperInfraDirNSPperLLY>();
            lubesInfraDirNSPperLWrapListEst  = new list<WrapperInfraDirNSPperLEst>();
            lubesInfraDirNSPperLWrapListPrice  = new list<WrapperInfraDirNSPperLPrice>();
            
            
            map<string,decimal> mapOfMonthVsCumminNSPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminNSPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminNSPperLESTCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsCumminNSPperLPriceCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusNSPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusNSPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusNSPperLESTCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusNSPperLPriceCount = new map<string,decimal>();
            
            
            map<string,decimal> mapOfMonthVsInfraNSPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraNSPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraNSPperLESTCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraNSPperLPriceCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsPowerNSPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerNSPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerNSPperLESTCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsPowerNSPperLPriceCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsIndusDirNSPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirNSPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirNSPperLESTCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsIndusDirNSPperLPriceCount = new map<string,decimal>();
            
            map<string,decimal> mapOfMonthVsInfraDirNSPperLMtdCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirNSPperLLYCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirNSPperLESTCount = new map<string,decimal>();
            map<string,decimal> mapOfMonthVsInfraDirNSPperLPriceCount = new map<string,decimal>();
       
       
       
       
           //list<opportunity> oppListForNSPperL = [select account.Final_Segment__c, Monthly_Plan_Month__c, LY_NSP_Ltr_Lubes__c, NSP_change__c, LE_NSP_Ltr_Lubes__c, Latest_Estimated_NSP_ltr__c, MTD_NSP_ltr_Lubesformula__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    //AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')];     
            
                decimal mtdCumminCountNsp = 0.0;
                decimal lyCumminCountNsp = 0.0;
                decimal estCumminCountNsp = 0.0;
                decimal priceChgeCumminCountNsp = 0.0;
                
                
                decimal mtdIndusCountNsp = 0.0;
                decimal lyIndusCountNsp = 0.0;
                decimal estIndusCountNsp = 0.0;
                decimal priceChgeIndusCountNsp = 0.0;
                
                decimal mtdInfraCountNsp = 0.0;
                decimal lyInfraCountNsp = 0.0;
                decimal estInfraCountNsp = 0.0;
                decimal priceChgeInfraCountNsp = 0.0;
                
                decimal mtdPowerCountNsp = 0.0;
                decimal lyPowerCountNsp = 0.0;
                decimal estPowerCountNsp = 0.0;
                decimal priceChgePowerCountNsp = 0.0;
                
                decimal mtdIndusDirCountNsp = 0.0;
                decimal lyIndusDirCountNsp = 0.0;
                decimal estIndusDirCountNsp = 0.0;
                decimal priceChgeIndusDirCountNsp = 0.0;
                
                decimal mtdInfraDirCountNsp = 0.0;
                decimal lyInfraDirCountNsp = 0.0;
                decimal estInfraDirCountNsp = 0.0;
                decimal priceChgeInfraDirCountNsp = 0.0;
           
             for(opportunity opt: [select account.Final_Segment__c, Monthly_Plan_Month__c, LY_NSP_Ltr_Lubes__c, NSP_change__c, LE_NSP_Ltr_Lubes__c, Latest_Estimated_NSP_ltr__c, MTD_NSP_ltr_Lubesformula__c from opportunity where recordtype.DeveloperName = 'Monthly_Plan' 
                    AND Account.RecordTypeId IN: accountRecordType AND Financial_Year__c= :fys.name AND (account.Final_Segment__c ='Cummins Dealer' OR account.Final_Segment__c =  'Industrial - ID' OR account.Final_Segment__c = 'Infra - ID' OR account.Final_Segment__c ='Powergen' OR account.Final_Segment__c ='Industrial - Direct' OR account.Final_Segment__c ='Infra - Direct')]){
                
                
                if(opt.account.Final_Segment__c == 'Cummins Dealer'){
                   if(opt.MTD_NSP_ltr_Lubesformula__c == null){
                        mtdCumminCountNsp = 0.00;
                    }
                    else{
                        if(mapOfMonthVsCumminGPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdCumminCountNsp += opt.MTD_NSP_ltr_Lubesformula__c + mapOfMonthVsCumminGPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdCumminCountNsp += opt.MTD_NSP_ltr_Lubesformula__c ;
                        }
                    }
                    
                    if(opt.LY_NSP_Ltr_Lubes__c == null){
                        lyCumminCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsCumminNSPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyCumminCountNsp += opt.LY_NSP_Ltr_Lubes__c + mapOfMonthVsCumminNSPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyCumminCountNsp += opt.LY_NSP_Ltr_Lubes__c;
                        }
                    }
                    if(opt.Latest_Estimated_NSP_ltr__c == null){
                        estCumminCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsCumminNSPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estCumminCountNsp += opt.LE_NSP_Ltr_Lubes__c + mapOfMonthVsCumminNSPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estCumminCountNsp += opt.LE_NSP_Ltr_Lubes__c;
                        }
                    }
                    if(opt.NSP_change__c == null){
                        priceChgeCumminCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsCumminNSPperLPriceCount.containsKey(opt.Monthly_Plan_Month__c)){
                            priceChgeCumminCountNsp += opt.NSP_change__c + mapOfMonthVsCumminNSPperLPriceCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            priceChgeCumminCountNsp += opt.NSP_change__c;
                        }
                    }
                    
                    mapOfMonthVsCumminNSPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdCumminCountNsp);
                    mapOfMonthVsCumminNSPperLLYCount.put(opt.Monthly_Plan_Month__c,lyCumminCountNsp);
                    mapOfMonthVsCumminNSPperLESTCount.put(opt.Monthly_Plan_Month__c,estCumminCountNsp);
                    mapOfMonthVsCumminNSPperLPriceCount.put(opt.Monthly_Plan_Month__c,priceChgeCumminCountNsp );
                    mtdCumminCountNsp = 0.00;
                    lyCumminCountNsp = 0.00;
                    estCumminCountNsp = 0.00;
                    priceChgeCumminCountNsp = 0.00;
                   // system.debug(mapOfMonthVsCumminNSPperLMtdCount);
                } 
                if(opt.account.Final_Segment__c == 'Industrial - ID'){
                    if(opt.MTD_NSP_ltr_Lubesformula__c == null){
                        mtdIndusCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusNSPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdIndusCountNsp += opt.MTD_NSP_ltr_Lubesformula__c + mapOfMonthVsIndusNSPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdIndusCountNsp += opt.MTD_NSP_ltr_Lubesformula__c ;
                        }
                    }
                    if(opt.LY_NSP_Ltr_Lubes__c == null){
                        lyIndusCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusNSPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyIndusCountNsp += opt.LY_NSP_Ltr_Lubes__c + mapOfMonthVsIndusNSPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyIndusCountNsp += opt.LY_NSP_Ltr_Lubes__c ;
                        }
                    }
                    if(opt.Latest_Estimated_NSP_ltr__c == null){
                        estIndusCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusNSPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estIndusCountNsp += opt.LE_NSP_Ltr_Lubes__c + mapOfMonthVsIndusNSPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estIndusCountNsp += opt.LE_NSP_Ltr_Lubes__c;
                        }
                    }
                    if(opt.NSP_change__c == null){
                        priceChgeIndusCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusNSPperLPriceCount.containsKey(opt.Monthly_Plan_Month__c)){
                            priceChgeIndusCountNsp += opt.NSP_change__c + mapOfMonthVsIndusNSPperLPriceCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            priceChgeIndusCountNsp += opt.NSP_change__c;
                        }
                    }
                    
                    mapOfMonthVsIndusNSPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusCountNsp);
                    mapOfMonthVsIndusNSPperLLYCount.put(opt.Monthly_Plan_Month__c,lyIndusCountNsp); 
                    mapOfMonthVsIndusNSPperLESTCount.put(opt.Monthly_Plan_Month__c,estIndusCountNsp);
                    mapOfMonthVsIndusNSPperLPriceCount.put(opt.Monthly_Plan_Month__c,priceChgeIndusCountNsp );
                     mtdIndusCountNsp = 0.0;
                    lyIndusCountNsp = 0.0;
                    estIndusCountNsp = 0.0;
                    priceChgeIndusCountNsp = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Infra - ID'){
                    if(opt.MTD_NSP_ltr_Lubesformula__c == null){
                        mtdInfraCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraNSPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdInfraCountNsp += opt.MTD_NSP_ltr_Lubesformula__c + mapOfMonthVsInfraNSPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdInfraCountNsp += opt.MTD_NSP_ltr_Lubesformula__c ;
                        }
                    } 
                    if(opt.LY_NSP_Ltr_Lubes__c == null){
                        lyInfraCountNsp += 0.0;
                    }  
                    else{      
                        if(mapOfMonthVsInfraNSPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyInfraCountNsp += opt.LY_NSP_Ltr_Lubes__c + mapOfMonthVsInfraNSPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{          
                            lyInfraCountNsp += opt.LY_NSP_Ltr_Lubes__c ;
                        }
                    }
                    if(opt.Latest_Estimated_NSP_ltr__c == null){
                        estInfraCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraNSPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estInfraCountNsp += opt.LE_NSP_Ltr_Lubes__c + mapOfMonthVsInfraNSPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estInfraCountNsp += opt.LE_NSP_Ltr_Lubes__c;
                        }
                    }
                    if(opt.NSP_change__c == null){
                        priceChgeInfraCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraNSPperLPriceCount.containsKey(opt.Monthly_Plan_Month__c)){
                            priceChgeInfraCountNsp += opt.NSP_change__c + mapOfMonthVsInfraNSPperLPriceCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            priceChgeInfraCountNsp += opt.NSP_change__c;
                        }
                    }
                    
                    mapOfMonthVsInfraNSPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraCountNsp);
                    mapOfMonthVsInfraNSPperLLYCount.put(opt.Monthly_Plan_Month__c,lyInfraCountNsp);
                    mapOfMonthVsInfraNSPperLESTCount.put(opt.Monthly_Plan_Month__c,estInfraCountNsp);
                    mapOfMonthVsInfraNSPperLPriceCount.put(opt.Monthly_Plan_Month__c,priceChgeInfraCountNsp);
                     mtdInfraCountNsp = 0.0;
                    lyInfraCountNsp = 0.0;
                    estInfraCountNsp = 0.0;
                    priceChgeInfraCountNsp = 0.0;
                }
                if(opt.account.Final_Segment__c == 'Powergen'){
                    if(opt.MTD_NSP_ltr_Lubesformula__c == null){
                        mtdPowerCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsPowerNSPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdPowerCountNsp += opt.MTD_NSP_ltr_Lubesformula__c + mapOfMonthVsPowerNSPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdPowerCountNsp += opt.MTD_NSP_ltr_Lubesformula__c ;
                        }
                    }
                    if(opt.LY_NSP_Ltr_Lubes__c  == null){
                        lyPowerCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsPowerNSPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyPowerCountNsp += opt.LY_NSP_Ltr_Lubes__c  + mapOfMonthVsPowerNSPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyPowerCountNsp += opt.LY_NSP_Ltr_Lubes__c ;
                        }
                    }
                    if(opt.Latest_Estimated_NSP_ltr__c == null){
                        estPowerCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsPowerNSPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estPowerCountNsp += opt.LE_NSP_Ltr_Lubes__c + mapOfMonthVsPowerNSPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estPowerCountNsp += opt.LE_NSP_Ltr_Lubes__c;
                        }
                        
                    }
                    if(opt.NSP_change__c == null){
                        priceChgePowerCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsPowerNSPperLPriceCount.containsKey(opt.Monthly_Plan_Month__c)){
                            priceChgePowerCountNsp += opt.NSP_change__c + mapOfMonthVsPowerNSPperLPriceCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            priceChgePowerCountNsp += opt.NSP_change__c;
                        }
                    }
                    
                    mapOfMonthVsPowerNSPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdPowerCountNsp);
                    mapOfMonthVsPowerNSPperLLYCount.put(opt.Monthly_Plan_Month__c,lyPowerCountNsp);
                    mapOfMonthVsPowerNSPperLESTCount.put(opt.Monthly_Plan_Month__c,estPowerCountNsp);
                    mapOfMonthVsPowerNSPperLPriceCount.put(opt.Monthly_Plan_Month__c,priceChgePowerCountNsp );
                     mtdPowerCountNsp = 0.0;
                    lyPowerCountNsp = 0.0;
                    estPowerCountNsp = 0.0;
                    priceChgePowerCountNsp = 0.0;
                }
                
                if(opt.account.Final_Segment__c == 'Industrial - Direct'){
                    if(opt.MTD_NSP_ltr_Lubesformula__c == null){
                        mtdIndusDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusDirNSPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdIndusDirCountNsp += opt.MTD_NSP_ltr_Lubesformula__c + mapOfMonthVsIndusDirNSPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdIndusDirCountNsp += opt.MTD_NSP_ltr_Lubesformula__c ;
                        }
                    }
                    if(opt.LY_NSP_Ltr_Lubes__c  == null){
                        lyIndusDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusDirNSPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyIndusDirCountNsp += opt.LY_NSP_Ltr_Lubes__c  + mapOfMonthVsIndusDirNSPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyIndusDirCountNsp += opt.LY_NSP_Ltr_Lubes__c ;
                        }
                    }
                    if(opt.Latest_Estimated_NSP_ltr__c == null){
                        estIndusDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusDirNSPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estIndusDirCountNsp += opt.LE_NSP_Ltr_Lubes__c + mapOfMonthVsIndusDirNSPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estIndusDirCountNsp += opt.LE_NSP_Ltr_Lubes__c;
                        }
                        
                    }
                    if(opt.NSP_change__c == null){
                        priceChgeIndusDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsIndusDirNSPperLPriceCount.containsKey(opt.Monthly_Plan_Month__c)){
                            priceChgeIndusDirCountNsp += opt.NSP_change__c + mapOfMonthVsIndusDirNSPperLPriceCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            priceChgeIndusDirCountNsp += opt.NSP_change__c;
                        }
                    }
                    
                    mapOfMonthVsIndusDirNSPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdIndusDirCountNsp);
                    mapOfMonthVsIndusDirNSPperLLYCount.put(opt.Monthly_Plan_Month__c,lyIndusDirCountNsp);
                    mapOfMonthVsIndusDirNSPperLESTCount.put(opt.Monthly_Plan_Month__c,estIndusDirCountNsp);
                    mapOfMonthVsIndusDirNSPperLPriceCount.put(opt.Monthly_Plan_Month__c,priceChgeIndusDirCountNsp );
                    mtdIndusDirCountNsp = 0.0;
                    lyIndusDirCountNsp = 0.0;
                    estIndusDirCountNsp = 0.0;
                    priceChgeIndusDirCountNsp = 0.0;
                }
                
                if(opt.account.Final_Segment__c == 'Infra - Direct'){
                    if(opt.MTD_NSP_ltr_Lubesformula__c == null){
                        mtdInfraDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraDirNSPperLMtdCount.containsKey(opt.Monthly_Plan_Month__c)){
                            mtdInfraDirCountNsp += opt.MTD_NSP_ltr_Lubesformula__c + mapOfMonthVsInfraDirNSPperLMtdCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            mtdInfraDirCountNsp += opt.MTD_NSP_ltr_Lubesformula__c ;
                        }
                    }
                    if(opt.LY_NSP_Ltr_Lubes__c  == null){
                        lyInfraDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraDirNSPperLLYCount.containsKey(opt.Monthly_Plan_Month__c)){
                            lyInfraDirCountNsp += opt.LY_NSP_Ltr_Lubes__c  + mapOfMonthVsInfraDirNSPperLLYCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            lyInfraDirCountNsp += opt.LY_NSP_Ltr_Lubes__c ;
                        }
                    }
                    if(opt.Latest_Estimated_NSP_ltr__c == null){
                        estInfraDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraDirNSPperLESTCount.containsKey(opt.Monthly_Plan_Month__c)){
                            estInfraDirCountNsp += opt.LE_NSP_Ltr_Lubes__c + mapOfMonthVsInfraDirNSPperLESTCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            estInfraDirCountNsp += opt.LE_NSP_Ltr_Lubes__c;
                        }
                        
                    }
                    if(opt.NSP_change__c == null){
                        priceChgeInfraDirCountNsp += 0.0;
                    }
                    else{
                        if(mapOfMonthVsInfraDirNSPperLPriceCount.containsKey(opt.Monthly_Plan_Month__c)){
                            priceChgeInfraDirCountNsp += opt.NSP_change__c + mapOfMonthVsInfraDirNSPperLPriceCount.get(opt.Monthly_Plan_Month__c);
                        }
                        else{
                            priceChgeInfraDirCountNsp += opt.NSP_change__c;
                        }
                    }
                    
                    mapOfMonthVsInfraDirNSPperLMtdCount.put(opt.Monthly_Plan_Month__c,mtdInfraDirCountNsp);
                    mapOfMonthVsInfraDirNSPperLLYCount.put(opt.Monthly_Plan_Month__c,lyInfraDirCountNsp);
                    mapOfMonthVsInfraDirNSPperLESTCount.put(opt.Monthly_Plan_Month__c,estInfraDirCountNsp);
                    mapOfMonthVsInfraDirNSPperLPriceCount.put(opt.Monthly_Plan_Month__c,priceChgeInfraDirCountNsp );
                     mtdInfraDirCountNsp = 0.0;
                    lyInfraDirCountNsp = 0.0;
                    estInfraDirCountNsp = 0.0;
                    priceChgeInfraDirCountNsp = 0.0;
                }
            
            }
    system.debug(mapOfMonthVsCumminNSPperLMtdCount);
    
    ////////////////////////////////////////////////////////   End of NSP/l Lubes  /////////////////////////////////////////////////////////////////     
          
            for(string str : monthString){
                
                ///// lubes volume
                
                WrapperCumminsEst estObj = new WrapperCumminsEst();
                estObj.estCount = mapOfMonthVsCumminESTCount.get(str); 
                lubesCumminsWrapListEst.add(estObj);    
                
                WrapperCumminsLY lyObj = new WrapperCumminsLY();
                lyObj.lycount = mapOfMonthVsCumminLYCount.get(str);
                lubesCumminsWrapListLY.add(lyObj); 
                
                WrapperCumminsMTD mtdObj = new WrapperCumminsMTD();
                mtdObj.mtdcount = mapOfMonthVsCumminMtdCount.get(str);
                lubesCumminsWrapListMTD.add(mtdObj); 
                
                // end cummin
                
                WrapperIndustrialMTD indusmtdObj = new WrapperIndustrialMTD();
                indusmtdObj.mtdCount = mapOfMonthVsIndusMtdCount.get(str); 
                lubesIndustrialWrapListMTD.add(indusmtdObj);    
                
                WrapperIndustrially induslyObj = new WrapperIndustrially();
                induslyObj.lyCount = mapOfMonthVsInduslyCount.get(str); 
                lubesIndustrialWrapListly.add(induslyObj); 
                
                WrapperIndustrialest indusestObj = new WrapperIndustrialest();
                indusestObj.estCount = mapOfMonthVsIndusestCount.get(str); 
                lubesIndustrialWrapListest.add(indusestObj); 
                
                // end Industrial
                
                WrapperInfraest infraestObj = new WrapperInfraest();
                infraestObj.estcount = mapOfMonthVsInfraestCount.get(str);
                lubesInfraWrapListest.add(infraestObj);   
                
                WrapperInfraly infralyObj = new WrapperInfraly();
                infralyObj.lycount = mapOfMonthVsInfralyCount.get(str);
                lubesInfraWrapListly.add(infralyObj);
                
                WrapperInfraMTD inframtdObj = new WrapperInfraMTD();
                inframtdObj.mtdcount = mapOfMonthVsInfraMtdCount.get(str);
                lubesInfraWrapListMTD.add(inframtdObj); 
                
                // end Infra
                
                WrapperPowergenest powerestObj = new WrapperPowergenest();
                powerestObj.estcount = mapOfMonthVsPowerestCount.get(str);
                lubesPowergenWrapListest.add(powerestObj);   
                
                WrapperPowergenly powerlyObj = new WrapperPowergenly();
                powerlyObj.lycount = mapOfMonthVsPowerlyCount.get(str);
                lubesPowergenWrapListly.add(powerlyObj); 
                
                WrapperPowergenMTD powermtdObj = new WrapperPowergenMTD();
                powermtdObj.mtdcount = mapOfMonthVsPowerMtdCount.get(str);
                lubesPowergenWrapListMTD.add(powermtdObj);
                
                // end powergen 
                 
                WrapperIndusDirest IndusDirestObj = new WrapperIndusDirest();
                IndusDirestObj.estcount = mapOfMonthVsIndusDirestCount.get(str);
                lubesIndusDirWrapListest.add(IndusDirestObj);   
                
                WrapperIndusDirly IndusDirlyObj = new WrapperIndusDirly();
                IndusDirlyObj.lycount = mapOfMonthVsIndusDirlyCount.get(str);
                lubesIndusDirWrapListly.add(IndusDirlyObj); 
                
                WrapperIndusDirMTD IndusDirmtdObj = new WrapperIndusDirMTD();
                IndusDirmtdObj.mtdcount = mapOfMonthVsIndusDirMtdCount.get(str);
                lubesIndusDirWrapListMTD.add(IndusDirmtdObj);
                
                // end Industrai-Direct 
                
                WrapperInfraDirest InfraDirestObj = new WrapperInfraDirest();
                InfraDirestObj.estcount = mapOfMonthVsInfraDirestCount.get(str);
                lubesInfraDirWrapListest.add(InfraDirestObj);   
                
                WrapperInfraDirly InfraDirlyObj = new WrapperInfraDirly();
                InfraDirlyObj.lycount = mapOfMonthVsInfraDirlyCount.get(str);
                lubesInfraDirWrapListly.add(InfraDirlyObj); 
                
                WrapperInfraDirMTD InfraDirmtdObj = new WrapperInfraDirMTD();
                InfraDirmtdObj.mtdcount = mapOfMonthVsInfraDirMtdCount.get(str);
                lubesInfraDirWrapListMTD.add(InfraDirmtdObj);
                
                // end Infra- Direct 
                
                
                /////////////////////////Gp Lubes
                
                if(mapOfMonthVsCumminGPESTCount.containsKey(str)){
                    WrapperCumminsGPEst estObjGP = new WrapperCumminsGPEst ();                
                    estObjGP.estCount = decimal.valueOf(string.valueOf(mapOfMonthVsCumminGPESTCount.get(str)).substring(0,string.valueOf(mapOfMonthVsCumminGPESTCount.get(str)).length()-2)); 
                    lubesCumminsGPWrapListEst.add(estObjGP); 
                }
                else{
                    WrapperCumminsGPEst estObjGP = new WrapperCumminsGPEst ();                
                    estObjGP.estCount = 0.00; 
                    lubesCumminsGPWrapListEst.add(estObjGP); 
                }   
                if(mapOfMonthVsCumminGPLYCount.containsKey(str)){
                    WrapperCumminsGPLY lyObjGP = new WrapperCumminsGPLY ();
                    lyObjGP.lycount = mapOfMonthVsCumminGPLYCount.get(str);
                    lubesCumminsGPWrapListLY.add(lyObjGP); 
                }
                else{
                    WrapperCumminsGPLY lyObjGP = new WrapperCumminsGPLY ();
                    lyObjGP.lycount = 0.00;
                    lubesCumminsGPWrapListLY.add(lyObjGP);
                }
                if(mapOfMonthVsCumminGPMtdCount.containsKey(str)){
                    WrapperCumminsGPMTD mtdObjGP = new WrapperCumminsGPMTD();
                    mtdObjGP.mtdcount = mapOfMonthVsCumminGPMtdCount.get(str);
                    lubesCumminsGPWrapListMTD.add(mtdObjGP); 
                }
                else{
                    WrapperCumminsGPMTD mtdObjGP = new WrapperCumminsGPMTD();
                    mtdObjGP.mtdcount = 0.00;
                    lubesCumminsGPWrapListMTD.add(mtdObjGP); 
                }
                
                // end cummin
                if(mapOfMonthVsIndusGPMtdCount.containsKey(str)){
                    WrapperIndustrialGPMTD indusmtdObjGP = new WrapperIndustrialGPMTD();
                    indusmtdObjGP.mtdCount = mapOfMonthVsIndusGPMtdCount.get(str); 
                    lubesIndustrialGPWrapListMTD.add(indusmtdObjGP); 
                } 
                else{
                    WrapperIndustrialGPMTD indusmtdObjGP = new WrapperIndustrialGPMTD();
                    indusmtdObjGP.mtdCount = 0.00; 
                    lubesIndustrialGPWrapListMTD.add(indusmtdObjGP); 
                
                }  
                if(mapOfMonthVsCumminGPMtdCount.containsKey(str)){
                    WrapperIndustrialGPly induslyObjGP = new WrapperIndustrialGPly();
                    induslyObjGP.lyCount = mapOfMonthVsIndusGPlyCount.get(str); 
                    lubesIndustrialGPWrapListly.add(induslyObjGP);
                } 
                else{
                }
                if(mapOfMonthVsIndusGPestCount.containsKey(str)){
                    WrapperIndustrialGPest indusestObjGP = new WrapperIndustrialGPest();
                    indusestObjGP.estCount = decimal.valueOf(string.valueOf(mapOfMonthVsIndusGPestCount.get(str)).substring(0,string.valueOf(mapOfMonthVsIndusGPestCount.get(str)).length()-2));                 
                    lubesIndustrialGPWrapListest.add(indusestObjGP); 
                }
                else{
                    WrapperIndustrialGPest indusestObjGP = new WrapperIndustrialGPest();
                    indusestObjGP.estCount = 0.00;                 
                    lubesIndustrialGPWrapListest.add(indusestObjGP); 
                }
               
                
                // end Industrial
                if(mapOfMonthVsInfraGPestCount.containsKey(str)){
                    WrapperInfraGPest infraestObjGP = new WrapperInfraGPest();
                    infraestObjGP.estcount = decimal.valueOf(string.valueOf(mapOfMonthVsInfraGPestCount.get(str)).substring(0,string.valueOf(mapOfMonthVsInfraGPestCount.get(str)).length()-2));                 
                    lubesInfraGPWrapListest.add(infraestObjGP); 
                } 
                else{
                    WrapperInfraGPest infraestObjGP = new WrapperInfraGPest();
                    infraestObjGP.estcount = 0.00;                 
                    lubesInfraGPWrapListest.add(infraestObjGP);
                } 
                if(mapOfMonthVsInfraGPlyCount.containsKey(str)){
                    WrapperInfraGPly infralyObjGP = new WrapperInfraGPly();
                    infralyObjGP.lycount = mapOfMonthVsInfraGPlyCount.get(str);
                    lubesInfraGPWrapListly.add(infralyObjGP);
                }
                else{
                    WrapperInfraGPly infralyObjGP = new WrapperInfraGPly();
                    infralyObjGP.lycount = 0.00;
                    lubesInfraGPWrapListly.add(infralyObjGP);
                }
                if(mapOfMonthVsInfraGPMtdCount.containsKey(str)){
                    WrapperInfraGPMTD inframtdObjGP = new WrapperInfraGPMTD();
                    inframtdObjGP.mtdcount = mapOfMonthVsInfraGPMtdCount.get(str);
                    lubesInfraGPWrapListMTD.add(inframtdObjGP); 
                }
                else{
                    WrapperInfraGPMTD inframtdObjGP = new WrapperInfraGPMTD();
                    inframtdObjGP.mtdcount = 0.00;
                    lubesInfraGPWrapListMTD.add(inframtdObjGP);
                }
                
                // end Infra
                if(mapOfMonthVsPowerGPestCount.containsKey(str)){
                    WrapperPowergenGPest powerestObjGP = new WrapperPowergenGPest();
                    powerestObjGP.estcount = decimal.valueOf(string.valueOf(mapOfMonthVsPowerGPestCount.get(str)).substring(0,string.valueOf(mapOfMonthVsPowerGPestCount.get(str)).length()-2));                 
                    lubesPowergenGPWrapListest.add(powerestObjGP);   
                }
                else{
                    WrapperPowergenGPest powerestObjGP = new WrapperPowergenGPest();
                    powerestObjGP.estcount = 0.00;                 
                    lubesPowergenGPWrapListest.add(powerestObjGP);
                }
                if(mapOfMonthVsPowerGPlyCount.containsKey(str)){
                    WrapperPowergenGPly powerlyObjGP = new WrapperPowergenGPly();
                    powerlyObjGP.lycount = mapOfMonthVsPowerGPlyCount.get(str);
                    lubesPowergenGPWrapListly.add(powerlyObjGP); 
                }
                else{
                    WrapperPowergenGPly powerlyObjGP = new WrapperPowergenGPly();
                    powerlyObjGP.lycount = 0.00;
                    lubesPowergenGPWrapListly.add(powerlyObjGP);
                }
                if(mapOfMonthVsPowerGPMtdCount.containsKey(str)){
                    WrapperPowergenGPMTD powermtdObjGP = new WrapperPowergenGPMTD();
                    powermtdObjGP.mtdcount = mapOfMonthVsPowerGPMtdCount.get(str);
                    lubesPowergenGPWrapListMTD.add(powermtdObjGP);
                }
                else{
                    WrapperPowergenGPMTD powermtdObjGP = new WrapperPowergenGPMTD();
                    powermtdObjGP.mtdcount = 0.00;
                    lubesPowergenGPWrapListMTD.add(powermtdObjGP);
                }
                
                // end powergen 
                
                if(mapOfMonthVsIndusDirGPestCount.containsKey(str)){
                    WrapperIndusDirGPest IndusDirestObjGP = new WrapperIndusDirGPest();
                    IndusDirestObjGP.estcount = decimal.valueOf(string.valueOf(mapOfMonthVsIndusDirGPestCount.get(str)).substring(0,string.valueOf(mapOfMonthVsIndusDirGPestCount.get(str)).length()-2));                 
                    lubesIndusDirGPWrapListest.add(IndusDirestObjGP);   
                }
                else{
                    WrapperIndusDirGPest IndusDirestObjGP = new WrapperIndusDirGPest();
                    IndusDirestObjGP.estcount = 0.00;                 
                    lubesIndusDirGPWrapListest.add(IndusDirestObjGP);
                }
                if(mapOfMonthVsIndusDirGPlyCount.containsKey(str)){
                    WrapperIndusDirGPly IndusDirlyObjGP = new WrapperIndusDirGPly();
                    IndusDirlyObjGP.lycount = mapOfMonthVsIndusDirGPlyCount.get(str);
                    lubesIndusDirGPWrapListly.add(IndusDirlyObjGP); 
                }
                else{
                    WrapperIndusDirGPly IndusDirlyObjGP = new WrapperIndusDirGPly();
                    IndusDirlyObjGP.lycount = 0.00;
                    lubesIndusDirGPWrapListly.add(IndusDirlyObjGP);
                }
                if(mapOfMonthVsIndusDirGPMtdCount.containsKey(str)){
                    WrapperIndusDirGPMTD IndusDirmtdObjGP = new WrapperIndusDirGPMTD();
                    IndusDirmtdObjGP.mtdcount = mapOfMonthVsIndusDirGPMtdCount.get(str);
                    lubesIndusDirGPWrapListMTD.add(IndusDirmtdObjGP);
                }
                else{
                    WrapperIndusDirGPMTD IndusDirmtdObjGP = new WrapperIndusDirGPMTD();
                    IndusDirmtdObjGP.mtdcount = 0.00;
                    lubesIndusDirGPWrapListMTD.add(IndusDirmtdObjGP);
                }
                
                // end Industrai- Direct 
                
                if(mapOfMonthVsInfraDirGPestCount.containsKey(str)){
                    WrapperInfraDirGPest InfraDirestObjGP = new WrapperInfraDirGPest();
                    InfraDirestObjGP.estcount = decimal.valueOf(string.valueOf(mapOfMonthVsInfraDirGPestCount.get(str)).substring(0,string.valueOf(mapOfMonthVsInfraDirGPestCount.get(str)).length()-2));                 
                    lubesInfraDirGPWrapListest.add(InfraDirestObjGP);   
                }
                else{
                    WrapperInfraDirGPest InfraDirestObjGP = new WrapperInfraDirGPest();
                    InfraDirestObjGP.estcount = 0.00;                 
                    lubesInfraDirGPWrapListest.add(InfraDirestObjGP);
                } 
                if(mapOfMonthVsInfraDirGPlyCount.containsKey(str)){
                    WrapperInfraDirGPly InfraDirlyObjGP = new WrapperInfraDirGPly();
                    InfraDirlyObjGP.lycount = mapOfMonthVsInfraDirGPlyCount.get(str);
                    lubesInfraDirGPWrapListly.add(InfraDirlyObjGP); 
                }
                else{
                    WrapperInfraDirGPly InfraDirlyObjGP = new WrapperInfraDirGPly();
                    InfraDirlyObjGP.lycount = 0.00;
                    lubesInfraDirGPWrapListly.add(InfraDirlyObjGP);
                }
                if(mapOfMonthVsInfraDirGPMtdCount.containsKey(str)){
                    WrapperInfraDirGPMTD InfraDirmtdObjGP = new WrapperInfraDirGPMTD();
                    InfraDirmtdObjGP.mtdcount = mapOfMonthVsInfraDirGPMtdCount.get(str);
                    lubesInfraDirGPWrapListMTD.add(InfraDirmtdObjGP);
                }
                else{
                    WrapperInfraDirGPMTD InfraDirmtdObjGP = new WrapperInfraDirGPMTD();
                    InfraDirmtdObjGP.mtdcount = 0.00;
                    lubesInfraDirGPWrapListMTD.add(InfraDirmtdObjGP);
                }
                
                // end Infra- Direct 
                
                
                ///////////////////////GP/L Lubes
                
                WrapperCumminsGPperLEst estObjGPperL = new WrapperCumminsGPperLEst ();
                estObjGPperL.estCount = mapOfMonthVsCumminGPperLESTCount.get(str); 
                lubesCumminsGPperLWrapListEst.add(estObjGPperL);    
                
                WrapperCumminsGPperLLY lyObjGPperL = new WrapperCumminsGPperLLY ();
                lyObjGPperL.lycount = mapOfMonthVsCumminGPperLLYCount.get(str);
                lubesCumminsGPperLWrapListLY.add(lyObjGPperL); 
                
                WrapperCumminsGPperLMTD mtdObjGPperL = new WrapperCumminsGPperLMTD();
                mtdObjGPperL.mtdcount = mapOfMonthVsCumminGPperLMtdCount.get(str);
                lubesCumminsGPperLWrapListMTD.add(mtdObjGPperL); 
                
                // end cummin
                
                WrapperIndustrialGPperLMTD indusmtdObjGPperL = new WrapperIndustrialGPperLMTD();
                indusmtdObjGPperL.mtdCount = mapOfMonthVsIndusGPperLMtdCount.get(str); 
                lubesIndustrialGPperLWrapListMTD.add(indusmtdObjGPperL);    
                
                WrapperIndustrialGPperLly induslyObjGPperL = new WrapperIndustrialGPperLly();
                induslyObjGPperL.lyCount = mapOfMonthVsIndusGPlyCount.get(str); 
                lubesIndustrialGPperLWrapListly.add(induslyObjGPperL); 
                
                WrapperIndustrialGPperLest indusestObjGPperL = new WrapperIndustrialGPperLest();
                indusestObjGPperL.estCount = mapOfMonthVsIndusGPperLestCount.get(str); 
                lubesIndustrialGPperLWrapListest.add(indusestObjGPperL); 
                
                // end Industrial
                
                WrapperInfraGPperLest infraestObjGPperL = new WrapperInfraGPperLest();
                infraestObjGPperL.estcount = mapOfMonthVsInfraGPperLestCount.get(str);
                lubesInfraGPperLWrapListest.add(infraestObjGPperL);   
                
                WrapperInfraGPperLly infralyObjGPperL = new WrapperInfraGPperLly();
                infralyObjGPperL.lycount = mapOfMonthVsInfraGPperLlyCount.get(str);
                lubesInfraGPperLWrapListly.add(infralyObjGPperL);
                
                WrapperInfraGPperLMTD inframtdObjGPperL = new WrapperInfraGPperLMTD();
                inframtdObjGPperL.mtdcount = mapOfMonthVsInfraGPperLMtdCount.get(str);
                lubesInfraGPperLWrapListMTD.add(inframtdObjGPperL); 
                //system.debug(inframtdObjGP.mtdcount);
                // end Infra
                
                WrapperPowergenGPperLest powerestObjGPperL = new WrapperPowergenGPperLest();
                powerestObjGPperL.estcount = mapOfMonthVsPowerGPperLestCount.get(str);
                lubesPowergenGPperLWrapListest.add(powerestObjGPperL);   
                
                WrapperPowergenGPperLly powerlyObjGPperL = new WrapperPowergenGPperLly();
                powerlyObjGPperL.lycount = mapOfMonthVsPowerGPperLlyCount.get(str);
                lubesPowergenGPperLWrapListly.add(powerlyObjGPperL); 
                
                WrapperPowergenGPperLMTD powermtdObjGPperL = new WrapperPowergenGPperLMTD();
                powermtdObjGPperL.mtdcount = mapOfMonthVsPowerGPperLMtdCount.get(str);
                lubesPowergenGPperLWrapListMTD.add(powermtdObjGPperL);
                
                // end powergen
                
                WrapperIndusDirGPperLest IndusDirestObjGPperL = new WrapperIndusDirGPperLest();
                IndusDirestObjGPperL.estcount = mapOfMonthVsIndusDirGPperLestCount.get(str);
                lubesIndusDirGPperLWrapListest.add(IndusDirestObjGPperL);   
                
                WrapperIndusDirGPperLly IndusDirlyObjGPperL = new WrapperIndusDirGPperLly();
                IndusDirlyObjGPperL.lycount = mapOfMonthVsIndusDirGPperLlyCount.get(str);
                lubesIndusDirGPperLWrapListly.add(IndusDirlyObjGPperL); 
                
                WrapperIndusDirGPperLMTD IndusDirmtdObjGPperL = new WrapperIndusDirGPperLMTD();
                IndusDirmtdObjGPperL.mtdcount = mapOfMonthVsIndusDirGPperLMtdCount.get(str);
                lubesIndusDirGPperLWrapListMTD.add(IndusDirmtdObjGPperL);
                
                // end Industrial Direct
                
                WrapperInfraDirGPperLest InfraDirestObjGPperL = new WrapperInfraDirGPperLest();
                InfraDirestObjGPperL.estcount = mapOfMonthVsInfraDirGPperLestCount.get(str);
                lubesInfraDirGPperLWrapListest.add(InfraDirestObjGPperL);   
                
                WrapperInfraDirGPperLly InfraDirlyObjGPperL = new WrapperInfraDirGPperLly();
                InfraDirlyObjGPperL.lycount = mapOfMonthVsInfraDirGPperLlyCount.get(str);
                lubesInfraDirGPperLWrapListly.add(InfraDirlyObjGPperL); 
                
                WrapperInfraDirGPperLMTD InfraDirmtdObjGPperL = new WrapperInfraDirGPperLMTD();
                InfraDirmtdObjGPperL.mtdcount = mapOfMonthVsInfraDirGPperLMtdCount.get(str);
                lubesInfraDirGPperLWrapListMTD.add(InfraDirmtdObjGPperL);
                
                // end Infra Direct
                
                
                //////////// NSP/L///////////////////
                
                if(mapOfMonthVsCumminNSPperLESTCount.containsKey(str)){
                    WrapperCumminsNSPperLEst estObjNSPperL = new WrapperCumminsNSPperLEst ();
                    estObjNSPperL.estCount = mapOfMonthVsCumminNSPperLESTCount.get(str); 
                    lubesCumminsNSPperLWrapListEst.add(estObjNSPperL);  
                }
                else{
                    WrapperCumminsNSPperLEst estObjNSPperL = new WrapperCumminsNSPperLEst ();
                    estObjNSPperL.estCount = 0.00; 
                    lubesCumminsNSPperLWrapListEst.add(estObjNSPperL); 
                }  
                if(mapOfMonthVsCumminNSPperLLYCount.containsKey(str)){
                    WrapperCumminsNSPperLLY lyObjNSPperL = new WrapperCumminsNSPperLLY ();
                    lyObjNSPperL.lycount = mapOfMonthVsCumminNSPperLLYCount.get(str);
                    lubesCumminsNSPperLWrapListLY.add(lyObjNSPperL); 
                }
                else{
                    WrapperCumminsNSPperLLY lyObjNSPperL = new WrapperCumminsNSPperLLY ();
                    lyObjNSPperL.lycount = 0.00;
                    lubesCumminsNSPperLWrapListLY.add(lyObjNSPperL);
                }
                if(mapOfMonthVsCumminNSPperLMtdCount.containsKey(str)){
                    WrapperCumminsNSPperLMTD mtdObjNSPperL = new WrapperCumminsNSPperLMTD();
                    mtdObjNSPperL.mtdcount = mapOfMonthVsCumminNSPperLMtdCount.get(str);
                    lubesCumminsNSPperLWrapListMTD.add(mtdObjNSPperL);
                } 
                else{
                    WrapperCumminsNSPperLMTD mtdObjNSPperL = new WrapperCumminsNSPperLMTD();
                    mtdObjNSPperL.mtdcount = 0.00;
                    lubesCumminsNSPperLWrapListMTD.add(mtdObjNSPperL);
                }
                if(mapOfMonthVsCumminNSPperLPriceCount.containsKey(str)){
                    WrapperCumminsNSPperLPrice priceObjNSPperL = new WrapperCumminsNSPperLPrice();
                    priceObjNSPperL.pricecount = mapOfMonthVsCumminNSPperLPriceCount.get(str);
                    lubesCumminsNSPperLWrapListPrice.add(priceObjNSPperL); 
                }
                else{
                    WrapperCumminsNSPperLPrice priceObjNSPperL = new WrapperCumminsNSPperLPrice();
                    priceObjNSPperL.pricecount = 0.00;
                    lubesCumminsNSPperLWrapListPrice.add(priceObjNSPperL); 
                }
                
                // end cummin
                if(mapOfMonthVsIndusNSPperLMtdCount.containsKey(str)){
                    WrapperIndustrialNSPperLMTD indusmtdObjNSPperL = new WrapperIndustrialNSPperLMTD();
                    indusmtdObjNSPperL.mtdCount = mapOfMonthVsIndusNSPperLMtdCount.get(str); 
                    lubesIndustrialNSPperLWrapListMTD.add(indusmtdObjNSPperL);  
                } 
                else{
                    WrapperIndustrialNSPperLMTD indusmtdObjNSPperL = new WrapperIndustrialNSPperLMTD();
                    indusmtdObjNSPperL.mtdCount = 0.00; 
                    lubesIndustrialNSPperLWrapListMTD.add(indusmtdObjNSPperL);
                } 
                if(mapOfMonthVsIndusNSPperLESTCount.containsKey(str)){
                    WrapperIndustrialNSPperLly induslyObjNSPperL = new WrapperIndustrialNSPperLly();
                    induslyObjNSPperL.lyCount = mapOfMonthVsIndusNSPperLESTCount.get(str); 
                    lubesIndustrialNSPperLWrapListly.add(induslyObjNSPperL); 
                }
                else{
                    WrapperIndustrialNSPperLly induslyObjNSPperL = new WrapperIndustrialNSPperLly();
                    induslyObjNSPperL.lyCount = 0.00; 
                    lubesIndustrialNSPperLWrapListly.add(induslyObjNSPperL);
                }
                if(mapOfMonthVsIndusNSPperLestCount.containsKey(str)){
                    WrapperIndustrialNSPperLest indusestObjNSPperL = new WrapperIndustrialNSPperLest();
                    indusestObjNSPperL.estCount = mapOfMonthVsIndusNSPperLestCount.get(str); 
                    lubesIndustrialNSPperLWrapListest.add(indusestObjNSPperL);
                }
                else{
                    WrapperIndustrialNSPperLest indusestObjNSPperL = new WrapperIndustrialNSPperLest();
                    indusestObjNSPperL.estCount = 0.00; 
                    lubesIndustrialNSPperLWrapListest.add(indusestObjNSPperL);
                }
                if(mapOfMonthVsIndusNSPperLPriceCount.containsKey(str)){
                    WrapperIndustrialNSPperLPrice indusPriceObjNSPperL = new WrapperIndustrialNSPperLPrice();
                    indusPriceObjNSPperL.priceCount = mapOfMonthVsIndusNSPperLPriceCount.get(str); 
                    lubesIndustrialNSPperLWrapListPrice.add(indusPriceObjNSPperL); 
                }
                else{
                    WrapperIndustrialNSPperLPrice indusPriceObjNSPperL = new WrapperIndustrialNSPperLPrice();
                    indusPriceObjNSPperL.priceCount = 0.00; 
                    lubesIndustrialNSPperLWrapListPrice.add(indusPriceObjNSPperL);
                }
                
                // end Industrial
                if(mapOfMonthVsInfraNSPperLestCount.containsKey(str)){
                    WrapperInfraNSPperLest infraestObjNSPperL = new WrapperInfraNSPperLest();
                    infraestObjNSPperL.estcount = mapOfMonthVsInfraNSPperLestCount.get(str);
                    lubesInfraNSPperLWrapListest.add(infraestObjNSPperL); 
                }  
                else{
                    WrapperInfraNSPperLest infraestObjNSPperL = new WrapperInfraNSPperLest();
                    infraestObjNSPperL.estcount = 0.00;
                    lubesInfraNSPperLWrapListest.add(infraestObjNSPperL); 
                }
                if(mapOfMonthVsInfraNSPperLlyCount.containsKey(str)){
                    WrapperInfraNSPperLly infralyObjNSPperL = new WrapperInfraNSPperLly();
                    infralyObjNSPperL.lycount = mapOfMonthVsInfraNSPperLlyCount.get(str);
                    lubesInfraNSPperLWrapListly.add(infralyObjNSPperL);
                }
                else{
                    WrapperInfraNSPperLly infralyObjNSPperL = new WrapperInfraNSPperLly();
                    infralyObjNSPperL.lycount = 0.00;
                    lubesInfraNSPperLWrapListly.add(infralyObjNSPperL);
                }
                if(mapOfMonthVsInfraNSPperLMtdCount.containsKey(str)){
                    WrapperInfraNSPperLMTD inframtdObjNSPperL = new WrapperInfraNSPperLMTD();
                    inframtdObjNSPperL.mtdcount = mapOfMonthVsInfraNSPperLMtdCount.get(str);
                    lubesInfraNSPperLWrapListMTD.add(inframtdObjNSPperL); 
                }
                else{
                    WrapperInfraNSPperLMTD inframtdObjNSPperL = new WrapperInfraNSPperLMTD();
                    inframtdObjNSPperL.mtdcount = 0.00;
                    lubesInfraNSPperLWrapListMTD.add(inframtdObjNSPperL);
                }
                if(mapOfMonthVsInfraNSPperLPriceCount.containsKey(str)){
                    WrapperInfraNSPperLPrice infraPriceObjNSPperL = new WrapperInfraNSPperLPrice();
                    infraPriceObjNSPperL.pricecount = mapOfMonthVsInfraNSPperLPriceCount.get(str);
                    lubesInfraNSPperLWrapListPrice.add(infraPriceObjNSPperL ); 
                }
                else{
                    WrapperInfraNSPperLPrice infraPriceObjNSPperL = new WrapperInfraNSPperLPrice();
                    infraPriceObjNSPperL.pricecount = 0.00;
                    lubesInfraNSPperLWrapListPrice.add(infraPriceObjNSPperL );
                }
                // end Infra
                
                if(mapOfMonthVsPowerNSPperLestCount.containsKey(str)){
                    WrapperPowergenNSPperLest powerestObjNSPperL = new WrapperPowergenNSPperLest();
                    powerestObjNSPperL.estcount = mapOfMonthVsPowerNSPperLestCount.get(str);
                    lubesPowergenNSPperLWrapListest.add(powerestObjNSPperL);  
                } 
                else{
                    WrapperPowergenNSPperLest powerestObjNSPperL = new WrapperPowergenNSPperLest();
                    powerestObjNSPperL.estcount = 0.00;
                    lubesPowergenNSPperLWrapListest.add(powerestObjNSPperL); 
                }
                if(mapOfMonthVsPowerNSPperLlyCount.containsKey(str)){
                    WrapperPowergenNSPperLly powerlyObjNSPperL = new WrapperPowergenNSPperLly();
                    powerlyObjNSPperL.lycount = mapOfMonthVsPowerNSPperLlyCount.get(str);
                    lubesPowergenNSPperLWrapListly.add(powerlyObjNSPperL); 
                }
                else{
                    WrapperPowergenNSPperLly powerlyObjNSPperL = new WrapperPowergenNSPperLly();
                    powerlyObjNSPperL.lycount = 0.00;
                    lubesPowergenNSPperLWrapListly.add(powerlyObjNSPperL); 
                }
                if(mapOfMonthVsPowerNSPperLMtdCount.containsKey(str)){
                    WrapperPowergenNSPperLMTD powermtdObjNSPperL = new WrapperPowergenNSPperLMTD();
                    powermtdObjNSPperL.mtdcount = mapOfMonthVsPowerNSPperLMtdCount.get(str);
                    lubesPowergenNSPperLWrapListMTD.add(powermtdObjNSPperL);
                }
                else{
                    WrapperPowergenNSPperLMTD powermtdObjNSPperL = new WrapperPowergenNSPperLMTD();
                    powermtdObjNSPperL.mtdcount = 0.00;
                    lubesPowergenNSPperLWrapListMTD.add(powermtdObjNSPperL);
                }
                if(mapOfMonthVsPowerNSPperLPriceCount.containsKey(str)){
                    WrapperPowergenNSPperLPrice powerPriceObjNSPperL = new WrapperPowergenNSPperLPrice ();
                    powerPriceObjNSPperL.pricecount = mapOfMonthVsPowerNSPperLPriceCount.get(str);
                    lubesPowergenNSPperLWrapListPrice.add(powerPriceObjNSPperL);
                }
                else{
                    WrapperPowergenNSPperLPrice powerPriceObjNSPperL = new WrapperPowergenNSPperLPrice ();
                    powerPriceObjNSPperL.pricecount = 0.00;
                    lubesPowergenNSPperLWrapListPrice.add(powerPriceObjNSPperL);
                }
                
                // end powergen
                
                if(mapOfMonthVsIndusDirNSPperLestCount.containsKey(str)){
                    WrapperIndusDirNSPperLest IndusDirestObjNSPperL = new WrapperIndusDirNSPperLest();
                    IndusDirestObjNSPperL.estcount = mapOfMonthVsIndusDirNSPperLestCount.get(str);
                    lubesIndusDirNSPperLWrapListest.add(IndusDirestObjNSPperL);  
                } 
                else{
                    WrapperIndusDirNSPperLest IndusDirestObjNSPperL = new WrapperIndusDirNSPperLest();
                    IndusDirestObjNSPperL.estcount = 0.00;
                    lubesIndusDirNSPperLWrapListest.add(IndusDirestObjNSPperL); 
                }
                if(mapOfMonthVsIndusDirNSPperLlyCount.containsKey(str)){
                    WrapperIndusDirNSPperLly IndusDirlyObjNSPperL = new WrapperIndusDirNSPperLly();
                    IndusDirlyObjNSPperL.lycount = mapOfMonthVsIndusDirNSPperLlyCount.get(str);
                    lubesIndusDirNSPperLWrapListly.add(IndusDirlyObjNSPperL); 
                }
                else{
                    WrapperIndusDirNSPperLly IndusDirlyObjNSPperL = new WrapperIndusDirNSPperLly();
                    IndusDirlyObjNSPperL.lycount = 0.00;
                    lubesIndusDirNSPperLWrapListly.add(IndusDirlyObjNSPperL); 
                }
                if(mapOfMonthVsIndusDirNSPperLMtdCount.containsKey(str)){
                    WrapperIndusDirNSPperLMTD IndusDirmtdObjNSPperL = new WrapperIndusDirNSPperLMTD();
                    IndusDirmtdObjNSPperL.mtdcount = mapOfMonthVsIndusDirNSPperLMtdCount.get(str);
                    lubesIndusDirNSPperLWrapListMTD.add(IndusDirmtdObjNSPperL);
                }
                else{
                    WrapperIndusDirNSPperLMTD IndusDirmtdObjNSPperL = new WrapperIndusDirNSPperLMTD();
                    IndusDirmtdObjNSPperL.mtdcount = 0.00;
                    lubesIndusDirNSPperLWrapListMTD.add(IndusDirmtdObjNSPperL);
                }
                if(mapOfMonthVsIndusDirNSPperLPriceCount.containsKey(str)){
                    WrapperIndusDirNSPperLPrice IndusDirPriceObjNSPperL = new WrapperIndusDirNSPperLPrice ();
                    IndusDirPriceObjNSPperL.pricecount = mapOfMonthVsIndusDirNSPperLPriceCount.get(str);
                    lubesIndusDirNSPperLWrapListPrice.add(IndusDirPriceObjNSPperL);
                }
                else{
                    WrapperIndusDirNSPperLPrice IndusDirPriceObjNSPperL = new WrapperIndusDirNSPperLPrice ();
                    IndusDirPriceObjNSPperL.pricecount = 0.00;
                    lubesIndusDirNSPperLWrapListPrice.add(IndusDirPriceObjNSPperL);
                }
                
                // end Of Industrial Direct
                
                if(mapOfMonthVsInfraDirNSPperLestCount.containsKey(str)){
                    WrapperInfraDirNSPperLest InfraDirestObjNSPperL = new WrapperInfraDirNSPperLest();
                    InfraDirestObjNSPperL.estcount = mapOfMonthVsInfraDirNSPperLestCount.get(str);
                    lubesInfraDirNSPperLWrapListest.add(InfraDirestObjNSPperL);  
                } 
                else{
                    WrapperInfraDirNSPperLest InfraDirestObjNSPperL = new WrapperInfraDirNSPperLest();
                    InfraDirestObjNSPperL.estcount = 0.00;
                    lubesInfraDirNSPperLWrapListest.add(InfraDirestObjNSPperL); 
                }
                if(mapOfMonthVsInfraDirNSPperLlyCount.containsKey(str)){
                    WrapperInfraDirNSPperLly InfraDirlyObjNSPperL = new WrapperInfraDirNSPperLly();
                    InfraDirlyObjNSPperL.lycount = mapOfMonthVsInfraDirNSPperLlyCount.get(str);
                    lubesInfraDirNSPperLWrapListly.add(InfraDirlyObjNSPperL); 
                }
                else{
                    WrapperInfraDirNSPperLly InfraDirlyObjNSPperL = new WrapperInfraDirNSPperLly();
                    InfraDirlyObjNSPperL.lycount = 0.00;
                    lubesInfraDirNSPperLWrapListly.add(InfraDirlyObjNSPperL); 
                }
                if(mapOfMonthVsInfraDirNSPperLMtdCount.containsKey(str)){
                    WrapperInfraDirNSPperLMTD InfraDirmtdObjNSPperL = new WrapperInfraDirNSPperLMTD();
                    InfraDirmtdObjNSPperL.mtdcount = mapOfMonthVsInfraDirNSPperLMtdCount.get(str);
                    lubesInfraDirNSPperLWrapListMTD.add(InfraDirmtdObjNSPperL);
                }
                else{
                    WrapperInfraDirNSPperLMTD InfraDirmtdObjNSPperL = new WrapperInfraDirNSPperLMTD();
                    InfraDirmtdObjNSPperL.mtdcount = 0.00;
                    lubesInfraDirNSPperLWrapListMTD.add(InfraDirmtdObjNSPperL);
                } 
                if(mapOfMonthVsInfraDirNSPperLPriceCount.containsKey(str)){
                    WrapperInfraDirNSPperLPrice InfraDirPriceObjNSPperL = new WrapperInfraDirNSPperLPrice ();
                    InfraDirPriceObjNSPperL.pricecount = mapOfMonthVsInfraDirNSPperLPriceCount.get(str);
                    lubesInfraDirNSPperLWrapListPrice.add(InfraDirPriceObjNSPperL);
                }
                else{
                    WrapperInfraDirNSPperLPrice InfraDirPriceObjNSPperL = new WrapperInfraDirNSPperLPrice ();
                    InfraDirPriceObjNSPperL.pricecount = 0.00;
                    lubesInfraDirNSPperLWrapListPrice.add(InfraDirPriceObjNSPperL);
                }
                
                // end Of Infra Direct
                
            }
            
        }
       
        return null;

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
    
    /////////////////////////////////////////////////////////////////////////////Start of wrapper of Lubes Volume (KL)/////////////////////////////////////////////////////////
    
    global class WrapperCumminsMTD{
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperCumminsLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperCumminsEst{
        
        
        public decimal estCount{get;set;}  
    }
    
    global class WrapperIndustrialMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndustrialLY{
        
       
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndustrialEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperInfraMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperPowergenMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperPowergenLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperPowergenEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperIndusDirMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndusDirLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndusDirEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperInfraDirMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraDirLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraDirEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class aopWrapper{
        public decimal count{get;set;}
    }
    global class aopWrapperGp{
        public decimal count{get;set;}
    }
    global class aopWrapperGpPerL{
        public decimal count{get;set;}
    }
    /////////////////////////////////////////////////////////////////////////////End of wrapper of Lubes Volume (KL)/////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////// start of Gp Lubes Wrapper /////////////////////////////////////////////////////////////////
    global class WrapperCumminsGPMTD{
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperCumminsGPLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperCumminsGPEst{
        
        
        public decimal estCount{get;set;}  
    }
    
    global class WrapperIndustrialGPMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndustrialGPLY{
        
       
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndustrialGPEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperInfraGPMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraGPLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraGPEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperPowergenGPMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperPowergenGPLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperPowergenGPEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperIndusDirGPMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndusDirGPLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndusDirGPEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperInFraDirGPMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInFraDirGPLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInFraDirGPEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    
    //////////////////////////////////////////////////////////////////////////// End of Gp Lubes Wrapper /////////////////////////////////////////////////////////////////
    
    //////////////////////////////////////////////////////////////////////////// start of Gp/L Lubes Wrapper /////////////////////////////////////////////////////////////////
    global class WrapperCumminsGPperLMTD{
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperCumminsGPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperCumminsGPperLEst{
        
        
        public decimal estCount{get;set;}  
    }
    
    global class WrapperIndustrialGPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndustrialGPperLLY{
        
       
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndustrialGPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperInfraGPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraGPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraGPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperPowergenGPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperPowergenGPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperPowergenGPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperIndusDirGPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndusDirGPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndusDirGPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperInfraDirGPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraDirGPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraDirGPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    
    //////////////////////////////////////////////////////////////////////////// End of Gp/L Lubes Wrapper /////////////////////////////////////////////////////////////////
    
    
    //////////////////////////////////////////////////////////////////////////// start of NSP/L Lubes Wrapper /////////////////////////////////////////////////////////////////
    global class WrapperCumminsNSPperLMTD{
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperCumminsNSPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperCumminsNSPperLEst{
        
        
        public decimal estCount{get;set;}  
    }
    
    global class WrapperCumminsNSPperLPrice{
        
        
        public decimal Pricecount{get;set;}  
    }
    
    
    global class WrapperIndustrialNSPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndustrialNSPperLLY{
        
       
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndustrialNSPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    
    global class WrapperIndustrialNSPperLPrice{
        
        
        public decimal Pricecount{get;set;}  
    }
    
    global class WrapperInfraNSPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraNSPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraNSPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperInfraNSPperLPrice{
        
        
        public decimal Pricecount{get;set;}  
    }
    global class WrapperPowergenNSPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperPowergenNSPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperPowergenNSPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperPowergenNSPperLPrice{
        
        
        public decimal Pricecount{get;set;}  
    }
    
    global class WrapperIndusDirNSPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperIndusDirNSPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperIndusDirNSPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperIndusDirNSPperLPrice{
        
        
        public decimal Pricecount{get;set;}  
    }
    
    global class WrapperInfraDirNSPperLMTD{
        
        
        public decimal mtdcount{get;set;}   
        
    }
    
    global class WrapperInfraDirNSPperLLY{
        
        
        public decimal lycount{get;set;}  
    }
    
    global class WrapperInfraDirNSPperLEst{
        
        
        public decimal estcount{get;set;}  
    }
    global class WrapperInfraDirNSPperLPrice{
        
        
        public decimal Pricecount{get;set;}  
    }
    
    
    //////////////////////////////////////////////////////////////////////////// End of NSP/L Lubes Wrapper /////////////////////////////////////////////////////////////////
    global class cogWrapper {
        public decimal cogsCount{get;set;}
        public string monthName {get ; set ;}
       
    }
}