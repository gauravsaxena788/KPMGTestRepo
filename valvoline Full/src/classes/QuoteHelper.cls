public class QuoteHelper {
    
    @AuraEnabled
    public static Id getAccountId(String oppId)
    {
        Opportunity opp = [SELECT Id, AccountId  FROM Opportunity WHERE Id=:oppId limit 1];
        return opp.AccountId;
    }
    
    @AuraEnabled
    public static String findAllowed(String oppId){
        String flag='Not Allowed';
        String flag2 = '';
        Opportunity opp = [SELECT Id, AccountId, Account.BU_Name__c  FROM Opportunity WHERE Id=:oppId limit 1];
        
        ////////// check for SM opportunity team is available or not
        for(OpportunityTeamMember otm: [select id, TeamMemberRole from OpportunityTeamMember where OpportunityId=:oppId])
        {
            if(otm.TeamMemberRole.EqualsIgnoreCase('Segment Manager'))
            {
                flag2 = 'SM';
                break;
            }    
        }
        
        Account acc = [SELECT Id, Quote_allowed__c,Accound_Aprroved__c FROM Account WHERE Id=:opp.AccountId limit 1];
        List<Quote> qlist =new List<Quote>();
        qlist=[Select id,name,status from quote where opportunityID=:oppID and status='In Review'];
        if(qlist.size()>0)
        {
            flag='In Review';        
        }
        else if(flag2 == '' && String.valueOf(opp.Account.BU_Name__c)=='C&I')
        {
            flag='Not SM';
        } 
        else if(acc.Quote_allowed__c=='Yes' && acc.Accound_Aprroved__c==true){ 
            flag='Allow';
        }       
        
        return flag;
    }
    
    @AuraEnabled
    public static String quoteCount(String oppId){
        String newQuoteNumber='';
        Opportunity opp = [SELECT Id, AccountId, Opportunity_Number__c FROM Opportunity WHERE Id=:oppId limit 1];
        Account acc = [SELECT Id, Quote_allowed__c, BU_Name__c FROM Account WHERE Id=:opp.AccountId limit 1];
        List<Quote> qt = [SELECT Id, Quote_Number__c  FROM Quote WHERE OpportunityId = :oppId ORDER BY CreatedDate desc NULLS LAST];
        
        newQuoteNumber=acc.BU_Name__c+'/';
        
        Date dateToday = Date.today();
        //String sToday = RIGHT(TEXT(YEAR( DATEVALUE(CreatedDate))),2) + "/" +LPAD(TEXT(MONTH( DATEVALUE(CreatedDate)   )),2,"0") + "/" +LPAD(TEXT(DAY( DATEVALUE(CreatedDate))),2,"0")
        String year= String.valueof(dateToday.year());
        system.debug('year '+year);
        
        system.debug('year.charAt(2) substring) '+year.substring(2));
        String mon='';
        String dy='';
        Integer d=dateToday.day(); 
        Integer mn=dateToday.month();        
        if(mn<10){
            //07
            mon = '0'+String.valueOf(mn);
        }else{ mon = String.valueOf(mn); }
         if(d<10){
            //07
            dy = '0'+String.valueOf(d);
        }else{ dy = String.valueOf(d); }
        
        
        String sToday = year.substring(2) + mon + dy;
        
        newQuoteNumber = newQuoteNumber + sToday + '/';
        newQuoteNumber = newQuoteNumber + opp.Opportunity_Number__c + '/';
        Integer num=0;
        String finalNum='';
         system.debug('qt.size() '+qt.size());
        if(qt.size()>0){
            String qtn=qt[0].Quote_Number__c;
            
            if(qtn!=null){
                String[] oldQuoteNumber =qtn.split('/');
                system.debug('oldQuoteNumber[] '+oldQuoteNumber);
                
                if(oldQuoteNumber.size()>3){
                    num=Integer.valueOf(oldQuoteNumber[3]);
                    num += 1;
                    system.debug('in IF [] ');
                    
                    if(num<10){
                        //056
                        finalNum = '00'+String.valueOf(num);
                    }else if(num<100 && num > 9){
                        finalNum = '0'+String.valueOf(num);
                    }else{
                        finalNum=String.valueOf(num);
                    }
                }}else{
                    system.debug('in else qtn[] ');
                    finalNum='001';
                }
        }else{
            system.debug('in else qt[] ');
            finalNum='001';
        }
        newQuoteNumber = newQuoteNumber + finalNum;
        
        system.debug('newQuoteNumber '+newQuoteNumber);
        
        return newQuoteNumber;
    }
    
    public static void approvalDetail(List<Quote> qtLst){
        MAP<ID,user> ownerMap= new MAP<ID,user>();
        MAP<String,ID> NSHuserMAP= new MAP<String,ID>();
        MAP<ID,ID> oppSMUserMap = new MAP<ID,ID>();
        List<opportunityTeamMember> omList=new List<opportunityTeamMember>();
        List<ID> oppidList= new List<ID>();
        for(quote q : qtLst){
            if(q.opportunityId!=null && q.RecordType.Name=='General')
                oppidList.add(q.opportunityId);
        }
        if(oppidList.size()>0){
            omlist=[select id,opportunityId,userId from opportunityTeamMember where opportunityId IN :oppidList and TeamMemberRole='Segment Manager'];
            if(omlist.size()>0){
                for(opportunityTeamMember os:omlist){
                    oppSMUserMap.put(os.opportunityId,os.userId);
                }
                system.debug('**oppSMUserMap**'+oppSMUserMap);
            }    
        }
        List<User> OwnerList=[select id,name,managerid, manager.name,manager.userrole.name from user where ID =:UserInfo.getUserId()];
        system.debug('**OwnerList**'+OwnerList);
        for(user u :OwnerList){
            ownerMap.put(u.id,u);
        }
        system.debug('**ownerMap**'+ownerMap);
        List<User> NSHusers  = [select Id, Name, UserRole.Name  from User where UserRole.Name='NSH-C&I' 
                                                                        OR UserRole.Name='NSH-FLEET' 
                                                                        OR UserRole.Name='NSH-OEM' ];
        if(NSHusers.size()>0){                                                                
            for(User user : NSHusers){
                NSHuserMAP.put(user.UserRole.Name,user.Id);   
            } 
        }                 
        
        ////// get list of Primary Account Record types ///////
        //List<string> primaryRecordTypeIds = VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
         
        for(quote q : qtLst)
        {          
            q.Manager_Role__c=ownerMap.get(UserInfo.getUserId()).manager.userrole.name;
            q.Reporting_Manager__c=ownerMap.get(UserInfo.getUserId()).managerid;
            
            //if(primaryRecordTypeIds.contains(q.Account.RecordTypeId))
            if(q.RecordType.Name=='General')
            {
                if(oppSMUserMap.get(q.opportunityId)==null && q.Quote_Number__c.contains('C&I'))
                    q.addError('Please add Segment Manager in Opportunity Team.');
                else
                    q.SM_Name__c=oppSMUserMap.get(q.opportunityId);
            }
              
            if(q.Quote_Number__c.contains('FLEET'))
                q.NSH__c =NSHuserMAP.get('NSH-FLEET');
            else if(q.Quote_Number__c.contains('OEM'))
                q.NSH__c =NSHuserMAP.get('NSH-OEM'); 
            else
                q.NSH__c =NSHuserMAP.get('NSH-C&I');          
        }
    }
}