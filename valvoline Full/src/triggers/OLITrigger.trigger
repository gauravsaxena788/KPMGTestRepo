trigger OLITrigger on OpportunityLineItem (before Insert,after update,after insert,after delete) {
    OLITriggerHandler olihandler=new OLITriggerHandler();
    if((Trigger.isInsert && Trigger.isBefore))
        olihandler.updateSaleOnAccountPotential(trigger.new);
        
        ///////////////// new code for updating rollup sum of quantity to Account Potentials
    Set<id> mpIds = new Set<id>();
    List<Opportunity> MPOptyToUpdate = new List<Opportunity>();

    
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter)
    {
        for (OpportunityLineItem op : Trigger.new)
        {
            if((Trigger.isInsert && Trigger.isAfter) || (Trigger.isUpdate && Trigger.isAfter && (op.quantity!=Trigger.oldMap.get(op.Id).quantity )))
            {

                    mpIds.add(op.Account_Product_Potential__c);    
            }
        }
    }
    
    if(Trigger.isDelete)
    {
        for(OpportunityLineItem op: Trigger.old)
        {

                mpIds.add(op.Account_Product_Potential__c);
        }
    }
        
    List<Account_Potential__c> aplist= new List<Account_Potential__c>();
    
    for (Account_Potential__c ap: [select Id,   YTD_in_volume__c, (select Id, quantity from Opportunity_Product__r) from Account_Potential__c where Id IN :mpIds]) 
    {
         ap.YTD_in_volume__c=0;
         
         for(OpportunityLineItem oli: ap.Opportunity_Product__r)
         {
             ap.YTD_in_volume__c = ap.YTD_in_volume__c + oli.quantity;

         }         
         aplist.add(ap);
    }
    
    system.debug('aplist: '+aplist);
    update aplist;
    
    //////////////////////////////////////////////////////////////////////////////
        

}