({
	doInit : function(component, event, helper) {
        console.log('ACC Rec ID : '+component.get("v.recordId"));
        /*var action = component.get("c.getpickval");
	action.setParams({
            accId: component.get("v.recordId")
        });
        var inputsel = component.find("InputSelectDynamic");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
        });
        $A.enqueueAction(action); */
        },
    
    onRadio: function(component, event, helper) {
		 var selected = event.getSource().get("v.label");
        console.log(selected);
        if(selected=='Current Year'))
         {
        	//helper.checkValidity();
    	 }
		 resultCmp = component.find("radioResult");
		 resultCmp.set("v.value", selected);
	 }
	
})