public Class VCPL_trgOnDiffrentialPricingcls{
    
    public Static void trgonbeforeinsert(List<VCPL_Differential_Pricing__c> lstofDiffPricng){
        // Data Defined
        Set<String> setofprodComb = new Set<String>();
        Set<String> setofCDOsAccCode = new Set<String>();
        Map<String,String> MapofCCodeprodComb = new Map<String,String>();
        Set<String> setofAccId = new Set<String>();
        Map<String,Account> mapIdwithDealer = new Map<String,Account>();
        Map<String,Set<String>> mapofProdDP = new Map<String,Set<String>>();
        Map<String,String> mapofParebtchildata = new Map<String,String>();
        
        for(VCPL_Differential_Pricing__c objDiffP :lstofDiffPricng){
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c) &&
               !String.isBlank(objDiffP.VCPL_Dealer_Name__c))
                setofAccId.add(objDiffP.VCPL_Dealer_Name__c);
        }
        if(setofAccId.size() > 0){
            for(Account objAcc: [SELECT id, VCPL_Account_ID__c FROM Account WHERE Id IN :setofAccId ]){
                mapIdwithDealer.put(objAcc.Id,objAcc);
            }
        }
        for(VCPL_Differential_Pricing__c objDiffP :lstofDiffPricng){
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c)){
                setofCDOsAccCode.add(objDiffP.VCPL_Customer_Code__c);
                setofprodComb.add(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
                MapofCCodeprodComb.put(objDiffP.VCPL_Customer_Code__c,String.Valueof(objDiffP.VCPL_Product__c).substring(0,15));
            }
        }
        if(setofprodComb.size() > 0){ 
            mapofProdDP = getRelatedDPdata(setofprodComb,null);
            mapofParebtchildata = getRelatedDPParentdata(setofCDOsAccCode ,null,MapofCCodeprodComb);
        }
        
        for(VCPL_Differential_Pricing__c objDiffP :lstofDiffPricng){
            system.debug('===objDiffP ==='+objDiffP );
            system.debug(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
            System.debug(mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c));
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c)
               && mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c) != null ){
                   system.debug('====mapofProdDP==='+mapofProdDP);
                   Set<String> setofdata = mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
                   if(setofdata != null && setofdata.size() > 0){
                       List<String> lstofstr = new List<String>(setofdata);
                       List<String> lstofstringmessage = lstofstr[0].split(';');
                       objDiffP.VCPL_Alert_message_for_Approver__c =  lstofstringmessage[0]+' '+lstofstringmessage[1];
                       objDiffP.VCPL_Alert_message_for_Branch_Head__c = lstofstringmessage[0];
                   }
                   if(!String.isBlank(objDiffP.VCPL_Dealer_Name__c) && mapIdwithDealer.get(objDiffP.VCPL_Dealer_Name__c) != null
                      && !String.isBlank(objDiffP.VCPL_Dealer_Name__c) && mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c+'-'+objDiffP.VCPL_Dealer_Name__c) != null){
                          
                          for(String strDPData : mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c+'-'+objDiffP.VCPL_Dealer_Name__c)){
                           List<String> lstofstringmessage = strDPData.split(';');
                           if(lstofstringmessage.size() > 2){
                               List<String> strDatevalue = lstofstringmessage[2].split('enddate');
                               system.debug('===v===='+strDatevalue);
                               if(strDatevalue != null && strDatevalue.size() > 1){
                                   Date DPStartdate = Date.Valueof(strDatevalue[0]);
                                   Date DPEnddate = Date.Valueof(strDatevalue[1]);
                                   
                                   if((objDiffP.VCPL_Validity_Start_Date__c <= DPStartdate && DPEnddate <= objDiffP.VCPL_DP_Expiry_Date__c) ||
                                      (objDiffP.VCPL_Validity_Start_Date__c <= DPStartdate && DPEnddate >= objDiffP.VCPL_DP_Expiry_Date__c) ||
                                       (objDiffP.VCPL_Validity_Start_Date__c <= DPStartdate && DPStartdate <= objDiffP.VCPL_DP_Expiry_Date__c)||
                                       (objDiffP.VCPL_Validity_Start_Date__c <= DPEnddate && DPEnddate <= objDiffP.VCPL_DP_Expiry_Date__c))
                                   {
                                       //objdata.objectName = 'ERROR';
                                       // objdata.strId = Label.VCPL_DP_Record_found_Error+' DP ID: '+ lstofstringmessage[0]+' Owner is '+ lstofstringmessage[1];
                                   		objDiffP.addError(Label.VCPL_DP_Record_found_Error+' DP ID: '+ lstofstringmessage[0]+' Owner is '+ lstofstringmessage[1]);
                                   }//objDiffPricobj.VCPL_DP_Expiry_Date__c
                               }
                           }
                       }
                          
                          //objDiffP.addError(Label.VCPL_DP_Record_found_Error);
                      }
                       
               }
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c)
               && mapofParebtchildata.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c) != null ){
                   system.debug('====mapofProdDP==='+mapofProdDP);
                   String setofdatachild = mapofParebtchildata.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
                   
                   List<String> lstofstringmessage = setofdatachild.split(';');
                   objDiffP.VCPL_Alert_message_for_Approver__c =  lstofstringmessage[0]+' '+lstofstringmessage[1];
                   objDiffP.VCPL_Alert_message_for_Branch_Head__c = lstofstringmessage[0];
               }
        }
    }
    
    public Static void trgonbeforeupdate(List<VCPL_Differential_Pricing__c> lstofDiffPricng, Map<Id,VCPL_Differential_Pricing__c> mapofDiffPrcng){
        // Data Defined
        Set<String> setofprodComb = new Set<String>();
        Map<String,String> MapofCCodeprodComb = new Map<String,String>();
        Set<String> setofAccId = new Set<String>();
        Set<String> DPIds = new Set<String>();
        Set<String> setofCDOsAccCode = new Set<String>();
        Map<String,Account> mapIdwithDealer = new Map<String,Account>();
        Map<String,Set<String>> mapofProdDP = new Map<String,Set<String>>();
        Map<String,String> mapofParebtchildata = new Map<String,String>();
        
        for(VCPL_Differential_Pricing__c objDiffP :lstofDiffPricng){
            DPIds.add(objDiffP.Id);
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c) &&
               !String.isBlank(objDiffP.VCPL_Dealer_Name__c))
                setofAccId.add(objDiffP.VCPL_Dealer_Name__c);
        }
        if(setofAccId.size() > 0){
            for(Account objAcc: [SELECT id, VCPL_Account_ID__c FROM Account WHERE Id IN :setofAccId ]){
                mapIdwithDealer.put(objAcc.Id,objAcc);
            }
        }
        
        for(VCPL_Differential_Pricing__c objDiffP :lstofDiffPricng){
            system.debug('====objDiffP ==='+objDiffP );
            system.debug(objDiffP.VCPL_Product__c+'====='+mapofDiffPrcng.get(objDiffP.Id).VCPL_Product__c);
            
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c)
               && (objDiffP.VCPL_Product__c != mapofDiffPrcng.get(objDiffP .Id).VCPL_Product__c ||  
                   objDiffP.VCPL_Customer_Code__c != mapofDiffPrcng.get(objDiffP .Id).VCPL_Customer_Code__c) ){
                       setofCDOsAccCode.add(objDiffP.VCPL_Customer_Code__c);
                       MapofCCodeprodComb.put(objDiffP.VCPL_Customer_Code__c,String.Valueof(objDiffP.VCPL_Product__c).substring(0,15));
                       setofprodComb.add(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
                   }
        }
        if(setofprodComb.size() > 0){
            system.debug('===setofprodComb=='+setofprodComb);
            mapofProdDP = getRelatedDPdata(setofprodComb,DPIds);
            mapofParebtchildata = getRelatedDPParentdata(setofCDOsAccCode ,DPIds ,MapofCCodeprodComb);
        }
        
        for(VCPL_Differential_Pricing__c objDiffP :lstofDiffPricng){
            system.debug('====objDiffP ==='+objDiffP );
            system.debug('===mapofParebtchildata==='+mapofParebtchildata);
            system.debug(objDiffP.VCPL_Product__c+'====='+mapofDiffPrcng.get(objDiffP.Id).VCPL_Product__c);
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c)
               && (objDiffP.VCPL_Product__c != mapofDiffPrcng.get(objDiffP .Id).VCPL_Product__c ||  
                   objDiffP.VCPL_Customer_Code__c != mapofDiffPrcng.get(objDiffP .Id).VCPL_Customer_Code__c)
               && mapofParebtchildata.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c) != null){
                   
                   String setofdatachild = mapofParebtchildata.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
                   
                   
                   List<String> lstofstringmessage = setofdatachild.split(';');
                   objDiffP.VCPL_Alert_message_for_Approver__c =  lstofstringmessage[0]+' '+lstofstringmessage[1];
                   objDiffP.VCPL_Alert_message_for_Branch_Head__c = lstofstringmessage[0];
               }
            
            if(!String.isBlank(objDiffP.VCPL_Customer_Code__c) &&  !String.isBlank(objDiffP.VCPL_Product__c)
               && (objDiffP.VCPL_Product__c != mapofDiffPrcng.get(objDiffP .Id).VCPL_Product__c ||  
                   objDiffP.VCPL_Customer_Code__c != mapofDiffPrcng.get(objDiffP .Id).VCPL_Customer_Code__c)
               && mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c) != null){
                   
                   Set<String> setofdata = mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c);
                   if(setofdata != null && setofdata.size() > 0){
                       List<String> lstofstr = new List<String>(setofdata);
                       List<String> lstofstringmessage = lstofstr[0].split(';');
                       objDiffP.VCPL_Alert_message_for_Approver__c =  lstofstringmessage[0]+' '+lstofstringmessage[1];
                       objDiffP.VCPL_Alert_message_for_Branch_Head__c = lstofstringmessage[0];
                   }
                   
                   if(!String.isBlank(objDiffP.VCPL_Dealer_Name__c) && mapIdwithDealer.get(objDiffP.VCPL_Dealer_Name__c) != null
                      && !String.isBlank(objDiffP.VCPL_Dealer_Name__c) && mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c+'-'+objDiffP.VCPL_Dealer_Name__c) != null)
                       
                          for(String strDPData : mapofProdDP.get(String.Valueof(objDiffP.VCPL_Product__c).substring(0,15)+'-'+objDiffP.VCPL_Customer_Code__c+'-'+objDiffP.VCPL_Dealer_Name__c)){
                           List<String> lstofstringmessage = strDPData.split(';');
                           if(lstofstringmessage.size() > 2){
                               List<String> strDatevalue = lstofstringmessage[2].split('enddate');
                               system.debug('===v===='+strDatevalue);
                               if(strDatevalue != null && strDatevalue.size() > 1){
                                   Date DPStartdate = Date.Valueof(strDatevalue[0]);
                                   Date DPEnddate = Date.Valueof(strDatevalue[1]);
                                   
                                   if((objDiffP.VCPL_Validity_Start_Date__c <= DPStartdate && DPEnddate <= objDiffP.VCPL_DP_Expiry_Date__c) ||
                                      (objDiffP.VCPL_Validity_Start_Date__c <= DPStartdate && DPEnddate >= objDiffP.VCPL_DP_Expiry_Date__c) ||
                                       (objDiffP.VCPL_Validity_Start_Date__c <= DPStartdate && DPStartdate <= objDiffP.VCPL_DP_Expiry_Date__c)||
                                       (objDiffP.VCPL_Validity_Start_Date__c <= DPEnddate && DPEnddate <= objDiffP.VCPL_DP_Expiry_Date__c))
                                   {
                                       //objdata.objectName = 'ERROR';
                                       // objdata.strId = Label.VCPL_DP_Record_found_Error+' DP ID: '+ lstofstringmessage[0]+' Owner is '+ lstofstringmessage[1];
                                   		objDiffP.addError(Label.VCPL_DP_Record_found_Error+' DP ID: '+ lstofstringmessage[0]+' Owner is '+ lstofstringmessage[1]);
                                   }//objDiffPricobj.VCPL_DP_Expiry_Date__c
                               }
                           }
                       }
                          
                          //objDiffP.addError(Label.VCPL_DP_Record_found_Error);
                       //objDiffP.addError(Label.VCPL_DP_Record_found_Error);
               }
        }
    }
    
    // Method to check the duplicate DP
    public static Map<String,Set<String>> getRelatedDPdata(Set<String> setofprodComb , Set<String> setofDPId){
        Map<String,Set<String>> mapofProdDP = new Map<String,Set<String>>();
        for(VCPL_Differential_Pricing__c objDiffPrc: [SELECT Name, id, VCPL_Product_AccountCode__c, VCPL_Dealer_Name__c, VCPL_Dealer_Name__r.Name, VCPL_Product__c, VCPL_Customer_Code__c, CreatedDate, VCPL_Discount_L__c, VCPL_DP_Request_Status__c, VCPL_Dealer_Name__r.Is_Parent__c,
                                                      VCPL_Dealer_Name__r.ParentId ,VCPL_Dealer_Name__r.Parent.VCPL_Isgroupbyparent__c , VCPL_Dealer_Name__r.Parent.Name, Owner.Name, VCPL_Validity_Start_Date__c, VCPL_DP_Expiry_Date__c FROM VCPL_Differential_Pricing__c WHERE VCPL_Product_AccountCode__c IN:setofprodComb
                                                      AND VCPL_DP_Request_Status__c != 'Expired' AND Id NOT IN :setofDPId ORDER BY CreatedDate DESC]){
                                                          if(objDiffPrc.VCPL_Product_AccountCode__c != null && mapofProdDP.get(objDiffPrc.VCPL_Product__c+'-'+objDiffPrc.VCPL_Customer_Code__c) == null){
                                                              Set<String> setofStr = new Set<String>();
                                                              
                                                              setofStr.add('A Diff. pricing request for the selected customer and product already exist as '+objDiffPrc.Name+' by '+objDiffPrc.VCPL_Dealer_Name__r.Name+' ; Discount/L '+objDiffPrc.VCPL_Discount_L__c+' and '+objDiffPrc.VCPL_DP_Request_Status__c+' ; Owner is '+objDiffPrc.Owner.Name+' ; '+objDiffPrc.VCPL_Validity_Start_Date__c+'$'+ objDiffPrc.VCPL_DP_Expiry_Date__c);
                                                              mapofProdDP.put(objDiffPrc.VCPL_Product_AccountCode__c,setofStr);
                                                          }
                                                          
                                                          if(mapofProdDP.get(objDiffPrc.VCPL_Product_AccountCode__c+'-'+objDiffPrc.VCPL_Dealer_Name__c) != null ){
                                                              String messageofoldDP = objDiffPrc.Name+' ; '+objDiffPrc.Owner.Name+' ; '+objDiffPrc.VCPL_Validity_Start_Date__c+' enddate '+ objDiffPrc.VCPL_DP_Expiry_Date__c;
                                                              Set<String> setofStr = mapofProdDP.get(objDiffPrc.VCPL_Product_AccountCode__c+'-'+objDiffPrc.VCPL_Dealer_Name__c);
                                                              setofStr.add(messageofoldDP);
                                                              //setofStr.add(objDiffPrc.Id);
                                                              mapofProdDP.put(objDiffPrc.VCPL_Product_AccountCode__c+'-'+objDiffPrc.VCPL_Dealer_Name__c, setofStr );
                                                              
                                                          }
                                                          else if(mapofProdDP.get(objDiffPrc.VCPL_Product_AccountCode__c+'-'+objDiffPrc.VCPL_Dealer_Name__c) == null ){
                                                              String messageofoldDPnew = objDiffPrc.Name+' ; '+objDiffPrc.Owner.Name+' ; '+objDiffPrc.VCPL_Validity_Start_Date__c+' enddate '+ objDiffPrc.VCPL_DP_Expiry_Date__c;
                                                              Set<String> setofStr = new Set<String>();
                                                              setofStr.add(messageofoldDPnew);
                                                              //setofStr.add(objDiffPrc.Id);
                                                              mapofProdDP.put(objDiffPrc.VCPL_Product_AccountCode__c+'-'+objDiffPrc.VCPL_Dealer_Name__c,setofStr );
                                                              
                                                          }
                                                      }
        system.debug('===mapofProdDP=='+mapofProdDP);
        return mapofProdDP;
    }
    
    
    public Static void trgonAfterinsert(List<VCPL_Differential_Pricing__c> lstofDiffPricng){
        // Variable Defined
        Map<String,Set<String>> mapOfDiffPrcWithShareuser = new Map<String,Set<String>>();
        
        for(VCPL_Differential_Pricing__c objDiffprc: lstofDiffPricng){
            Set<String> setofUserId = new Set<String>();
            if(!String.isBlank(objDiffprc.VCPL_DAM__c))
                setofUserId.add(objDiffprc.VCPL_DAM__c);
            if(!String.isBlank(objDiffprc.VCPL_HOD__c))
                setofUserId.add(objDiffprc.VCPL_HOD__c);
            if(!String.isBlank(objDiffprc.VCPL_Segment_Manager__c))
                setofUserId.add(objDiffprc.VCPL_Segment_Manager__c); 
            if(setofUserId.size() > 0)
                mapOfDiffPrcWithShareuser.put(objDiffprc.Id,setofUserId);
        }
        if(mapOfDiffPrcWithShareuser.size() > 0)
            shareDifferencialpricing(mapOfDiffPrcWithShareuser);
    }
    
    
    public Static void trgonAfterupdate(List<VCPL_Differential_Pricing__c> lstofDiffPricng,Map<Id,VCPL_Differential_Pricing__c> mapofDiffPrcng){
        
        List<VCPL_Differential_Pricing__c>  lstofDiffPrcng = new List<VCPL_Differential_Pricing__c>();
        Date startDate,endDate;
        
        for(VCPL_Differential_Pricing__c objDP: lstofDiffPricng){
            if(objDP.VCPL_DP_Request_Status__c == 'Approved' &&
               objDP.VCPL_DP_Request_Status__c != mapofDiffPrcng.get(objDP.Id).VCPL_DP_Request_Status__c){
                   lstofDiffPrcng.add(objDP);
                   if(startDate == null || (startDate != null && objDP.VCPL_Validity_Start_Date__c != null 
                                            && startDate > objDP.VCPL_Validity_Start_Date__c))
                       startDate = objDP.VCPL_Validity_Start_Date__c;
                   
                   if(endDate == null || (endDate != null && objDP.VCPL_DP_Expiry_Date__c != null
                                          && endDate < objDP.VCPL_DP_Expiry_Date__c))
                       endDate = objDP.VCPL_DP_Expiry_Date__c;
               }
        }
        updateInvoicelineItem(lstofDiffPrcng, startDate ,endDate  );
    }
    public Static void updateInvoicelineItem(List<VCPL_Differential_Pricing__c> lstofDiffPricng, Date strtDate, Date endDate) {
        
        List<VCPL_Secondary_Sales_LineItem__c> lstofSendrySale = new List<VCPL_Secondary_Sales_LineItem__c >();
        system.debug('====lstofDiffPricng===='+lstofDiffPricng);
        Map<String,VCPL_Differential_Pricing__c> mapofdiffPrc = new Map<String,VCPL_Differential_Pricing__c>();
        Set<String> setofproductwithacccode = new Set<String>();
        
        for(VCPL_Differential_Pricing__c objDP: lstofDiffPricng){
            if(!String.isBlank(objDP.VCPL_Customer_Code__c) && !String.isBlank(objDP.VCPL_Product__c) && !String.isBlank(objDP.VCPL_Dealer_Name__c)){
                setofproductwithacccode.add(String.Valueof(objDP.VCPL_Product__c).substring(0,15)+'-'+objDP.VCPL_Customer_Code__c+'-'+String.Valueof(objDP.VCPL_Dealer_Name__c).substring(0,15));
                mapofdiffPrc.put(String.Valueof(objDP.VCPL_Product__c).substring(0,15)+'-'+objDP.VCPL_Customer_Code__c+'-'+String.Valueof(objDP.VCPL_Dealer_Name__c).substring(0,15),objDP);
            }
        }
        system.debug('=====setofproductwithacccode====='+setofproductwithacccode);
        system.debug(strtDate +'=====setofproductwithacccode====='+endDate );
        
        for(VCPL_Secondary_Sales_LineItem__c objSecndarySales: [SELECT Id, VCPL_Differential_Pricing__c ,VCPL_Invoice__c, Product_AccountCode__c  FROM VCPL_Secondary_Sales_LineItem__c WHERE Product_AccountCode__c IN :setofproductwithacccode
                                                                AND VCPL_Invoice__c >= :strtDate AND  VCPL_Invoice__c <= :endDate AND VCPL_Differential_Pricing__c = NULL]){
                                                                    system.debug('====objSecndarySales===='+objSecndarySales);
                                                                    system.debug('===mapofdiffPrc.get(objSecndarySales.Product_AccountCode__c)==='+mapofdiffPrc.get(objSecndarySales.Product_AccountCode__c));
                                                                    if(objSecndarySales.VCPL_Invoice__c != null && !String.isBlank(objSecndarySales.Product_AccountCode__c) && mapofdiffPrc.get(objSecndarySales.Product_AccountCode__c) != null &&
                                                                       objSecndarySales.VCPL_Invoice__c >= mapofdiffPrc.get(objSecndarySales.Product_AccountCode__c).VCPL_Validity_Start_Date__c && objSecndarySales.VCPL_Invoice__c <= mapofdiffPrc.get(objSecndarySales.Product_AccountCode__c).VCPL_DP_Expiry_Date__c){
                                                                           objSecndarySales.VCPL_Differential_Pricing__c = mapofdiffPrc.get(objSecndarySales.Product_AccountCode__c).Id;
                                                                           lstofSendrySale.add(objSecndarySales);
                                                                       }
                                                                }
        
        if(lstofSendrySale.size() > 0)
            update lstofSendrySale;
    }
    
    // This is used to Manual share differeantial records
    public static void shareDifferencialpricing(Map<String,Set<String>> mapOfDiffPrcWithShareuser){
        
        List<VCPL_Differential_Pricing__Share > lstDiffShare = new List<VCPL_Differential_Pricing__Share >();
        if(mapOfDiffPrcWithShareuser.size() > 0){
            for(String objStr :mapOfDiffPrcWithShareuser.keyset()){
                if(mapOfDiffPrcWithShareuser.get(objStr) != null)
                    for(String onjUser : mapOfDiffPrcWithShareuser.get(objStr)){
                        VCPL_Differential_Pricing__Share objDPShare = new VCPL_Differential_Pricing__Share();
                        objDPShare.ParentId = objStr;
                        objDPShare.UserOrGroupId = onjUser ;
                        objDPShare.AccessLevel = 'Read';
                        objDPShare.RowCause= 'Manual';
                        lstDiffShare.add(objDPShare);
                    }
            }
            
        }
        if(lstDiffShare.size()> 0)
            insert lstDiffShare;
    }
    public static Map<String,String> getRelatedDPParentdata(Set<String> setofParentAccId , Set<String> setofDPId, Map<String,String> mapofParentwithProd){
        // Variable defined
        Map<String,String> mapofParentwithChildCode = new Map<String,String>();
        Map<String,String> mapofParentwithData = new Map<String,String>();
        Map<String,String> mapofParentwithChildDP = new Map<String,String>();
        Map<String,String> mapParentwithProduct = new Map<String,String>();
        Set<String> setofCDOSParent = new Set<String>();
        Set<String> setofCDOSParentId = new Set<String>();
        
        for(Account objAcc:[SELECT Id, VCPL_CDOS_AccountId__c, ParentId FROM Account WHERE VCPL_CDOS_AccountId__c  IN:setofParentAccId]){
            if(!string.isBlank(objAcc.ParentId)){ 
                setofCDOSParentId.add(objAcc.ParentId);
                if(mapofParentwithProd != null && mapofParentwithProd.get(objAcc.VCPL_CDOS_AccountId__c) != null){
                    mapParentwithProduct.put(objAcc.ParentId,mapofParentwithProd.get(objAcc.VCPL_CDOS_AccountId__c));
                    mapofParentwithData.put(objAcc.ParentId,objAcc.VCPL_CDOS_AccountId__c);
                }
            }
        }
        system.debug('===mapParentwithProduct==='+mapParentwithProduct);
        if(setofParentAccId.size() > 0)
            for(Account objAcc: [SELECT Id ,VCPL_CDOS_AccountId__c ,ParentId  From Account WHERE ParentId IN: setofCDOSParentId AND VCPL_CDOS_AccountId__c  NOT IN:setofParentAccId]){
                system.debug('===mapParentwithProduct=='+mapParentwithProduct);
                if(mapParentwithProduct.get(objAcc.ParentId) != null && !String.isBlank(objAcc.VCPL_CDOS_AccountId__c)){
                    setofCDOSParent.add(mapParentwithProduct.get(objAcc.ParentId)+'-'+objAcc.VCPL_CDOS_AccountId__c);
                if(!String.isBlank(objAcc.ParentId) && !String.isBlank(mapParentwithProduct.get(objAcc.ParentId)) )
                    mapofParentwithChildCode.put(objAcc.VCPL_CDOS_AccountId__c,mapofParentwithData.get(objAcc.ParentId));                    
                }
            }
        system.debug('===mapParentwithProduct==='+mapParentwithProduct);
        system.debug('===setofCDOSParent==='+setofCDOSParent);
        if(setofCDOSParent.size() > 0)
            for(VCPL_Differential_Pricing__c objDiffPrc: [SELECT Name, id, VCPL_Product_AccountCode__c, VCPL_Dealer_Name__c, VCPL_Dealer_Name__r.Name, VCPL_Product__c, VCPL_Customer_Code__c, VCPL_Customer_Name__r.Name ,VCPL_Customer_Name__r.Parent.Name ,VCPL_Customer_Name__r.ParentId ,CreatedDate, VCPL_Discount_L__c, VCPL_DP_Request_Status__c, VCPL_Dealer_Name__r.Is_Parent__c,
                                                          VCPL_Dealer_Name__r.ParentId ,VCPL_Dealer_Name__r.Parent.VCPL_Isgroupbyparent__c ,VCPL_Dealer_Name__r.Parent.Name FROM VCPL_Differential_Pricing__c WHERE VCPL_Product_AccountCode__c IN:setofCDOSParent
                                                          AND VCPL_DP_Request_Status__c != 'Expired' AND Id NOT IN :setofDPId ORDER BY CreatedDate DESC]){
                                                              if(!String.isBlank(objDiffPrc.VCPL_Customer_Code__c)){
                                                                  String messageforChildduplicate = 'A Diff. pricing request for the '+objDiffPrc.VCPL_Customer_Name__r.Name+' whose parent is '+objDiffPrc.VCPL_Customer_Name__r.Parent.Name +' and product already exist as '+objDiffPrc.Name+' by '+objDiffPrc.VCPL_Dealer_Name__r.Name+' ; Discount/L '+objDiffPrc.VCPL_Discount_L__c+' and '+objDiffPrc.VCPL_DP_Request_Status__c;
                                                                  if(!String.isBlank(objDiffPrc.VCPL_Customer_Name__r.ParentId) && !String.isBlank(mapParentwithProduct.get(objDiffPrc.VCPL_Customer_Name__r.ParentId)) 
                                                                     && !String.isBlank(objDiffPrc.VCPL_Customer_Code__c) && !String.isBlank(mapofParentwithChildCode.get(objDiffPrc.VCPL_Customer_Code__c)) )
                                                                    mapofParentwithChildDP.put(mapParentwithProduct.get(objDiffPrc.VCPL_Customer_Name__r.ParentId)+'-'+mapofParentwithChildCode.get(objDiffPrc.VCPL_Customer_Code__c),messageforChildduplicate );
                                                              }
                                                          }
        
        return mapofParentwithChildDP;
    }
}