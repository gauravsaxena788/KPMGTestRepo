public class VCPL_trgOnSecondrySalesLineItemHandler{
    
    
    public static void trgOnbeforeInsert(List<VCPL_Secondary_Sales_LineItem__c> lstOfsndrySalsLineItem){
        
        List<VCPL_DP_Margin_Config__mdt> lstDPM = [SELECT Id, VCPL_End_point__c, VCPL_Margin__c, 
                                                 VCPL_Start_point__c FROM VCPL_DP_Margin_Config__mdt];
        
        Set<String> setOfsalesLIId = new Set<String>();
        Map<String,VCPL_Differential_Pricing__c> mapofDiffcal = new Map<String,VCPL_Differential_Pricing__c>();
        Set<String> setOfstrProdWithacc = new Set<String>();
        Map<String,Set<String>> mapofSSaleWPrd = new Map<String,Set<String>>();
        Map<String,VCPL_Secondary_Sales__c> mapofIdWithSecndrySales = new Map<String,VCPL_Secondary_Sales__c>();
        Map<String,String> mapofIdWithproductAccID = new Map<String,String>();
        Date startDate,EndDate;
        
        for(VCPL_Secondary_Sales_LineItem__c objSSLI :lstOfsndrySalsLineItem){
            if(!String.isBlank(objSSLI.VCPL_Secondary_Sales__c)){
                setOfsalesLIId.add(objSSLI.VCPL_Secondary_Sales__c);
                if(!String.isBlank(objSSLI.VCPL_Product__c)){
                    if(mapofSSaleWPrd.get(objSSLI.VCPL_Secondary_Sales__c) != null ){
                        Set<String> setofStr = mapofSSaleWPrd.get(objSSLI.VCPL_Secondary_Sales__c);
                        setofStr.add(objSSLI.VCPL_Product__c);
                        mapofSSaleWPrd.put(objSSLI.VCPL_Secondary_Sales__c,setofStr);
                    }
                    else if(mapofSSaleWPrd.get(objSSLI.VCPL_Secondary_Sales__c) == null ){
                        Set<String> setofStr = new Set<String>();
                         setofStr.add(objSSLI.VCPL_Product__c);
                        mapofSSaleWPrd.put(objSSLI.VCPL_Secondary_Sales__c,setofStr);
                    }
                }
        }
        }
       if(setOfsalesLIId.Size() > 0){
           system.debug('====setOfsalesLIId===='+setOfsalesLIId);
           for(VCPL_Secondary_Sales__c objSendrySals:[SELECT Id, VCPL_CDOS_Account_Id__c, VCPL_CDOS_ACCOUNT_ADDR_ID__c, VCPL_Invoice_Date__c, VCPL_Dealer_ID__c FROM 
                                                          VCPL_Secondary_Sales__c WHERE Id IN:setOfsalesLIId]){
                    mapofIdWithSecndrySales.put(objSendrySals.Id,objSendrySals);
                     system.debug('====mapofSSaleWPrd======'+mapofSSaleWPrd+'=====objSendrySals==='+objSendrySals);                                         
                    if(mapofSSaleWPrd.get(objSendrySals.id) != null && !String.isBlank(objSendrySals.VCPL_CDOS_ACCOUNT_ADDR_ID__c))
                    for(String onjStr:mapofSSaleWPrd.get(objSendrySals.id)){
                        setOfstrProdWithacc.add(String.valueof(onjStr).substring(0,15)+'-'+objSendrySals.VCPL_CDOS_ACCOUNT_ADDR_ID__c); 
                        mapofIdWithproductAccID.put(String.valueof(onjStr).substring(0,15)+'-'+objSendrySals.Id,String.valueof(onjStr).substring(0,15)+'-'+objSendrySals.VCPL_CDOS_ACCOUNT_ADDR_ID__c+'-'+objSendrySals.VCPL_Dealer_ID__c);                       
                    }
                    if(objSendrySals.VCPL_Invoice_Date__c != null && (startDate == null || startDate > objSendrySals.VCPL_Invoice_Date__c)){
                        startDate = objSendrySals.VCPL_Invoice_Date__c;
                      }
                    if(objSendrySals.VCPL_Invoice_Date__c != null && (endDate == null || endDate < objSendrySals.VCPL_Invoice_Date__c)){
                        endDate = objSendrySals.VCPL_Invoice_Date__c;
                      }
           }
          system.debug('===setOfstrProdWithacc===='+setOfstrProdWithacc);
          if(setOfstrProdWithacc.Size() > 0){   
              for(VCPL_Differential_Pricing__c objDP : [SELECT Id, VCPL_Product_AccountCode__c, VCPL_Validity_Start_Date__c , VCPL_Dealer_Name__c, VCPL_DP_Expiry_Date__c  FROM VCPL_Differential_Pricing__c WHERE VCPL_Product_AccountCode__c IN :setOfstrProdWithacc AND 
                                                          VCPL_Validity_Start_Date__c <= :startDate AND VCPL_DP_Expiry_Date__c >= :endDate  AND VCPL_DP_Request_Status__c = 'Approved']){
                    
                     if(!String.isBlank(objDP.VCPL_Product_AccountCode__c) && !String.isBlank(objDP.VCPL_Dealer_Name__c))
                         mapofDiffcal.put(objDP.VCPL_Product_AccountCode__c+'-'+String.valueof(objDP.VCPL_Dealer_Name__c).substring(0,15),objDP );                                    
              }
             system.debug('====mapofDiffcal======'+mapofDiffcal); 
                 
               for(VCPL_Secondary_Sales_LineItem__c objSSLI :lstOfsndrySalsLineItem){
                   system.debug('===='+mapofIdWithproductAccID); 
                   System.debug('===='+mapofDiffcal.get(mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c)));
                    system.debug('===='+mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c)); 
                   if(!String.isBlank(objSSLI.VCPL_Product__c) && !String.isBlank(objSSLI.VCPL_Secondary_Sales__c) && mapofIdWithSecndrySales.get(objSSLI.VCPL_Secondary_Sales__c) != null
                       && mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c) != null && mapofIdWithSecndrySales.get(objSSLI.VCPL_Secondary_Sales__c).VCPL_Invoice_Date__c != null
                       && mapofDiffcal.get(mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c)) != null &&
                       mapofDiffcal.get(mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c)).VCPL_Validity_Start_Date__c <= mapofIdWithSecndrySales.get(objSSLI.VCPL_Secondary_Sales__c).VCPL_Invoice_Date__c && 
                       mapofDiffcal.get(mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c)).VCPL_DP_Expiry_Date__c >= mapofIdWithSecndrySales.get(objSSLI.VCPL_Secondary_Sales__c).VCPL_Invoice_Date__c){
                           objSSLI.VCPL_Differential_Pricing__c = mapofDiffcal.get(mapofIdWithproductAccID.get(String.valueof(objSSLI.VCPL_Product__c).substring(0,15)+'-'+objSSLI.VCPL_Secondary_Sales__c)).Id;
                       }
                    if(lstDPM != null && lstDPM.size() > 0 && objSSLI.VCPL_Differential_Pricing__c != null ){
                       for(VCPL_DP_Margin_Config__mdt objDPM :lstDPM ){               
                           if(objDPM.VCPL_Start_point__c <= objSSLI.VCPL_Considered_Discount__c && objDPM.VCPL_End_point__c >= objSSLI.VCPL_Considered_Discount__c)
                                objSSLI.VCPL_Dealer_Margin_Prop__c= objDPM.VCPL_Margin__c;
                           }
                   }
                    if(objSSLI.VCPL_Final_DP__c != null && objSSLI.VCPL_Final_DP__c > 0)
                        objSSLI.VCPL_Final_DP_Value__c = objSSLI.VCPL_Final_DP__c ;
                        
                     
               }
          }
       }
    }
    public static void trgOnbeforeUpdate(List<VCPL_Secondary_Sales_LineItem__c> lstOfsndrySalsLineItem, Map<Id,VCPL_Secondary_Sales_LineItem__c> mapofOldMap){
        
        List<VCPL_DP_Margin_Config__mdt> lstDPM = [SELECT Id, VCPL_End_point__c, VCPL_Margin__c, 
                                                 VCPL_Start_point__c FROM VCPL_DP_Margin_Config__mdt];
                                                 
        for(VCPL_Secondary_Sales_LineItem__c objSSLI: lstOfsndrySalsLineItem){
           if(objSSLI.VCPL_Final_DP__c != mapofOldMap.get(objSSLI.Id).VCPL_Final_DP__c)
                objSSLI.VCPL_Final_DP_Value__c = objSSLI.VCPL_Final_DP__c ;
           if(lstDPM != null && lstDPM.size() > 0 && objSSLI.VCPL_Differential_Pricing__c != null && objSSLI.VCPL_Dealer_Margin_Prop__c == null && objSSLI.VCPL_Considered_Discount__c != mapofOldMap.get(objSSLI.Id).VCPL_Considered_Discount__c){
               for(VCPL_DP_Margin_Config__mdt objDPM :lstDPM ){               
                   if(objDPM.VCPL_Start_point__c <= objSSLI.VCPL_Considered_Discount__c && objDPM.VCPL_End_point__c >= objSSLI.VCPL_Considered_Discount__c)
                        objSSLI.VCPL_Dealer_Margin_Prop__c= objDPM.VCPL_Margin__c;
                   }
           }
          }
    }
}