public with sharing class QuoteApprovalHelper{

     
     @AuraEnabled
        public static Integer getOne(String quoteId) {
         List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where ( Status = 'In Review' AND Opportunity.recordtype.DeveloperName = 'Business_Development')];
        
         Integer step;
         if(!opp_Tmp.isEmpty())
         {
              step = 1;
              system.debug('** one step' +step);
         }
        return step;
    }
    
    @AuraEnabled
        public static Integer getTwo(String quoteId) {
        List<Quote> opp_Tmp = [SELECT id,Name,NSH__r.Name,Total_Vol__c,GP_Ltr__c,Manager_Role__c,NSH__c,Status FROM Quote where ( Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development')];
        
         Integer step;
         if(!opp_Tmp.isEmpty())
         {
         IF( opp_Tmp[0].Manager_Role__c == 'NSH')
          {
         // step = 2;
          }
          else 
          {
           step = 2;
           system.debug('** two step' +step);
            String id = opp_Tmp[0].Id; 
         getOne(id);
          }
          }
        return step;
    }
    
    @AuraEnabled
        public static Integer getThree(String quoteId) {
        List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where (Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development') ];
        
          Integer step;
         if(!opp_Tmp.isEmpty())
         {
         if((opp_Tmp[0].Total_Vol__c > 100) && (opp_Tmp[0].GP_Ltr__c< 5))
         {
         step = 3;
         system.debug('** three step' +step);
          String id = opp_Tmp[0].Id; 
         getTwo(id);
         }
         }
        return step;
    }
    
    @AuraEnabled
        public static Integer getFour(String quoteId) {
        List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where ( Status = 'In Review'and Opportunity.recordtype.DeveloperName = 'Business_Development' )];
        
         Integer step;
         if(!opp_Tmp.isEmpty())
         {
         if((opp_Tmp[0].Total_Vol__c >= 200) && (opp_Tmp[0].GP_Ltr__c < 5))
         {
              step = 4;
              system.debug('** four step' +step);
               String id = opp_Tmp[0].Id; 
         getThree(id);
         }
         }
        return step;
    }
    
    
     @AuraEnabled
        public static String getApprovalone(String quoteId) {
         List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where ( Status = 'In Review' AND Opportunity.recordtype.DeveloperName = 'Business_Development')];
        
         String step;
         if(!opp_Tmp.isEmpty())
         {
              step = 'ZM Approval';
              system.debug('** ZM ' +step);
         }
        return step;
    }
    
    @AuraEnabled
        public static String getApprovaltwo(String quoteId) {
        List<Quote> opp_Tmp = [SELECT id,Name,NSH__r.Name,Total_Vol__c,GP_Ltr__c,Manager_Role__c,NSH__c,Status FROM Quote where ( Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development')];
        
         String step;
         if(!opp_Tmp.isEmpty())
         {
             IF(opp_Tmp[0].Manager_Role__c == 'NSH')
              {
                // step = 2;
              }
              else 
              {
                step = 'ZM-BU Head';
                system.debug('** BU' +step);
                String id = opp_Tmp[0].Id; 
                getApprovalone(id);
              }
          }
        return step;
    }
    
    @AuraEnabled
        public static String getApprovalthree(String quoteId) {
        List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where (Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development') ];
        
          String step;
         if(!opp_Tmp.isEmpty())
         {
         if((opp_Tmp[0].Total_Vol__c > 100) && (opp_Tmp[0].GP_Ltr__c< 5))
         {
         step = 'FC Approval';
         system.debug('** FC' +step);
          String id = opp_Tmp[0].Id; 
         getApprovaltwo(id);
         }
         }
        return step;
    }
    
    @AuraEnabled
        public static String getApprovalfour(String quoteId) {
        List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where ( Status = 'In Review'and Opportunity.recordtype.DeveloperName = 'Business_Development' )];
        
         String step;
         if(!opp_Tmp.isEmpty())
         {
         if((opp_Tmp[0].Total_Vol__c >= 200) && (opp_Tmp[0].GP_Ltr__c < 5))
         {
              step = 'CEO Approval';
              system.debug('** CEO' +step);
               String id = opp_Tmp[0].Id; 
         getApprovalthree(id);
         }
         }
        return step;
    }
    
    
    
   
    @AuraEnabled
        public static String getStepone(String quoteId) {
        
         List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,Reporting_Manager__r.Name,GP_Ltr__c,Status FROM Quote where (Id = :quoteId and Status = 'In Review' AND Opportunity.recordtype.DeveloperName = 'Business_Development')];
        
        system.debug('quoteID' +quoteId);
         String approvalManager;
         if(!opp_Tmp.isEmpty())
         {
        
        // String currentUserId = UserInfo.getUserId();
        // List<User> userProfile = [select u.Profile.Name,ManagerId from User u where u.id = :currentUserId LIMIT 1]; 
        // User ManagerName =   [select u.Profile.Name,Manager.Name from User u where u.id = :currentUserId LIMIT 1];
       
         approvalManager = opp_Tmp[0].Reporting_Manager__r.Name;
         system.debug('reporting manager' +opp_Tmp[0].Reporting_Manager__r.Name);
          system.debug('approval manager' +approvalManager);
          
          
 
        }
        return approvalManager;
    }
    
     @AuraEnabled
        public static String getSteptwo(String quoteId) {
        
         List<Quote> opp_Tmp = [SELECT id,Name,NSH__r.Name,Total_Vol__c,GP_Ltr__c,Manager_Role__c,NSH__c,Status FROM Quote where (Id = :quoteId AND Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development' )];
        
         String approvalManager;
         if(!opp_Tmp.isEmpty())
         {
         IF(opp_Tmp[0].Manager_Role__c == 'NSH')
          {
          
          /* String currentUserId = UserInfo.getUserId();
           User ManagerName =   [select u.Profile.Name,Manager.Name from User u where u.id = :currentUserId LIMIT 1];
          approvalManager = ManagerName.Manager.Name;
          system.debug('approval' +approvalManager);*/
       
           String id = opp_Tmp[0].Id; 
           getStepone(id);
            getOne(id);
           getApprovalone(id);
          
         }
         else
         {
             
            // String currentUserId = UserInfo.getUserId();
          // User ManagerName =   [select u.Profile.Name,Manager.Name from User u where u.id = :currentUserId LIMIT 1];
          approvalManager = opp_Tmp[0].NSH__r.Name;
           system.debug('NSH approval' );
          system.debug('NSH approval' +approvalManager);
             String id = opp_Tmp[0].Id; 
           getStepone(id);
            getTwo(id);
           getApprovaltwo(id);
            
             
         }
        
        }
       
        return approvalManager;
    }
    
     @AuraEnabled
        public static String getStepthree(String quoteId) {
       
         List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where (Id = :quoteId and Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development' ) ];
        
         String approvalManager;
         if(!opp_Tmp.isEmpty())
         {
         if(((opp_Tmp[0].Total_Vol__c > 100) && (opp_Tmp[0].GP_Ltr__c < 5)) )
         {
          
         String currentUserId = UserInfo.getUserId();
        // List<User> userProfile = [select u.Profile.Name,ManagerId from User u where u.id = :currentUserId LIMIT 1]; 
         User ManagerName =   [select id,Name from User u where Name = 'Jugvinder Bhatia' LIMIT 1];
          approvalManager = ManagerName.Name;
           system.debug('CEO approval' );
          system.debug('approval' +approvalManager);
           String id = opp_Tmp[0].Id; 
          
          getSteptwo(id);
           getThree(id);
           getApprovalthree(id);
          
         }
         
        }
        
        return approvalManager;
    }
    
     @AuraEnabled
        public static String getStepfour(String quoteId) {
        
         List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where (Id = :quoteId and Status = 'In Review'and Opportunity.recordtype.DeveloperName = 'Business_Development' )];
        
         String approvalManager;
         if(!opp_Tmp.isEmpty())
         {
         if(((opp_Tmp[0].Total_Vol__c >= 200) && (opp_Tmp[0].GP_Ltr__c < 5)) )
         {
         
         String currentUserId = UserInfo.getUserId();
        // List<User> userProfile = [select u.Profile.Name,ManagerId from User u where u.id = :currentUserId LIMIT 1]; 
         User ManagerName =   [select id,Name from User where Name = 'Sandeep Kalia' LIMIT 1];
          approvalManager = ManagerName.Name;
          system.debug('CEO2 approval' );
          system.debug('approval' +approvalManager);
          String id = opp_Tmp[0].Id; 
         
          getStepthree(id);
           getFour(id);
           getApprovalfour(id);
     
          
          }
 
        }
        return approvalManager;
    }
    
    @AuraEnabled
    public static String getStatus(String quoteId) {
     List<Quote> opp_Tmp = new List<Quote>();
     String sts= '';
     opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where ( Id= :quoteId and Status = 'In Review' and Opportunity.recordtype.DeveloperName = 'Business_Development' ) Limit 1];
     if(opp_Tmp.size()>0)
     {  
     
        sts= opp_Tmp[0].Status;
     }
     else
     {
         sts = 'Draft';
     }
    return sts;
    }
    
    @AuraEnabled
    public static String getStatus1(String quoteId) {
     List<Quote> opp_Tmp = [SELECT id,Name,Total_Vol__c,GP_Ltr__c,Status FROM Quote where ( Id= :quoteId and (Status = 'Rejected' OR Status = 'Draft' OR Status = 'Approved') and Opportunity.recordtype.DeveloperName = 'Business_Development' ) Limit 1];
    
     if(!opp_Tmp.isEmpty() )
     {
     if(opp_Tmp[0]!=null)
         {  
         
         
         }
   
    }
    return opp_Tmp[0].Status;
    }

    
       
 
}