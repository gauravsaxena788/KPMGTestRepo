public class Accountlogcontroller {
    
    public String selectedtype{get;set;}
    public String seltype{get;set;}
    public Static String currentUserName{get;set;}
    public Static String currentUserId{get;set;}
    public String accountId{get;set;}
    public Boolean alertrender{get;set;}
    public Boolean alertrender2{get;set;}
    public String accountname{get;set;}
    public String accountcity{get;set;}
    public String accountcode{get;set;}
    public List<task> Tasklist{get;set;}
    public List<Event> eventList { get; set; }
    //public List<Note> NoteList{get;set;}
    public List<Opportunity> opplist{get;set;}
    //  public list<WrapperOpportunity> wrapoptyList{get;set;}
    
    public Accountlogcontroller()
    {
        accountId = ApexPages.currentPage().getParameters().get('recordId');
        getAccountList();
        tasklist = new List<task>();
        eventList = new List<Event>();
        selectedtype='THIS_WEEK';
        seltype='week';
        
        AllTaskList();
        
        
    }
    
    public void getAccountlogDetails(){
        
        currentUserId = UserInfo.getUserId();
        system.debug('cuid: '+currentUserId);
        
        User u = [select Name from User u where u.id = :currentUserId];
        currentUserName = u.Name;
        
    }
    
    public void getAccountList()
    {
        
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
    
    public List<SelectOption> getdynamiclist() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('THIS_WEEK','This Week'));
        options.add(new SelectOption('THIS_MONTH','This Month'));
        options.add(new SelectOption('LAST_N_MONTHS_12','Last 1 Year'));
        options.add(new SelectOption('LAST_N_MONTHS_24','Last 2 Years'));
        return options;
    }
    
    public void AllTaskList()
    {
        currentUserId = UserInfo.getUserId(); 
        getAccountlogDetails();
        
        if(selectedtype == 'THIS_WEEK'){
            //cdate='CreatedDate = THIS_WEEK';
            // opplist.clear();
            seltype='week';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype,Description, CreatedBy.name, who.Type from Tasks where CreatedDate = THIS_WEEK ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = THIS_WEEK) from Opportunity where recordtype.developername='Business_Development'];
            
            
        }
        else if(selectedtype == 'THIS_MONTH') {
            //cdate='CreatedDate = THIS_MONTH';
            //opplist.clear();
            seltype='month';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype, Description, CreatedBy.name,who.Type from Tasks where CreatedDate = THIS_MONTH ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = THIS_MONTH) from Opportunity where recordtype.developername='Business_Development'];
            
        }
        else if(selectedtype == 'LAST_N_MONTHS_12') {
            seltype='1year';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype, Description, CreatedBy.name,who.Type from Tasks where CreatedDate = LAST_N_MONTHS:12 ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = LAST_N_MONTHS:12) from Opportunity where recordtype.developername='Business_Development'];
            
        }
        else if(selectedtype == 'LAST_N_MONTHS_24'){ 
            seltype='2year';
            opplist=[Select Id, OwnerId, Name, StageName, (Select Id,whatid,what.name,subject,createddate, OwnerId,TaskSubtype, Description, CreatedBy.name,who.Type from Tasks where CreatedDate = LAST_N_MONTHS:24 ),(Select Id,whatid,what.name,subject,createddate, OwnerId,EventSubtype,Description, CreatedBy.name, who.Type from Events where CreatedDate = LAST_N_MONTHS:24) from Opportunity where recordtype.developername='Business_Development'];
            
        }
        
        
        //return null;
    }
    
    
}