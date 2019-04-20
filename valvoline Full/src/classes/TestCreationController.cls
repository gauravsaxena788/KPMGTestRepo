Public class TestCreationController{
    @AuraEnabled
    public static String getLoggedInUserId() {
        Id userId = UserInfo.getUserId();
        return userId;
        //return [SELECT IsActive FROM User WHERE Id = :userId].IsActive;
    }

}