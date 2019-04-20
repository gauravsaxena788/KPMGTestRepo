/**************************************************************
**** Class Name - OpportunityTrigger 
**** Author - KPMG
**** Created Date - 27/07/2017
**** Description - Opportunity process logic. 
******************************************************************/

trigger OpportunityTrigger on Opportunity (before update,after Update,before insert, after insert, after delete) {
    
    // for chaning owner of the SAP Opportunities
    if(Trigger.isBefore && Trigger.isInsert){
       String recordTypeSAP  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
       Set<Id> accIds = New Set<Id>();       
       List<opportunity> sapOpptyList=new list<opportunity>(); 
       for(Opportunity opp : Trigger.New)
       {
           if(opp.RecordTypeId == recordTypeSAP)
           {
              accIds.add(opp.AccountId);
              sapOpptyList.add(opp);
           }
       }
        if(accIds.size()>0)
        {
        OpportunityTriggerHelper.changeOwnership(sapOpptyList,accIds);
        }
    }
    //For AOP line MTD update
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHelper_AOPLine oppAopLine = new OpportunityTriggerHelper_AOPLine();
        oppAopLine.updateAOPLineOnOppClosed();
        //OpportunityTriggerHelper.updateMonthlyPlanOpp(Trigger.new,Trigger.OldMap);
    }
  
    ///////////////// new code for updating rollup sum of sap order opty's volume
    Set<id> mpIds = new Set<id>();
    List<Opportunity> MPOptyToUpdate = new List<Opportunity>();
    Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter)
    {
        for (Opportunity op : Trigger.new)
        {
            if((Trigger.isInsert && Trigger.isAfter) || 
               (Trigger.isUpdate && Trigger.isAfter && 
               (op.Volume__c!=Trigger.oldMap.get(op.Id).Volume__c || 
                op.Focused_Volume__c!=Trigger.oldMap.get(op.Id).Focused_Volume__c || 
                op.AUS_Volume__c!=Trigger.oldMap.get(op.Id).AUS_Volume__c || 
                op.NON_AUS_Volume__c!=Trigger.oldMap.get(op.Id).NON_AUS_Volume__c || 
                op.MTD_NSP_Ltr_AUS__c!=Trigger.oldMap.get(op.Id).MTD_NSP_Ltr_AUS__c || 
                op.MTD_NSP_Ltr_Lubes__c!=Trigger.oldMap.get(op.Id).MTD_NSP_Ltr_Lubes__c || 
                op.NSP_Ltr_AUS__c!=Trigger.oldMap.get(op.Id).NSP_Ltr_AUS__c || 
                op.NSP_Ltr_Lubes__c!=Trigger.oldMap.get(op.Id).NSP_Ltr_Lubes__c
               )
               )
              )
            {
                if(rt_map.get(op.recordTypeID).getName().containsIgnoreCase('SAP ORDER'))
                    mpIds.add(op.Opportunity_Id__c);    
            }
        }
        
        /////// create opportunity team for sap headers on creation ////////
        if(Trigger.isInsert && Trigger.isAfter)
        {
            List<Opportunity> SAPOptyList = new List<Opportunity>();
            String recordTypeSAPHeader = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('SAP Order').getRecordTypeId();
            for(Opportunity opt: Trigger.New)
            {
                if(opt.RecordTypeId == recordTypeSAPHeader)
                {
                    SAPOptyList.add(opt);
                }
            } 
            system.debug('sap data: '+SAPOptyList);
            if(SAPOptyList.size()>0)
            {
                OpportunityTriggerHelper op = new OpportunityTriggerHelper();
                op.OpportunityTeamCreateforSAPOrder(SAPOptyList);
            }          
        }
    }
    
    if(Trigger.isDelete)
    {
        for(Opportunity op: Trigger.old)
        {
            if(rt_map.get(op.recordTypeID).getName().containsIgnoreCase('SAP ORDER'))
                mpIds.add(op.Opportunity_Id__c);
        }
    }
        
    List<Opportunity> monthlyList = new List<Opportunity>();
    
    for (Opportunity opty : [select Id, MTD_Volume__c, MTD_Focussed_Volume__c, MTD_AUS_Volume__c, MTD_NON_AUS_Volume__c, MTD_NSP_Ltr_AUS__c, MTD_NSP_Ltr_Lubes__c, (select Id, Volume__c, Focused_Volume__c, AUS_Volume__c, NON_AUS_Volume__c, NSP_Ltr_AUS__c, NSP_Ltr_Lubes__c from OpportunitiesSAPOrder__r) from Opportunity where Id IN :mpIds]) 
    {
         opty.MTD_Volume__c = 0;
         opty.MTD_Focussed_Volume__c = 0;
         opty.MTD_AUS_Volume__c = 0;
         opty.MTD_NON_AUS_Volume__c = 0;
         opty.MTD_NSP_Ltr_AUS__c = 0;
         opty.MTD_NSP_Ltr_Lubes__c = 0;
         
         for(Opportunity sapOpt: opty.OpportunitiesSAPOrder__r)
         {
             opty.MTD_Volume__c = opty.MTD_Volume__c + sapOpt.Volume__c;
             opty.MTD_Focussed_Volume__c = opty.MTD_Focussed_Volume__c + sapOpt.Focused_Volume__c;
             
             opty.MTD_AUS_Volume__c = opty.MTD_AUS_Volume__c + sapOpt.AUS_Volume__c;
             opty.MTD_NON_AUS_Volume__c = opty.MTD_NON_AUS_Volume__c + sapOpt.NON_AUS_Volume__c;
             
             opty.MTD_NSP_Ltr_AUS__c = opty.MTD_NSP_Ltr_AUS__c + sapOpt.NSP_Ltr_AUS__c;
             opty.MTD_NSP_Ltr_Lubes__c = opty.MTD_NSP_Ltr_Lubes__c + sapOpt.NSP_Ltr_Lubes__c;
         }         
         monthlyList.add(opty);
    }
    
    system.debug('Monthly List: '+monthlyList);
    update monthlyList;
    
    //////////////////////////////////////////////////////////////////////////////
    
    ////////// update Last sub stage changing date/time /////////////////
    
    if((Trigger.IsInsert || Trigger.isUpdate) && Trigger.isBefore)
    {
        String recordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();
        for(Opportunity opt: Trigger.New)
        {
            if(Trigger.isUpdate)
            {
                Opportunity o = Trigger.OldMap.get(opt.id);
                if(opt.RecordTypeId == recordTypeId && (opt.Sub_Stage__c != o.Sub_Stage__c))
                {
                    opt.Last_Sub_Stage_Change_Date__c = system.now();
                }
            }
            else
            {
                if(opt.RecordTypeId == recordTypeId)
                {
                    opt.Last_Sub_Stage_Change_Date__c = system.now();
                }
            }
        }
    }
    
    // sending records for invoice attachment checking
   /* if(Trigger.isBefore && Trigger.isUpdate){
       
        String recordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Business Development').getRecordTypeId();
        List<opportunity> bdOpptyList=new list<opportunity>();
        for(Opportunity opp : Trigger.New)
        { 
          Opportunity o = Trigger.OldMap.get(opp.id); 
          system.debug('opp.recordTypeId *************** '+recordTypeId);
          
          if(opp.RecordTypeId == recordTypeId && (opp.StageName != o.StageName) && opp.StageName == 'Won')
          {
              bdOpptyList.add(opp);
          }  
        }
       if(bdOpptyList.size()>0)
            OpportunityTriggerHelper.checkAttachment(bdOpptyList);
     }   
*/
     
}