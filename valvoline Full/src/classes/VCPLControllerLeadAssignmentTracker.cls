@isTest
public class VCPLControllerLeadAssignmentTracker {
    public static testmethod void LeadAssignMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            
            Account objCDAccount = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','P S CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccount.Service_By__c ='Dealer';
            objCDAccount.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO7O';
            objCDAccount.Is_Parent__c ='Y';
            objCDAccount.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccount.Status__c = 'Activated';
            insert objCDAccount;
            
            Account objCDAccountnew = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_CD_Customer','GONA CONSTRUCTION','Cummins Dealer Secondary customer','Secondary Customer through Channel','Cummins Rental');
            objCDAccountnew.Service_By__c ='Dealer';
            objCDAccountnew.VCPL_CDOS_AccountId__c ='1-9EW6-301-2E1WO71';
            objCDAccountnew.Is_Parent__c ='Y';
            objCDAccountnew.VCPL_CDOS_Account_Creation_Date__c = System.today().addYears(-1); 
            objCDAccountnew.Status__c = 'Activated';
            insert objCDAccountnew;
            
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            // Insert BH User
            User objPortalBHUser = IDCumminsTestadataClass.createUser('CD BH Partner User',True,objOtherUser.Id);
            objPortalBHUser.Contactid = conBH.Id;
            objPortalBHUser.VCPL_Contact_Role__c = 'Branch Head';
            insert objPortalBHUser;
            system.debug('====objPortalBHUser'+objPortalBHUser);
            Lead returnLeadELP ;
            System.runas(objOtherUser){
                objELPAssign = new VCPL_ELP_Assignment__c(); 
                objELPAssign.Name = 'TestELPASSIGN';
                objELPAssign.VCPL_Branch__c =objaccBranch.Id;
                objELPAssign.VCPL_User__c = objPortalUser.Id;
                objELPAssign.VCPL_isActive__c = true;
                insert objELPAssign;
            }
            test.startTest();
            System.runas(objPortalUser){
            	returnLeadELP = IDCumminsTestadataClass.returnLeadTestdata('VCPL_CD_Customer', 'CD Customer', 'Cummins Dealer Secondary customer', 'Secondary customer through channel');
                returnLeadELP.Email = 'Test11@gmail.com';
                returnLeadELP.MobilePhone = '9090909090';
                insert returnLeadELP;
                User objNewUserELP = [select Id, Profile.Name, VCPL_Contact_Role__c, AccountId from User where Id =: objPortalBHUser.id];
                VCPLControllerLeadAssignment objAss = new VCPLControllerLeadAssignment(returnLeadELP.Id);
                VCPLControllerLeadAssignment objAss2 = new VCPLControllerLeadAssignment(returnLeadELP);
                VCPLControllerLeadAssignment objAss1 = new VCPLControllerLeadAssignment(returnLeadELP.Id);
                new VCPLControllerLeadAssignment(returnLeadELP.Id).setCurrentUser();
                new VCPLControllerLeadAssignment(returnLeadELP.Id).getLoggedInUserRelatedData();
                new VCPLControllerLeadAssignment(returnLeadELP).upsertLeadRecord();                
                //new VCPLControllerLeadAssignment(returnLeadELP).setBranchListForBH();
            }
            system.runAs(objPortalBHUser){
                User objNewUser = [select Id, Profile.Name, VCPL_Contact_Role__c, AccountId from User where Id =: objPortalBHUser.id];
                system.debug('===objNewUser=='+objNewUser);
                VCPLControllerLeadAssignment objLA = new VCPLControllerLeadAssignment(returnLeadELP);
               // objLA.setCurrentUser();
               	objLA.currentLogedInUserDetails = objNewUser;
                objLA.setBranchListForBH();
                objLA.setBranchListForHOD();
            }
            test.stopTest();
        }
    }
}