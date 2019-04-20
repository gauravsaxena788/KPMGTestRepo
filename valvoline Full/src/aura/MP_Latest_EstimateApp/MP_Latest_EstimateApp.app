<aura:application access="global" extends="force:slds" >
	
     <aura:attribute name="recordId" type="Id" />
   
   <c:MP_Latest_Estimate_Fill recordId="{!v.recordId}" />
</aura:application>