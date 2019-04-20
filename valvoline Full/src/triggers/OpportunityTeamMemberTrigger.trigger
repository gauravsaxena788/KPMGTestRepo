trigger OpportunityTeamMemberTrigger on OpportunityTeamMember (before insert, before update) {
    /*List<ID> userIDList= new List<ID>();
    MAP<ID,String> userIDProfileMap= new MAP<ID, String>();
    for(OpportunityTeamMember ot :trigger.new){
            if(ot.userID!=null)
                userIDList.add(ot.userID);
    }
    if(userIDList.size()>0){
        List<user> uList=[SELECT Id, name, profile.name from user  where id IN :userIDList];
        for(user u : uList){
            userIDProfileMap.put(u.id,u.profile.name);
        }
    }
    
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String MyProflieName = PROFILE[0].Name;
    
    for(OpportunityTeamMember ot :trigger.new){
    
        if(MyProflieName!='System Administrator')
        {
            if((ot.TeamMemberRole=='NKAM' && userIDProfileMap.get(ot.userID)!='NKAM') ||
                (ot.TeamMemberRole=='RKAM' && userIDProfileMap.get(ot.userID)!='TBM') ||
                (ot.TeamMemberRole=='Segment Manager' && userIDProfileMap.get(ot.userID)!='SM') ||
              (ot.TeamMemberRole=='Product Manager' && userIDProfileMap.get(ot.userID)!='PM' ))
                ot.addError('Team role doesn’t match with user’s profile. Please select the user and the role correctly');
        }
    }*/
}