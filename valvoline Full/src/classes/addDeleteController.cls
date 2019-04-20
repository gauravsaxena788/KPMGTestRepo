public with sharing class addDeleteController {
   public Static Boolean isEligible{get;set;}
   
   
   @AuraEnabled
    public static void saveQuoteLineItem(List<QuoteLineItem> ListQuoteLineItem){
        //Insert ListQuoteLineItem;
    }
    
    @AuraEnabled
    public static Boolean findAllNew(String QuoteId){
        
        String uid = UserInfo.getUserId();
        
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        
        if(String.valueOf(PROFILE[0].Name)=='System Administrator')
        {
            isEligible = true;
        }
        else
        {
            List<Quote> qt = [select Id, Status from Quote where Id=:QuoteId AND Status='Draft' AND Owner.Id=:uid];
            if(qt.size()>0)
            {
                isEligible = true;
            }
            else
            {
                isEligible = false;
            }
        }
        
        return isEligible;
    }
}