public class AVDHelperClass{

    public AVDHelperClass(){}
    
    public static void checkDuplicate(Set<Id> quoteIds, List<AVD_Line_Item__c> avdList)
    {
        Set<Id> quoteSet = new Set<Id>();
        for(AVD_Line_Item__c avd: [select Quote__c, Most_Likely__c from AVD_Line_Item__c where Quote__c IN: quoteIds AND Most_Likely__c=true])
        {
            quoteSet.add(avd.Quote__c);
        }
                        
        for(AVD_Line_Item__c avd: avdList)
        {
            if(quoteSet.contains(avd.Quote__c))
            {
                avd.addError('You have already marked one AVD as Most Likely.');
            }
        }
    }
    
}