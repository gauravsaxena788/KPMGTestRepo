public class VCPL_SKUMappingTriggerHandler{
    
    public static void beforeInsert(List<CD_SKU_Mapping__c > lstofSKU){
        Set<Decimal> setofSKUId = new Set<Decimal>();
        Map<String,String> mapofSKUWithData = new Map<String,String>();
        
        for(CD_SKU_Mapping__c objCDSKU :lstofSKU){
            if(!String.isBlank(objCDSKU.VCPL_Product_SKU_Id__c))
                setofSKUId.add(decimal.valueOf(objCDSKU.VCPL_Product_SKU_Id__c));
        } 
        
        if(setofSKUId.size() > 0)
            mapofSKUWithData = tagProductwithSKUid(setofSKUId); 
        
        for(CD_SKU_Mapping__c objCDSKU :lstofSKU){
            if(!String.isBlank(objCDSKU.VCPL_Product_SKU_Id__c) && mapofSKUWithData.containskey(objCDSKU.VCPL_Product_SKU_Id__c))
                objCDSKU.Product__c = mapofSKUWithData.get(objCDSKU.VCPL_Product_SKU_Id__c);
        }
        
    }
    
    public static void beforeUpdate(List<CD_SKU_Mapping__c > lstofSKU , Map<Id,CD_SKU_Mapping__c> mapofOlddata){
        Set<Decimal> setofSKUId = new Set<Decimal>();
        Map<String,String> mapofSKUWithData = new Map<String,String>();
        
        for(CD_SKU_Mapping__c objCDSKU :lstofSKU){
            if(!String.isBlank(objCDSKU.VCPL_Product_SKU_Id__c) && objCDSKU.VCPL_Product_SKU_Id__c != mapofOlddata.get(objCDSKU.Id).VCPL_Product_SKU_Id__c) 
                setofSKUId.add(decimal.valueOf(objCDSKU.VCPL_Product_SKU_Id__c));
        }
        
        if(setofSKUId.size() > 0)
            mapofSKUWithData = tagProductwithSKUid(setofSKUId); 
        
        for(CD_SKU_Mapping__c objCDSKU :lstofSKU){
            if(!String.isBlank(objCDSKU.VCPL_Product_SKU_Id__c)  && objCDSKU.VCPL_Product_SKU_Id__c != mapofOlddata.get(objCDSKU.Id).VCPL_Product_SKU_Id__c
               && mapofSKUWithData.containskey(objCDSKU.VCPL_Product_SKU_Id__c))
                objCDSKU.Product__c = mapofSKUWithData.get(objCDSKU.VCPL_Product_SKU_Id__c);
        }
        
    }
    
    public static Map<String,String> tagProductwithSKUid(Set<Decimal> setofSKU){
        Map<String,String> mapofSKUWithData = new Map<String,String>();
        for(Product2 objProd :[SELECT id, SKU_Id__c FROM Product2 WHERE SKU_Id__c IN :setofSKU]){
            mapofSKUWithData.put(String.valueOf(objProd.SKU_Id__c) ,String.valueOf(objProd.Id));
        }
        return mapofSKUWithData ;
    }
}