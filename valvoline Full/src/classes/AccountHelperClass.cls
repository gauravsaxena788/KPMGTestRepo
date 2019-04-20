public class AccountHelperClass
{
    Map<Id, List<AccountTeamMember>> ATMmap = new Map<Id, List<AccountTeamMember>>();
    List<Opportunity> optyListtoUpsert = new List<Opportunity>();
    
    //Id primaryaccRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'VCPL_Primary_Account' AND sObjectType = 'Account'].Id;
    
    ////// get list of Primary Account Record types ///////
    List<string> primaryRecordTypeIds = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
    
    Set<String> primaryRecordTypes = new Set<String>(primaryRecordTypeIds);
    
    public void CreateMonthlyOpportunity(List<Opportunity> optyList, List<Account> accList)
    {
        Integer fisyear = 0;
        //system.debug('list of primary account record type ids: '+primaryRecordTypeIds);
                
        String str = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        fisyear = Integer.valueOf(str);
        
        if(optyList.size()>0) // called from batch
        {
            //for(AccountTeamMember atm: [Select Id, AccountId, UserId, TeamMemberRole, OpportunityAccessLevel from AccountTeamMember where Account.Status__c='Activated'])
            for(AccountTeamMember atm: [Select Id, AccountId, UserId, TeamMemberRole, OpportunityAccessLevel from AccountTeamMember where Account.Status__c='Activated' AND Account.RecordTypeId IN: primaryRecordTypeIds])                                    
            {
                if(!ATMmap.containsKey(atm.accountID))
                {
                    ATMmap.put(atm.AccountId, new List<AccountTeamMember>());
                }
                
                ATMmap.get(atm.AccountId).add(atm);
            }
            
            for(Opportunity opty: optylist)
            {
                Opportunity newOpty = opty.Clone(false,true);
                newOpty.StageName = 'Open';
                newOpty.OwnerId = opty.Account.OwnerId;
                newOpty.Year__c = String.valueOf(Integer.valueOf(opty.Year__c)+1);
                newOpty.Financial_Year__c = String.valueOf(Integer.valueOf(opty.Financial_Year__c)+1);
                newOpty.IsCreatedfromVF__c = true;
                newOpty.CloseDate = Date.valueOf((opty.CloseDate.Year()+1)+'-'+(opty.CloseDate.Month())+'-'+(opty.CloseDate.Day()));
                newOpty.Latest_Est_GP_ltr__c = 0.0;
                newOpty.Latest_Est_Volume__c = 0.0;
                newOpty.MTD_GP__c = 0.0;
                newOpty.MTD_Volume__c = 0.0;
                newOpty.MTD_DSO__c = 0.0;
                newOpty.MTD_Focussed_Volume__c = 0.0;
                newOpty.Planned_Volume__c = 0.0;
                newOpty.Planned_GP_Ltr__c = 0.0;
                
                newOpty.MTD_AUS_Volume__c = 0.0;
                newOpty.MTD_NON_AUS_Volume__c = 0.0;
                newOpty.MTD_NSP_Ltr_AUS__c = 0.0;
                newOpty.MTD_NSP_Ltr_Lubes__c = 0.0;
                
                newOpty.LY_GP__c = opty.MTD_GP__c;
                newOpty.LY_Volume__c = opty.MTD_Volume__c;  
                newOpty.Name = opty.Month__c+'-'+newOpty.Year__c+'-'+String.valueOf(opty.Account.Ship_to_Code__c)+'-'+'Monthly Plan';
                String num = String.valueOf(opty.Actual_Month_Opposite__c);
                if(num.length()!=2)
                {
                    num = '0'+num;
                }
                
                if(Test.isRunningTest())
                {
                    newOpty.Opportunity_Code__c = '0000';
                }
                else
                {
                    String mystr = opty.Opportunity_Code__c.right(2);
                    String str2 = String.valueOf(Integer.valueOf(mystr)+1);
                    String str3 = (opty.Opportunity_Code__c).substring(0,opty.Opportunity_Code__c.length()-2);
                    String fstr = str3+str2;
                    newOpty.Opportunity_Code__c = fstr;
                    //MG :Adding new fields
                    opportunity ly = new opportunity(Opportunity_Code__c = opty.Opportunity_Code__c);
                    if(ly!=null)                    
                        newOpty.Last_Year_Monthly_Plan__r=ly;
                    newOpty.LY_AUS_Vol__c=opty.MTD_AUS_Volume__c; 
                    newOpty.LY_Lubes_Vol__c=opty.MTD_NON_AUS_Volume__c; 
                    newOpty.LY_NSP_Ltr_Lubes__c=opty.MTD_NSP_Ltr_Lubes__c; 
                    newOpty.LY_NSP_Ltr_AUS__c=opty.MTD_NSP_Ltr_AUS__c;  

                    optyListtoUpsert.add(newOpty);
                }
            }
        }
        
        if(accList.size()>0) // called from account trigger
        {
            for(AccountTeamMember atm: [Select Id, AccountId, UserId, TeamMemberRole, OpportunityAccessLevel from AccountTeamMember where AccountId IN :accList])
            {
                if(!ATMmap.containsKey(atm.accountID))
                {
                    ATMmap.put(atm.AccountId, new List<AccountTeamMember>());
                }
                
                ATMmap.get(atm.AccountId).add(atm);
            }
            
            // create monthly opportunity for all 12 months
            Id monthlyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Monthly Plan').getRecordTypeId();
            List<String> monthList = new List<String>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
            Map<String, String> monthMap = new Map<String, String>();
            monthMap.put('Jan', '01');
            monthMap.put('Feb', '02');
            monthMap.put('Mar', '03');
            monthMap.put('Apr', '04');
            monthMap.put('May', '05');
            monthMap.put('Jun', '06');
            monthMap.put('Jul', '07');
            monthMap.put('Aug', '08');
            monthMap.put('Sep', '09');
            monthMap.put('Oct', '10');
            monthMap.put('Nov', '11');
            monthMap.put('Dec', '12');
            
            for(Account ac: accList)
            {
                //String fyear = String.valueOf(System.TODAY().YEAR()+1);
                for(String month: monthList)
                {
                    Opportunity newOpty = new Opportunity();
                    newOpty.AccountId = ac.Id;
                    newOpty.RecordTypeId = monthlyRecordTypeId;
                    newOpty.StageName = 'Open';
                    newOpty.Month__c = month;
                    newOpty.Monthly_Plan_Month__c = month;
                    newOpty.OwnerId = ac.OwnerId;
                    
                    if(month=='Oct' || month=='Nov' || month=='Dec')
                        newOpty.Year__c = String.valueOf(fisyear-1);
                    else
                        newOpty.Year__c = String.valueOf(fisyear);
                    newOpty.Financial_Year__c = String.valueOf(fisyear);
                    newOpty.IsCreatedfromVF__c = true;
                    
                    Integer numberOfDays = Date.daysInMonth(Integer.valueOf(newOpty.Year__c), Integer.valueOf(monthMap.get(month)));
                    Date lastDayOfMonth = Date.newInstance(Integer.valueOf(newOpty.Year__c), Integer.valueOf(monthMap.get(month)), numberOfDays);
                    system.debug('Last Date: '+lastDayOfMonth);
                    
                    newOpty.CloseDate = lastDayOfMonth; //Date.valueOf((System.TODAY().Year()+1)+'-'+(System.TODAY().Month())+'-'+(System.TODAY().Day()));
                    newOpty.Latest_Est_GP_ltr__c = 0.0;
                    newOpty.Latest_Est_Volume__c = 0.0;
                    newOpty.MTD_GP__c = 0.0;
                    newOpty.MTD_Volume__c = 0.0;
                    newOpty.MTD_DSO__c = 0.0;
                    newOpty.MTD_Focussed_Volume__c = 0.0;
                    newOpty.Planned_Volume__c = 0.0;
                    newOpty.Planned_GP_Ltr__c = 0.0;
                    newOpty.LY_GP__c = 0.0;
                    newOpty.LY_Volume__c = 0.0; 
                    
                    newOpty.MTD_AUS_Volume__c = 0.0;
                    newOpty.MTD_NON_AUS_Volume__c = 0.0;
                    newOpty.MTD_NSP_Ltr_AUS__c = 0.0;
                    newOpty.MTD_NSP_Ltr_Lubes__c = 0.0;
                     
                    newOpty.Name = month+'-'+newOpty.Year__c+'-'+String.valueOf(ac.Ship_to_Code__c)+'-'+'Monthly Plan';
                    
                    
                    newOpty.Opportunity_Code__c = String.valueOf(ac.Ship_to_Code__c)+monthMap.get(month)+(newOpty.Year__c.right(2));
                    
                    system.debug('Opportunity Code: '+newOpty.Opportunity_Code__c);
                    optyListtoUpsert.add(newOpty);
                }
            }
        }
        
        system.debug('Opportunity List: '+optyListtoUpsert);
        if(optyListtoUpsert.size()>0){
            
            if(accList.size()>0) // called when account triggered
            {
                upsert optyListtoUpsert;
            }
            else // called when batch run
            {                       
                Schema.SObjectField f = Opportunity.Opportunity_Code__c;
                Database.UpsertResult[] srList = Database.upsert(optyListtoUpsert, f, false);
                // Iterate through each returned result
                for (Database.UpsertResult sr : srList)
                {
                    if (sr.isSuccess()) 
                    {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                    }
                    else 
                    {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) 
                        {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Opportunity fields that affected this error: ' + err.getFields());
                        }
                    }
                }            
            }
            
            
            String lstMonthOppCode;
            //MG adding Last month opp link
            for(Opportunity o :optyListtoUpsert){
                lstMonthOppCode='';
                if(o.Month__c=='Jan'){
                    lstMonthOppCode=o.Opportunity_Code__c.left(6)+'12'+string.valueof((Integer.valueof(o.Opportunity_Code__c.right(2)))-1 );   
                }
                else if(o.Month__c=='Oct'){
                    lstMonthOppCode=o.Opportunity_Code__c.left(6)+'09'+string.valueof((Integer.valueof(o.Opportunity_Code__c.right(2))));   
                }
                else{
                    lstMonthOppCode=string.valueof((Integer.valueof(o.Opportunity_Code__c.left(8)))-1 )+o.Opportunity_Code__c.right(2);   
                }
                
                
                if(o.Month__c=='Oct' && accList.size()>0 ){
                    //Do nothing - Excluding Oct MP because new account will not have any last month opportunity for Oct
                }
                else{
                    opportunity lmonth = new opportunity(Opportunity_Code__c =lstMonthOppCode);
                    o.Last_Month_Opportunity__r=lmonth ;
                }
            }
            
            if(accList.size()>0)
                update optyListtoUpsert;
        }    
        
        List<OpportunityTeamMember> otMember = new List<OpportunityTeamMember>();
        
        for(Opportunity opt: optyListtoUpsert)
        {
            if(atmMap.size()>0)
            {
                if(atmMap.get(opt.AccountId)!=null){
                    for(AccountTeamMember am: atmMap.get(opt.AccountId))
                    {
                        OpportunityTeamMember ot = new OpportunityTeamMember();
                        ot.OpportunityId = opt.Id;
                        ot.UserId = am.UserId;
                        ot.TeamMemberRole = am.TeamMemberRole;
                        ot.OpportunityAccessLevel = am.OpportunityAccessLevel;
                        otMember.add(ot);
                    }
                }
            }
        }
        
        if(otMember.size()>0 && accList.size()>0)
            insert otMember;
        system.debug('ATMmap: '+ATMmap);
        
    }
    
    
    public void updateLastMonthOpportunity(List<Opportunity> optList, List<Account> accList)
    {
        String lstMonthOppCode;
        for(Opportunity o :optList)
        {
            lstMonthOppCode='';
            if(o.Month__c=='Jan'){
                system.debug('Print Opportunity Code: '+o.Opportunity_Code__c);
                lstMonthOppCode=o.Opportunity_Code__c.left(6)+'12'+string.valueof((Integer.valueof(o.Opportunity_Code__c.right(2)))-1 );   
            }
            else if(o.Month__c=='Oct'){
                lstMonthOppCode=o.Opportunity_Code__c.left(6)+'09'+string.valueof((Integer.valueof(o.Opportunity_Code__c.right(2))));   
            }
            else{
                lstMonthOppCode=string.valueof((Integer.valueof(o.Opportunity_Code__c.left(8)))-1 )+o.Opportunity_Code__c.right(2);   
            }
            
            
            if(o.Month__c=='Oct' && accList.size()>0 ){
                //Do nothing - Excluding Oct MP because new account will not have any last month opportunity for Oct
            }
            else{
                opportunity lmonth = new opportunity(Opportunity_Code__c =lstMonthOppCode);
                o.Last_Month_Opportunity__r=lmonth ;
            }
            o.Monthly_Plan_Month__c = o.Month__c;
        }
            
        Schema.SObjectField f = Opportunity.Opportunity_Code__c;
        Database.UpsertResult[] srList = Database.upsert(optList, f, false);
        // Iterate through each returned result
        for (Database.UpsertResult sr : srList)
        {
            if (sr.isSuccess()) 
            {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else 
            {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) 
                {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Opportunity fields that affected this error: ' + err.getFields());
                }
            }
        }           
    }
    
    public void createOpportunityTeamforNewMonthlyPlan(List<Opportunity> optyList)
    {
        if(optyList.size()>0)
        {
            for(AccountTeamMember atm: [Select Id, AccountId, UserId, TeamMemberRole, OpportunityAccessLevel from AccountTeamMember where Account.Status__c='Activated'])
            {
                if(!ATMmap.containsKey(atm.accountID))
                {
                    ATMmap.put(atm.AccountId, new List<AccountTeamMember>());
                }
                
                ATMmap.get(atm.AccountId).add(atm);
            }
            
            List<OpportunityTeamMember> otMember = new List<OpportunityTeamMember>();
        
            for(Opportunity opt: optyList)
            {
                if(ATMmap.size()>0)
                {
                    if(ATMmap.get(opt.AccountId)!=null)
                    {
                        for(AccountTeamMember am: ATMmap.get(opt.AccountId))
                        {
                            OpportunityTeamMember ot = new OpportunityTeamMember();
                            ot.OpportunityId = opt.Id;
                            ot.UserId = am.UserId;
                            ot.TeamMemberRole = am.TeamMemberRole;
                            ot.OpportunityAccessLevel = am.OpportunityAccessLevel;
                            otMember.add(ot);
                        }
                    }
                }
            }
            
            Database.SaveResult[] srList = Database.insert(otMember, false);
            // Iterate through each returned result
            for (Database.SaveResult sr : srList)
            {
                if (sr.isSuccess()) 
                {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account team.' + sr.getId());
                }
                else 
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) 
                    {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account Team fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            //if(otMember.size()>0)
                //insert otMember;
            system.debug('ATMmap: '+ATMmap);
        }
    }
    
    /// Method to auto populate SM (Account Team) on account creation on the basis of BU and Industry Segment.
    public void Account_SM(List<Account> accList)
    {
        List<AccountTeamMember> accTeamMember = new List<AccountTeamMember>();
        Map<String, String> customSettingMap = new Map<String, String>();
        
        for(Account_Setting__mdt accSetting: [Select BU_Name__c, Industry_Segment__c, Employee_Code__c, Role__c from Account_Setting__mdt])
        {
            customSettingMap.put(accSetting.BU_Name__c+'-'+accSetting.Industry_Segment__c, accSetting.Employee_Code__c+'-'+accSetting.Role__c);
        }
        for(Account act: accList)
        {
            //system.debug('act record type id: '+act.RecordTypeId);
            //if(act.BU_Name__c!=null && act.Indutry_Segment__c!=null)
            system.debug('Primary Record Type Ids: '+primaryRecordTypeIds);
            system.debug('Account Record Type Id: '+act.RecordTypeId);
            if(act.BU_Name__c!=null && act.Indutry_Segment__c!=null && primaryRecordTypes.contains(act.RecordTypeId))                                    
            {
                if(customSettingMap.get(act.BU_Name__c+'-'+act.Indutry_Segment__c)!=null)
                {
                    AccountTeamMember atMember = new AccountTeamMember();
                    
                    
                    String mstr = customSettingMap.get(act.BU_Name__c+'-'+act.Indutry_Segment__c);
                    List<String> mList = mstr.split('-');
                    
                    atMember.AccountId = act.Id;
                    atMember.TeamMemberRole = mList[1];
                    
                    User u = new User();
                    u.Employee_Code__c = mList[0];
                    
                    atMember.User = u;
                    atMember.OpportunityAccessLevel = 'Read';
                    atMember.AccountAccessLevel = 'Edit';
                    atMember.CaseAccessLevel = 'Read';
                    
                    accTeamMember.add(atMember);
                }
            }
        }
        system.debug('Account Team Member: '+accTeamMember);
        if(accTeamMember.size()>0)
            insert accTeamMember;
    }
    
    
    // Change owner of monthly plan open opportunity on Account owner change
    public void changeOpportunityOwnerofOpenMonthlyPlan(List<Account> accList, Map<Id, Account> oldAccountMap)
    {
        try 
        {
            Set<Id> accountIds = new Set<Id>(); //set for holding the Ids of all Accounts that have been assigned to new Owners
            Map<Id, String> newOwnerIds = new Map<Id, String>(); //map for holding the new account ownerId
            
            Opportunity[] opportunityUpdates = new Opportunity[0]; //Opportunity sObject to hold OwnerId updates
            
            for (Account a : accList) 
            {                
                //if(a.OwnerId != oldAccountMap.get(a.Id).OwnerId)
                if(a.OwnerId != oldAccountMap.get(a.Id).OwnerId && primaryRecordTypes.contains(a.RecordTypeId))                                                
                {
                    newOwnerIds.put(a.Id, a.OwnerId); //put the new OwnerId value in a map
                    accountIds.add(a.Id); //add the Account Id to the set
                }
            }
            
            system.debug('newOwnerIds: '+newOwnerIds);
            system.debug('accountIds: '+accountIds);
            
            if (!accountIds.isEmpty()) 
            {
                for(Account act : [SELECT Id, (SELECT Id, OwnerId FROM Opportunities WHERE StageName = 'Open' AND RecordType.DeveloperName='Monthly_Plan') FROM Account WHERE Id in :accountIds]) 
                {
                    String newOwnerId = newOwnerIds.get(act.Id); //get the new OwnerId value for the account
                    
                    for(Opportunity o : act.Opportunities) 
                    {
                        Opportunity updatedOpportunity = new Opportunity(Id = o.Id, OwnerId = newOwnerId); //create a new Opportunity sObject
                        opportunityUpdates.add(updatedOpportunity); //add the opportunity to our List of updates
                    }
                }
                
                update opportunityUpdates; //update the Opportunities
            }
        } 
        catch(Exception e) 
        {
            System.Debug('reassignRelatedOpportunities failure: '+e.getMessage());
        }
    }
    
    

}