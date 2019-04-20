public class QVDHelperClass{

    public QVDHelperClass(){}
    
    public static void checkDuplicate(Set<Id> quoteIds, List<QVD_Line_Item__c> qvdList)
    {
        Set<Id> quoteSet = new Set<Id>();
        for(QVD_Line_Item__c qvd: [select Quote__c, Most_Likely__c from QVD_Line_Item__c where Quote__c IN: quoteIds AND Most_Likely__c=true])
        {
            quoteSet.add(qvd.Quote__c);
        }
                        
        for(QVD_Line_Item__c qvd: qvdList)
        {
            if(quoteSet.contains(qvd.Quote__c))
            {
                qvd.addError('You have already marked one QVD as Most Likely.');
            }
        }
    }

}