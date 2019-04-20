@isTest(seeAllData=false)
public class VCPL_CustomerPotentialCaptureTracker {
    public static testmethod void testCustomerpotentialMethod(){
        User objOtherUsernew = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        objOtherUsernew.Street ='Sector-58';
        objOtherUsernew.City ='Noida';
        objOtherUsernew.State ='Uttar Pradesh';
        objOtherUsernew.Country = 'India';
        objOtherUsernew.PostalCode = '201301';
        insert objOtherUsernew;
        System.runAs(objOtherUsernew){
            User objPortalUser = IDCumminsTestadataClass.createUser('Industrial Distributor Partner Community User',True,objOtherUsernew.id);
            insert objPortalUser;
            System.runas(objPortalUser){   
                User objUser = [SELECT id,AccountId FROM User WHERE Id=:Userinfo.getUserId()];
                Account objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.ShippingCity = 'RKL';
                if(objUser != null && !string.isBlank(objUser.AccountId))
                    objaccID.ParentId =objUser.AccountId;
                insert objaccID;
                List<account> lstAcc =[SELECT Parent.Name FROM Account WHERE Id=:objaccID.Id];
                system.debug('lstAcc'+lstAcc[0].Parent.Name);
                Contact conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                               MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
                insert conIDAcc; 
                String finacialYear;
                 if(System.today().month() > 9){                    
                    finacialYear = String.valueof(System.today().Year()+1);                    
                }
                else                   
                    finacialYear = String.valueof(System.today().Year());  
                
                VCPL_CustomerPotentialCaptureController.getDetails(); 
                List<VCPL_CustomerPotentialCaptureController.detailsWrapper> lstWrap = VCPL_CustomerPotentialCaptureController.getData(finacialYear,'');
                VCPL_CustomerPotentialCaptureController.saveDate(JSON.serialize(lstWrap));
                Account_Potential__c objAP = VCPL_CustomerPotentialCaptureController.createPotential(objUser.AccountId,'Gas Engine Oils',98);
                VCPL_CustomerSalesCaptureController.getSearchResults('Test',JSON.serialize(lstWrap));
                List<Account_Potential__c> lstAP = new List<Account_Potential__c>();
                String strValueofPG ='Gas Engine Oils ; Industrial Oils ; Gear Oils ; Antifreeze ; Greases ; HDDEO ; Others';
                for(String objStr:strValueofPG.split(';')){
                    Account_Potential__c objAPnew =  IDCumminsTestadataClass.createPotentialTest(objaccID.Id,objStr,99);
                	objAPnew.Valvoline_Financial_Year__c = finacialYear;
                    lstAP.add(objAPnew);
                }                    
                insert lstAP;
                lstWrap = VCPL_CustomerPotentialCaptureController.getData(finacialYear,objUser.AccountId);
                VCPL_CustomerPotentialCaptureController.saveDate(JSON.serialize(lstWrap));
                VCPL_CustomerPotentialCaptureController.getSearchResults('Test',JSON.serialize(lstWrap));
            }
        }
    }
}