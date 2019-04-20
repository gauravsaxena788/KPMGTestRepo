@isTest
public class VCPL_CreateMonthlyOpportunityTracker {
    public static testmethod void testCreateMonthlyOpportunityMethod(){
        Test.startTest();
        User objOtherUsernew = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUsernew.Street ='Sector-58';
        objOtherUsernew.City ='Noida';
        objOtherUsernew.State ='Uttar Pradesh';
        objOtherUsernew.Country = 'India';
        objOtherUsernew.PostalCode = '201301';
        insert objOtherUsernew;
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        Account objaccID ;
        System.runAs(objOtherUser){
            objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
            objaccID.ShippingCity = 'RKL';
            insert objaccID;
            VCPL_CreateMonthlyOpportunityBatch batchUpdatenoti = new VCPL_CreateMonthlyOpportunityBatch();
            DataBase.executeBatch(batchUpdatenoti); 
        }
        Test.stopTest();
    }
    /*public static testmethod void testCreateMonthlyOpportunity1Method(){
        Test.startTest();
        User objOtherUsernew = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUsernew.Street ='Sector-58';
        objOtherUsernew.City ='Noida';
        objOtherUsernew.State ='Uttar Pradesh';
        objOtherUsernew.Country = 'India';
        objOtherUsernew.PostalCode = '201301';
        insert objOtherUsernew;
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        Account objaccID ;
        System.runAs(objOtherUser){
            objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
            objaccID.ShippingCity = 'RKL';
            insert objaccID;
            Opportunity objOpp= IDCumminsTestadataClass.returnBDOpportunityTestdata('Business_Development','Test Gona Opport',objaccID);
            insert objOpp;
            VCPL_MonthlyOpportunityBatch batchUpdatenoti = new VCPL_MonthlyOpportunityBatch();
            DataBase.executeBatch(batchUpdatenoti); 
        }
        Test.stopTest();
    }  */     
}