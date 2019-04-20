/** 
--------------------------------------------------------------------------------------
Version#     Date                             Author                    Description
--------------------------------------------------------------------------------------
1.0        03-May-2018                   Manoj Jain               Initial Version
--------------------------------------------------------------------------------------
*/
public class VA_CARReportController       
{
    public Id CaseId{get;set;}         
    public Case objCase{get;set;}     
    
    public VA_CARReportController()    
    {
        
        CaseId = ApexPages.currentPage().getParameters().get('id');   
        objCase= new Case();
        Id profileId=userinfo.getProfileId();   
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        for(Case caseRec: [Select Id,VA_Complaint_Id__c,CreatedBy.Name,VA_Product__r.Name,Batch_No__c,VA_Pack_Size__c,CreatedDate,Account.Name,VA_Quantity_Affected__c,Description,VA_Containment__c,VA_Root_Cause__c,VA_Why_1__c,VA_Why_2__c,VA_Why_3__c,VA_Why_4__c,VA_Why_5__c,VA_Man__c,VA_Machine__c,VA_Material__c,VA_Measurement__c,VA_Method__c,VA_Mother_Nature__c,VA_Correction__c,VA_Corrective_Action__c,(Select Id,VA_Document_Reviewed__c,VA_Doc_Updated__c,VA_Doc_Version__c from Document_Reviews__r) From case where id=:CaseId]){
            objCase =  caseRec;     
            
        }    
    } 
    
    /*@auraEnabled
    public static String createAttachment(String CaseId)
    {
        pagereference pr = new pagereference('/apex/CARReportPage?id='+CaseId);    
        ContentVersion v = new ContentVersion();
        v.VersionData = pr.getContentAsPdf();
        v.title = 'CAR Report';
        v.pathOnClient = pr.getUrl()+'/hello.pdf';  
        insert v;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:v.Id].ContentDocumentId;   
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = CaseId; // you can use objectId,GroupId etc
        cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
        insert cDe;
        
        String theMsgToReturn = 'CAR Report successfully saved';       
        return theMsgToReturn;
    }*/
    
  
}