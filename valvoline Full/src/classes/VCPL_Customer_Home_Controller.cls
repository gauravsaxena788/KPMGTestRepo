public class VCPL_Customer_Home_Controller {
  
 @AuraEnabled    
 public static list<case> getServiceRequest(){
     
     String userName = UserInfo.getUserId();
     List<User> lstUser = [Select u.ContactId,u.name from User u where u.Id = :userName];
     Id conID = lstUser[0].ContactId;
   
        list<case> lstCase = [select CaseNumber,CreatedDate,ContactId  from case  where ContactId =:conID AND recordtype.name = 'Register a Complaint' ORDER BY LastModifiedDate DESC limit 1]; 
       
            return lstCase;
        }	   
      

}