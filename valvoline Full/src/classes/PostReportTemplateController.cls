public class PostReportTemplateController{
    public Id CaseId{get;set;}         
    public Case objCase{get;set;}
    public List<VA_TestResult__c> lstTestResults{get;set;}
    public Boolean flag{get; set;}
    
    
    public PostReportTemplateController(ApexPages.StandardController std){
        CaseId = ApexPages.currentPage().getParameters().get('id');   
        objCase= new Case();
        lstTestResults = [SELECT Case__r.VA_POST_Number__c,Case__r.Status,Case__r.VA_Request_Purpose__c  ,Case__r.VA_Product__r.name,Case__r.VA_Additive_Elements_Testing_Required__c,Case__r.Contact.Name  ,Case__r.VA_Project__r.Name, Case__r.VA_Veh_Reg_No__c ,Case__r.Va_Engine_Serial_No__c , Case__r.VA_Report_Release_Date__c,Case__r.Product_Category__r.Name,Case__r.VA_Engine_Make_Model__c ,Case__r.VA_Equipment_ID__c, Case__r.VA_Total_Engine_Hours__c,Case__r.VA_Date_of_Sample_Drawn__c,Case__r.VA_Hours_Km_seen_by_Oil__c,Id,Name,RecordTypeId,VA_30_vol__c,VA_Aldehydes__c,VA_Alkalinity_as_NH3__c,VA_Aluminium_Al__c,VA_Appearance_Texture__c,VA_Appearance__c,VA_Biuret__c,VA_Boiling_Point_DegC__c,VA_Boron_B__c,VA_Calcium_Ca__c,VA_Chromium_Cr__c,VA_Colour__c,VA_Copper_Cu__c,VA_Density_20C__c,VA_Droping_Point_C__c,VA_Elemental_analysis__c,VA_Flash_PointC__c,VA_Foaming_vv__c,VA_Free_Alkalinity_as_LiOH_Wt__c,VA_Free_Organic_Acidity_oleic_acid_Wt__c,VA_Fuel_Wt__c,VA_Glycol_Wt__c,VA_Identity__c,VA_Insoluble_matter__c,VA_Iron_Fe__c,VA_Kinematic_Viscosity_40C_cSt__c,VA_Kinematic_Viscosity_100C_cSt__c,VA_Lead_Pb__c,VA_Lithium_Li__c,VA_Magnesium_Mg__c,VA_Molybdenum_Mo__c,VA_Nickel_Ni__c,VA_Nitration_Abscm__c,VA_Oxidation_Abscm__c,VA_Phosphate__c,VA_Phosphorous_P__c,VA_pH_as_is__c,VA_pH_of_30__c,VA_pH__c,VA_Potassium_K__c,VA_Refractive_index_20C__c,VA_Refractive_Index__c,VA_Reserved_Alkalinity__c,VA_Silicon_Si__c,VA_Sodium_Na__c,VA_Soot_wt__c,VA_Sulfur_S__c,VA_TAN_mgKOHg__c,VA_TBN_mgKOHg__c,VA_Tin_Sn__c,VA_Total_Baterical_Count__c,VA_Total_Chloride_ppm__c,VA_Total_Hardness_ppm__c,VA_Tramp_Oil_ml__c,VA_UnWork_Pentration__c,VA_Urea_content__c,VA_Value__c,VA_VI__c,VA_Water_Wt__c,VA_Worked_Pentration_60_Strokes__c,VA_Worked_Pentration_100000_Strokes__c,VA_Zinc_Zn__c FROM VA_TestResult__c where Case__c=:CaseId   ORDER BY LastModifiedDate DESC limit 1];
        if(lstTestResults != null || lstTestResults.size() > 0 ) {
            for(VA_TestResult__c objTestResult : lstTestResults )
            {
                if(objTestResult.Case__r.Status== 'Final Report Released' )
                flag = true;
            }
            
        }
        else 
        {
            flag = false;
        }
        //PostReportTemplateRedirectPage();
        system.debug('@@lstTestResults '+lstTestResults );
        
    }
   public PageReference PostReportTemplateRedirectPage(){
        CaseId = ApexPages.currentPage().getParameters().get('id');
        PageReference redirecttoPostTemplate;
        
        PageReference pageRef = ApexPages.currentPage();
        lstTestResults = [SELECT Case__r.Status,Case__r.VA_Request_Purpose__c  ,Case__r.Product_Category__r.Name,Case__r.VA_Product__r.name,Id,Name,RecordTypeId, RecordType.DeveloperName  FROM VA_TestResult__c where Case__c=:CaseId   ORDER BY LastModifiedDate DESC limit 1];
        //Case objCase = [Select id ,Product_Category__r.Name from Case where id =: CaseId];
        system.debug('@@@ProductCategory'+objCase.Product_Category__r.Name);
        system.debug('@@@caseid'+CaseId);
        
        if((lstTestResults != null || lstTestResults.size() > 0) && flag== true) {
            
            for(VA_TestResult__c objTestResult : lstTestResults)
            {
                if ((objTestResult.case__r.Product_Category__r.Name == 'Engine Oil MCO' && objTestResult.RecordType.DeveloperName == 'VA_Engine_Oil_MCO' ) || (objTestResult.case__r.Product_Category__r.Name == 'Engine Oil DEO' && objTestResult.RecordType.DeveloperName == 'VA_Engine_Oil_DEO') || (objTestResult.case__r.Product_Category__r.Name == 'Engine Oil PCMO' && objTestResult.RecordType.DeveloperName == 'VA_Engine_Oil_PCMO')|| (objTestResult.case__r.Product_Category__r.Name == 'Engine Oil GEO' && objTestResult.RecordType.DeveloperName == 'VA_Engine_Oil_GEO')){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_EngineOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
            
               else if (objTestResult.case__r.Product_Category__r.Name == 'Industrial Oil – Cutting – Neat Type' && objTestResult.RecordType.DeveloperName == 'VA_Industrial_Oil_Cutting_Neat_Type'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_CuttingNeatOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                else if (objTestResult.case__r.Product_Category__r.Name == 'Industrial Oil – Cutting – Emulsion Type' && objTestResult.RecordType.DeveloperName == 'VA_Industrial_Oil_Cutting_Emulsion_Type'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_CuttingEmulsionOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                 else if (objTestResult.case__r.Product_Category__r.Name == 'Industrial Others' && objTestResult.RecordType.DeveloperName == 'VA_Industrial_Others'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_IndustrialOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                else if (objTestResult.case__r.Product_Category__r.Name == 'AU32/DEF' && objTestResult.RecordType.DeveloperName == 'VA_AU32_DEF'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_AUS32_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                else if (objTestResult.case__r.Product_Category__r.Name == 'Coolant – Auto Coolant' && objTestResult.RecordType.DeveloperName == 'VA_Coolant_Auto_Coolant'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_Coolant_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                else if (objTestResult.case__r.Product_Category__r.Name == 'Grease' && objTestResult.RecordType.DeveloperName == 'VA_Grease'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_GreaseOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                else if (objTestResult.case__r.Product_Category__r.Name == 'Gear & Axle Oil' && objTestResult.RecordType.DeveloperName == 'VA_Gear_Axle_Oil'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_GearAxleOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }
                else if (objTestResult.case__r.Product_Category__r.Name == 'Hydraulic Oil' && objTestResult.RecordType.DeveloperName == 'VA_Hydraulic_Oil'){
                    redirecttoPostTemplate = new PageReference('/apex/VA_Post_Test_HydraulicOil_Template'+'?id='+CaseId);
                    redirecttoPostTemplate.setRedirect(true);
                    return redirecttoPostTemplate ; 
                }

                else{
                    ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'No Report Found . Please review your Sample Request' );
                    ApexPages.addmessage(msg);
                    return null; 
                }
                
            }
            return redirecttoPostTemplate;
            
        } 
       
        else {
          ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Error,'No Report Found . Please review your Sample Request' );
          ApexPages.addmessage(msg);
          return null; 
        } 
    }
}