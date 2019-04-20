public without sharing class  VCPL_DiffrentialPricingController {
    
    @AuraEnabled
    public Static VCPL_Differential_Pricing__c getvaluesforDiffrentailPricing(String parentId){
        // Variables defined
        String valuesofComp;
        VCPL_Differential_Pricing__c objDiffPric = new VCPL_Differential_Pricing__c();
        
        User objUser = [SELECT id,Name , Manager.Name, Profile.Name, AccountId, Account.Name, Account.Owner.Name, Account.OwnerId
                        ,VCPL_Contact_Role__c, Account.Parent.Name, Account.Parent.OwnerId, Account.ParentId FROM User WHERE ID = :UserInfo.getUserId()];
        String SobjectName = '';
        wrapObjectwithName objwrap = new wrapObjectwithName();
        objwrap.DAMName = objUser.Account.Owner.Name;
        if(objUser.VCPL_Contact_Role__c == 'ELP'){
            objwrap.DealerName = objUser.Account.Name;
            objwrap.BranchName = '' ;
        }
        else{
            objwrap.DealerName = objUser.Account.Parent.Name;
            objwrap.BranchName = objUser.Account.Name ;
        }   
        objwrap.CustomerName ='';
        objwrap.CustomerContactName ='';
        objwrap.IsLoginUserisOwner = true;
        objwrap.LoginUserProfile = (objUser.Profile.Name == 'System Administrator')?objUser.Profile.Name:objUser.VCPL_Contact_Role__c;
        
        system.debug('======'+objUser+'==='+objUser.Account.Parent.Name);
        if(String.isBlank(parentId)){
            
            if(objUser.Account.OwnerId != null)
                objDiffPric.VCPL_DAM__c = objUser.Account.OwnerId ;
            if(!String.isBlank(objUser.VCPL_Contact_Role__c) && objUser.VCPL_Contact_Role__c == 'ELP'){
                objDiffPric.VCPL_Dealer_Name__c = objUser.AccountId;
            }
            else{
                objDiffPric.VCPL_Dealer_Name__c = objUser.Account.ParentId;
                objDiffPric.VCPL_Branch__c = objUser.AccountId;
            }
            objDiffPric.VCPL_Remark__c = JSON.serialize(objwrap);
            objDiffPric.VCPL_DP_Type__c = 'New';
            objDiffPric.VCPL_Validity_Start_Date__c = System.Today();
            objDiffPric.VCPL_DP_Expiry_Date__c = objDiffPric.VCPL_Validity_Start_Date__c.addMonths(Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month));
            objDiffPric.VCPL_DP_Request_Status__c = 'Draft';
            objDiffPric.VCPL_Today_Date__c = System.Today();
            objDiffPric.VCPL_Validity_of_Discount__c = Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month);
            
        }
        
        if(!String.isBlank(parentId)){
            system.debug('=====parentId'+parentId);
            String sObjName = Id.valueOf(parentId).getSObjectType().getDescribe().getName();
            system.debug('=====sObjName'+sObjName);
            if(!String.isBlank(sObjName) && sObjName == 'Account'){
                /*
            List<Contact> lstContact = [SELECT id, FirstName, Account.VCPL_CDOS_AccountId__c, LastName, Phone,MobilePhone,Account.Name, Account.VCPL_Isgroupbyparent__c FROM Contact WHERE AccountId =:parentId  AND Account.VCPL_Isgroupbyparent__c = False ORDER BY CreatedDate];
            if(lstContact != null && lstContact.Size() > 0 ){
            objDiffPric.VCPL_Customer_Contact_Person__c = lstContact[0].Id;
            objDiffPric.VCPL_Customer_Contact_No__c = lstContact[0].MobilePhone;
            objwrap.CustomerName = lstContact[0].Account.Name;
            
            String firstnamecontact = (lstContact[0].FirstName != null)?lstContact[0].FirstName:'';
            String lastnamecontact = (lstContact[0].LastName != null)? lstContact[0].LastName :'';
            objwrap.CustomerContactName = firstnamecontact+' '+lastnamecontact;
            objDiffPric.VCPL_Customer_Code__c = lstContact[0].Account.VCPL_CDOS_AccountId__c;
            objDiffPric.VCPL_Customer_Name__c = parentId;
            }
            else { */
                List<Account> lstAcc = [SELECT id, Name,VCPL_CDOS_AccountId__c, VCPL_Isgroupbyparent__c FROM Account WHERE Id =:parentId AND VCPL_Isgroupbyparent__c = False];
                if(lstAcc != null && lstAcc.Size() > 0 ){
                    objwrap.CustomerName = lstAcc[0].Name;
                    objDiffPric.VCPL_Customer_Code__c = lstAcc[0].VCPL_CDOS_AccountId__c;
                    objDiffPric.VCPL_Customer_Name__c = parentId;
                    objDiffPric.VCPL_DP_Type__c = 'New';
                }
                // }
                if(objUser.Account.OwnerId != null)
                    objDiffPric.VCPL_DAM__c = objUser.Account.OwnerId ;
                if(!String.isBlank(objUser.VCPL_Contact_Role__c) && objUser.VCPL_Contact_Role__c == 'ELP'){
                    objDiffPric.VCPL_Dealer_Name__c = objUser.AccountId;
                }
                else{
                    objDiffPric.VCPL_Dealer_Name__c = objUser.Account.ParentId;
                    objDiffPric.VCPL_Branch__c = objUser.AccountId;
                }
                objDiffPric.VCPL_Remark__c = JSON.serialize(objwrap);
                
                
                objDiffPric.VCPL_Validity_Start_Date__c = System.Today();
                objDiffPric.VCPL_Today_Date__c = System.Today();
                objDiffPric.VCPL_DP_Expiry_Date__c = objDiffPric.VCPL_Validity_Start_Date__c.addMonths(Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month));
                objDiffPric.VCPL_DP_Request_Status__c = 'Draft';
                objDiffPric.VCPL_Validity_of_Discount__c = Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month);
            }
            
            else if(!String.isBlank(sObjName) && sObjName == 'VCPL_Differential_Pricing__c'){
                
                objDiffPric = [SELECT Id,VCPL_Basic_Price_L__c, VCPL_Branch__c, VCPL_Branch__r.Name, VCPL_CCPC__c,VCPL_Today_Date__c, VCPL_Validity_of_Discount__c, VCPL_Validity_Start_Date__c, VCPL_Others_Customer_Nature_of_Business__c,
                               VCPL_Config_Margin__c, VCPL_Customer_Code__c, VCPL_Customer_Contact_No__c, VCPL_Customer_nature_of_business__c,VCPL_Customer_Name__r.Name ,VCPL_Customer_contact_person_name__c,
                               VCPL_DAM__c, VCPL_DAM__r.Name, VCPL_Dealer_Name__c,VCPL_Dealer_Name__r.Name, VCPL_Dealer_Margin_Liter__c, VCPL_Discount_L__c, VCPL_DP_Expiry_Date__c, VCPL_DP_Request_Status__c, VCPL_Exception__c, VCPL_Customer_Name__c,
                               VCPL_Expected_volume__c, VCPL_Final_Approval_Date__c, VCPL_HOD__c, VCPL_KL_Potential_per_year__c, VCPL_LY_volume__c, VCPL_NSH__c, VCPL_Offer_Price_L__c, Owner.Name, VCPL_Contact_Person_Email__c,
                               VCPL_Pack_Size__c, VCPL_Part_no__c, VCPL_Price_increase_plan_in_next_quarter__c, VCPL_Product__c,VCPL_Product__r.Name, VCPL_Reason_for_Discount__c, VCPL_Remark__c,VCPL_RM_ZM__c, VCPL_Segment_Manager__c
                               FROM VCPL_Differential_Pricing__c WHERE Id = :parentId LIMIT 1];
                objwrap.CustomerName = objDiffPric.VCPL_Customer_Name__r.Name;
                /* String firstname ='',lastname ='';
                    firstname = (objDiffPric.VCPL_Customer_Contact_Person__r.FirstName != null)?objDiffPric.VCPL_Customer_Contact_Person__r.FirstName:'';
                    lastname = (objDiffPric.VCPL_Customer_Contact_Person__r.LastName != null)? objDiffPric.VCPL_Customer_Contact_Person__r.LastName :'';
                    objwrap.CustomerContactName = firstname+' '+lastname;*/
                objwrap.DAMName = objDiffPric.VCPL_DAM__r.Name;
                objwrap.DealerName = objDiffPric.VCPL_Dealer_Name__r.Name;
                objwrap.BranchName = objDiffPric.VCPL_Branch__r.Name ;
                if(objUser.Name != objDiffPric.owner.Name)
                    objwrap.IsLoginUserisOwner = false;
                objDiffPric.VCPL_Remark__c = JSON.serialize(objwrap);
            }
        }
        
        return objDiffPric;
    }
    
    @AuraEnabled
    public Static String upsertDiffrentailPricingRecord(String objDiffPric){
        
        system.debug('objDiffPric'+objDiffPric);
        String valuesofException ='' ;
        List<User> lstOfUser = new List<User>();
        List<Account> lstAccnt = new List<Account>();
        
        VCPL_Differential_Pricing__c objDiffPricobj ;
        Map<String, Object> DiffPricemap = (Map<String, Object>) JSON.deserializeUntyped(objDiffPric);
        for(String objStr : Label.VCPL_Differential_Json.split(';')){
            DiffPricemap.remove(objStr);
        }
        system.debug('JSON.serialize(DiffPricemap)'+JSON.serialize(DiffPricemap));
        objDiffPricobj = (VCPL_Differential_Pricing__c)JSON.deserialize(JSON.serialize(DiffPricemap), VCPL_Differential_Pricing__c.class);
        if(!String.isBlank(objDiffPricobj.VCPL_Customer_Code__c) && !String.isBlank(objDiffPricobj.VCPL_Part_no__c))
            objDiffPricobj.VCPL_CCPC__c = objDiffPricobj.VCPL_Customer_Code__c+'-'+objDiffPricobj.VCPL_Part_no__c;
        if(!String.isBlank(objDiffPricobj.VCPL_DAM__c)){
            
            for(User objUsr:[SELECT Id, Name, ManagerId, Manager.ManagerId, VCPL_Contact_Role__c ,AccountId 
                             FROM User WHERE Id =:objDiffPricobj.VCPL_DAM__c OR AccountId =:objDiffPricobj.VCPL_Dealer_Name__c]){
                                 if(objDiffPricobj.VCPL_DAM__c == objUsr.Id){
                                     if(!String.isBlank(objUsr.ManagerId)){
                                         objDiffPricobj.VCPL_RM_ZM__c = objUsr.ManagerId;
                                         if(!String.isBlank(objUsr.Manager.ManagerId))
                                             objDiffPricobj.VCPL_NSH__c = objUsr.Manager.ManagerId;
                                     }
                                 }
                                 else if(objDiffPricobj.VCPL_Dealer_Name__c == objUsr.AccountId && objUsr.VCPL_Contact_Role__c == 'HOD'){
                                     objDiffPricobj.VCPL_HOD__c = objUsr.Id;
                                 }
                             }
        }
        
        if(!String.isBlank(objDiffPricobj.VCPL_Dealer_Name__c)){
            // lstAccnt = [SELECT Id, Name,(SELECT Id, UserId,TeamMemberRole FROM AccountTeamMembers)  FROM Account WHERE Id =:objDiffPricobj.VCPL_Dealer_Name__c];
            
            for(Account objAcc: [SELECT Id, Name,(SELECT Id, UserId,TeamMemberRole FROM AccountTeamMembers)
                                 FROM Account WHERE Id =:objDiffPricobj.VCPL_Dealer_Name__c]){
                                     if(objAcc.Id == objDiffPricobj.VCPL_Dealer_Name__c)
                                         for(AccountTeamMember objAccmenb: objAcc.AccountTeamMembers){
                                             if(objAccmenb.TeamMemberRole == 'Segment Manager')
                                                 objDiffPricobj.VCPL_Segment_Manager__c = objAccmenb.UserId;
                                         }
                                 }
            
        }
        
        objDiffPricobj.VCPL_Exception__c = false;
        if(objDiffPricobj.VCPL_Config_Margin__c != null && objDiffPricobj.VCPL_Dealer_Margin_Liter__c != null
           && objDiffPricobj.VCPL_Config_Margin__c < objDiffPricobj.VCPL_Dealer_Margin_Liter__c){
               objDiffPricobj.VCPL_Exception__c = true; 
               valuesofException = Label.VCPL_Exception_margin_amount_is_edited+'\n'+'\n';
           }
        if(objDiffPricobj.VCPL_Discount_L__c != null && objDiffPricobj.VCPL_Discount_L__c >= 100){
            objDiffPricobj.VCPL_Exception__c = true;
            valuesofException = valuesofException + Label.VCPL_Exception_Discount_more_100+'\n'+'\n';
        }
        if(objDiffPricobj.VCPL_Validity_Start_Date__c < System.Today()){
            objDiffPricobj.VCPL_Exception__c = true;
            valuesofException = valuesofException + Label.VCPL_Exception_Validity_start_date_past+'\n'+'\n';
        }
        
        objDiffPricobj.VCPL_Reason_for_Exception__c = valuesofException;
        
        wrapObjectwithdata objdata = new wrapObjectwithdata ();
        if(!String.isBlank(objDiffPricobj.VCPL_Product__c) && !String.isBlank(objDiffPricobj.VCPL_Customer_Code__c)){
            Set<String> setofnewdata = new Set<String>();
            String DPName ='';
            system.debug('=====objDiffPricobj===='+objDiffPricobj);
            setofnewdata.add(String.valueof(objDiffPricobj.VCPL_Product__c).substring(0,15)+'-'+objDiffPricobj.VCPL_Customer_Code__c);
            Set<String> setofDPId = new Set<String>();
            if(!String.isBlank(objDiffPricobj.Id))
                setofDPId.add(objDiffPricobj.Id);
            Map<String,Set<String>> mapodres;
            if(setofDPId.size() > 0)
                mapodres =  VCPL_trgOnDiffrentialPricingcls.getRelatedDPdata(setofnewdata,setofDPId);
            else
                mapodres =  VCPL_trgOnDiffrentialPricingcls.getRelatedDPdata(setofnewdata,null);
            
            system.debug('mapodres'+mapodres);
            if(mapodres != null && mapodres.get(String.valueof(objDiffPricobj.VCPL_Product__c).substring(0,15)+'-'+objDiffPricobj.VCPL_Customer_Code__c) != null)
            {
                Set<String> setofdata = mapodres.get(String.Valueof(objDiffPricobj.VCPL_Product__c).substring(0,15)+'-'+objDiffPricobj.VCPL_Customer_Code__c);
                if(setofdata != null && setofdata.size() > 0){
                    List<String> lstofstr = new List<String>(setofdata);
                    List<String> lstofstringmessage = lstofstr[0].split(';');
                    for(String objstr: lstofstringmessage[0].split(' ')){
                        if(objstr.contains('DP-') )
                            DPName = objstr;
                    }
                    if(lstofstringmessage[2] != null)
                        DPName += ' '+lstofstringmessage[2];
                    
                    objDiffPricobj.VCPL_Alert_message_for_Approver__c =  lstofstringmessage[0]+' '+lstofstringmessage[1];
                    objDiffPricobj.VCPL_Alert_message_for_Branch_Head__c = lstofstringmessage[0];
                    objdata.objectName = 'SUCCESS';
                    objdata.strId = objDiffPricobj.VCPL_Alert_message_for_Branch_Head__c;
                }
            }
            if(mapodres != null && mapodres.get(String.valueof(objDiffPricobj.VCPL_Product__c).substring(0,15)+'-'+objDiffPricobj.VCPL_Customer_Code__c+'-'+objDiffPricobj.VCPL_Dealer_Name__c) != null)
            {
                System.debug('++++++mapodres++++'+mapodres);
                for(String strDPData : mapodres.get(String.valueof(objDiffPricobj.VCPL_Product__c).substring(0,15)+'-'+objDiffPricobj.VCPL_Customer_Code__c+'-'+objDiffPricobj.VCPL_Dealer_Name__c)){
                    List<String> lstofstringmessage = strDPData.split(';');
                    if(lstofstringmessage.size() > 2){
                        List<String> strDatevalue = lstofstringmessage[2].split('enddate');
                        system.debug(strDatevalue.size()+'===v===='+strDatevalue);
                        if(strDatevalue != null && strDatevalue.size() > 1){
                            Date DPStartdate = Date.Valueof(strDatevalue[0]);
                            Date DPEnddate = Date.Valueof(strDatevalue[1]);
                            System.debug('====start'+objDiffPricobj.VCPL_Validity_Start_Date__c +'====end'+objDiffPricobj.VCPL_DP_Expiry_Date__c+'========srt'+ DPStartdate +'=====end'+ DPEnddate );
                            if((objDiffPricobj.VCPL_Validity_Start_Date__c <= DPStartdate && DPEnddate <= objDiffPricobj.VCPL_DP_Expiry_Date__c) ||
                               (objDiffPricobj.VCPL_Validity_Start_Date__c <= DPStartdate && DPEnddate >= objDiffPricobj.VCPL_DP_Expiry_Date__c) ||
                               (objDiffPricobj.VCPL_Validity_Start_Date__c <= DPStartdate && DPStartdate <= objDiffPricobj.VCPL_DP_Expiry_Date__c)||
                               (objDiffPricobj.VCPL_Validity_Start_Date__c <= DPEnddate && DPEnddate <= objDiffPricobj.VCPL_DP_Expiry_Date__c))
                            {
                                objdata.objectName = 'ERROR';
                                objdata.strId = Label.VCPL_DP_Record_found_Error+' DP ID: '+ lstofstringmessage[0]+' Owner is '+ lstofstringmessage[1];
                            }//objDiffPricobj.VCPL_DP_Expiry_Date__c
                        }
                    }
                }
                //objdata.objectName = 'ERROR';
                //objdata.strId = Label.VCPL_DP_Record_found_Error+' DP ID: '+ DPName;
            } 
            
        }
        
        if(String.isBlank(objdata.objectName) ||(!String.isBlank(objdata.objectName) && objdata.objectName == 'SUCCESS')){
            System.debug('====objDiffPricobj==='+objDiffPricobj);
            upsert objDiffPricobj;
            objdata.objectName = 'SUCCESS';
            if(!string.isBlank(objdata.strId))
                objdata.strId = objdata.strId+';'+String.valueof(objDiffPricobj.id);
            else 
                objdata.strId = String.valueof(objDiffPricobj.id);
        }
        String returnstr = JSON.serialize(objdata);
        system.debug('objDiffPricobj.id'+objDiffPricobj.id);
        return  returnstr ;
    }
    
    @AuraEnabled
    public Static wrapdatewithmessage validateDateRecord(String Startdate){
        system.debug('===='+Startdate);
        wrapdatewithmessage objwrapmessage = new wrapdatewithmessage();
        if(Date.valueOf(Startdate) < System.today()){
            system.debug('=====(Date.valueOf(Startdate)).daysBetween(System.today())'+(Date.valueOf(Startdate)).daysBetween(System.today()));
            if((Date.valueOf(Startdate)).daysBetween(System.today()) > 90)
                objwrapmessage.strmessage = 'Old Date no accepted';
            else
                objwrapmessage.strmessage = 'Old Date'; 
        }
        else
            objwrapmessage.strmessage = 'No issue';
        objwrapmessage.enddate = Date.valueOf(Startdate).addMonths(Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month));
        return  objwrapmessage;
    }
    
    public class wrapdatewithmessage{
        @auraenabled public Date enddate{get;set;}
        @auraenabled public String strmessage{get;set;}
    }
    
    public class wrapObjectwithdata{
        @auraenabled public String strId{get;set;}
        @auraenabled public String objectName{get;set;}
    }
    
    public class wrapObjectwithName{
        @auraenabled public String DAMName{get;set;}
        @auraenabled public String DealerName{get;set;}
        @auraenabled public String BranchName{get;set;}
        @auraenabled public String CustomerName{get;set;}
        @auraenabled public String CustomerContactName{get;set;}
        @auraenabled public String LoginUserProfile{get;set;}
        @auraenabled public Boolean IsLoginUserisOwner{get;set;}
    }
    
    @AuraEnabled
    public static string returnrelatedata(String objectname ,String strId ,String DealerAccount ,String relatedData){
        system.debug('==========objectname'+objectname+'========relatedData'+relatedData);
        DealerAccount = DealerAccount.substring(0,15);
        String strSobject = JSON.serialize('');
        wrapObjectwithdata objWrapData = new wrapObjectwithdata();
        objWrapData.strId = strId;
        objWrapData.objectName = objectname;
        Date currentDate = System.Today();
        Integer StartFinacialYearmonth = Integer.valueof(Label.VCPL_Financial_Year_Start) ; 
        Set<String> setofFinanacialYear = new Set<String>();
        String firstfinancialyear,lastfinancialyear;
        Decimal LYsale = 0,Targetsale = 0;
        
        if(currentDate.month() >= StartFinacialYearmonth){
            firstfinancialyear = String.valueof(currentDate.year()+1);
            lastfinancialyear = String.valueof(currentDate.year());
            //setofFinanacialYear.add(firstfinancialyear);
            // setofFinanacialYear.add(String.valueof(currentDate.year()));
        }
        
        else{
            firstfinancialyear = String.valueof((currentDate.year()));
            lastfinancialyear = String.valueof(currentDate.year()-1);
            //setofFinanacialYear.add(firstfinancialyear);
            //setofFinanacialYear.add(String.valueof(currentDate.year() - 1));
        }
        system.debug('firstfinancialyear'+firstfinancialyear+'===='+objWrapData.strId);
        //(wrapObjectwithdata)JSON.deserialize(objJSONwrapobjectwithdata, wrapObjectwithdata.class);
        system.debug('==========objWrapData'+objWrapData+'objWrapData.objectName.contains(Contact)'+objWrapData.objectName.contains('Contact'));
        if(objWrapData.strId != null && objWrapData.objectName == 'Customers'){
            /*
            Date currentDate = System.Today();
            Integer StartFinacialYearmonth = Integer.valueof(Label.VCPL_Financial_Year_Start) ; 
            Set<String> setofFinanacialYear = new Set<String>();
            String firstfinancialyear,lastfinancialyear;
            Decimal LYsale = 0,Targetsale = 0;
            
            if(currentDate.month() >= StartFinacialYearmonth){
                firstfinancialyear = String.valueof(currentDate.year()+1);
                lastfinancialyear = String.valueof(currentDate.year());
                //setofFinanacialYear.add(firstfinancialyear);
               // setofFinanacialYear.add(String.valueof(currentDate.year()));
            }
                
            else{
                firstfinancialyear = String.valueof((currentDate.year()));
                lastfinancialyear = String.valueof(currentDate.year()-1);
                //setofFinanacialYear.add(firstfinancialyear);
                //setofFinanacialYear.add(String.valueof(currentDate.year() - 1));
        		} */
            system.debug('firstfinancialyear'+firstfinancialyear+'===='+objWrapData.strId+'===DealerAccount==='+DealerAccount);
            
            if(!String.isBlank(relatedData)){
            for(AggregateResult objAggregateResult : [SELECT AVG(VCPL_Vol_in_Ltrs__c) , VCPL_Product__c FROM VCPL_Secondary_Sales_LineItem__c WHERE 
                                                                  VCPL_Secondary_Sales__r.VCPL_Dealer_ID__c=:DealerAccount AND VCPL_Secondary_Sales__r.VCPL_Financial_Year__c =:lastfinancialyear AND VCPL_Product__c =:relatedData AND VCPL_Secondary_Sales__r.Account__c =: objWrapData.strId
                                                                  GROUP BY VCPL_Product__c]){
                             LYsale = Double.ValueOf(objAggregateResult.get('expr0'))/1000;                                        
                         }
			for(AggregateResult objAggregateResult : [SELECT AVG(VCPL_Vol_in_Ltrs__c) , VCPL_Product__c FROM VCPL_Secondary_Sales_LineItem__c
                                                                  WHERE VCPL_Secondary_Sales__r.VCPL_Dealer_ID__c=:DealerAccount AND VCPL_Secondary_Sales__r.VCPL_Financial_Year__c =:firstfinancialyear AND VCPL_Product__c =:relatedData AND VCPL_Secondary_Sales__r.Account__c =: objWrapData.strId
                                                                  GROUP BY VCPL_Product__c]){
                             Targetsale = Double.ValueOf(objAggregateResult.get('expr0'))/1000;                                          
                         }
            }
            
            /*
            for(VCPL_Customer_Plan__c objCusPlan :[SELECT Id, VCPL_Financial_Year__c, VCPL_Last_Year_Sales_Vol__c, VCPL_Latest_Est_Sales__c, VCPL_Branch__c, VCPL_Customer_Account__c, VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c ,VCPL_Branch_CO_Sales_in_KL__c
                                                   FROM VCPL_Customer_Plan__c WHERE VCPL_Customer_Account__r.ParentId = :DealerAccount AND VCPL_Financial_Year__c = :firstfinancialyear AND VCPL_CD_Customer__c = :objWrapData.strId AND RecordType.DeveloperName = 'VCPL_Branch_Customer']){
                                                       system.debug('firstfinancialyear'+firstfinancialyear+'=====objCusPlan==='+objCusPlan);
                                                       if(objCusPlan.VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c != null)
                                                           LYsale = LYsale +objCusPlan.VCPL_Last_Yr_Cummins_Oil_Sales_Vol_in_KL__c;
                                                       if(objCusPlan.VCPL_Branch_CO_Sales_in_KL__c != null)
                                                           Targetsale = Targetsale + objCusPlan.VCPL_Branch_CO_Sales_in_KL__c;
                                                   } 
                                                                    
            List<Contact> lstConcWithAcc = [SELECT Id, Account.VCPL_CDOS_AccountId__c, Account.VCPL_Current_FY_Total_Actual_Sales_Vol__c, Account.VCPL_Current_Month_Total_Planned_Sales__c,
            MobilePhone, Name FROM Contact WHERE AccountId= :objWrapData.strId ORDER BY CreatedDate ASC];
            if(lstConcWithAcc != null && lstConcWithAcc.size() > 0){
            lstConcWithAcc[0].Account.VCPL_Current_FY_Total_Actual_Sales_Vol__c = Targetsale ;
            lstConcWithAcc[0].Account.VCPL_Current_Month_Total_Planned_Sales__c = LYsale ;
            strSobject = JSON.serialize(lstConcWithAcc[0]);
            }
            else if(lstConcWithAcc == null || lstConcWithAcc.size() == 0){ */
            List<Account> lstAcc= [SELECT Id, VCPL_CDOS_AccountId__c, VCPL_Current_FY_Total_Actual_Sales_Vol__c, VCPL_Current_Month_Total_Planned_Sales__c FROM Account WHERE Id =:objWrapData.strId];
            lstAcc[0].VCPL_Current_FY_Total_Actual_Sales_Vol__c = Targetsale ;
            lstAcc[0].VCPL_Current_Month_Total_Planned_Sales__c = LYsale ;
            strSobject = JSON.serialize(lstAcc[0]);
            //}
            system.debug('==========strSobject'+strSobject);
        }
        if(objWrapData.strId != null && objWrapData.objectName == 'Product'){
            system.debug('==========strSobject'+objWrapData.strId);
           
            if(!String.isBlank(relatedData)){
            for(AggregateResult objAggregateResult : [SELECT AVG(VCPL_Vol_in_Ltrs__c) , VCPL_Product__c FROM VCPL_Secondary_Sales_LineItem__c 
                                                      WHERE VCPL_Secondary_Sales__r.VCPL_Dealer_ID__c=:DealerAccount AND  VCPL_Secondary_Sales__r.VCPL_Financial_Year__c =:lastfinancialyear AND VCPL_Product__c =: objWrapData.strId AND VCPL_Secondary_Sales__r.Account__c =: relatedData
                                                                  GROUP BY VCPL_Product__c]){
                               LYsale = Double.ValueOf(objAggregateResult.get('expr0'))/1000;                                       
                         }
			for(AggregateResult objAggregateResult : [SELECT AVG(VCPL_Vol_in_Ltrs__c) , VCPL_Product__c FROM VCPL_Secondary_Sales_LineItem__c 
                                                      WHERE VCPL_Secondary_Sales__r.VCPL_Dealer_ID__c=:DealerAccount AND VCPL_Secondary_Sales__r.VCPL_Financial_Year__c =:firstfinancialyear AND VCPL_Product__c =:objWrapData.strId AND VCPL_Secondary_Sales__r.Account__c =: relatedData
                                                                  GROUP BY VCPL_Product__c]){
                                 Targetsale = Double.ValueOf(objAggregateResult.get('expr0'))/1000;                                          
                         }
            }
            
            
            List<CD_SKU_Mapping__c> lstprod2 = [SELECT Name, Product__r.Name, Product__c , Product__r.Packsize__c,  VCPL_Product_SKU_Id__c, VCPL_Base_Price__c FROM CD_SKU_Mapping__c WHERE Product__c= :objWrapData.strId];
            //List<VCPL_Product_Base_Price_Config__c> lstprod2 = [SELECT Id, VCPL_Base_Price__c, VCPL_Product__r.Packsize__c, VCPL_Product__r.StockKeepingUnit, VCPL_Product__r.SKU_Id__c FROM VCPL_Product_Base_Price_Config__c WHERE VCPL_Product__c= :objWrapData.strId];
            if(lstprod2 != null && lstprod2.size() > 0){
                String newname = String.valueOf(LYsale)+' - '+String.valueOf(Targetsale);
                lstprod2[0].name = newname;
                strSobject = JSON.serialize(lstprod2[0]);
            }
                
            system.debug('==========strSobject'+strSobject);
            
        }
        
        /*if(objWrapData.strId != null && objWrapData.objectName.contains('Contact')){
            List<Contact> lstcon = [SELECT Id, MobilePhone, Phone ,Name FROM Contact WHERE Id= :objWrapData.strId];
            if(lstcon != null && lstcon.size() > 0)
            strSobject = JSON.serialize(lstcon[0]);
            system.debug('==========strSobject'+strSobject);
            }*/
        
        return strSobject;
    }
    
    @AuraEnabled
    public static Decimal getMarginpercentage(Decimal discount){
        Decimal discountper;
        system.debug('discount'+discount);
        for(VCPL_DP_Margin_Config__mdt objDPM : [SELECT Id, VCPL_End_point__c, VCPL_Margin__c, 
                                                 VCPL_Start_point__c FROM VCPL_DP_Margin_Config__mdt]){
                                                     system.debug('objDPM'+objDPM);
                                                     if(objDPM.VCPL_Start_point__c <= discount && objDPM.VCPL_End_point__c >= discount)
                                                         discountper = objDPM.VCPL_Margin__c;
                                                 } 
        
        if(discountper == null )
            discountper = 0;
        system.debug('discountper'+discountper);
        return discountper;
    }
    
    @AuraEnabled
    public static String gettheDiffdataonforExpire(String getdiffId){
        wrapObjectwithdata objWOD = new wrapObjectwithdata(); 
        User objuser = [SELECT id, Profile.Name FROM User WHERE Id=:Userinfo.getUserId()];
        if(!(objuser.Profile.Name == 'System Administrator' || objuser.Profile.Name == 'TBM')){
            objWOD.strId = 'No authority to edit records. <br/> Please contact Adminstrator';
            objWOD.objectName = 'ERROR';
        }
        else {
            List<VCPL_Differential_Pricing__c> lstDP = [SELECT id, VCPL_DP_Expiry_Reason__c, VCPL_DP_Expiry_Date__c ,VCPL_DP_Request_Status__c,
                                                        VCPL_DP_Mannul_Expiry_Date__c FROM VCPL_Differential_Pricing__c WHERE id=:getdiffId];
            if(lstDP != null && lstDP.size() > 0){
                if(lstDP[0].VCPL_DP_Request_Status__c != 'Approved'){
                    objWOD.strId = Label.VCPL_Differential_Pricing_Expire_Message_Manually ;
                    objWOD.objectName = 'ERROR';
                }
                else{
                    objWOD.strId = '';
                    objWOD.objectName = 'SUCCESS';
                }
            }
        }
        
        return JSON.serialize(objWOD);
    }
    
    @AuraEnabled
    public static void gettheDiffdataonforupdate(String getdiffId, String expiryDate, String expiryreason){ 
        VCPL_Differential_Pricing__c objDP = new VCPL_Differential_Pricing__c(Id= getdiffId,
                                                                              VCPL_DP_Mannul_Expiry_Date__c = Date.valueOf(expiryDate),
                                                                              VCPL_DP_Expiry_Reason__c = expiryreason,
                                                                              VCPL_DP_Request_Status__c = 'Expired');
        update objDP;
        
    }
    
    @AuraEnabled
    public static String getloginuserProfile(){
        User objUser = [SELECT id,Name , Manager.Name, Profile.Name, AccountId, Account.Name, Account.Owner.Name, Account.OwnerId
                        , Account.Parent.Name, Account.Parent.OwnerId, Account.ParentId FROM User WHERE ID = :UserInfo.getUserId()];
        
        return objUser.Profile.Name;
        
    }
    
    @AuraEnabled
    public static VCPL_clsforIdCustomerQuote.WrapobjError submitforApproval(String strDPId){
        String strOfMessage;
        Approval.ProcessSubmitRequest objReq = new Approval.ProcessSubmitRequest();
        objReq.setComments('Submitting Differential Pricing for approval by '+ Userinfo.getName());
        objReq.setObjectId(strDPId);
        
        // Submit on behalf of a specific submitter
        objReq.setSubmitterId(UserInfo.getUserId()); 
        
        // Submit the record to specific process and skip the criteria evaluation
        objReq.setSkipEntryCriteria(false);
        VCPL_clsforIdCustomerQuote.WrapobjError objWrap = new VCPL_clsforIdCustomerQuote.WrapobjError();
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(objReq);
        system.debug('result'+result);
        if(result.isSuccess()){
            objWrap.strResType = 'success' ;
            objWrap.strMessage = 'Successfully submited for approval';
        }
        else{
            objWrap.strResType = 'error' ;
            objWrap.strMessage = 'Something went wrong';
        }
        return objWrap;
    }
    
    @AuraEnabled
    public static String ShowToastMessage(String strDPId){
        String strOfMessageToast ='';
        List<VCPL_Differential_Pricing__c> lstDP = [SELECT id, VCPL_Alert_message_for_Branch_Head__c , VCPL_DP_Expiry_Reason__c, VCPL_DP_Expiry_Date__c ,VCPL_DP_Request_Status__c,
                                                    VCPL_DP_Mannul_Expiry_Date__c FROM VCPL_Differential_Pricing__c WHERE id=:strDPId];
        if(lstDP != null && lstDP.size() > 0)
            strOfMessageToast = lstDP[0].VCPL_Alert_message_for_Branch_Head__c;
        return strOfMessageToast;
    }
    
    @AuraEnabled
    public static List<String> getPickliskvalue(String objName, String FieldName){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(FieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        
        return options;
    }
    
    @AuraEnabled
    public static VCPL_clsforIdCustomerQuote.WrapobjError ExpireDPRequest(String DPRecord){
        List<String> options = new List<String>();
        
        List<VCPL_Differential_Pricing__c> lstDiffPrc = [SELECT Id, VCPL_DAM__c, VCPL_DAM__r.Email, Owner.Email, VCPL_DP_Request_Status__c, OwnerId FROM VCPL_Differential_Pricing__c WHERE Id=:DPRecord];
        VCPL_clsforIdCustomerQuote.WrapobjError objWrap = new VCPL_clsforIdCustomerQuote.WrapobjError();
        if(lstDiffPrc[0].VCPL_DP_Request_Status__c == 'Approved' && lstDiffPrc[0].OwnerId == Userinfo.getUserId()) {            
            objWrap.strResType = 'success' ;
            objWrap.strMessage = 'Successfully requested for expiration to DAM.';
            
            
            List<String> lstEmail = new List<String>();
            lstEmail.add(lstDiffPrc[0].VCPL_DAM__r.Email);
            EmailTemplate objET = [SELECT Id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName ='VCPL_Expire_DP_Template_Request_DAM'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(objET.Id);
            mail.setToAddresses(lstEmail);
            mail.setWhatId(lstDiffPrc[0].Id);
            mail.setTargetObjectId(lstDiffPrc[0].VCPL_DAM__c);
            //mail.setSaveAsActivity(true);
            mail.setTreatTargetObjectAsRecipient(false);
            List<Messaging.SingleEmailMessage> lstSEM = new List<Messaging.SingleEmailMessage>();
            lstSEM.add(mail);
            
            // Creates a task for the DP Expiration Assigned to DAM
            Task objtsk = new Task(Ownerid = lstDiffPrc[0].VCPL_DAM__c, Subject='Expire DP Request', status='Open', WhatId= DPRecord ,ActivityDate = System.today()); 
            Messaging.sendEmail(lstSEM,false);
            insert objtsk;
            
        }
        else if(lstDiffPrc[0].VCPL_DP_Request_Status__c == 'Approved' && lstDiffPrc[0].OwnerId != Userinfo.getUserId()){
            objWrap.strResType = 'error' ;
            objWrap.strMessage = 'You don\'t have authority to request for expiration to DAM.'; 
        }
        else if(lstDiffPrc[0].VCPL_DP_Request_Status__c != 'Approved' ){
            objWrap.strResType = 'error' ;
            objWrap.strMessage = 'You can\'t request for expiration to DAM at '+lstDiffPrc[0].VCPL_DP_Request_Status__c+' Stage.'; 
        }
        
        return objWrap;
    }
    
    @AuraEnabled
    public static VCPL_clsforIdCustomerQuote.WrapobjError RenewDPRequest(String DPRecord){
        List<String> options = new List<String>();
        VCPL_clsforIdCustomerQuote.WrapobjError objWrap = new VCPL_clsforIdCustomerQuote.WrapobjError();
        wrapObjectwithName objwrapdata = new wrapObjectwithName();
        
        User objUserClone = [SELECT id,Name , Manager.Name, Profile.Name, AccountId, Account.Name, Account.Owner.Name, Account.OwnerId
                             ,VCPL_Contact_Role__c, Account.Parent.Name, Account.Parent.OwnerId, Account.ParentId FROM User WHERE ID = :UserInfo.getUserId()];
        
        
        VCPL_Differential_Pricing__c objDiffPric = [SELECT Id,VCPL_Basic_Price_L__c, VCPL_Branch__c, VCPL_Branch__r.Name, VCPL_CCPC__c,VCPL_Today_Date__c, VCPL_Validity_of_Discount__c, VCPL_Validity_Start_Date__c, VCPL_Others_Customer_Nature_of_Business__c,
                                                    VCPL_Config_Margin__c, VCPL_Customer_Code__c, VCPL_Customer_Contact_No__c, VCPL_Customer_nature_of_business__c,VCPL_Customer_Name__r.Name ,VCPL_Customer_contact_person_name__c,
                                                    VCPL_DAM__c, VCPL_DAM__r.Name, VCPL_Dealer_Name__c,VCPL_Dealer_Name__r.Name, VCPL_Dealer_Margin_Liter__c, VCPL_Discount_L__c, VCPL_DP_Expiry_Date__c, VCPL_DP_Request_Status__c, VCPL_Exception__c, VCPL_Customer_Name__c,
                                                    VCPL_Expected_volume__c, VCPL_Final_Approval_Date__c, VCPL_HOD__c, VCPL_KL_Potential_per_year__c, VCPL_LY_volume__c, VCPL_NSH__c, VCPL_Offer_Price_L__c, Owner.Name, VCPL_Contact_Person_Email__c,
                                                    VCPL_Pack_Size__c, VCPL_Part_no__c, VCPL_Price_increase_plan_in_next_quarter__c, VCPL_Product__c,VCPL_Product__r.Name, VCPL_Reason_for_Discount__c, VCPL_Remark__c,VCPL_RM_ZM__c, VCPL_Segment_Manager__c
                                                    FROM VCPL_Differential_Pricing__c WHERE Id = :DPRecord];
        User objUser = [SELECT id,Name , Manager.Name, Profile.Name, AccountId, Account.Name, Account.Owner.Name, Account.OwnerId
                        ,VCPL_Contact_Role__c, Account.Parent.Name, Account.Parent.OwnerId, Account.ParentId FROM User WHERE ID = :UserInfo.getUserId()]; 
        if(objDiffPric.OwnerId == Userinfo.getUserId() && objDiffPric.VCPL_DP_Request_Status__c == 'Approved'){
            VCPL_Differential_Pricing__c objDiffPricClone = objDiffPric.clone(false, false, false, false);
            objDiffPricClone.VCPL_Old_Differential_Pricing__c = objDiffPric.Id;
            objDiffPricClone.VCPL_DP_Type__c = 'Renewal';
            objDiffPricClone.VCPL_Validity_Start_Date__c = objDiffPricClone.VCPL_DP_Expiry_Date__c.addDays(1);
            objDiffPricClone.VCPL_Today_Date__c = System.today();
            objDiffPricClone.VCPL_DP_Request_Status__c = 'Draft';
            objDiffPricClone.VCPL_DP_Expiry_Date__c = (objDiffPricClone.VCPL_Validity_Start_Date__c).addMonths(Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month));
            objwrapdata.CustomerName = objDiffPric.VCPL_Customer_Name__r.Name;
            objwrapdata.DAMName = objDiffPric.VCPL_DAM__r.Name;
            objwrapdata.DealerName = objDiffPric.VCPL_Dealer_Name__r.Name;
            objwrapdata.BranchName = objDiffPric.VCPL_Branch__r.Name ;
            objwrapdata.LoginUserProfile = (objUserClone.Profile.Name == 'System Administrator')?objUserClone.Profile.Name:objUserClone.VCPL_Contact_Role__c;
            objDiffPricClone.VCPL_Remark__c = JSON.serialize(objwrapdata);
            objDiffPricClone.VCPL_Validity_of_Discount__c = Integer.valueof(Label.VCPL_Differential_Pricing_Validity_month);
            objWrap.strResType = 'success' ;
            objWrap.strMessage = JSON.serialize(objDiffPricClone);
        }      
        else {  
            if(objDiffPric.OwnerId != Userinfo.getUserId()){
                objWrap.strResType = 'error' ;
                objWrap.strMessage = 'You don\'t have authority to renew this DP';
            }
            else if( objDiffPric.VCPL_DP_Request_Status__c != 'Approved'){
                objWrap.strResType = 'error' ;
                objWrap.strMessage = 'You can\'t renew DP at this stage';
            }
            else{
                objWrap.strResType = 'error' ;
                objWrap.strMessage = 'Something went wrong contact adminstrator';
            }
        }
        
        return objWrap;
    }
}