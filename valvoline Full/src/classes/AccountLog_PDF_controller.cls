public class AccountLog_PDF_controller {

    
    public String selectedtype{get;set;}
    public string seltype{get;set;}
    public Static String currentUserName{get;set;}
    public Static String currentUserId{get;set;}
    public String accountId{get;set;}
   // public Boolean alertrender{get;set;}
   // public Boolean alertrender2{get;set;}
    public String accountname{get;set;}
    public String accountcity{get;set;}
    public String accountcode{get;set;}
    //public List<task> Tasklist{get;set;}
    //public List<Event> eventList { get; set; }
    //public List<Note> NoteList{get;set;}
    public List<Opportunity> opplist{get;set;}
   // public list<WrapperOpportunity> wrapoptyList{get;set;}
    
    public AccountLog_PDF_controller()
    {

        selectedtype=ApexPages.currentPage().getParameters().get('seltype');
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        getAccountList();
      //  tasklist = new List<task>();
      //  eventList = new List<Event>();
                   
if(selectedtype == 'THIS_WEEK'){
            seltype='Week';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype,Description, CreatedBy.name, who.Type from Tasks where CreatedDate = THIS_WEEK ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = THIS_WEEK) from Opportunity where recordtype.developername='Business_Development'];
            
          
        }
        else if(selectedtype == 'THIS_MONTH') {
             seltype='This Month';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype, Description, CreatedBy.name,who.Type from Tasks where CreatedDate = THIS_MONTH ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = THIS_MONTH) from Opportunity where recordtype.developername='Business_Development'];
            
           
        }
        else if(selectedtype == 'LAST_N_MONTHS_12') {
            seltype='Last one year';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype, Description, CreatedBy.name,who.Type from Tasks where CreatedDate = LAST_N_MONTHS:12 ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = LAST_N_MONTHS:12) from Opportunity where recordtype.developername='Business_Development'];

        }
        else if(selectedtype == 'LAST_N_MONTHS_24'){ 
            seltype='Last two year';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype, Description, CreatedBy.name,who.Type from Tasks where CreatedDate = LAST_N_MONTHS:24 ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = LAST_N_MONTHS:24) from Opportunity where recordtype.developername='Business_Development'];

        }
        
        
    }
    
   
    
    public void getAccountlogDetails(){
        
        currentUserId = UserInfo.getUserId();
        system.debug('cuid: '+currentUserId);
        
        User u = [select Name from User u where u.id = :currentUserId];
        currentUserName = u.Name;
        
    }
    
    public void getAccountList()
    {
        //PageReference pg = new PageReference('/Accountlog?recordId='+accountId);
        //pg.setRedirect(true);
        getAccountlogDetails();
        
        /////// get account name /////////////
        List<Account> accList = [Select Id, Name, Ship_to_code__c, ShippingCity from Account Where Id=:accountId LIMIT 1];
        if(accList.size()>0)
        {
            accountname = accList[0].Name;
            accountcity = accList[0].ShippingCity;
            accountcode = accList[0].Ship_to_code__c;
        }       
        //return pg;
    }
    
    

}