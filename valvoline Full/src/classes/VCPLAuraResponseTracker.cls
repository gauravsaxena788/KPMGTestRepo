@istest
public class VCPLAuraResponseTracker 
{
@istest public static void Method1()
{
    Boolean isSuccess=true;
    String message='abcd';
    String response = 'erty';
    new VCPLAuraResponse(isSuccess,message,response);
    //new VCPLAuraResponse(isSuccess,message,response).isSuccess; 
}
}