@isTest
public class VCPLCmpServiceDealerScoreTracker {
	public static testmethod void testServiceDealerScoreMethod(){
       String strFinacialYear,strActualFinYear;
        if(System.today().month() > 9){                    
            strFinacialYear = String.valueof(System.today().Year()+1); 
            strActualFinYear = String.valueof(System.today().Year());
        }
        else{                   
            strFinacialYear = String.valueof(System.today().Year());
            strActualFinYear = String.valueof(System.today().Year()-1);
        } 
        User objOtherUser = IDCumminsTestadataClass.createUser('System Administrator',False,'');
        insert objOtherUser;
        User objOtherSMUser = IDCumminsTestadataClass.createUser('SM',False,'');
        insert objOtherSMUser;
        System.runAs(objOtherUser){            
            Account objaccDealer = IDCumminsTestadataClass.returnBranchDealerAccountTestdata('Cummins Dealer',objOtherUser.Id,False,'');
            insert objaccDealer;
            VCPL_Score_Card__c objDSC = new VCPL_Score_Card__c();
            objDSC.VCPL_Account__c = objaccDealer.Id;
            objDSC.VCPL_As_of__c = 'September';
            objDSC.VCPL_Financial_Year__c = strActualFinYear;
            objDSC.VCPL_Score_Card_Status__c = 'Approved';
            objDSC.VCPL_Segment_Manager__c = objOtherSMUser.Id; 
            insert objDSC; 
            VCPL_Score_Card_Parameters__c objSCP = new VCPL_Score_Card_Parameters__c();
            objSCP.VCPL_Active__c = true;
            objSCP.VCPL_Calculation_Method_Name__c ='test';
            objSCP.VCPL_Description__c ='Test';
            objSCP.VCPL_Max_Score__c = 6;
            objSCP.VCPL_Score_Scale__c = 'Teetrghgcgavjbhj';
            objSCP.VCPL_Value_Type__c = 'Manual';
            insert objSCP;
            VCPL_Score_Card_LineItem__c objSCLI = new VCPL_Score_Card_LineItem__c();
            objSCLI.VCPL_Comments__c = 'Testcomments';
            objSCLI.VCPL_Dealer_Score__c = 9;
            objSCLI.VCPL_Score_Card__c= objDSC.Id;
            objSCLI.VCPL_Score_Card_Parameter__c = objSCP.Id;
            objSCLI.VCPL_Value__c = 6;
            insert objSCLI;
            List<VCPL_Score_Card_LineItem__c> lstSCP = new List<VCPL_Score_Card_LineItem__c>();
            lstSCP.add(objSCLI);
            VCPLCmpServiceDealerScoreCard.getDealerScoreCardData('');
            VCPLCmpServiceDealerScoreCard.getScoreCardMasterRecordData('Test',JSON.serialize(objDSC));
            VCPLCmpServiceDealerScoreCard.upsertScoreCardLineItems(JSON.serialize(lstSCP),objDSC.Id);
        }
    }
}