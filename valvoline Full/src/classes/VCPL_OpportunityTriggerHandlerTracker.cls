@isTest
public class VCPL_OpportunityTriggerHandlerTracker {

    static testMethod void setup(){
        
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        String strFinacialYear,strActualFinYear;
        if(System.today().month() > 9){                    
            strFinacialYear = String.valueof(System.today().Year()+1);
            strActualFinYear = String.valueof(System.today().Year());
        }
        else{            
            strFinacialYear = String.valueof(System.today().Year());
            strActualFinYear = String.valueof(System.today().Year()-1);
        } 
        
        System.runas(objOtherUser){
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            Account objaccBranch = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer Branch',objOtherUser.Id,True,objaccDealer.id);
            insert objaccBranch;

            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('VCPL_ID_Customer').getRecordTypeId();
            Account ac = new Account(name ='Grazitti'+(math.random()*10).intValue()) ;
            ac.Indutry_Segment__c = 'Industrial';
            ac.RecordTypeId = accRecordTypeId;
            ac.BU_Name__c = 'C&I';
            ac.Account_Type__c = 'Secondary Customer through ID';
            ac.Market_Segment__c = 'Industrial Distributor';
            ac.Zone__c = 'East';
            ac.ShippingCity = 'Delhi';
            ac.OwnerId = objOtherUser.Id;              
            insert ac;
            Opportunity objOppSAP = IDCumminsTestadataClass.returnBDOpportunityTestdata('SAP_Order','TestRec',ac);
        	objOppSAP.Monthly_Plan_Month__c ='Jan';
            objOppSAP.Month_sap__c ='Jan';
            objOppSAP.Pricebook2Id = Test.getStandardPricebookId();
            objOppSAP.Calendar_Year__c = strFinacialYear;
            objOppSAP.IsCreatedfromVF__c =false;
            objOppSAP.Financial_Year__c =strFinacialYear ;
            insert objOppSAP;
            update objOppSAP;
		}
      
        
        
    }
}