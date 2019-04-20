Public class VA_OrdeLineItemHandler{
    public void afterConfirmedItemChanges(List<OrderItem> newList){
        Map<String,String> orderStatusMap = new Map<String,String>();
        Set<Id> lineItemSet = new Set<Id>();
        List<Order> orderList = new List<Order>();
        for(OrderItem line:newList){
            if(line.OrderId != null){
                lineItemSet.add(line.OrderId);
            }
        }
        
        if(lineItemSet != null && lineItemSet.size() > 0){
            orderList = [Select id,Status,VA_Total_Invoice_Quantity__c,(Select Quantity, Id from OrderItems Where VA_Type__c = 'Confirmed Line Item' AND VA_Status__c != 'Rejected' AND VA_Is_FreeGoods__c = False) from Order where Id IN :lineItemSet];
        }
        
        //List<Order> orderListToUpdate = new List<Order>();
        if(!orderList.isEmpty()){
            for(Order ord:orderList){
                system.debug('@@orderItems'+ord.OrderItems);
                Double totalLineItemQuantity = 0;
                for(OrderItem line:ord.OrderItems){
                    
                    totalLineItemQuantity = totalLineItemQuantity + line.Quantity;
                }
                system.debug('totalItem'+totalLineItemQuantity );
                system.debug('totalInvoice'+ord.VA_Total_Invoice_Quantity__c);
                if(ord.VA_Total_Invoice_Quantity__c > 0 ){
                    if(totalLineItemQuantity  - ord.VA_Total_Invoice_Quantity__c> 0){
                        ord.Status= 'Partially fulfilled';
                    }
                    else if(totalLineItemQuantity  - ord.VA_Total_Invoice_Quantity__c == 0){
                        ord.Status= 'Fulfilled';
                    }
                }
            }
            update orderList;
        }
    }
}