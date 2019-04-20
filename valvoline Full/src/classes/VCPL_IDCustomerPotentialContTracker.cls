@isTest(seeAllData=false)
public class VCPL_IDCustomerPotentialContTracker {
	public static testmethod void testAVDQVDIOControllerMethod(){
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objSMUser = IDCumminsTestadataClass.createUser('SM',False,'');
        insert objSMUser;
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
             Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            objaccDealer.Is_Parent__c = 'Y';
            objaccDealer.Indutry_Segment__c = 'Cummins Dealer';
            insert objaccDealer;
            AccountTeamMember objAccTeam = new AccountTeamMember(AccountId = objaccDealer.Id,UserId = objSMUser.Id,TeamMemberRole = 'Segment Manager');
            insert objAccTeam;
            Product2 objProd = IDCumminsTestadataClass.returnTestProduct();
            objProd.PH6_Qlikview__c = 'Car Care';
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
            OpportunityLineItem objOppLI = IDCumminsTestadataClass.createOpporLinItem(objOppnew,objPBE,4);            
            insert objOppLI;
            OpportunityLineItem objOppLI2 = IDCumminsTestadataClass.createOpporLinItem(objOppnew,objPBE,4);            
            insert objOppLI2;
            OpportunityLineItem objOppLI3 = IDCumminsTestadataClass.createOpporLinItem(objOppnewold,objPBE,4);            
            insert objOppLI3;
            OpportunityLineItem objOppLI4 = IDCumminsTestadataClass.createOpporLinItem(objOppnewold,objPBE,4);            
            insert objOppLI4;
              
              Account_Potential__c objAccPot = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'Industrial Oils');
			  insert objAccPot;
			  Account_Potential__c objAccPot1 = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'Gear Oils');
			  insert objAccPot1;
			  Account_Potential__c objAccPot2 = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'Greases');
			  insert objAccPot2;
			  Account_Potential__c objAccPot3 = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'HDDEO');
			  insert objAccPot3;
			  Account_Potential__c objAccPot4 = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'Others');
			  insert objAccPot4;
              Account_Potential__c objAccPot5 = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'Gas Engine Oils');
			  insert objAccPot5; 
			  Account_Potential__c objAccPot6 = IDCumminsTestadataClass.returnObjTestData(strFinacialYear,objaccBranch,'Antifreeze');
			  insert objAccPot6;
            VCPL_IDCustomerPotentialController.getDetailsWrapper objWrapDetail = VCPL_IDCustomerPotentialController.getDetails();
            VCPL_IDCustomerPotentialController.detailsWrapper objWrap = VCPL_IDCustomerPotentialController.getData(strFinacialYear,objaccBranch.id);
            VCPL_IDCustomerPotentialController.savePotential(JSON.serialize(objWrap));
           objWrap = VCPL_IDCustomerPotentialController.getData(strFinacialYear,objaccDealer.id);
    }
}
}