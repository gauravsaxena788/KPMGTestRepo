trigger Va_AccountTrigger on Account (after insert, after update, before update, before insert) {
    VA_AcountTriggerHandler handler = new VA_AcountTriggerHandler();
       if (handler.IsDisabled())
            return;
        
        // Detect the current trigger context and fire the relevant methods on the trigger handler:
 
        // Before trigger logic
        if (Trigger.IsBefore )
        {
            if (Trigger.IsInsert)
                handler.BeforeInsert(trigger.new);
 
            if (Trigger.IsUpdate)
                handler.BeforeUpdate(trigger.new, trigger.oldMap);
 
            
        }
         
        // After trigger logic
        if (Trigger.IsAfter)
        {
            if (Trigger.IsInsert)
                handler.AfterInsert(Trigger.new);
 
            if (Trigger.IsUpdate)
                handler.AfterUpdate(trigger.new, trigger.oldMap);
 
            
        }    
    
    
}