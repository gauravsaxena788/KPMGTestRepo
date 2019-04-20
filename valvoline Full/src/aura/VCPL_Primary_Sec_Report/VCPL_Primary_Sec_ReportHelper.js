({
	getData: function(component, event, helper) {
		var action = component.get("c.primarySecData");
        action.setCallback(this, function(response) {
            var state = response.getState();
			debugger;
            if (state === "SUCCESS") {
                
                var dealerTest = [];
                var dealerData = JSON.parse(response.getReturnValue());
                for(var key in dealerData){
                    dealerTest.push({value:dealerData[key], key:key});
                }
                component.set("v.dealerSales",dealerTest);
                
            }
        });
        $A.enqueueAction(action);
	},
    
    columnDetails : function(component){
    	var columns = [
            
            {
                label:'Dealer Name',
                fieldName:'dealerName',
                type:'text'
            },
            {
                label:'Primary LY Sales',
                fieldName:'primSaleslY',
                type:'number'
            }
            ,
            {
                label:'Primary CY Sales',
                fieldName:'primSalesCY',
                type:'number'
            }
            ,
            {
                label:'Sec LY Sales',
                fieldName:'secSaleslY',
                type:'number'
            }
            ,
            {
                label:'Sec CY Sales',
                fieldName:'secSalesCY',
                type:'number'
            }
        ];
        
        component.set('v.columns',columns);
	}
})