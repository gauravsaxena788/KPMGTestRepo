@isTest
public class VCPL_LeadTriggerHandlerTracker {
    
    public static testmethod void testLeadMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.VCPL_Dealer_CDOS_Email__c ='Test@testadata.com';
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
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
                Lead returnLeadELP = IDCumminsTestadataClass.returnLeadTestdata('VCPL_CD_Customer', 'CD Customer', 'Cummins Dealer Secondary customer', 'Secondary customer through channel');
                returnLeadELP.Email = 'Test11@gmail.com';
                returnLeadELP.MobilePhone = '9090909090';
                insert returnLeadELP;
                returnLeadELP.Status ='Rejected';
                returnLeadELP.Reason_for_Rejection__c = 'Exception reason';
                returnLeadELP.VCPL_Sync_to_CDOS_Date__c = System.today().addDays(-1);
                update returnLeadELP;
                
                ApexPages.currentPage().getParameters().put('dealerid', objaccDealer.Id);
                VCPL_CreatedLead objCreatedlead = new VCPL_CreatedLead();
                Lead returnLead = IDCumminsTestadataClass.returnLeadTestdata('VCPL_CD_Customer', 'CD Customer', 'Cummins Dealer Secondary customer', 'Secondary customer through channel');
                returnLead.VCPL_ELP__c = objELPAssign.Id;
                returnLead.VCPL_Branch__c = objaccBranch.Id;
                returnLead.VCPL_Partner_Account__c = objaccDealer.Id;
                insert returnLead;
            }
            System.runas(objPortalBHUser){    
                Lead returnLeadBH = IDCumminsTestadataClass.returnLeadTestdata('VCPL_CD_Customer', 'CD Customer', 'Cummins Dealer Secondary customer', 'Secondary customer through channel');
                insert returnLeadBH;
                returnLeadBH.OwnerId = objPortalUser.Id;
                update returnLeadBH;
                //returnLeadBH.Status='Qualified';
               // returnLeadBH.VCPL_Reason_for_Qualification__c ='test good';
                returnLeadBH.VCPL_Sync_to_CDOS_Date__c = System.today().addDays(-1);
                returnLeadBH.VCPL_Sync_to_CDOS__c ='True';
                update returnLeadBH;
            }
            System.runas(objOtherUser){
            VCPL_LeadSyncToCDOSBatch objBatch = new VCPL_LeadSyncToCDOSBatch();
            DataBase.executeBatch(objBatch);  
            }
            test.stopTest();
        } 
    }
}