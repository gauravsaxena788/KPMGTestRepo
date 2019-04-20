global Class VCPL_SendNotificationOnNegativeDP implements Database.Batchable<sObject>{
    
    global Database.querylocator start(Database.BatchableContext bc)
    {	
        Set<Id> setofAccId = new Set<Id>();
        Date Startdate = Date.newInstance(System.today().year(), System.today().month(), 1);
        VCPLDPDailyCalculationforNotification objDODaily = new VCPLDPDailyCalculationforNotification(Startdate,System.today()) ;
        objDODaily.setMapsForSegmentManagerView();
        setofAccId = objDODaily.setOfDealerIdsWithNegativeDisount;
        return Database.getQueryLocator('SELECT id, Name, OwnerId, SFDC_Account_ID__c, Owner.Profile.Name, Owner.Email, Owner.Name FROM Account WHERE Id IN:setofAccId');
    }
    
    global void execute(Database.BatchableContext BC, List<Account> lstAccount)
    {
        //Set<String> setofAccId = new Set<String>();
        Set<String> setofAccId = new Set<String>();
        Map<String,String> mapuseridWithEmail = new Map<String,String>();
        Map<String,String> mapuseridWithUser = new Map<String,String>();
        Map<String,List<Account>> mapuserIdWithAccountlst = new Map<String,List<Account>>();
        List<Messaging.SingleEmailMessage> lstofSEM = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress orgwiseEmail = [SELECT ID, DisplayName FROM OrgWideEmailAddress WHERE DisplayName= 'VEdge' limit 1];
        
        //List<Account> lstAcc = [SELECT id , OwnerId, Owner.Profile.Name, Owner.Email FROM Account WHERE Id IN : setofAccId ];
        
        //for(Account objAcc:[SELECT id , Name, OwnerId, SFDC_Account_ID__c, Owner.Profile.Name, Owner.Email, Owner.Name FROM Account WHERE Id IN : setofAccId]){
        for(Account objAcc:lstAccount) { 
            if(objAcc.Owner.Profile.Name == 'TBM'){
                if(mapuserIdWithAccountlst.get(objAcc.OwnerId) != null){
                    List<Account> lstAcc = mapuserIdWithAccountlst.get(objAcc.OwnerId);
                    lstAcc.add(objAcc);
                    mapuseridWithEmail.put(objAcc.OwnerId,objAcc.Owner.Email);
                    mapuseridWithUser.put(objAcc.OwnerId,objAcc.Owner.Name);
                    mapuserIdWithAccountlst.put(objAcc.OwnerId,lstAcc);
                }
                else if(mapuserIdWithAccountlst.get(objAcc.OwnerId) == null){
                    List<Account> lstAcc = new List<Account>();
                    lstAcc.add(objAcc);
                    mapuseridWithEmail.put(objAcc.OwnerId,objAcc.Owner.Email);
                    mapuseridWithUser.put(objAcc.OwnerId,objAcc.Owner.Name);
                    mapuserIdWithAccountlst.put(objAcc.OwnerId,lstAcc);
                }
            }
        }
        
        EmailTemplate objEmailTemp = [SELECT id, HtmlValue, DeveloperName,Subject FROM EmailTemplate WHERE DeveloperName = 'VCPL_TBM_Email_Alert']; 
        
        for(String objStr : mapuserIdWithAccountlst.keyset()){
            Messaging.SingleEmailMessage objSinEmailMessage = new Messaging.SingleEmailMessage();
            objSinEmailMessage.setSubject(objEmailTemp.Subject);
            String strHTMLBody = objEmailTemp.HtmlValue;
            Integer count= 0;
            String strmessage ='';
            for(Account objAcc: mapuserIdWithAccountlst.get(objStr)){
                count = count+1;
                strmessage+= '<tr><td>'+count+'</td><td>'+objAcc.Name+'</td><td>'+objAcc.SFDC_Account_ID__c+'</td></tr>';
            }
            
            strHTMLBody = strHTMLBody.replace('$UserName$',mapuseridWithUser.get(objStr));
            strHTMLBody = strHTMLBody.replace('<tr>$UserNameData$</tr>',strmessage);
            strHTMLBody = strHTMLBody.replace('{!$Label.VA_Disclaimer_Message}',Label.VA_Disclaimer_Message);
            strHTMLBody = strHTMLBody.replace('{!$Label.VA_LogoDocumentId}',Label.VA_LogoDocumentId);
            objSinEmailMessage.setHtmlBody(strHTMLBody);
            List<String> toAddress = new List<String>();
            toAddress.add(mapuseridWithEmail.get(objStr));
            objSinEmailMessage.setToAddresses(toAddress);
            
            objSinEmailMessage.setOrgWideEmailAddressId(orgwiseEmail.Id);
            system.debug('objSinEmailMessage');
            lstofSEM.add(objSinEmailMessage); 
        }
        try
        {
            if(lstofSEM!= null && lstofSEM.size() >0)
            {
                Messaging.SendEmail(lstofSEM);  
                System.debug('lstemail'+lstofSEM); 
                System.debug('lstemail.size()'+lstofSEM.size()); 
            }
        }
        catch(Exception ex)
        {
            system.debug('====='+ex.getMessage());
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;
        }
    }
    global void finish(Database.BatchableContext BC)
    {
        
    }
}