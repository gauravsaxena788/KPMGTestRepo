public with Sharing class AOPLineHelper {
    public static void checkDuplicate(List<AOP_Line__c> lst, Set<Id> parentQts){
        Set<String> uniqueQLs= new Set<String>();
        List<AOP_Line__c> lstQL=[SELECT Id, AOP__c, Month__c, Name FROM AOP_Line__c WHERE AOP__c IN : parentQts];
        for(AOP_Line__c ql:lstQL){  uniqueQLs.add(ql.AOP__c+ql.Month__c);
        }
        for(AOP_Line__c qltr:lst){
            
            if(uniqueQLs.contains(qltr.AOP__c+qltr.Month__c)){   qltr.addError('AOP Line for this month is already present');
            }
        }
    }
}