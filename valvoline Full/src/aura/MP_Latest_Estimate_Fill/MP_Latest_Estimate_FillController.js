({
    doInit : function(component, event, helper) {
        var param =component.get("v.recordId");
        console.log('ACC Rec ID : '+param);
        var action=component.get("c.findAll");
        action.setParams({
            "accId" : param
        });
        
       document.title="Monthly Plan" 
       
        action.setCallback(this, function(a){
            var resultLst=a.getReturnValue();  
            console.log('resultLst : '+resultLst);
            if(!$A.util.isEmpty(resultLst)){               
                component.set("v.opportunities",resultLst);
            }
        });
        
        $A.enqueueAction(action);
        
        action=component.get("c.findActualMonth");
        action.setCallback(this, function(response){    
        	component.set("v.actualMonth",response.getReturnValue());
        });
        $A.enqueueAction(action);
        
        
        action=component.get("c.getEditableMonthlyPlan");
        action.setCallback(this, function(response){    
        	component.set("v.editablemonthlyplan",response.getReturnValue());
            //alert(response.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.isEditableAllLE");
        action.setCallback(this, function(response){    
        	component.set("v.isEditableAllLE",response.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.findFiscalYearSettings");
        action.setCallback(this, function(response){    
            if(response.getReturnValue().length > 0){
                component.set("v.FiscalYear",response.getReturnValue()[0].Name);
            }
        });
        $A.enqueueAction(action);
        
		action=component.get("c.account_Details");
        action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(response){
         component.set("v.account",response.getReturnValue());
        });
        
        $A.enqueueAction(action);
        
        action=component.get("c.getLyvol");
        action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.lyvol",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         action=component.get("c.getLygpltr");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.lygpltr",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.getAccpotential");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.accpotential",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.getMonthvol");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.monthvolume",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.getMonthgpltr");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.monthgpltr",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.getMonthgp");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.monthgp",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         action=component.get("c.getLatestvol");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.latestvol",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         action=component.get("c.getLatestgpltr");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.latestgpltr",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         action=component.get("c.getLatestgp");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.latestgp",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.getActualvol");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.actualvol",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
        action=component.get("c.getActualgpltr");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.actualgpltr",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         action=component.get("c.getActualgp");
         action.setParams({
            "accId" : param
        });
        action.setCallback(this, function(a){    
        	component.set("v.actualgp",a.getReturnValue());
        });
        $A.enqueueAction(action);
        
         
        
    },
    
    
    saveLEOpp : function(component, event, helper) {
        var param =component.get("v.opportunities");
        
        console.log('Opp Lst : '+param[0].Latest_Est_Volume__c);
        var action=component.get("c.saveLatestEstimate");
        action.setParams({
            "lst" : param
        });
        action.setCallback(this, function(response){
            var resultLst=response.getReturnValue();          
            if(!$A.util.isEmpty(resultLst))
            {               
                alert(resultLst);
                window.close();
                // $A.get("e.force:closeWindow").fire();
            }
        });
        
        $A.enqueueAction(action);
    },
    
    cancelLEOpp : function(component, event, helper) {
        
        window.close();
        
    },
    
       
    calc_GP : function(component, event, helper) {
        
        var componentValue = component.get("v.opportunities");
        var latestvoltest = component.getReference("v.latestvol");
        var latestgpltrtest = component.getReference("v.latestgpltr");
        var latestgptest = component.getReference("v.latestgp");
        
        for(var index=0 ; index < componentValue.length ; index++){
            componentValue[index].Latest_Est_GP__c = 0;
            if(componentValue[index].Latest_Est_Volume__c != '' &&
               componentValue[index].Latest_Est_Volume__c != null && 
               componentValue[index].Latest_Est_Volume__c != 'undefined' && 
               componentValue[index].Latest_Est_GP_ltr__c != '' && 
               componentValue[index].Latest_Est_GP_ltr__c != null && 
               componentValue[index].Latest_Est_GP_ltr__c != 'undefined'){
                
                componentValue[index].Latest_Est_GP__c = ((parseFloat(componentValue[index].Latest_Est_Volume__c) * parseFloat(componentValue[index].Latest_Est_GP_ltr__c)) * 1000);
               //alert(componentValue[index].Latest_Est_GP__c);
            }
            
        }
        
        	var latestvoltest =[];
           	var total = 0;
            for (var i = 0; i <componentValue.length ; i++) {
                total += componentValue[i].Latest_Est_Volume__c; 
             }
            component.set('v.latestvol',total);
            
            var latestgpltrtest =[];
           	var total1 = 0;
       		var total2 = 0;
       		var total = 0;
            for (var i = 0; i <componentValue.length ; i++) {
               // total1 += componentValue[i].Latest_Est_GP_ltr__c; 
               total += componentValue[i].Latest_Est_Volume__c; 
                total2 += componentValue[i].Latest_Est_GP__c;             
               
             }
        	total1 = ((total2/total )*0.001);
            component.set('v.latestgpltr',total1);
            
            var latestgptest =[];
          	var total2 = 0;
            for (var i = 0; i <componentValue.length ; i++) {
                total2 += (componentValue[i].Latest_Est_GP__c/100000); 
             }
        	
            component.set('v.latestgp',total2);

         
        
        
        
        component.set("v.opportunities",componentValue);
        var action = component.get("c.getSumOfCreditsList");
        action.setCallback(this, function(a) {
            component.set("v.account", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    
    calc_Planned_GP : function(component, event, helper) {
        
        var componentValue = component.get("v.opportunities");
        var monthvoltest = component.getReference("v.monthvolume");
        var monthgpltrtest = component.getReference("v.monthgpltr");
        var monthgptest = component.getReference("v.monthgp");
        
        //alert(monthvoltest);
        //alert(monthgpltrtest);
        //alert(monthgptest);

        for(var index=0 ; index < componentValue.length ; index++){
            componentValue[index].Planned_GP__c = 0;
            if(componentValue[index].Planned_Volume__c != '' &&
               componentValue[index].Planned_Volume__c != null && 
               componentValue[index].Planned_Volume__c != 'undefined' && 
               componentValue[index].Planned_GP_Ltr__c != '' && 
               componentValue[index].Planned_GP_Ltr__c != null && 
               componentValue[index].Planned_GP_Ltr__c != 'undefined'){
                
                componentValue[index].Planned_GP__c = ((parseFloat(componentValue[index].Planned_Volume__c) * parseFloat(componentValue[index].Planned_GP_Ltr__c)) * 1000);
               //alert(componentValue[index].Planned_GP__c);
            }
            
        }
        
        	var monthvoltest =[];
           	var total = 0;
            for (var i = 0; i <componentValue.length ; i++) {
                total += componentValue[i].Planned_Volume__c; 
             }
            component.set('v.monthvolume',total);
            
            var monthgpltrtest =[];
           	var total1 = 0;
       		var total2 = 0;
       		var total = 0;
            for (var i = 0; i <componentValue.length ; i++) {
               // total1 += componentValue[i].Planned_GP_Ltr__c; 
               total += componentValue[i].Planned_Volume__c; 
                total2 += componentValue[i].Planned_GP__c;             
               
             }
        	total1 = ((total2/total )*0.001);
            component.set('v.monthgpltr',total1);
            
            var monthgptest =[];
          	var total2 = 0;
            for (var i = 0; i <componentValue.length ; i++) {
                total2 += (componentValue[i].Planned_GP__c/100000); 
             }
        	
            component.set('v.monthgp',total2);
         	component.set("v.opportunities",componentValue);
            var action = component.get("c.getSumOfCreditsList");
            action.setCallback(this, function(a) {
                component.set("v.account", a.getReturnValue());
            });
        	$A.enqueueAction(action);
    }
    
})