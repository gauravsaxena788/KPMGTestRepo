({
    doInit: function(component,  event, helper) {
        var recordId = component.get("v.recordId");
        //helper.getaccounts(component, event, helper);
        helper.loadAccountoptions(component, event, helper);
        //helper.loadOpportunityoptions(component, event, helper);
        
        if(recordId!=undefined){
            
            //alert(recordId);
            var action = component.get("c.getDetailsFromQuote");
            action.setParams({
                qtId: recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var qt = response.getReturnValue();
                    
                    if(qt.Status == 'In Review')
                    {
                        document.getElementById("msgdiv").style.display="block";
                        document.getElementById("quoteclone").style.display="none";
                        
                        component.set("v.message","This quote is already in review. Please recall or wait for approval.");
                    }
                    else
                    {
                        document.getElementById("msgdiv").style.display="none";
                        document.getElementById("quoteclone").style.display="block";
                        
                        component.set("v.qtname", qt.Name);
                        component.set("v.cnvalidfrom", qt.Contract_Valid_from__c); 
                        component.set("v.cnvalidtill", qt.Contract_Valid_till__c);
                        component.set("v.qtvalidtill", qt.Quote_Valid_till__c);
                        //component.set("v.accname", qt.Account_Name__c);
                        //component.set("v.oppname", qt.OpportunityId);
                        //alert(qt.Opportunity.Name);
                        //alert(qt.OpportunityId);
                        //component.find("OpportunityId").set("v.value", qt.Opportunity.Name);
                        //component.find("OpportunityId").set("v.key", qt.OpportunityId);
                    }
                    
                }
                
            });
            
            $A.enqueueAction(action);
        }
    },
    
    
    
    myAction : function (component, event, helper) {
        var quoteId =  component.get("v.recordId");
        
        var quotename =  component.get("v.qtname");
        var contvalidfrom1 =  component.get("v.cnvalidfrom"); 
        var contvalidtill1 = component.get("v.cnvalidtill"); 
        var quotevalidtill1 =  component.get("v.qtvalidtill");
        var accountid=component.find("AccountId").get("v.value");
        var oppid=component.find("OpportunityId").get("v.value");
        //alert(accountid);
        //alert(oppid);
        if(quotename=='')
        {
            alert('Please specify quote name.');
            return false;
        }
        if(accountid=='')
        {
            alert('Please specify account name.');
            return false;
        }
        if(oppid=='')
        {
            alert('Please specify opportunity name.');
            return false;
        }
        if(contvalidfrom1=='')
        {
            alert('Please specify contract valid from date.');
            return false;
        }
        if(contvalidtill1=='')
        {
            alert('Please specify contract valid till date.');
            return false;
        }
        if(quotevalidtill1=='')
        {
            alert('Please specify quote valid till date.');
            return false;
        }
        //return false;
        var action = component.get("c.createQuoteClone");
        //alert(contvalidfrom1);
        action.setParams({
            qtId: quoteId,
            qtname: quotename,
            cvalidfrom: contvalidfrom1,
            cvalidtill: contvalidtill1,
            qvalidtill: quotevalidtill1,
            aid:accountid,
            oid:oppid
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var qt = response.getReturnValue();
                if(qt=='Invalid Date')
                {
                    alert('Quote valid till date must be today or future date.');
                }
                else if(qt.length == 18)
                {
                    alert('Success! Quote has been cloned successfully.');
                    //helper.showSuccessToast(component, event, helper);
                    window.open('/one/one.app?#/sObject/'+ qt + '/view', '_self');
                } 
                else
                {
                    alert(qt);
                }                
            }
            
        });
        
        $A.enqueueAction(action);  
        //$A.get("e.force:closeQuickAction").fire();
    },
    
    closeModal : function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    onAccountchange: function(component, event, helper) {
        var Accid = event.getSource().get("v.value");
        //alert(component.find("AccountId").get("v.value"));
        //alert(Accid);
        
        var action = component.get("c.fetchopp");
        action.setParams({
            accountId: Accid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && component.isValid()) {
                var resp = response.getReturnValue();
                var opplist = [];
                var index = 0;
                //alert(resp);
                for (var key in resp) {
                    //alert('no call');
                    var obj = {
                        value: resp[key],
                        key: key
                    };
                    if (index === 0) {
                        //obj.selected = false;
                        if(key) component.find("OpportunityId").set("v.value", key);
                    }
                    opplist.push(obj);
                    index++;
                }
                //alert(opplist);
                component.set("v.oppOptions", opplist);
            }
        });
        $A.enqueueAction(action);
    }
    
})