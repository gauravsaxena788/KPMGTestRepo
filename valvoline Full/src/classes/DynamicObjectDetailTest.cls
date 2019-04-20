@istest
public class DynamicObjectDetailTest{

@testSetup
    static void setupTestData(){
        
    
    }
    
    
    public static testmethod void dynamicObjectDetailMethod(){
        
        string ObjectName = 'Account';
        sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject();
        sobj.put('name', 'Name');
        sobj.put('Account_Type__c','Factory Fill');
        sobj.put('Market_Segment__c', 'PowerGen');
        sobj.put('BU_Name__c','OEM');
        sobj.put('Is_Parent__c', 'N');
        sobj.put( 'Indutry_Segment__c', 'On-Highway');
        sobj.put('Zone__c', 'North');
        insert sObj;
        DynamicObjectDetail.GetsObjectData(sObj.id);
    }
   
}