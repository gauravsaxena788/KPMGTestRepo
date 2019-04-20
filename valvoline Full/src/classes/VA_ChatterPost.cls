public class VA_ChatterPost{
    
    @InvocableMethod
    public static void postFeed(List<Id> casId ){
        string caseNumber ;
        String orderNumber;
        String chatterGroupName;
        Id ContactId ;
        Id userId; // new line added by kpmg
        Id labAssistantUserId;
        List<Case> lstCase = new List <case>();
        List<Order> lstorder = new List<Order>();
        Set<Id> setAccountId = new Set<Id>();
        List<Contact> lstContact = new List<Contact>();
        List<User> lstUser = new List<User>();
        Id Caseid;
        Id OrderId;
        set<id> setCreatedById = new Set<Id>();
        system.debug('@@@'+URL.getSalesforceBaseUrl().toString());
        if(casId!=null){
            lstCase = [select id, Owner.Profile.Name,ownerId,Owner.name,caseNumber,accountId, createdbyId, contactId from case where id = : casId];
            lstorder = [select id, ownerId,accountId,OrderNumber,createdbyId from Order where id= :casId ];
            system.debug('@@lstCase'+lstCase);
            if(!lstCase.isEmpty()){
                for(Case objCase: lstCase)
                {
                    system.debug('@@owner'+objCase.OwnerId);
                    system.debug('@@objCase.Owner.name'+objCase.Owner.name);
                    if(string.valueOf(objCase.OwnerId).startsWith('00G')){
                        if(objCase.OwnerId!=null)
                            chatterGroupName= objCase.Owner.name;
                        
                        if(objCase.caseNumber!=null)
                            caseNumber = objCase.caseNumber;
                        
                        if(objCase.id!=null)
                            Caseid = objCase.id;
                        system.debug('@@chatterGroupName'+chatterGroupName);
                        system.debug('@@caseNumber'+caseNumber);
                    }
                    
                    else{
                        if(objCase.contactId!=null)
                            ContactId = objCase.contactId;
                        
                        if(objCase.caseNumber!=null)
                            caseNumber = objCase.caseNumber;
                        
                        if(objCase.id!=null)
                         Caseid = objCase.id;
                         system.debug('@@caseNumber'+caseNumber);
                         system.debug('@@ContactId'+ContactId);
                    }
                }
            }
            system.debug('@@lstorder'+lstorder);
            if(!lstorder.isEmpty()){
                for(Order objOrder : lstorder){
                
                    if(objOrder.createdbyId!=null)
                        setCreatedById.add(objOrder.createdbyId);
                    
                    if(objOrder.OrderNumber!=null)
                        orderNumber = objOrder.OrderNumber ;
                        
                    if(objOrder.id!=null)
                        OrderId= objOrder.id;    
                }
            }
            
            
            if(!setCreatedById.isEmpty()){
              lstUser = [Select id, ProfileId , Profile.name from User where id= :setCreatedById and (Profile.name= 'Customer Community User Login' OR Profile.name = 'Customer Community User Login_Post')];
            }
            
            if(ContactId != null){
                lstUser = [Select id, ProfileId , Profile.name from User where contactId = :ContactId];
            }
            system.debug('@@lstUser'+lstUser);
            system.debug('@@chatterGroupName'+chatterGroupName);
            if(!lstUser.isEmpty() && string.isBlank(chatterGroupName)){
               for(User objuser : lstUser){
                   ContactId = objuser.id;
                   userId = objuser.id; // new line added by kpmg
               }
            }
            
            
            FeedItem post = new FeedItem();
            system.debug('@@'+ContactId);
            if(!string.isBlank(chatterGroupName) && !lstCase.isEmpty()){
                CollaborationGroup chatterGroup = [select Id, Name from CollaborationGroup where Name = :chatterGroupName];
                post.ParentId = chatterGroup.Id;
                post.Title = caseNumber ;
                post.Body = 'Complaint # '+ caseNumber +''+'has been received.' ;
                post.NetworkScope='';   // added by kpmg            
                post.LinkUrl = System.Label.VA_ChatterGroupLinkUrl+Caseid +'/view';
                system.debug('@@@post'+post);
                insert post;
            }
            
            

            else if (ContactId != null){
                system.debug('enter else if ');
                system.debug('@@'+ContactId);
                list<user> userObj = new list<user>();
                                
                /*if(ContactId != null){
                    //userObj = [select id, contact.name, Profile.name from user where contact.name =: conName.name];
                    userObj = [select id, contact.name, Profile.name from user where id =: ContactId];
                }*/
                
                userObj = [select id, contact.name, Profile.name from user where id =: ContactId];
                ///// commented below 3 lines of code by KPMG on 2-Jan, because getting error while creating chatter feed item by lab admin.
                                
                String communityFirst = System.label.Community_Name_First;
                String communitySecond = System.label.Community_Name_Second;
                
                Network lstNetwork;
                
                system.debug('User Obj: '+userObj);
                
                /*if(userObj.size()>0 && userObj[0].Profile.name == 'Customer Community User Login'){
                     lstNetwork = [SELECT Id,name FROM Network where Name =: communitySecond ];
                     post.NetworkScope = lstNetwork.id;
                }
                else if(userObj.size()>0 && userObj[0].Profile.name == 'Customer Community User Login_Post'){
                    lstNetwork = [SELECT Id,name FROM Network where Name =: communityFirst ];
                    post.NetworkScope = lstNetwork.id;
                }*/
                
                if(userObj.size()>0 && (userObj[0].Profile.name == 'Customer Community User Login' || userObj[0].Profile.name == 'Customer Community User Login_Post')){
                     lstNetwork = [SELECT Id,name FROM Network where Name =: communitySecond ];
                     post.NetworkScope = lstNetwork.id;
                }
                else{
                    post.NetworkScope = '';
                }
                post.ParentId = ContactId;
                post.Title = 'Bell Notification';
                
                if(!string.isBlank(orderNumber)){
                    post.LinkUrl = System.Label.VA_chatterPostLinkUrl+OrderId;
                    post.Body = 'Order has been Submitted for '+ orderNumber  ;
                    post.Title =  orderNumber  ;
                    
                }
                else{
                    post.LinkUrl = System.Label.VA_chatterPostLinkUrl+Caseid ;
                    post.Body = 'Notification: Status change for '+ caseNumber ;
                    post.Title =  caseNumber ;
                }
                
                ///// commented below 3 lines of code by KPMG on 2-Jan, because getting error while creating chatter feed item by lab admin.
                /*for(Network objNetwork: lstNetwork ) {
                    post.NetworkScope = objNetwork.id;
                } */ 
                 
                
                system.debug('@@@post'+post);
                if(!test.isRunningTest())
                insert post;
                
            } 

        }
    }
    
}