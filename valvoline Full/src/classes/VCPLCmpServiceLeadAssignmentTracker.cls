@isTest
public class VCPLCmpServiceLeadAssignmentTracker {
@isTest 
    public static void method1()
    {
        String leadRecordId= '123456';
        VCPLCmpServiceLeadAssignment.getLoggedInUserRelatedDataService('123456');
       
        Lead testLead = IDCumminsTestadataClass.returnLeadTestdata('VCPL_General','Test123','Cummins Dealer','Industrial Distributor');	 
		String testJson = JSON.serialize(testLead);
        VCPLCmpServiceLeadAssignment.saveRecordData(testJson);
        
        //VCPLCmpServiceLeadAssignment.saveRecordData('1234');
    }
}