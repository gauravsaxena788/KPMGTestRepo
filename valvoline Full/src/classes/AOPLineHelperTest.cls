@isTest
public class AOPLineHelperTest {

    static testmethod void test1(){
         
        List<AOP__c> aopList = new List<AOP__c>();
        AOP__c aop = new AOP__c();
        aop.AOP_DSO__c = 52.00;
        aop.Valvoline_Financial_Year__c = '2017';
        aop.AOP_Regional_Vol_in_kL__c = 1.00;
        aop.AOP_National_Vol_in_kL__c = 2.00;
        aop.AOP_Focus_Vol_in_kL__c = 1.00;
        aop.AOP_Regional_GP__c = 1;
        aop.AOP_Forecast_Accuracy__c =10;
        aop.AOP_New_Win_in_kL__c = 3.00;
        aop.AOP_National_GP__c = 1.00;    
        aopList.add(aop);
        //insert aopList;
       
       List<AOP_Line__c> AopLineList = new List<AOP_Line__c>();
       AOP_Line__c aopLine = new AOP_Line__c();
       aopLine.AOP__c = aop.Id;
       aopLine.AOP_Regional_Vol_in_kL__c = aop.AOP_Regional_Vol_in_kL__c;
       aopLine.AOP_New_Win_in_kL__c = aop.AOP_New_Win_in_kL__c;
       aopLine.AOP_DSO__c = aop.AOP_DSO__c;
       aopLine.AOP_Forecast_Accuracy__c = aop.AOP_Forecast_Accuracy__c;
       aopLine.AOP_National_Vol_in_kL__c = aop.AOP_National_Vol_in_kL__c;
       aopLine.AOP_Regional_GP__c = aop.AOP_Regional_GP__c;
       aopLine.AOP_National_GP__c = aop.AOP_National_GP__c;
       aopLine.AOP_Focus_Vol_in_kL__c = aop.AOP_Focus_Vol_in_kL__c;
       aopLine.Month__c = 'JUN';
       AopLineList.add(aopLine);
       //insert AopLineList;
  	
        Test.startTest();
        	try
            {
                insert aopList;
                insert AopLineList;
            }
        catch(Exception e)
        {}
        Test.stopTest();    
    }
}