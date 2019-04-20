public class VCPL_clsforIdCustomerQuote {

    @AuraEnabled
    public Static String checkQuoteAllowed(String strOppId){
        String flag='Not Allowed';
        String flag2 = '';
        
        List<Quote> lstQuote =[SELECT Id,Name,Status FROM Quote where OpportunityID=:strOppId and Status='In Review'];
        if(lstQuote.size()>0)
        {
            flag='In Review';        
        }
        
        else{ 
            flag='Allow';
        }       
        
        return flag;
    }
    
    @AuraEnabled
    public static Wrapobj quotefieldsget(String strOppId){
        
        Wrapobj objWrap = new Wrapobj();
        String newQuoteNumber='';
        
        Id devRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(Label.VCPL_Quote_RecordType_for_ID).getRecordTypeId();
        
        Opportunity objOpp = [SELECT Id, AccountId, Account.BU_Name__c, Opportunity_Number__c FROM Opportunity WHERE Id=:StrOppId limit 1];
        List<Contact> lstContact;
        if(!String.isBlank(objOpp.AccountId))
            lstContact = [SELECT id FROM Contact WHERE AccountId = :objOpp.AccountId ORDER BY CreatedDate ASC];
        List<Quote> qt = [SELECT Id, Quote_Number__c, Opportunity.Opportunity_Number__c, AccountId , Account.BU_Name__c  FROM Quote WHERE OpportunityId = :strOppId ORDER BY CreatedDate desc NULLS LAST];
        
        newQuoteNumber = objOpp.Account.BU_Name__c+'/';
        
        Date dateToday = Date.today();
        String year= String.valueof(dateToday.year());
        system.debug('year '+year);
        
        system.debug('year.charAt(2) substring) '+year.substring(2));
        String mon='';
        String dy='';
        Integer d=dateToday.day(); 
        Integer mn=dateToday.month();        
        if(mn<10){
            //07
            mon = '0'+String.valueOf(mn);
        }else{ mon = String.valueOf(mn); }
         if(d<10){
            //07
            dy = '0'+String.valueOf(d);
        }else{ dy = String.valueOf(d); }
        
        
        String sToday = year.substring(2) + mon + dy;
        
        newQuoteNumber = newQuoteNumber + sToday + '/';
        newQuoteNumber = newQuoteNumber + objOpp.Opportunity_Number__c + '/';
        
        Integer num=0;
        String finalNum='';
         system.debug('qt.size() '+qt.size());
        if(qt.size()>0){
            String qtn=qt[0].Quote_Number__c;
            
            if(qtn!=null){
                String[] oldQuoteNumber =qtn.split('/');
                system.debug('oldQuoteNumber[] '+oldQuoteNumber);
                
                if(oldQuoteNumber.size()>3){
                    num=Integer.valueOf(oldQuoteNumber[3]);
                    num += 1;
                    system.debug('in IF [] ');
                    
                    if(num<10){
                        //056
                        finalNum = '00'+String.valueOf(num);
                    }else if(num<100 && num > 9){
                        finalNum = '0'+String.valueOf(num);
                    }else{
                        finalNum=String.valueOf(num);
                    }
                }}else{
                    system.debug('in else qtn[] ');
                    finalNum='001';
                }
        }else{
            system.debug('in else qt[] ');
            finalNum='001';
        }
        newQuoteNumber = newQuoteNumber + finalNum;
        
        system.debug('newQuoteNumber '+newQuoteNumber);
        objWrap.strQuoteNumber = newQuoteNumber;
        objWrap.strAccntId = objOpp.AccountId;
        objWrap.strRecordTypeId = devRecordTypeId ;
        objWrap.strBUName= objOpp.Account.BU_Name__c;
        if(lstContact != null && lstContact.size() > 0)
           objWrap.contactId = lstContact[0].Id;
        System.debug('objWrap'+objWrap);
        return objWrap;
    }
    
    public class Wrapobj{
       @AuraEnabled public String strAccntId;
       @AuraEnabled public String strQuoteNumber;
       @AuraEnabled public Id strRecordTypeId;
       @AuraEnabled public String strBUName;
       @AuraEnabled public String contactId;
    }
    
     public class WrapobjError{
       @AuraEnabled public String strResType;
       @AuraEnabled public String strMessage;
    }
    
    // This is called for Id Customer Quote to add approval manager
    public static void approvalDetail(List<Quote> lstQuote){
        
        Set<String> setofOwnrId = new Set<String>();
        Map<String,String> mapofUserIdWithUser = new Map<String,String>();
        Map<String,ID> NSHuserMAP= new Map<String,ID>();
        Map<ID,ID> oppSMUserMap = new Map<ID,ID>();
       
        Id devRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('ID Customer').getRecordTypeId();
       
        for(Quote objQuote : lstQuote){
            if(devRecordTypeId == objQuote.RecordTypeId)
                setofOwnrId.add(objQuote.Ownerid); 
        }
        
       if(setofOwnrId.Size() > 0)
        for(User objUser : [SELECT Id, Name ,VCPL_ID_Head__c FROM User WHERE Id IN: setofOwnrId]){
            if(!string.isBlank(objUser.VCPL_ID_Head__c))
                mapofUserIdWithUser.put(objUser.Id,objUser.VCPL_ID_Head__c);
        }                                                               
          
                      
        
        for(Quote objQuote : lstQuote){
            if(devRecordTypeId == objQuote.RecordTypeId && mapofUserIdWithUser != null && !string.isBlank(objQuote.OwnerId) &&
                     !string.isBlank(mapofUserIdWithUser.get(objQuote.OwnerId))){
                     objQuote.VCPL_ID_Head__c = mapofUserIdWithUser.get(objQuote.OwnerId); 
                    
        }
    }
 } 
    
    
    @AuraEnabled    
    public static WrapobjError findAllNew(String QuoteId){        
        
        String isEligible;
        String quotesId;
        String userId;
        
        String uid = UserInfo.getUserId();
        userId = uid;
        
        WrapobjError objWrap = new WrapobjError(); 
        
        List<Quote> lstQuote = [SELECT Id, Status,OwnerId, VCPL_ID_Head__c FROM Quote WHERE Id=:QuoteId AND Status='Draft'];
        if(lstQuote.size()>0)
            {
                List<QuoteLineItem> lstquoteLine = [SELECT Id FROM QuoteLineItem WHERE QuoteId=:lstQuote[0].Id];
                
                if(lstquoteLine != NULL && !lstquoteLine.isEmpty()){
                    if(lstQuote[0].OwnerId != UserInfo.getUserId()) {
                        objWrap.strResType = 'error' ;
                        objWrap.strMessage = 'You are not the actual Quote Owner';
                    }
                    /*else if(String.isBlank(lstQuote[0].VCPL_ID_Head__c)){
                        objWrap.strResType = 'error' ;
                        objWrap.strMessage = 'No ID head defined for the Owner of the Quote';
                    }*/
                    else{
                         objWrap.strResType = 'success' ;
                         objWrap.strMessage = 'You can submit for approval';
                    }   
                }
                 else
                 {
                      objWrap.strResType = 'error' ;
                      objWrap.strMessage = 'No Product is added';
                 }
                    
        }
        else
        {
            objWrap.strResType = 'error' ;
            objWrap.strMessage = 'Not in Draft status so cannot submit for approval';
        }
        
        return objWrap;
    }
   
    @AuraEnabled
    public static WrapobjError updateQuoteCall(String qt){
        List<Quote> lstQuote = [SELECT Id, Name, Status, VCPL_ID_Head__c  FROM Quote WHERE Id=:qt];
        
        WrapobjError objWrap = new WrapobjError(); 
        
        // Create an approval request for the account
        if(!String.isBlank(lstQuote[0].VCPL_ID_Head__c)){
            Approval.ProcessSubmitRequest objReq = new Approval.ProcessSubmitRequest();
            objReq.setComments('Submitting Quote for approval. for Id Customer');
            objReq.setObjectId(qt);
         
   
        // Submit on behalf of a specific submitter
            objReq.setSubmitterId(UserInfo.getUserId()); 
            
        // Submit the record to specific process and skip the criteria evaluation
            objReq.setProcessDefinitionNameOrId(Label.VCPL_Quote_Approval_process_Name);
            objReq.setSkipEntryCriteria(false);
            
        // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(objReq);
             // Verify the result
            if(result.isSuccess()){
                objWrap.strResType = 'success' ;
                objWrap.strMessage = 'Successfully submited for approval';
            }
        }
        else{
            Quote objQuote = new Quote(Id = lstQuote[0].Id, IsSubmitted__c = true,Status='Approved');
            try{
                update objQuote;
                objWrap.strResType = 'success' ;
                objWrap.strMessage = 'Quote successfully approved';
            }
            catch(Exception e){
                objWrap.strResType = 'error' ;
                objWrap.strMessage = e.getdmlMessage(0);
            }
        }               
       
        return objWrap;
    }
}