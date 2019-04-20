// Opportunity Trigger helper class to check invoice attachment on Opportunity

public with Sharing class OpportunityTriggerHelper
{    
    
    // change Owner for SAP Order Opportunity
    
    public static void changeOwnership(List<Opportunity> SapOppList,Set<Id> accIds)
    {   
        Map<Id,Id> accOppMap = new Map<Id,Id>();
        List<Account> accList = [select Id,OwnerId from Account where Id in : accIds];
        for(Account a : accList)
        {   
            system.debug('******a.Id*** '+a.Id+'***Ow '+a.OwnerId);
            Id ids= accOppMap.get(a.Id);
            if (ids == null) {
                accOppMap.put(a.Id,a.OwnerId);
            }    
            
        }
        for(Opportunity Opp : SapOppList)
        {    
            Opp.OwnerId = accOppMap.get(Opp.AccountId);
        }
        
    }
    
    public static void updateMonthlyPlanOpp(List<Opportunity> SapOppList, Map<Id, Opportunity> oldMapOpp)
    {
       
        List<Opportunity> oppLst= new List<Opportunity>();
        MAP<id,Opportunity> mpMapToupdate= new MAP<id,Opportunity>();
        Map<Id, Opportunity> mpMap = new Map<Id, Opportunity>();
        String recordTypeSAP  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
        Set<Id> parentIds= new Set<Id>();
        for(Opportunity opp : SapOppList){
            Opportunity o=oldMapOpp.get(opp.Id);
             system.debug('**New opp.Volume__c**'+opp.Volume__c);
             system.debug('**o.Volume__c**'+o.Volume__c);
             system.debug('**opp.Focused_Volume__c**'+opp.Focused_Volume__c);
             system.debug('**o.Focused_Volume__c**'+o.Focused_Volume__c);
            if(opp.RecordTypeId == recordTypeSAP && ((opp.Volume__c != o.Volume__c) || (opp.Focused_Volume__c != o.Focused_Volume__c))){
                system.debug('**inside if**'+opp.id);
                parentIds.add(opp.Opportunity_Id__c);
            }
        }
        if(parentIds.size()>0){
            system.debug('**parentIds*'+parentIds);
            List<Opportunity> MPOppList = [SELECT Id, MTD_Volume__c, MTD_Focussed_Volume__c FROM Opportunity WHERE Id IN : parentIds];
            for( Opportunity op:MPOppList){
                mpMap.put(op.Id, op);
            }
            for(Opportunity SAP : SapOppList){
                Opportunity SAPOld=oldMapOpp.get(SAP.Id);
                system.debug('opp.Id '+SAP.Opportunity_Id__c);
                if(SAP.Opportunity_Id__c!=null){
                    Opportunity MP=mpMap.get(SAP.Opportunity_Id__c);
                    system.debug('**SAP.Volume__c '+SAP.Volume__c);
                    if(MP.MTD_Volume__c != null){
                        if((SAP.Volume__c != SAPold.Volume__c))
                            MP.MTD_Volume__c=MP.MTD_Volume__c + SAP.Volume__c;
                    }else{
                        MP.MTD_Volume__c=0.00;
                        if((SAP.Volume__c != SAPold.Volume__c))
                            MP.MTD_Volume__c=MP.MTD_Volume__c + SAP.Volume__c;
                    }
                    if(MP.MTD_Focussed_Volume__c != null){
                        if((SAP.Focused_Volume__c!= SAPold.Focused_Volume__c))
                            MP.MTD_Focussed_Volume__c=MP.MTD_Focussed_Volume__c + SAP.Focused_Volume__c;
                     }else{
                         MP.MTD_Focussed_Volume__c=0.00;
                         if((SAP.Focused_Volume__c!= SAPold.Focused_Volume__c))
                             MP.MTD_Focussed_Volume__c=MP.MTD_Focussed_Volume__c + SAP.Focused_Volume__c;
                     }
                    mpMapToupdate.put(SAP.Opportunity_Id__c,MP);
                }
            }
            for(Id mpid :mpMapToupdate.keySet()){
                oppLst.add(mpMapToupdate.get(mpid));
            }
            Update oppLst;
            
        }
        
    }
    
    //////// insert opportunity team on SAP order when created ////////////////
    
    public void OpportunityTeamCreateforSAPOrder(List<opportunity> oplist)
    {
        Set<Id> monthlyOppIds = new Set<Id>();
        
        for(Opportunity o: oplist)
        {
            if(o.Opportunity_Id__c!=NULL)
                monthlyOppIds.add(o.Opportunity_Id__c);                    
        }
                
        Map<Id, List<OpportunityTeamMember>> oppmembersmonthlylist = new Map<Id, List<OpportunityTeamMember>>();
        List<OpportunityTeamMember> opmemberssap = new list<OpportunityTeamMember>();
        
        for(Opportunity opty: [Select Id, (Select Id, UserId, OpportunityId, OpportunityAccessLevel, TeamMemberRole from OpportunityTeamMembers) from Opportunity where Id In:monthlyOppIds])
        {
            oppmembersmonthlylist.put(opty.Id, opty.OpportunityTeamMembers); 
        }
        
        for(Opportunity opp :oplist)
        {
            if(oppmembersmonthlylist.containsKey(opp.Opportunity_Id__c))
            {
                for(OpportunityTeamMember otm: oppmembersmonthlylist.get(opp.Opportunity_Id__c))
                {
                     opmemberssap.add(New OpportunityTeamMember(OpportunityId = opp.id, TeamMemberRole = otm.TeamMemberRole, OpportunityAccessLevel = otm.OpportunityAccessLevel, UserId= otm.UserId));
                }
            }
        }
        
        if(opmemberssap.size()> 0)
        {
             insert opmemberssap;
        }    
    } 

}