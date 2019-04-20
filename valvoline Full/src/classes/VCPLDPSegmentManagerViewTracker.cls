@isTest
public class VCPLDPSegmentManagerViewTracker {
    public static testmethod void testDPMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objSMUser = IDCumminsTestadataClass.createUser('SM',False,'');
        insert objSMUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            AccountTeamMember objAccTeam = new AccountTeamMember(AccountId = objaccDealer.Id,UserId = objSMUser.Id,TeamMemberRole = 'Segment Manager');
            insert objAccTeam;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            AccountTeamMember objAccTeam1 = new AccountTeamMember(AccountId = objaccBranch.Id,UserId = objSMUser.Id,TeamMemberRole = 'Segment Manager');
            insert objAccTeam1;
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
            // insert objPortalUser;
            
            // Insert BH User
            User objPortalBHUser = IDCumminsTestadataClass.createUser('CD BH Partner User',True,objOtherUser.Id);
            objPortalBHUser.Contactid = conBH.Id;
            objPortalBHUser.VCPL_Contact_Role__c = 'Branch Head';
            //insert objPortalBHUser;
            test.startTest();
            System.runas(objSMUser){ 
                Map<Id,Account> mapofIdWithAcc = new Map<Id,Account>();
                mapofIdWithAcc.put(objaccDealer.Id,objaccDealer);
                new VCPLDPSegmentManagerViewCalculation('October',String.valueOf(System.today().Year()),mapofIdWithAcc);
                new VCPLDPSegmentManagerViewCalculation('October',String.valueOf(System.today().Year()),mapofIdWithAcc).setMapsForSegmentManagerView();
                new VCPLDPSegmentManagerViewCalculation('October',String.valueOf(System.today().Year()),mapofIdWithAcc).setDealerMapForSegmentManger();
            }
            test.stopTest();
        }
    }
}