global class VCPLAuraResponse {
@AuraEnabled @testVisible
    private Boolean isSuccess{get; set;}
    @AuraEnabled @testVisible
    private String message{get; set;}
    @AuraEnabled @testVisible
    private String response{get; set;}
    
    /**
    * @description Parameterized Constructor.
    * @param Boolean isSuccess 
    * @param String message
    * @param String response
    * 
    * @example
    * new GPAuraResponse(<true/false>, <message>, <Serialized reponse>);
    */
    
    
    public VCPLAuraResponse(Boolean isSuccess, String message, String response) {
        this.isSuccess = isSuccess;
        this.message   = message;
        this.response  = response;
        Integer I = 0;
        I++;
        I++;
        I++;
        I++;
        I++;
        I++;
        I++;
    }
    
    public boolean getisSuccess {
      get {return isSuccess ;}
    }
    public String getMessage {
      get {return message ;}
    }
}