public class VA_SendEmailOrder
{

    @InvocableMethod
    public static void VA_SendEmailOrder(List<String> recordID){
        try{
            VA_Order_Send_Email_Setting__mdt objmdtSendEmail = [select  DeveloperName, VA_Custom_Profile_Name_Post__c,VA_Custom_Profile_Name__c, VA_Email_Template_Name__c FROM VA_Order_Send_Email_Setting__mdt] ;
            system.debug('@@ProfileName'+objmdtSendEmail.VA_Custom_Profile_Name__c);
            system.debug('@@EmailTemplate'+objmdtSendEmail.VA_Email_Template_Name__c );
            EmailTemplate  objEmailTemplate = [select Id, Subject, HtmlValue,Markup, Body from EmailTemplate WHERE DeveloperName =: objmdtSendEmail.VA_Email_Template_Name__c];

            String subject = objEmailTemplate.Subject;
            String htmlBody = objEmailTemplate.HtmlValue;
            String[] toAddresses;
            string contEmail;
            

            Order objOrder = [Select Id,Sold_To_Code__c,VA_Delivery_Address__c, AccountID,Account.name,Account.VA_OTC_Executive_Mail_Id__c, Account.VA_OTC_Generic_Mail_Id__c, Account.Owner.Email, CreatedBy.name, ShippingAddress, (select id,VA_Material_SKU__c,Quantity,UnitPrice,VA_SFDC_Order_Line_Item_Number__c,Product2.Description from OrderItems), VA_Source__c, CreatedById, VA_SFDC_Order_Number__c,CreatedDate, VA_Ship_To_Code__c, EffectiveDate, VA_Payment_Terms__c, VA_Business_Vertical__c, PoNumber,VA_GST_Number__c, VA_PO_Attached__c FROM Order WHERE Id=: recordID ];

            //User objOTCUser  = [select id , Email ,name, Profile.name from User where profile.name =: 'OTC' ];
            
            system.debug('@@user'+UserInfo.getUserId());
            String orderCreatedDate = objOrder.CreatedDate.format('dd.MM.yyyy');
            List<String> setofProfileName = new List<String>();
            setofProfileName = VCPL_CommonUtilityClass.getCustomerPortalProfiles();
            
            String orderEffectiveDate = dateTime.newInstance(objOrder.EffectiveDate,Time.newInstance(0, 0, 0, 0)).format('dd.MM.yyyy');
            for(Contact objcontactEmail : [SELECT email FROM Contact WHERE id IN (SELECT contactid FROM User WHERE id=:objOrder.CreatedById AND Profile.Name IN :setofProfileName)])
            {
                contEmail= objcontactEmail .email;
                system.debug('@@contEmail'+contEmail);
            }
            //List<Contact> lstContEmail= [select email from Contact where id in (select contactid from user where id=: UserInfo.getUserId())];

            //if(lstContEmail!=null  && lstContEmail.size()>0)
            //contEmail= lstContEmail[0].email;
            system.debug('@@OTCEmailid'+objOrder.Account.VA_OTC_Executive_Mail_Id__c);
            if(contEmail!=null && contEmail!= '' && objOrder.Account.VA_OTC_Executive_Mail_Id__c!=null && objOrder.Account.VA_OTC_Executive_Mail_Id__c!= '' && objOrder.Account.Owner.Email!=null && objOrder.Account.Owner.Email!='')
                toAddresses = new String[]{objOrder.Account.VA_OTC_Executive_Mail_Id__c, objOrder.Account.Owner.Email ,contEmail };
                
            else if(contEmail!=null && contEmail!= '')
               toAddresses = new String[]{contEmail };
                    
            else if(objOrder.Account.VA_OTC_Executive_Mail_Id__c!=null && objOrder.Account.VA_OTC_Executive_Mail_Id__c!= '' && objOrder.Account.Owner.Email!=null && objOrder.Account.Owner.Email!='')
                toAddresses = new String[]{objOrder.Account.VA_OTC_Executive_Mail_Id__c,objOrder.Account.Owner.Email};
            
            
            if(toAddresses != null && objOrder.Account.VA_OTC_Generic_Mail_Id__c!=null && objOrder.Account.VA_OTC_Generic_Mail_Id__c!= '')
                toAddresses.add(objOrder.Account.VA_OTC_Generic_Mail_Id__c);
            
            system.debug('To Addresses:'+toAddresses);
            
            subject = subject.replace('{!Order.VA_SFDC_Order_Number__c}', objOrder.VA_SFDC_Order_Number__c!=null?objOrder.VA_SFDC_Order_Number__c:'');
            //htmlBody = htmlBody.replace('{!User.Name} ', objOTCUser.Name!=null?objOTCUser.Name:'');
            htmlBody = htmlBody.replace('{!Order.AccountNumber}', objOrder.Account.name!=null?objOrder.Account.name:'');
            htmlBody = htmlBody.replace('{!Order.VA_Delivery_Address__c}', string.valueof(objOrder.VA_Delivery_Address__c)!=null?string.valueof(objOrder.VA_Delivery_Address__c):'');
            htmlBody = htmlBody.replace('{!Order.CreatedDate}', orderCreatedDate!=null?orderCreatedDate:'');
            htmlBody = htmlBody.replace('{!Order.VA_Business_Vertical__c}', objOrder.VA_Business_Vertical__c!=null?objOrder.VA_Business_Vertical__c:'');
            htmlBody = htmlBody.replace('{!Order.PoNumber}', objOrder.PoNumber!=null?objOrder.PoNumber:'');
            htmlBody = htmlBody.replace('{!Order.VA_Source__c}', objOrder.VA_Source__c!=null?objOrder.VA_Source__c:'');
            htmlBody = htmlBody.replace('{!Order.VA_SFDC_Order_Number__c}', objOrder.VA_SFDC_Order_Number__c!=null?objOrder.VA_SFDC_Order_Number__c:'');
            htmlBody = htmlBody.replace('{!$Label.VA_LogoDocumentId}',Label.VA_LogoDocumentId);
            htmlBody = htmlBody.replace('{!Order.CreatedById}', objOrder.CreatedBy.name !=null?objOrder.CreatedBy.name :'');
            htmlBody = htmlBody.replace('{!Order.VA_GST_Number__c}', string.valueof(objOrder.VA_GST_Number__c)!=null?string.valueof(objOrder.VA_GST_Number__c):'');
            htmlBody = htmlBody.replace('{!Order.EffectiveDate}', orderEffectiveDate !=null?orderEffectiveDate :'');
            htmlBody = htmlBody.replace('{!Order.VA_Ship_To_Code__c}', objOrder.VA_Ship_To_Code__c!=null?objOrder.VA_Ship_To_Code__c:'');
            htmlBody = htmlBody.replace('{!Order.VA_Payment_Terms__c}', objOrder.VA_Payment_Terms__c!=null?objOrder.VA_Payment_Terms__c:'');
            htmlBody = htmlBody.replace('{!Order.VA_PO_Attached__c}', objOrder.VA_PO_Attached__c==true?'True':'False');
            htmlBody = htmlBody.replace('{!Order.Sold_To_Code__c}', string.valueof(objOrder.Sold_To_Code__c)!=null?string.valueof(objOrder.Sold_To_Code__c):'');
            htmlBody += '<br/>';
            
            if(contEmail!=null && contEmail!= '')
                htmlBody +='<table style="width:100%" ><caption><h3>Line Item Details  </h3></caption><tr><center><th>Product SKU</th><th>Product Description</th><th>Product Quantity</th><th>Expected Price</th></center></tr>';
            
            else
                htmlBody +='<table style="width:100%" ><caption><h3>Line Item Details  </h3></caption><tr><center><th>Product SKU</th><th>Product Description</th><th>Product Quantity</th><th>Expected Price</th><th>SFDC Line Item No</th></center></tr>';
            
            for(OrderItem objOrderItem :objOrder.OrderItems){
            
               if(contEmail!=null && contEmail!= '')
                  htmlBody +='<tr><center><td>'+objOrderItem.VA_Material_SKU__c+'</td><td>'+objOrderItem.Product2.Description+'</td><td>'+ objOrderItem.Quantity +'</td><td>'+objOrderItem.UnitPrice  +'</td></center></tr> '; 
               
               else
                   htmlBody +='<tr><center><td>'+objOrderItem.VA_Material_SKU__c+'</td><td>'+objOrderItem.Product2.Description+'</td><td>'+ objOrderItem.Quantity +'</td><td>'+objOrderItem.UnitPrice  +'</td><td>'+objOrderItem.VA_SFDC_Order_Line_Item_Number__c+'</td></center></tr> ';  
               

               
               /* htmlBody = htmlBody.replace('{!OrderItem.Quantity}', string.valueof(objOrderItem.Quantity)!=null?string.valueof(objOrderItem.Quantity):'');
                htmlBody = htmlBody.replace('{!OrderItem.UnitPrice}', string.valueof(objOrderItem.UnitPrice)!=null?string.valueof(objOrderItem.UnitPrice):'');
                htmlBody = htmlBody.replace('{!OrderItem.VA_SFDC_Order_Line_Item_Number__c}', objOrderItem.VA_SFDC_Order_Line_Item_Number__c!=null?objOrderItem.VA_SFDC_Order_Line_Item_Number__c:'');*/

            }

            htmlBody += ' </table><br/> ';
             
            if(objOrder.VA_PO_Attached__c == true)
                htmlBody += '<br/> Please also find the PO Images attached with this mail. <br/>';
            
            htmlBody +=' <br/> Thanks <br/><br/> VCPL <br/><br/>'+ System.Label.VA_Disclaimer_Message;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'vedgeinfo@valvolinecummins.com'];

            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            email.setToAddresses(toAddresses);
            email.setReplyTo('vedgeinfo@valvolinecummins.com');
            //email.setSenderDisplayName('vedgeinfo@valvolinecummins.com'); //noreply@salesforce.com

            email.setSaveAsActivity(true);

            email.setSubject(subject);
            email.setHtmlBody(htmlBody);
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            List<ContentDocumentLink> lstContentDocumentLink = [SELECT ContentDocumentId  FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Order where id=: objOrder.id) and LinkedEntity.Type='Order' ORDER BY SystemModstamp DESC limit 1];
            if(!lstContentDocumentLink.isEmpty()){
                for(ContentDocumentLink objContentDocumentLink : lstContentDocumentLink){
                    for(ContentVersion objContentVersion : [select id ,Title,VersionData ,ContentDocumentId   from ContentVersion where ContentDocumentId =: objContentDocumentLink.ContentDocumentId ])
                    {
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        efa.setFileName(objContentVersion.Title);
                        efa.setBody(objContentVersion.VersionData);
                        fileAttachments.add(efa);
                    }
                }   
            }
            
            if(!fileAttachments.isEmpty())
                email.setFileAttachments(fileAttachments);
            
            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});

        }
        catch(Exception ex) {  
            VA_Error_Log__c errorLog = new VA_Error_Log__c(VA_Message__c = ex.getMessage(),VA_Cause__c = String.valueof(ex.getCause()),VA_Line_Number__c=ex.getLineNumber(),VA_Stack_Trace__c=ex.getStackTraceString());  
            insert errorLog;
            
        } 
    }
         
    
}