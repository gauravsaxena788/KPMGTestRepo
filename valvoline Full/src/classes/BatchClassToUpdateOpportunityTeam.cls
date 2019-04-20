/**************************************************************
**** Class Name - BatchClasstoUpsertOpportunityTeamFromAccountTeam 
**** Author - KPMG
**** Created Date - 06/03/2018
**** Description - Upsert Opportunity Team member from Account Team Member 
******************************************************************/

global class BatchClassToUpdateOpportunityTeam implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    Set<Id> accIds = new Set<Id>();
    Map<Id, List<AccountTeamMember>> ATMmap = new Map<Id, List<AccountTeamMember>>();
    List<OpportunityTeamMember> otMember = new List<OpportunityTeamMember>();
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {      
      return Database.getQueryLocator('SELECT Id, AccountId, UserId, TeamMemberRole, OpportunityAccessLevel FROM AccountTeamMember WHERE (CreatedDate=TODAY OR LastModifiedDate=TODAY) AND (Account.RecordType.DeveloperName=\'VCPL_Primary_Account\' OR Account.RecordType.DeveloperName=\'VCPL_Industrial_Distributor\' OR Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer\' OR Account.RecordType.DeveloperName=\'VCPL_Cummins_Dealer_Branch\')');
    }

    global void execute(Database.BatchableContext BC, List<AccountTeamMember> accountteamlist)
    {
        system.debug('Account Team List: '+accountteamlist);
        for(AccountTeamMember aTeam : accountteamlist)
        {
            accIds.add(aTeam.AccountId);
            
            if(ATMmap.containsKey(aTeam.AccountId))
                ATMmap.get(aTeam.AccountId).add(aTeam);
            else    
                ATMmap.put(aTeam.AccountId, new List<AccountTeamMember> { aTeam });
        }
        system.debug('AccIds: '+accIds);
        system.debug('ATMmap Data: '+ATMmap);
        for(Opportunity opt: [Select Id, AccountId, Account.Id, OwnerId From Opportunity Where RecordType.DeveloperName='Monthly_Plan' AND StageName='Open' AND AccountId IN: accIds])
        {
            for(AccountTeamMember atMember: ATMmap.get(opt.AccountId))
            {
                OpportunityTeamMember ot = new OpportunityTeamMember();
                ot.OpportunityId = opt.Id;
                ot.UserId = atMember.UserId;
                ot.TeamMemberRole = atMember.TeamMemberRole;
                //ot.OpportunityAccessLevel = atMember.OpportunityAccessLevel;
                ot.OpportunityAccessLevel = 'Edit';
                otMember.add(ot);
            }
        }
        
        system.debug('otMember: '+otMember);
        
        if(otMember.size()>0)
            upsert otMember;
           
        
    }

    global void finish(Database.BatchableContext BC)
    {

    }
    
}