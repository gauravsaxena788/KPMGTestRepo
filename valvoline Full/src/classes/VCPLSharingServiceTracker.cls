@istest
public class VCPLSharingServiceTracker 
{
    Static List < VCPL_ELP_Assignment__c > ELPList;
    Static VCPL_ELP_Assignment__c ELP1;
    @istest
    public static void method1()
    {
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objPortalBHUser,objPortalHODUser;
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;
            Contact conHOD = new Contact(LastName ='testHOD '+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conHOD;
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP;
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VCPL_Cummins_Dealer_Branch').getRecordTypeId();
            Account ac = new Account(name ='Grazitti'+(math.random()*10).intValue()) ;
            ac.Indutry_Segment__c = 'Industrial';
            ac.RecordTypeId = accRecordTypeId; 
            ac.BU_Name__c = 'C&I';
            ac.Account_Type__c = 'Industrial Distributor';
            ac.Market_Segment__c = 'Industrial Distributor';
            ac.Zone__c = 'East';
            if(false)
                ac.ParentId = objaccDealer.id;
            ac.OwnerId = objOtherUser.Id;              
            insert ac;
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            User objOtherUser1 = IDCumminsTestadataClass.createUser('System Administrator',False,'');
            insert objOtherUser1;
            
            system.runAs(objOtherUser1){
                Account objaccDealer1 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
                insert objaccDealer1;             
                
                Account objaccBranch1 = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer1.id);
                insert objaccBranch1; 
                
                VCPL_BLIS_Group__c objBlis = new VCPL_BLIS_Group__c();
                objBlis.Name= 'test BLIS';
                objBlis.VCPL_Dealer__c= objaccDealer1.id;          
                insert objBlis;  
                VCPL_Group_Branch__c Branch1= new VCPL_Group_Branch__c();
                branch1.VCPL_BLIS_Group__c  = objBlis.id;  
                branch1.VCPL_Branch__c = objaccBranch1.id;
                insert Branch1;
                
                
                ELP1 = new VCPL_ELP_Assignment__c();
                ELP1.Name= 'TEST ELP';
                ELP1.VCPL_isActive__c = true;
                ELP1.VCPL_Branch__c = objaccBranch.Id;
                ELP1.VCPL_User__c = objPortalUser.id;
                insert ELP1;
                Lead returnLead = IDCumminsTestadataClass.returnLeadTestdata('VCPL_CD_Customer', 'CD Customer', 'Cummins Dealer Secondary customer', 'Secondary customer through channel');
                returnLead.VCPL_ELP__c = ELP1.Id;
                returnLead.VCPL_Branch__c = objaccBranch.Id;
                returnLead.VCPL_Partner_Account__c = objaccDealer.Id;
                insert returnLead;
                
                Account objaccID = IDCumminsTestadataClass.returnCDIDAccountTestdata('VCPL_ID_Customer','Test Gona', 'Industrial','Secondary Customer through ID','Compressor');
                objaccID.ShippingCity = 'RKL';
                insert objaccID;
                
                Contact conIDAcc = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccID.Id,
                                               MailingStreet = 'New Indra Nagar', MailingCity = 'Gurgaon',MailingState = 'Haryana',MailingCountry = 'India',MailingPostalCode = '122001');
                
                insert conIDAcc;   
                System.runAs(objOtherUser1){
                    // Insert BH User
                    objPortalBHUser = IDCumminsTestadataClass.createUser('CD BH Partner User',True,objOtherUser.Id);
                    objPortalBHUser.Contactid = conBH.Id;
                    objPortalBHUser.VCPL_Contact_Role__c = 'Branch Head';
                    insert objPortalBHUser;
                    objPortalHODUser = IDCumminsTestadataClass.createUser('CD HOD Partner User',True,objOtherUser.Id);
                    objPortalHODUser.Contactid = conHOD.Id;
                    objPortalHODUser.VCPL_Contact_Role__c = 'HOD';
                    insert objPortalHODUser;
                }
                
                Lead returnLead1 = IDCumminsTestadataClass.returnLeadTestdata('VCPL_CD_Customer', 'CD Customer', 'Cummins Dealer Secondary customer', 'Secondary customer through channel');
                returnLead1.VCPL_Branch_Head__c = objPortalBHUser.Id;
                returnLead1.VCPL_Branch__c = objaccBranch.Id;
                returnLead1.VCPL_Partner_Account__c = objaccDealer.Id;
                insert returnLead1;
                Opportunity objOpp= IDCumminsTestadataClass.returnBDOpportunityTestdata('Business_Development','Test Gona Opport',objaccID);
                objOpp.VCPL_Branch__c = objaccBranch.Id;
                insert objOpp;
                List<Opportunity> lstOpp = new List<Opportunity>();
                lstOpp.add(objOpp);
                ELPList = new List < VCPL_ELP_Assignment__c >();
                ELPList.add(ELP1);
                VCPLSharingService obj = new VCPLSharingService();
                obj.shareRecordsAfterELPAssignmentRecordCreation(ELPList);                
                
                ELP1.VCPL_isActive__c = false;
                update ELP1;
                obj.deleteShareRecordsOfLeadShareAndCustomerPlan(ELPList);
                try{
                obj.shareBlanketOpportunities(lstOpp);
                }
                catch(Exception e){
                }
                
            }
        }
        
        
    } 
}