trigger AOPLineTrigger on AOP_Line__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        Set<Id> parentQts= new Set<Id>();
        for(AOP_Line__c ql : Trigger.New){
            parentQts.add(ql.AOP__c);
        }
        AOPLineHelper.checkDuplicate(Trigger.New,parentQts);
    }
}