public class VA_PicklistValuesController 
{
  @AuraEnabled
    public static list<string> getPickListValues(string objectAPIName, string fieldAPIName) {
        list<string> lstPickvals = new list<string>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectAPIName);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldAPIName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
          lstPickvals.add(a.getValue());//add the value  to our final list
        }
        system.debug('@@@@'+lstPickvals);
        return lstPickvals;
    }
}