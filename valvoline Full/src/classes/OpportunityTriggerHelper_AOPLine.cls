public class OpportunityTriggerHelper_AOPLine{

    // this function use for update aop line record called when opprtunity status closed .
    public void updateAOPLineOnOppClosed(){
        List<Opportunity> newOpportunities = (List<Opportunity>)trigger.new;
        Map<Id,Opportunity> oldMapOpportunities = (Map<Id,Opportunity>)trigger.oldMap;
        Map<Id,Opportunity> newMapOpportunities = (Map<Id,Opportunity>)trigger.newMap;
        
        List<Opportunity> updateOpportunityWithRKAMList = new List<Opportunity>(); // update opportunity fields: Regional Split with RKAM and Regional Split without RKAM
        List<Opportunity> updateOpportunityWithoutRKAMList = new List<Opportunity>();
                        
        List<Id> oppIds = new List<Id>();

        for(Opportunity opp : newOpportunities ){
            if(oldMapOpportunities.get(opp.Id).StageName != opp.StageName && opp.StageName == 'Closed' && opp.Month__c != null && opp.Financial_Year__c!= null)
                oppIds.add(opp.Id);            
        }  
        if(oppIds.size() > 0){
                
            Set<Id> useridSet = new Set<Id>();
            Set<String> oppMonths = new Set<String>();
            Set<String> oppYears = new Set<String>();
            List<Opportunity> oppList = [SELECT Id,Account.Category__c,MTD_Volume__c,MTD_Focussed_Volume__c,MTD_GP__c, MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, Month__c,Year__c,Financial_Year__c,OwnerId,Owner.ManagerId,Owner.Manager.ManagerId,Regional_Split_with_RKAM__c,Regional_Split_without_RKAM__c,
                                                (SELECT Id, UserId,User.ManagerId,User.Manager.ManagerId,TeamMemberRole 
                                                 FROM OpportunityTeamMembers WHERE TeamMemberRole != null AND UserId != null) 
                                        FROM Opportunity WHERE Id IN:oppIds];
            for(Opportunity opp : oppList){
            
                /////////////////////// new code to update opportunity fields
                Boolean checkRKAM = false;
                for(OpportunityTeamMember oppTemMember : opp.OpportunityTeamMembers)
                {
                    if(oppTemMember.TeamMemberRole.EqualsIgnoreCase('RKAM'))
                    {
                        opp.Regional_Split_with_RKAM__c = opp.MTD_Volume__c;
                        updateOpportunityWithRKAMList.add(opp);
                        checkRKAM = true;
                    }
                }
                system.debug('Team Member size: '+opp.OpportunityTeamMembers.size());
                if(opp.OpportunityTeamMembers.size()==0 || checkRKAM==false)
                {
                    opp.Regional_Split_without_RKAM__c = opp.MTD_Volume__c;
                    updateOpportunityWithoutRKAMList.add(opp);
                }
                               
                system.debug('Opportunity List with RKAM: '+updateOpportunityWithRKAMList);
                system.debug('Opportunity List without RKAM: '+updateOpportunityWithoutRKAMList); 
                
                ////////////////////////////////////// end of new code ////////////////////
            
                oppMonths.add(opp.Month__c);
                oppYears.add(opp.Financial_Year__c);
                
                if(opp.OwnerId != null)
                    useridSet.add(opp.OwnerId);
                
                if(opp.Owner.ManagerId != null)
                    useridSet.add(opp.Owner.ManagerId);
             
                for(OpportunityTeamMember oppTemMember : opp.OpportunityTeamMembers){
                    useridSet.add(oppTemMember.UserId);
                    
                    if(oppTemMember.User.ManagerId != null)
                        useridSet.add(oppTemMember.User.ManagerId);
                        
                    if(oppTemMember.User.Manager.ManagerId != null)
                        useridSet.add(oppTemMember.User.Manager.ManagerId);
                }
           }
           
           if(useridSet.size() > 0 && oppMonths.size() >0 && oppYears.size() >0){
                Map<Id,User> userMap = new Map<Id,User>([SELECT Id,Profile.Name FROM User WHERE Id IN: useridSet]);
                
                Map<String,Id> aopLnMap = new Map<String,Id>();
                for(AOP_Line__c aopLn : [SELECT Id,Month__c,MTD_Regional_Vol_in_kL__c, MTD_National_Vol_in_kL__c,MTD_Focus_Vol_in_kL__c, MTD_Regional_GP__c, MTD_National_GP__c, MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, 
                                                MTD_New_Win_in_kL__c,Valvoline_Financial_Year__c,AOP_Plan_User__c FROM AOP_Line__c
                                         WHERE  AOP_Plan_User__c IN : useridSet AND Month__c IN : oppMonths AND Valvoline_Financial_Year__c IN : oppYears]){
                                                
                    String keyMap = aopLn.Month__c.toUpperCase() +'#'+aopLn.Valvoline_Financial_Year__c+'#'+aopLn.AOP_Plan_User__c;   
                    aopLnMap.put(keyMap,aopLn.Id);
               }
               
               if(aopLnMap.size() > 0){
                   List<Monthly_line_Logs__c> inserMonthLn = new List<Monthly_line_Logs__c>();
                   List<AOP_Setting__mdt> aopCustomSetting = [select Opportunity_Fields__c, Monthly_Line_Log_Fields__c, Role__c from AOP_Setting__mdt];
                   for(Opportunity opp : oppList){
                        opp.MTD_Volume__c = opp.MTD_Volume__c != null ? opp.MTD_Volume__c : 0;
                        opp.MTD_GP__c = opp.MTD_GP__c != null ? opp.MTD_GP__c : 0;
                        opp.MTD_Focussed_Volume__c = opp.MTD_Focussed_Volume__c != null ? opp.MTD_Focussed_Volume__c : 0;
                        
                        // initialize MTD AUS and MTD NON AUS values
                        opp.MTD_AUS_Volume__c = opp.MTD_AUS_Volume__c != null ? opp.MTD_AUS_Volume__c : 0;
                        opp.MTD_NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c != null ? opp.MTD_NON_AUS_Volume__c : 0;
                       
                        
                        String keyMap = opp.Month__c.toUpperCase() +'#'+opp.Financial_Year__c;
                        
                        //TBM
                        if(opp.OwnerId != null){
                            if(aopLnMap.containsKey(keyMap+'#'+opp.OwnerId)){
                            
                                Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+opp.OwnerId);
                                
                                for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                {                                    
                                    if(aopSetting.Role__c=='TBM')
                                    {
                                        Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                        mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                    }
                                    
                                }
                                
                                /*mnthAopLn.MTD_Regional_Vol_in_kL__c = opp.MTD_Volume__c;
                                mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;                         
                                mnthAopLn.MTD_Regional_GP__c = opp.MTD_GP__c;*/
                                
                                mnthAopLn.Regional_Split_with_RKAM__c=opp.Regional_Split_with_RKAM__c;
                                mnthAopLn.Regional_Split_without_RKAM__c=opp.Regional_Split_without_RKAM__c;
                                
                                /*/////// copy AUS and NON AUS Volume
                                mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                
                                if(opp.Account.Category__c== 'New')
                                    mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                
                                inserMonthLn.add(mnthAopLn);
                            }
                        }
                        //M1 : TBM's Manager
                        if(opp.Owner.ManagerId != null){
                            if(aopLnMap.containsKey(keyMap+'#'+opp.Owner.ManagerId)){
                                if(userMap.get(opp.Owner.ManagerId).profile.name.equalsIgnoreCase('ZM')){
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+opp.Owner.ManagerId);
                                    
                                    for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                    {                                        
                                        system.debug('Role Name: '+aopSetting.Role__c);
                                        
                                        if(aopSetting.Role__c=='M1') // TBM's Manager
                                        {
                                            Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                            mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                        }                                        
                                    }
                                    
                                    /*mnthAopLn.MTD_Regional_Vol_in_kL__c = opp.MTD_Volume__c;
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;                         
                                    mnthAopLn.MTD_Regional_GP__c = opp.MTD_GP__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                    
                                    if(opp.Account.Category__c== 'New')
                                        mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                    
                                    inserMonthLn.add(mnthAopLn); 
                                }else if(userMap.get(opp.Owner.ManagerId).profile.name.equalsIgnoreCase('NSH')){
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+opp.Owner.ManagerId);
                                    
                                    for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                    {                                        
                                        system.debug('Role Name: '+aopSetting.Role__c);
                                        
                                        if(aopSetting.Role__c=='NSH')
                                        {
                                            Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                            mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                        }                                        
                                    }
                                    
                                    /*mnthAopLn.MTD_National_Vol_in_kL__c = opp.MTD_Volume__c;
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;                         
                                    mnthAopLn.MTD_National_GP__c = opp.MTD_GP__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                    
                                    if(opp.Account.Category__c== 'New')
                                        mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                    
                                    inserMonthLn.add(mnthAopLn); 
                                }                                  
                            }
                        }
                        //M2
                        if(opp.Owner.Manager.ManagerId != null){
                            if(aopLnMap.containsKey(keyMap+'#'+opp.Owner.Manager.ManagerId)){                                
                                if(userMap.get(opp.Owner.Manager.ManagerId).profile.name.equalsIgnoreCase('NSH')){
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+opp.Owner.Manager.ManagerId);
                                    
                                    for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                    {                                        
                                        system.debug('Role Name: '+aopSetting.Role__c);
                                        
                                        if(aopSetting.Role__c=='M2') // NSH's Manager
                                        {
                                            Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                            mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                        }                                        
                                    }
                                    
                                    /*mnthAopLn.MTD_National_Vol_in_kL__c = opp.MTD_Volume__c;
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;                         
                                    mnthAopLn.MTD_National_GP__c = opp.MTD_GP__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                    
                                    if(opp.Account.Category__c== 'New')
                                        mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                    
                                    inserMonthLn.add(mnthAopLn); 
                                }                             
                            }
                        }
                        //Boolean checkRKAM = false;
                        //system.debug('CHECK RKAM: '+checkRKAM);
                        for(OpportunityTeamMember oppTemMember : opp.OpportunityTeamMembers){
                            if(oppTemMember.TeamMemberRole.EqualsIgnoreCase('RKAM')){
                                
                                //checkRKAM = true;
                                //opp.Regional_Split_with_RKAM__c = opp.MTD_Volume__c;
                                  
                                if(aopLnMap.containsKey(keyMap+'#'+oppTemMember.UserId)){
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+oppTemMember.UserId);
                                    
                                    for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                    {                                        
                                        system.debug('Role Name: '+aopSetting.Role__c);
                                        
                                        if(aopSetting.Role__c=='RKAM')
                                        {
                                            Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                            mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                        }                                        
                                    }
                                    
                                    /*mnthAopLn.MTD_National_Vol_in_kL__c = opp.MTD_Volume__c;
                                    mnthAopLn.MTD_National_GP__c = opp.MTD_GP__c;
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                    
                                    if(opp.Account.Category__c== 'New')
                                        mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                    
                                    inserMonthLn.add(mnthAopLn);                           
                                }
                                
                                //M3
                                if(oppTemMember.User.ManagerId != null && oppTemMember.User.ManagerId != opp.Owner.ManagerId){
                                    if(aopLnMap.containsKey(keyMap+'#'+oppTemMember.User.ManagerId)){
                                        if(userMap.get(oppTemMember.User.ManagerId).profile.name.equalsIgnoreCase('ZM')){
                                            Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                            mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+oppTemMember.User.ManagerId);
                                            
                                            for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                            {                                        
                                                system.debug('Role Name: '+aopSetting.Role__c);
                                                
                                                if(aopSetting.Role__c=='ZM')
                                                {
                                                    Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                                    mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                                }                                        
                                            }
                                            
                                            /*mnthAopLn.MTD_National_Vol_in_kL__c = opp.MTD_Volume__c;
                                            mnthAopLn.MTD_National_GP__c = opp.MTD_GP__c;
                                            mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;
                                            
                                            /////// copy AUS and NON AUS Volume
                                            mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                            mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/             
                                            
                                            if(opp.Account.Category__c== 'New')
                                                mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                            inserMonthLn.add(mnthAopLn);
                                        }   
                                    }                    
                                } 
                            }else if(oppTemMember.TeamMemberRole.EqualsIgnoreCase('NKAM')){
                                if(aopLnMap.containsKey(keyMap+'#'+oppTemMember.UserId)){                                    
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+oppTemMember.UserId);
                                    
                                    for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                    {                                        
                                        system.debug('Role Name: '+aopSetting.Role__c);
                                        
                                        if(aopSetting.Role__c=='NKAM')
                                        {
                                            Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                            mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                        }                                        
                                    }
                                    
                                    /*mnthAopLn.MTD_National_Vol_in_kL__c = opp.MTD_Volume__c;
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;
                                    mnthAopLn.MTD_National_GP__c = opp.MTD_GP__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                    
                                    if(opp.Account.Category__c== 'New')
                                        mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                    inserMonthLn.add(mnthAopLn);                             
                                } 
                            }else if(oppTemMember.TeamMemberRole.EqualsIgnoreCase('Segment Manager')){
                                if(aopLnMap.containsKey(keyMap+'#'+oppTemMember.UserId)){
                                   
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+oppTemMember.UserId);
                                    
                                    for(AOP_Setting__mdt aopSetting: aopCustomSetting)
                                    {                                        
                                        system.debug('Role Name: '+aopSetting.Role__c);
                                        
                                        if(aopSetting.Role__c=='Segment Manager')
                                        {
                                            Object oldData = opp.get(aopSetting.Opportunity_Fields__c);
                                            mnthAopLn.put(aopSetting.Monthly_Line_Log_Fields__c, oldData);
                                        }                                        
                                    }
                                    
                                    /*mnthAopLn.MTD_National_Vol_in_kL__c = opp.MTD_Volume__c;
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;
                                    mnthAopLn.MTD_National_GP__c = opp.MTD_GP__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;*/
                                    
                                    if(opp.Account.Category__c== 'New')
                                        mnthAopLn.MTD_New_Win_in_kL__c = opp.MTD_Volume__c;
                                    inserMonthLn.add(mnthAopLn);                              
                                } 
                            }else if(oppTemMember.TeamMemberRole.EqualsIgnoreCase('Product Manager')){
                                if(aopLnMap.containsKey(keyMap+'#'+oppTemMember.UserId)){
                                    Monthly_line_Logs__c mnthAopLn = new Monthly_line_Logs__c(Monthly_Opportunity__c = opp.Id); 
                                    mnthAopLn.Monthly_line__c = aopLnMap.get(keyMap+'#'+oppTemMember.UserId);
                                    mnthAopLn.MTD_Focus_Vol_in_kL__c = opp.MTD_Focussed_Volume__c;
                                    
                                    /////// copy AUS and NON AUS Volume
                                    mnthAopLn.AUS_Volume__c = opp.MTD_AUS_Volume__c;
                                    mnthAopLn.NON_AUS_Volume__c = opp.MTD_NON_AUS_Volume__c;
                                    
                                    inserMonthLn.add(mnthAopLn);                     
                                } 
                            } 
                            
                        }                            
                   }
                   
                   update oppList;
                   
                   if(inserMonthLn.size() > 0)
                       insert inserMonthLn;
               }
               
           }
           
           /////////
           if(updateOpportunityWithRKAMList.size()>0)
               update updateOpportunityWithRKAMList;
           
           if(updateOpportunityWithoutRKAMList.size()>0)
               update updateOpportunityWithoutRKAMList;    
        }
    }
}