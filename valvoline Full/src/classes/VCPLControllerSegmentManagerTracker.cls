@isTest
public class VCPLControllerSegmentManagerTracker {
	public static testmethod void ControllerSegmentManagerMethod(){
        	string month= 'august';
   			string year=String.valueOf(System.today().Year());
        VCPLControllerSegmentManagerView objCSM = new VCPLControllerSegmentManagerView(month,year);
        objCSM.getSegmentManagerViewData();
    }
}