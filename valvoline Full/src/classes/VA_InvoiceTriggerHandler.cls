Public class VA_InvoiceTriggerHandler {
    public void updateOrderQuantities(List<VA_Invoice__c> invList){
        Set<Id> orderSet = new Set<Id>();
        for(VA_Invoice__c inv:invList){
            if(inv.VA_Order__c != null){
                orderSet.add(inv.VA_Order__c);
            }
        }
        
        if(orderSet != null && orderSet.size() > 0){
            updateOrder(orderSet);
        }
        
    }
    
    public void updateOrderQuantitiesAfterChange(Map<Id,VA_Invoice__c> invOldMap, List<VA_Invoice__c> invList){
        Set<Id> orderSet = new Set<Id>();
        for(VA_Invoice__c inv:invList){
            if((inv.VA_Order__c != null && invOldMap.get(inv.id).VA_Invoice_Status__c != inv.VA_Invoice_Status__c) || (inv.VA_Order__c != null && invOldMap.get(inv.id).VA_Total_Invoice_Quantity__c != inv.VA_Total_Invoice_Quantity__c)){
                orderSet.add(inv.VA_Order__c);
            }
        }
        
        if(orderSet != null && orderSet.size() > 0){
            updateOrder(orderSet);
        }
    }
    
    public void updateOrderQuantitiesDelete(List<VA_Invoice__c> invLst){
        updateOrderQuantities(invLst);
    }
    
    private void updateOrder(Set<Id> orderSet){
        List<Order> ordLst = [Select id,VA_Dispatched_Quantity__c, VA_Delivered_Quantity__c , (Select id,VA_Total_Invoice_Quantity__c,VA_Invoice_Status__c from Invoices__r) FROM Order WHERE Id =:orderSet];
        if(ordLst != null && ordLst.size() > 0){
            for(Order ord:ordLst){
                integer dispatched = 0;
                integer delivered = 0;
                for(VA_Invoice__c inv:ord.Invoices__r){
                    if(inv.VA_Invoice_Status__c == 'Dispatched'){
                       dispatched = dispatched + Integer.valueOf(inv.VA_Total_Invoice_Quantity__c); 
                    }
                    else if(inv.VA_Invoice_Status__c == 'Delivered'){
                        delivered = delivered + Integer.valueOf(inv.VA_Total_Invoice_Quantity__c);
                    }
                }
                ord.VA_Dispatched_Quantity__c = dispatched;
                ord.VA_Delivered_Quantity__c = delivered;
            }
            update ordLst;
        }
    }
}