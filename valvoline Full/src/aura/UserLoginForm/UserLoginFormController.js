({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();    
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap2}).fire();
        component.set('v.isUsernamePasswordEnabled', helper.getIsUsernamePasswordEnabled(component, event, helper));
        component.set("v.isSelfRegistrationEnabled", helper.getIsSelfRegistrationEnabled(component, event, helper));
        component.set("v.communityForgotPasswordUrl", helper.getCommunityForgotPasswordUrl(component, event, helper));
        component.set("v.communitySelfRegisterUrl", helper.getCommunitySelfRegisterUrl(component, event, helper));
		debugger;
       
        //document.getelementById('username').focus();
        
        //var xyz = component.find('username');
        
        var usernameId = component.find("username").getLocalId();
        var passId = component.find("password").getLocalId();
        var username = helper.readCookie1(component, event,usernameId);
        var pass = helper.readCookie1(component, event,passId);
        console.log(username);
        console.log(pass);
        if(username != ''){
            console.log(username);
        	component.find("username").set("v.value", username);
        }
        if(pass != '')
        component.find("password").set("v.value", pass);
        //readCookie(passId);
    },
    
    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    
    handleLogin: function (component, event, helpler) {
        helpler.handleLogin(component, event, helpler);
    }, 
    
    
    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },
	
	remember :function(component, event, helper){
        console.log('remeber');
        var username = component.find("username").get("v.value");
        var password = component.find("password").get("v.value");
        helper.newCookie(component,event,component.find("username").getLocalId(),username);
        helper.newCookie(component,event,component.find("password").getLocalId(),password);
    },   
    onKeyUp: function(component, event, helpler){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helpler.handleLogin(component, event, helpler);
        }
    },
    
    navigateToForgotPassword: function(cmp, event, helper) {
        var forgotPwdUrl = cmp.get("v.communityForgotPasswordUrl");
        if ($A.util.isUndefinedOrNull(forgotPwdUrl)) {
            forgotPwdUrl = cmp.get("v.forgotPasswordUrl");
        }
        var attributes = { url: forgotPwdUrl };
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    },
    
    navigateToSelfRegister: function(cmp, event, helper) {
        var selrRegUrl = cmp.get("v.communitySelfRegisterUrl");
        if (selrRegUrl == null) {
            selrRegUrl = cmp.get("v.selfRegisterUrl");
        }
    
        var attributes = { url: selrRegUrl }; 
        $A.get("e.force:navigateToURL").setParams(attributes).fire();
    } 
})