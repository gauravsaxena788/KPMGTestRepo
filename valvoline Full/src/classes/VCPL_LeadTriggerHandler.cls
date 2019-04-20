public Class VCPL_LeadTriggerHandler{
    
    // Before insert
    public static void onBeforeInsert(List<Lead> lstLead ){
        
        Set<String> setofELP = new Set<String>();
        List<VCPL_ELP_Assignment__c> lstELPA;
        Map<String,VCPL_ELP_Assignment__c> mapstringwithELPAssgn = new Map<String,VCPL_ELP_Assignment__c>();
        
        List<User> lstUser = [SELECT Id, AccountId, Account.ParentId, Profile.Name, VCPL_Contact_Role__c FROM User WHERE Id= : Userinfo.getUserId()];
         for(Lead objLead : lstLead ){
             if(!String.isBlank(objLead.VCPL_ELP__c))
                 setofELP.add(objLead.VCPL_ELP__c);
             if(setofELP.size() > 0)
                 mapstringwithELPAssgn = getmapofELPAssgnWithId(setofELP);
             
         }
        if(lstUser[0].VCPL_Contact_Role__c == 'ELP'){
            if(!String.isBlank(lstUser[0].Account.ParentId))
                    lstELPA= [SELECT Id, VCPL_Branch__c, VCPL_User__c FROM VCPL_ELP_Assignment__c
                             WHERE (VCPL_User__c = :lstUser[0].Id AND VCPL_Branch__c = :lstUser[0].Account.ParentId)];
            else 
                 lstELPA= [SELECT Id, VCPL_Branch__c, VCPL_User__c FROM VCPL_ELP_Assignment__c
                             WHERE VCPL_User__c = :lstUser[0].Id];
            
        }
        system.debug('lstELPA'+lstELPA);
        Set<String> setofRecordType = new Set<String>();
        for(String objstr : Label.VCPL_Lead_RecordType.split(';')){
          setofRecordType.add(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(objstr).getRecordTypeId());
        }
        for(Lead objLead : lstLead){
          
          if(lstUser != null && !String.isBlank(lstUser[0].Profile.Name) && lstUser[0].AccountId != null){
                   //if(Label.Customer_Portal_Profile == lstUser[0].Profile.Name) 
                        objLead.VCPL_Partner_Account__c = objLead.VCPL_Partner_Account__c != null ? objLead.VCPL_Partner_Account__c : lstUser[0].AccountId;
                    if(lstUser[0].Profile.Name == 'CD BH Partner User' && lstUser[0].VCPL_Contact_Role__c == 'Branch Head' 
                            && String.isBlank(objLead.VCPL_ELP__c) && String.isBlank(objLead.VCPL_Branch_Head__c)){
                        objLead.VCPL_Branch_Head__c = lstUser[0].Id;
                        objLead.VCPL_Branch__c = lstUser[0].AccountId;
                        objLead.OwnerId = lstUser[0].Id;
                        if(!String.isBlank(lstUser[0].Account.ParentId))
                            objLead.VCPL_Partner_Account__c = lstUser[0].Account.ParentId;                            
                    }
                    else if(lstUser[0].Profile.Name == 'CD ELP Partner User' && lstUser[0].VCPL_Contact_Role__c == 'ELP' && String.isBlank(objLead.VCPL_ELP__c)
                             && String.isBlank(objLead.VCPL_Branch_Head__c) && lstELPA != null && lstELPA.size() > 0 && lstELPA.size() == 1){
                        objLead.VCPL_ELP__c = lstELPA[0].Id;
                        objLead.VCPL_Branch__c = lstELPA[0].VCPL_Branch__c ;
                        objLead.OwnerId = lstELPA[0].VCPL_User__c;
                       if(!String.isBlank(lstUser[0].AccountId))
                            objLead.VCPL_Partner_Account__c = lstUser[0].AccountId;          
                    }
           }
                    
          
          if(!String.isBlank(objLead.RecordTypeId) && !setofRecordType.isEmpty() && setofRecordType.contains(objLead.RecordTypeId)){
              if(!String.isBlank(objLead.VCPL_Assigned_To__c))
                    objLead.OwnerId = objLead.VCPL_Assigned_To__c;
              if(String.isBlank(objLead.VCPL_Branch_Head__c) && !String.isBlank(objLead.VCPL_ELP__c) && mapstringwithELPAssgn != null 
                  && mapstringwithELPAssgn.get(objLead.VCPL_ELP__c) != null && mapstringwithELPAssgn.get(objLead.VCPL_ELP__c).VCPL_User__c != null)
                  objLead.OwnerId = mapstringwithELPAssgn.get(objLead.VCPL_ELP__c).VCPL_User__c;
              if(!String.isBlank(objLead.VCPL_Branch_Head__c) && String.isBlank(objLead.VCPL_ELP__c))
                  objLead.OwnerId = objLead.VCPL_Branch_Head__c;
              if(!String.isBlank(objLead.Email) || !String.isBlank(objLead.MobilePhone))
                 updateEmailandmobile(objLead);
              if(objLead.Status =='Rejected')
                 objLead.VCPL_Is_Rejected__c = 'Rejected'; 
              else
                  objLead.VCPL_Is_Rejected__c = 'In Process';
              returnrecordtypemethod(objLead);
          }
          
        }
    }
    
    // Before Update
    public static void onBeforeUpdate(List<Lead> lstLead , Map<Id,Lead> mapOfOldLead){
        
        Set<String> setofELP = new Set<String>();
        List<VCPL_ELP_Assignment__c> lstELPA;
        Map<String,VCPL_ELP_Assignment__c> mapstringwithELPAssgn = new Map<String,VCPL_ELP_Assignment__c>();
        
        List<User> lstUser = [SELECT Id, AccountId, Account.ParentId, Profile.Name, VCPL_Contact_Role__c FROM User WHERE Id= : Userinfo.getUserId()];
         for(Lead objLead : lstLead ){
             if(!String.isBlank(objLead.VCPL_ELP__c))
                 setofELP.add(objLead.VCPL_ELP__c);
             if(setofELP.size() > 0)
                 mapstringwithELPAssgn = getmapofELPAssgnWithId(setofELP);
             
         }
        Set<String> setofRecordType = new Set<String>();
        for(String objstr : Label.VCPL_Lead_RecordType.split(';')){
          setofRecordType.add(Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(objstr).getRecordTypeId());
        } 
       for(Lead objLead : lstLead){
            if(!String.isBlank(objLead.VCPL_Branch_Head__c) && String.isBlank(objLead.VCPL_ELP__c)  && objLead.VCPL_Branch_Head__c != mapOfOldLead.get(objLead.id).VCPL_Branch_Head__c )
                  objLead.OwnerId = objLead.VCPL_Branch_Head__c;
            if(String.isBlank(objLead.VCPL_Branch_Head__c) && !String.isBlank(objLead.VCPL_ELP__c) && mapstringwithELPAssgn != null && mapstringwithELPAssgn.get(objLead.VCPL_ELP__c) != null && 
                  mapstringwithELPAssgn.get(objLead.VCPL_ELP__c).VCPL_User__c != null && objLead.OwnerId != mapstringwithELPAssgn.get(objLead.VCPL_ELP__c).VCPL_User__c)
                  objLead.OwnerId = mapstringwithELPAssgn.get(objLead.VCPL_ELP__c).VCPL_User__c;
            if(!setofRecordType.isEmpty() && setofRecordType.contains(objLead.RecordTypeId)){
              if(!String.isBlank(objLead.RecordTypeId) && objLead.RecordTypeId != mapOfOldLead.get(objLead.id).RecordTypeId)
                  returnrecordtypemethod(objLead);
               if(objLead.Status =='Rejected' && mapOfOldLead.get(objLead.id).Status != objLead.Status)
                 objLead.VCPL_Is_Rejected__c = 'Rejected';
              if(objLead.Status !='Rejected' && mapOfOldLead.get(objLead.id).Status != objLead.Status && mapOfOldLead.get(objLead.id).Status == 'Rejected')
                 objLead.VCPL_Is_Rejected__c = 'In Process';
          if(!String.isBlank(objLead.VCPL_Assigned_To__c) && objLead.VCPL_Assigned_To__c != mapOfOldLead.get(objLead.id).VCPL_Assigned_To__c )
                    objLead.OwnerId = objLead.VCPL_Assigned_To__c;
            if((!String.isBlank(objLead.Email) && objLead.Email != mapOfOldLead.get(objLead.id).Email )
                || (!String.isBlank(objLead.MobilePhone) && objLead.MobilePhone!= mapOfOldLead.get(objLead.id).MobilePhone)){
                    updateEmailandmobile(objLead);
           
          } 
        }
        
        }
    }

    // This is used to copy mobile and email
    static void updateEmailandmobile(Lead objLead){
        if(!String.isBlank(objLead.Email))
           objLead.VCPL_Lead_Email__c = objLead.Email;
        if(!String.isBlank(objLead.MobilePhone)) {
            objLead.VCPL_Lead_Mobile__c = objLead.MobilePhone;
        }
    }
    
    // This is used to assign Recordtype to a picklist value     
    public Static Map<String,VCPL_ELP_Assignment__c> getmapofELPAssgnWithId(Set<String> setofELPId){
       Map<String,VCPL_ELP_Assignment__c> mapstringwithELPAssgn = new Map<String,VCPL_ELP_Assignment__c>(); 
       for(VCPL_ELP_Assignment__c objELPAssgn : [SELECT Id, VCPL_Branch__c, VCPL_User__c FROM VCPL_ELP_Assignment__c
                             WHERE Id IN: setofELPId]){
              mapstringwithELPAssgn.put(objELPAssgn.Id,objELPAssgn); 
       }
       return mapstringwithELPAssgn ;
    }
    // This is used to assign Recordtype to a picklist value 
    Static void returnrecordtypemethod(Lead objLead){
      
      objLead.VCPL_Lead_Record_Type__c = Schema.getGlobalDescribe().get('Lead').getDescribe().getRecordTypeInfosById().get(objLead.RecordTypeId).getDeveloperName();
    }
    
    // After Update
    public static void onAfterUpdate(List<Lead> lstLead , Map<Id,Lead> mapOfOldLead){
        List<Lead> lstLeadUsedToShareRecords = new List<Lead>();
        for(Lead leadRecord : lstLead){
            if(leadRecord.OwnerId != mapOfOldLead.get(leadRecord.Id).OwnerId){
                lstLeadUsedToShareRecords.add(leadRecord);
            }
        }
        if(lstLeadUsedToShareRecords.size() > 0)
            new VCPLSharingService().shareLeadRecords(lstLeadUsedToShareRecords);
       
    }
      
      public static void onAfterInsert(List < Lead > lstLead) {
        new VCPLSharingService().shareLeadRecords(lstLead);
    }
    
}