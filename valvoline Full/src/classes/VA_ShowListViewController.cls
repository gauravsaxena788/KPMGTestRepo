public without sharing class VA_ShowListViewController {
@AuraEnabled    
 public static DataTableWrapper getCaseList(Decimal pageNumber, Decimal pageSize,string strRecordId,string strFieldListName,string strObjectApI, string parentId, string filterName, String context) {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
         Integer offset; 
        //Offset for SOQL
        if(pSize != null)
         offset = (pNumber - 1) * pSize;  
         
        set<Id> CreatedByUser = new Set<Id>();

        if(String.isNotBlank(context) && context == 'child'){
           
            CreatedByUser.add(UserInfo.getUserId()); //bcoz as case was created by Parent's Contact
        }else{
         CreatedByUser = getAccountUser(parentId);
        }
        


     	system.debug('ZZ parentId : '+ parentId);
     	system.debug('ZZ CreatedByUser ' + CreatedByUser);
     
        //Total Records
        Integer totalRecords;
        String recordTypeName = '';
         if(filterName.toLowerCase() == 'post'){
           System.debug('ZZZ In VA_ShwLstVwCon-->In post filter');
           totalRecords = [SELECT COUNT() FROM Case where CreatedById in : CreatedByUser AND (recordType.developerName = 'VA_Post_kit' OR recordType.developerName = 'VA_Post')];
           recordTypeName = ' AND (recordType.developerName = \'VA_Post_kit\' OR recordType.developerName = \'VA_Post\')';
         }
         if(filterName.toLowerCase() == 'ccms'){
           System.debug('ZZZ In VA_ShwLstVwCon-->In ccms filter');
           totalRecords = [SELECT COUNT() FROM Case where CreatedById in : CreatedByUser AND recordType.developerName = 'VA_CCMS'];         
           recordTypeName = ' AND recordType.developerName = \'VA_CCMS\' ';  
         }
		 
		 if(filterName.toLowerCase() == 'Invoice') 
		 {
            System.debug('ZZZ In VA_ShwLstVwCon-->In invoice filter');
			totalRecords = [SELECT COUNT() FROM VA_Invoice__c where VA_Order__r.AccountID=:parentId];
		 }
		 
		 if(filterName.toLowerCase() == 'Order')
		 {
			System.debug('ZZZ In VA_ShwLstVwCon-->In order filter');
            totalRecords = [SELECT COUNT() FROM order where AccountID =:parentId];
		 }
     
        system.debug('ZZZ In VA_ShwLstVwCon-->totlrecrds-->'+ totalRecords);
        
        Integer recordEnd;
        if(pSize != null)  
        recordEnd = pSize * pNumber;     
    //Instance of DataTable Wrapper Class
        DataTableWrapper objDT =  new DataTableWrapper();  
        if(pSize != null)  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;  
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        String theQuery = 'SELECT ';  
		
		if(filterName.toLowerCase() == 'Order')
		{
			theQuery += strFieldListName+' FROM '+strObjectApI+' where AccountID =:parentId'+' LIMIT '+pSize+' OFFSET '+offset;
            objDT.orderList = Database.Query(theQuery);
		}
     	else if(filterName.toLowerCase() == 'Invoice')
        {
            theQuery += strFieldListName+' FROM '+strObjectApI+' where VA_Order__r.AccountID =:parentId'+' LIMIT '+pSize+' OFFSET '+offset;
            objDT.invoiceList = Database.Query(theQuery);
        }
		else
		{
			theQuery += strFieldListName +' FROM '+strObjectApI+ ' where CreatedById in : CreatedByUser '+ recordTypeName +' LIMIT '+pSize+' OFFSET '+offset;   
            objDT.caseList = Database.Query(theQuery); 
		}

        System.debug('ZZZ In VA_ShwLstVwCon-->theQuery-->'+theQuery);    
        //objDT.caseList = Database.Query(theQuery); 
        system.debug('ZZZ In VA_ShwLstVwCon-->wrapper--> '+ objDT);       
     
     	system.debug('ZZZ In VA_ShwLstVwCon-->caseList--> '+ objDT.caseList);
        return objDT;  
    }
    //Wrapper Class For DataTable    
    public class DataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}  
        @AuraEnabled
        public List<Case> caseList {get;set;}
        @AuraEnabled
        public List<Order> orderList {get;set;}
        @AuraEnabled
        public List<VA_Invoice__c> invoiceList {get;set;}
    }
    
    public static set<Id> getAccountUser(string accountId){
        set<Id> objSetId = new set<Id>();
        for(User objUser : [SELECT Id from User where User.Contact.AccountId = : accountId]){
            objSetId.add(objUser.Id);
        }
        System.debug('ZZZ In VA_ShwLstVwCon-->getAccUsr_M-->objSetId--> '+ objSetId);
      
        return objSetId;
    }

        
}