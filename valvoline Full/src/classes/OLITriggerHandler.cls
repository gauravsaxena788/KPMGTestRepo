public class OLITriggerHandler{
    public void updateSaleOnAccountPotential(List<opportunityLineItem> OLIList){
        List<string> accPotKey=new List<string>();
        List<Account_Potential__c> accPotList= new List<Account_Potential__c>();
        List<Account_Potential__c> accPotToUpdate = new List<Account_Potential__c>();
        MAP<String,Account_Potential__c> accPotMAP = new MAP<String,Account_Potential__c>();
         for(opportunityLineItem oli :OLIList){
             accPotKey.add(oli.AccPotentialCalculation__c);
         }
         if(accPotKey.size()>0){
             accPotList=[select id,name,AccPotentialCalculation__c,YTD_in_volume__c
                                       from Account_Potential__c 
                                               where AccPotentialCalculation__c IN :accPotKey ];  
             if(accPotList.size()>0){
                 for(Account_Potential__c ap:accPotList){
                     accPotMAP.put(ap.AccPotentialCalculation__c ,ap);
                 }
             }  
         }
         for(opportunityLineItem oli :OLIList){
             if(accPotMAP.get(oli.AccPotentialCalculation__c)!=null){
                Account_Potential__c ap=accPotMAP.get(oli.AccPotentialCalculation__c);
                oli.Account_Product_Potential__c=ap.id;
                
             }
         }
       
    }
}