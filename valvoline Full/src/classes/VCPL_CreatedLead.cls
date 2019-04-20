public class VCPL_CreatedLead {
   
   public List<Lead> lstLead{get;set;}
   public String DealerId{get;set;}
   public String Dealername{get;set;}
   
   public VCPL_CreatedLead(){
      
        DealerId = ApexPages.currentPage().getParameters().get('dealerid');
        String StrLeadRecordtype = 'CD-Customer';
        if(!String.isBlank(DealerId)){
            String queryStr = 'SELECT ';
            for(Schema.FieldSetMember fSLead : SObjectType.Lead.FieldSets.VCPL_Lead_Field_Set.getFields())
            {
                queryStr += String.escapeSingleQuotes(fSLead.getFieldPath()) + ', ';
            }
           queryStr += ' Name FROM Lead WHERE VCPL_Sync_to_CDOS_Date__c = YESTERDAY AND RecordType.Name = :StrLeadRecordtype AND VCPL_Partner_Account__c =:DealerId ' ;
           
            lstLead = Database.Query(queryStr);
            Dealername = (lstLead != null)?lstLead[0].VCPL_Partner_Account__r.Name:'';
       }
       
   } 
}