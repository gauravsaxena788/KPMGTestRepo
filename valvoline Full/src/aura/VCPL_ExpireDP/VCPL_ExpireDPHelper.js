({
	validatecheckfield : function(component, event) {
		var returnstate = true;
        var cmptodaydateid = component.find("todaydate");
        var cmptodaydateidval = cmptodaydateid.get("v.value");
        if(cmptodaydateid != null && cmptodaydateid != ''){
            if(cmptodaydateidval == null || cmptodaydateidval == ''){
        		cmptodaydateid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
               cmptodaydateid.set("v.errors", null); 
        }
        
        
        var cmpreasonforcloseid = component.find("reasonforclose");
        var cmpreasonforcloseidval = cmpreasonforcloseid.get("v.value");
        if(cmpreasonforcloseid != null && cmpreasonforcloseid != ''){
            if(cmpreasonforcloseidval == null || cmpreasonforcloseidval == ''){
        		cmpreasonforcloseid.set("v.errors", [{message:"This field is required" }]);
                returnstate = false;
            }
            else
               cmpreasonforcloseid.set("v.errors", null); 
        }
        
        return returnstate;
	}
})