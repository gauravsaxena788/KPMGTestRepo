@isTest
public class VCPL_CommonUtilityClassTracker {
  public static testmethod void testCommonUtilityClassMethod(){
        
        
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        
        system.runAs(objOtherUser){
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUser.id);
            insert objPortalUser;
            User objUser = [SELECT id,AccountId from User WHERE id=:objPortalUser.Id];
            Set<String> setOfaccId = new Set<String>{objUser.AccountId};
            Account objacc = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
            objacc.ShippingCity = 'RKL';
            insert objacc;
            system.debug('===objacc'+objacc);
            List<Account> lstAcc= new List<Account>();
            lstAcc.add(objacc);
            system.runAs(objOtherUser){
            VCPL_CommonUtilityClass.getPrimaryAccountRecordType();
            VCPL_CommonUtilityClass.shareRecordswithUser(lstAcc,setOfaccId);
             VCPL_CommonUtilityClass.hasCustomerPortalAccess(objPortalUser.ProfileId);
              VCPL_CommonUtilityClass.hasCustomerPortalAccess('Industrial Distributor Partner Community User');
               VCPL_CommonUtilityClass.convertCDOSDate(String.valueof(system.today()));
               VCPL_CommonUtilityClass.getCustomerPortalProfiles();
            }
        }        
        
    }
}