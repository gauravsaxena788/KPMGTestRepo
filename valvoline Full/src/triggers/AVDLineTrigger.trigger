trigger AVDLineTrigger on AVD_Line_Item__c (before insert, before update) {

    Set<Id> QuoteIds= new Set<Id>();
    
       
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
                
        for(AVD_Line_Item__c newal: Trigger.New)
        {
           if((Trigger.isInsert && newal.Most_Likely__c==true) || (newal.Most_Likely__c==true && Trigger.isUpdate && newal.Most_Likely__c != Trigger.oldMap.get(newal.Id).Most_Likely__c))
           {
               QuoteIds.add(newal.Quote__c);
               
               if(newal.Slab_Discount__c!=NULL)
                   newal.Discount__c = Decimal.valueOf(newal.Slab_Discount__c);
               else
                   newal.Discount__c = 0.0;
           }
           else if(newal.Most_Likely__c==false)
           {
               newal.Discount__c = 0.0;
           }
           /*else
           {
               if(newal.Slab_Discount__c!=NULL)
                   newal.Discount__c = Decimal.valueOf(newal.Slab_Discount__c);
               else
                   newal.Discount__c = 0.0;
           }*/
        }
        
        system.debug('QuoteIds: '+QuoteIds);
        
        AVDHelperClass.checkDuplicate(QuoteIds, Trigger.New);
    }
        
}