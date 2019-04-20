@isTest(seeAllData=false)
public class VCPL_AVDQVDCOControllerTracker {
	public static testmethod void testAVDQVDCOControllerMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objSMUser = IDCumminsTestadataClass.createUser('SM',False,'');
        insert objSMUser;
        VCPL_ELP_Assignment__c objELPAssign;
        
        System.runas(objOtherUser){
            String strFinacialYear,strActualFinYear;
            if(System.today().month() > 9){                    
                    strFinacialYear = String.valueof(System.today().Year()+1);
                	strActualFinYear = String.valueof(System.today().Year());
                }
            else{            
                    strFinacialYear = String.valueof(System.today().Year());
                	strActualFinYear = String.valueof(System.today().Year()-1);
            }        
            
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
            
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.Is_Parent__c = 'Y';
            objaccDealer.Indutry_Segment__c = 'Cummins Dealer';
            insert objaccDealer;
            AccountTeamMember objAccTeam = new AccountTeamMember(AccountId = objaccDealer.Id,UserId = objSMUser.Id,TeamMemberRole = 'Segment Manager');
            insert objAccTeam;
            Product2 objProd = IDCumminsTestadataClass.returnTestProduct();
            objProd.PH6_Qlikview__c = 'Cummins Oil';
            insert objProd;
            PricebookEntry objPBE = IDCumminsTestadataClass.returncreatePriceBookEntry(objProd.Id);
            insert objPBE; 
            System.debug('returncreatePriceBookEntry'+objPBE.Pricebook2Id);
            Opportunity objOpp = IDCumminsTestadataClass.returnBDOpportunityTestdata('Business_Development', 'Opport new',objaccDealer);
            objOpp.Pricebook2Id = Test.getStandardPricebookId();
            insert objOpp;
            System.debug('returncreatePriceBookEntry'+objOpp.Pricebook2Id);
            System.debug('returncreatePriceBookEntry'+[SELECT ID,Pricebook2Id FROM Opportunity WHERE Id=:objOpp.Id].Pricebook2Id);
            
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            objaccBranch.Is_Parent__c = 'N';
            objaccBranch.Indutry_Segment__c = 'Cummins Dealer';
            insert objaccBranch;
            
            Opportunity objOppSAP = IDCumminsTestadataClass.returnBDOpportunityTestdata('SAP_Order', 'Opport new',objaccBranch);
            objOppSAP.Monthly_Plan_Month__c ='Jan';
            objOppSAP.Month_sap__c ='Jan';
            objOppSAP.Pricebook2Id = Test.getStandardPricebookId();
            objOppSAP.Calendar_Year__c = strFinacialYear;
            objOppSAP.IsCreatedfromVF__c =false;
            objOppSAP.Financial_Year__c =strFinacialYear ;
            insert objOppSAP;
            Opportunity objOppnew = IDCumminsTestadataClass.returnBDOpportunityTestdata('Monthly_Plan', 'Opport new',objaccBranch);
            objOppnew.Monthly_Plan_Month__c ='Jan';
            objOppnew.Opportunity_Id__c = objOppSAP.Id;
            objOppnew.IsCreatedfromVF__c =false;
            objOppnew.Financial_Year__c =strFinacialYear ;
            insert objOppnew;
            
            Opportunity objOppSAPold = IDCumminsTestadataClass.returnBDOpportunityTestdata('SAP_Order', 'Opport new',objaccBranch);
            objOppSAPold.Monthly_Plan_Month__c ='Jan';
            objOppSAPold.Month_sap__c ='Jan';
            objOppSAPold.Pricebook2Id = Test.getStandardPricebookId();
            objOppSAPold.Calendar_Year__c = String.valueof(Integer.valueof(strFinacialYear)-1);
            objOppSAPold.IsCreatedfromVF__c =false;
            objOppSAPold.Financial_Year__c = String.valueof(Integer.valueof(strFinacialYear)-1) ;
            insert objOppSAPold;
            Opportunity objOppnewold = IDCumminsTestadataClass.returnBDOpportunityTestdata('Monthly_Plan', 'Opport new',objaccBranch);
            objOppnewold.Monthly_Plan_Month__c ='Jan';
            objOppnewold.Opportunity_Id__c = objOppSAPold.Id;
            objOppnewold.IsCreatedfromVF__c =false;
            objOppnewold.Financial_Year__c = String.valueof(Integer.valueof(strFinacialYear)-1) ;
            insert objOppnewold;
            System.debug('returncreatePriceBookEntry'+objOpp.Pricebook2Id);
            System.debug(objOppnew+'returncreatePriceBookEntry'+[SELECT ID,Pricebook2Id,Monthly_Plan_Month__c,Financial_Year__c FROM Opportunity WHERE Id=:objOpp.Id]);
            String PriceboookId = [SELECT ID,Pricebook2Id FROM Opportunity WHERE Id=:objOppnew.Id].Pricebook2Id;
            PricebookEntry objPBEnew = new PricebookEntry(
            Pricebook2Id = PriceboookId , Product2Id = objProd.Id,
            UnitPrice = 10000, IsActive = true);
            //insert objPBEnew;
            
            OpportunityLineItem objOppLI = IDCumminsTestadataClass.createOpporLinItem(objOppnew,objPBE,4);            
            insert objOppLI;
            OpportunityLineItem objOppLI2 = IDCumminsTestadataClass.createOpporLinItem(objOppnew,objPBE,4);            
            insert objOppLI2;
            OpportunityLineItem objOppLI3 = IDCumminsTestadataClass.createOpporLinItem(objOppnewold,objPBE,4);            
            insert objOppLI3;
            OpportunityLineItem objOppLI4 = IDCumminsTestadataClass.createOpporLinItem(objOppnewold,objPBE,4);            
            insert objOppLI4;
            Contact conHOD = new Contact(LastName ='testConHOD'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conHOD; 
            Contact conELP = new Contact(LastName ='testCon'+(math.random()*10).intValue(), AccountId = objaccDealer.Id);
            insert conELP; 
            Contact conBH = new Contact(LastName ='testBH'+(math.random()*10).intValue(), AccountId = objaccBranch.Id);
            insert conBH;
            
            // Insert ELP User 
            User objPortalUser = IDCumminsTestadataClass.createUser('CD ELP Partner User',True,objOtherUser.Id);
            objPortalUser.Contactid = conELP.Id;
            objPortalUser.VCPL_Contact_Role__c = 'ELP';
            insert objPortalUser;
            
            User objPortalHODUser = IDCumminsTestadataClass.createUser('CD HOD Partner User',True,objOtherUser.Id);
            objPortalHODUser.Contactid = conHOD.Id;
            objPortalHODUser.VCPL_Contact_Role__c = 'HOD';
            insert objPortalHODUser;
             VCPL_BLISController.getDealers();
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
                VCPL_BLIS_Group__c objblisGroup;
                VCPL_Group_Branch__c objBlisbranch;
                VCPL_AVD_QVD__c objAVDQVD;
                VCPL_AVD_QVD__c objAVDQVD1;
                VCPL_Customer_Plan__c objCusPlan;
                VCPL_Secondary_Sales_LineItem__c objSecSaleLineItem;
                VCPL_Secondary_Sales__c objSecSale;
                System.runas(objOtherUser){
                    
                VCPL_AVDQVDCOController.getDealers();
                    
                                        
                    objAVDQVD = IDCumminsTestadataClass.createAVDQVD('Cummins',strFinacialYear);
                    insert objAVDQVD;
                    objAVDQVD1 = IDCumminsTestadataClass.createAVDQVD('Cummins',String.valueof(Integer.valueof(strFinacialYear)-1));
                    insert objAVDQVD1; 
                    objblisGroup = IDCumminsTestadataClass.createBlisGroupRecords(objOtherUser,objaccDealer,'Approved');
                    insert objblisGroup;
                    objBlisbranch = IDCumminsTestadataClass.createBlisGroupRecords(objblisGroup,objaccBranch);
                    insert objBlisbranch; 
                    
                }
                VCPL_AVDQVDCOController.getDealers();
                VCPL_AVDQVDCOController.getpicklistvalues();
                VCPL_AVDQVDCOController.DataWrapper objDataWrap =  VCPL_AVDQVDCOController.getData(objaccDealer.Id,strFinacialYear);
                objDataWrap =  VCPL_AVDQVDCOController.getData(objaccBranch.Id,strFinacialYear); 
                }
            System.runas(objOtherUser){		
            		objOppSAP.Month_sap__c ='May';
                    objOppSAP.Monthly_Plan_Month__c ='May';
                    update objOppSAP;
                    objOppnew.Monthly_Plan_Month__c ='May';
                    update objOppnew; 
                    objOppSAPold.Month_sap__c ='May';
                    objOppSAPold.Monthly_Plan_Month__c ='May';
                    update objOppSAPold;
                    objOppnewold.Monthly_Plan_Month__c ='May';
                    update objOppnewold;
                    VCPL_AVDQVDCOController.DataWrapper objDataWrap =  VCPL_AVDQVDCOController.getData(objaccDealer.Id,strFinacialYear);
                	objDataWrap =  VCPL_AVDQVDCOController.getData(objaccBranch.Id,strFinacialYear); 
                	objOppSAP.Month_sap__c ='Aug';
                    objOppSAP.Monthly_Plan_Month__c ='Aug';
                    update objOppSAP;
                    objOppnew.Monthly_Plan_Month__c ='Aug';
                    update objOppnew;
                    objOppSAPold.Month_sap__c ='Aug';
                    objOppSAPold.Monthly_Plan_Month__c ='Aug';
                    update objOppSAPold;
                    objOppnewold.Monthly_Plan_Month__c ='Aug';
                    update objOppnewold;
                    objDataWrap =  VCPL_AVDQVDCOController.getData(objaccDealer.Id,strFinacialYear);
                	objDataWrap =  VCPL_AVDQVDCOController.getData(objaccBranch.Id,strFinacialYear); 
                    objOppSAP.Month_sap__c ='Oct';
                    objOppSAP.Monthly_Plan_Month__c ='Oct';
                    objOppSAPold.Month_sap__c ='Oct';
                    objOppSAPold.Monthly_Plan_Month__c ='Oct';
                    update objOppSAPold;
                    objOppnewold.Monthly_Plan_Month__c ='Oct';
                    update objOppnewold;
                    update objOppSAP;
                    objOppnew.Monthly_Plan_Month__c ='Oct';
                    update objOppnew;
                    objDataWrap =  VCPL_AVDQVDCOController.getData(objaccDealer.Id,strFinacialYear);
                	objDataWrap =  VCPL_AVDQVDCOController.getData(objaccBranch.Id,strFinacialYear); 
            }
            System.runas(objSMUser){
                VCPL_AVDQVDCOController.getDealers();
            }
            System.runas(objPortalHODUser){
                VCPL_AVDQVDCOController.getDealers();
            }
        }
    }
}