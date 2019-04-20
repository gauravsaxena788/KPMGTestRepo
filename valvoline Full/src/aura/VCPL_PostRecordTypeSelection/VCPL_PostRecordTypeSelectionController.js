({
	createRecord : function(component, event, helper) {
		var createRecordEvent = $A.get("e.force:createRecord");
        var recurId = component.get("v.recordTypeId");
        console.log(recurId);
        
		createRecordEvent.setParams({
         	"entityApiName": "Case",
            "recordTypeId": recurId
           
             
      });
      createRecordEvent.fire();
	}
})