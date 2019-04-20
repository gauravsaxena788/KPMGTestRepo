@isTest
public class VCPL_SKUMappingTriggerTracker {
    public static testmethod void testSKUMethod(){
        Product2 objprod = IDCumminsTestadataClass.returnTestProduct();
        insert objprod;
        CD_SKU_Mapping__c objCDSKU = new CD_SKU_Mapping__c();
        objCDSKU.Name ='123456';
        objCDSKU.VCPL_Product_SKU_Id__c = '123456';
        insert objCDSKU;
        objprod.SKU_Id__c = 996886;
        update objprod;
        objCDSKU.VCPL_Product_SKU_Id__c = '996886';
        update objCDSKU;
    }

}