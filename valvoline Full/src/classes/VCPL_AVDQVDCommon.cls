public without sharing class VCPL_AVDQVDCommon 
{
	@AuraEnabled
    public static String getFinancialYear(Date dtDate,Integer FiscalYearStartMonth)
    {
    	if(dtDate==null)
            return 'null';
        
        integer currentmonth =dtDate.Month();
        integer currntDtYear= dtDate.Year();
    	
    	if(currentmonth < FiscalYearStartMonth)
        {
            return string.valueof(currntDtYear);
        }
        else
        {
        	return string.valueof(currntDtYear+1);
        }
        return 'null';    
    }
    @AuraEnabled
    public static string getCurrentFinancialYear()
    {
        Integer fiscalYearStartMonth = 10;
        
        string strfinyear=getFinancialYear(system.today(),fiscalYearStartMonth);
        
        return strfinyear;
    }
    @AuraEnabled
    public  static Map<Integer,string>  getMonthQuarter()
    {
        Map<Integer,string> mapNameMonthNum = new Map<Integer,string>
        {1=>'Q2', 2=>'Q2', 3=>'Q2', 4=>'Q3', 5=>'Q3',6=>'Q3', 7=>'Q4', 8=>'Q4', 9=>'Q4',
            10=>'Q1',11=>'Q1', 12=>'Q1'};
                
                return mapNameMonthNum;
    }    
}