({
    onInit : function(component, event, helper) {
        
        var url = window.location.href;
        var currentAccountId = url.substring(url.indexOf("id=")+3) || 'ReturnToHome';
        console.log('In VCPL_ShwDataCmp-->H-->val of acId-->'+currentAccountId);
        console.log('In VCPL_ShwDataCmp-->H-->URL id index-->'+url.indexOf("id=")+3);
        console.log('In VCPL_ShwDataCmp-->H-->URL -->'+url);
        component.set("v.Idaccount", currentAccountId);
        /* Call the Apex class method to fetch the List of all account */ 
        var action = component.get("c.listAllAccount");
        action.setCallback(this, function(response){  
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){    
                /* set the value to the attribute of the component */                 
                var responseValue = response.getReturnValue();
                console.log('In VCPL_ShwDataCmp-->H-->ret val From Apex-->'+JSON.stringify(responseValue));
                /*var lstOptions = [];
                for(var i=0; i < responseValue.length; i++){
                    lstOptions.push({
                        value : responseValue[i].split('####')[1],
                        key : responseValue[i].split('####')[0]  
                    });  
                }
                lstOptions.sort();*/
                component.set('v.AccountsList', response.getReturnValue());
            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    goToUrl : function(component, event, helper) {
        var accountId = component.get("v.Idaccount"); 
       
        if(accountId=='ReturnToHome'){
            var URlToSet = '/';      
        }
        else{  
            var URlToSet = '/show-child-data?id='+accountId;    
        }
        var urlEvent = $A.get("e.force:navigateToURL");       
        urlEvent.setParams({
            "url":URlToSet   
        });
        urlEvent.fire(); 
        
        var changedVal = component.find('inputSelectVal').get('v.value');
        console.log('-->val of selectOpt-->'+changedVal);
        if(! $A.util.isUndefinedOrNull(changedVal) && changedVal.startsWith('001')){
            console.log('Inside if of App Event-->val of-->'+changedVal);
            var appEvent = $A.get("e.c:PassRecordId");
            appEvent.setParams({
                "accId": changedVal
             });
            appEvent.fire();
        }

        
    }, 
    
    returnToUrl : function(component, event, helper) {
        var URlToSet = '/';         
        var urlEvent = $A.get("e.force:navigateToURL");    
        urlEvent.setParams({
            "url":URlToSet   
        });
        urlEvent.fire();    
        
    },       
    
})