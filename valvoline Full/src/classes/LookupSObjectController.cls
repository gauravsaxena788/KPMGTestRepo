/**
* @group LookupComponentController.  
*
* @description Controller Class for Lookup Component.
*/
public with sharing class LookupSObjectController {
    
    /**
* @description Query listof records matching the search string.
* @param searchString : Search String corresponding to which records with saame name will be fetched.
* @param sObjectAPIName: object apiname wrt to which query will be done.
* @param FilterCondition : Extenal Filter condition to be applied in query.
* @param isClickOnSearch : TRUE : SOQL ; FALSE : SOSL. 
*
*/
    @AuraEnabled
    public static Result[] filterDealerLookup(String searchString, string filterTypeName, String sObjectName) {
        
        List < Result > results = new List < Result > ();
        Set<String> setofString = new Set<String>();
        String searchQuery;
        
        if(filterTypeName == 'ELPUserMapping' ) {
            
            string UserId = Userinfo.getUserId();
            
            searchQuery = 'Select VCPL_User__c, VCPL_User__r.Name, VCPL_Branch__c, VCPL_Branch__r.Name from VCPL_ELP_Assignment__c WHERE VCPL_User__c=: UserId ';  
            String sanitizedSearchStringSOQL =  String.escapeSingleQuotes(searchString);
            sanitizedSearchStringSOQL = '%'+sanitizedSearchStringSOQL.trim()+'%';
            
            if(!String.isBlank(sanitizedSearchStringSOQL)){
                searchQuery += ' AND VCPL_Branch__r.Name LIKE : sanitizedSearchStringSOQL Limit 20';
            }
            else {
                searchQuery += ' Order By LastModifiedDate limit 10';
            }
            
            list<VCPL_ELP_Assignment__c> listofELPUSER = database.query(searchQuery);
            
            if (listofELPUSER != null && listofELPUSER.size() > 0) {
                // Create a list of matches to return
                for (VCPL_ELP_Assignment__c so: listofELPUSER) {
                    if(!setofString.contains(so.VCPL_Branch__c)){
                        setofString.add(so.VCPL_Branch__c);
                        results.add(new Result(so.VCPL_Branch__r.Name, so.VCPL_Branch__c));
                    }
                }
            }
        }
        
        return results; 
    }
    
    @AuraEnabled
    public static Result[] filterLookup(String searchString, string filterTypeName,String sObjectName) {
        
        List < Result > results = new List < Result > ();
        Set<String> setofString = new Set<String>();
        String searchQuery;
        String sanitizedSearchStringSOQL =  String.escapeSingleQuotes(searchString);
        sanitizedSearchStringSOQL = '%'+sanitizedSearchStringSOQL.trim()+'%';
        
        if(filterTypeName == 'DealerMapping' && sObjectName =='Account') {
            
            string dealerId = VCPL_TargetAssignmentController.getParentAccount();
            searchQuery = 'Select VCPL_Customer_Account__c, VCPL_Customer_Account__r.Name from VCPL_Dealer_Customer_Mapping__c where VCPL_Dealer_Account__c=: dealerId ';  
            
            if(searchString != null && searchString !=  ''){
                searchQuery += ' AND VCPL_Customer_Account__r.Name LIKE: sanitizedSearchStringSOQL Limit 20';
            }
            else {
                searchQuery += ' Order By LastModifiedDate limit 10';
            }
            
            list<VCPL_Dealer_Customer_Mapping__c> listofCustomers = database.query(searchQuery);
            
            
            if (listofCustomers.size() > 0) {
                // Create a list of matches to return
                for (VCPL_Dealer_Customer_Mapping__c so: listofCustomers) {
                    if(!setofString.contains(so.VCPL_Customer_Account__c)){
                        setofString.add(so.VCPL_Customer_Account__c);
                        results.add(new Result(so.VCPL_Customer_Account__r.Name, so.VCPL_Customer_Account__c));
                    }
                }
            }
        }
        else if(filterTypeName == 'DealerMapping' && sObjectName == 'Product2') {
            searchQuery = 'SELECT Name, Product__r.Name, Product__c , VCPL_Product_SKU_Id__c FROM CD_SKU_Mapping__c ';  
            
            if(searchString != null && searchString !=  ''){
                searchQuery += 'WHERE Name LIKE :sanitizedSearchStringSOQL Limit 20';
                system.debug('===searchQuery=='+searchQuery);
            }
            else {
                searchQuery += ' Order By LastModifiedDate limit 10';
            }
            
            list<CD_SKU_Mapping__c> listofPBC = database.query(searchQuery);
            
            if (listofPBC.size() > 0) {
                // Create a list of matches to return
                for (CD_SKU_Mapping__c so: listofPBC) {
                    if(!setofString.contains(so.Name)){
                        setofString.add(so.Product__c);
                        results.add(new Result(so.Name+'  , '+so.Product__r.Name, so.Product__c));
                    }
                }
            }
        }
        return results; 
    }
    
    
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName, String FilterCondition, boolean isClickOnSearch) {
        // Sanitze the input
        String sanitizedSObjectAPIName = String.isBlank(sObjectAPIName) ? String.escapeSingleQuotes('') : String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedSearchString = String.isBlank(searchString) ? String.escapeSingleQuotes('a') : String.escapeSingleQuotes(searchString);
        String sanitizedSObjectFilterCondition = String.isBlank(FilterCondition) ? String.escapeSingleQuotes('') : String.escapeSingleQuotes(FilterCondition);
        
        List < Result > results = new List < Result > ();
        String ActiveProduct = 'Active';
        String searchQuery ='';        
        String sanitizedSearchStringSOQL = String.isBlank(searchString) ? String.escapeSingleQuotes(''): String.escapeSingleQuotes(searchString) ;
        sanitizedSearchStringSOQL = '%'+sanitizedSearchStringSOQL.trim()+'%';
        sanitizedSObjectAPIName = String.escapeSingleQuotes(sanitizedSObjectAPIName);
        
        if(sanitizedSObjectAPIName == 'Account' && sanitizedSObjectFilterCondition.contains('RecordType.DeveloperName= VCPL_CD_Customer')){
            sanitizedSObjectFilterCondition = sanitizedSObjectFilterCondition.replace('RecordType.DeveloperName= VCPL_CD_Customer','RecordType.DeveloperName=\'VCPL_CD_Customer\'');
        }
            sanitizedSObjectFilterCondition.replace('RecordType.DeveloperName= VCPL_CD_Customer','RecordType.DeveloperName=\'VCPL_CD_Customer\'');
        system.debug('sanitizedSObjectFilterCondition'+sanitizedSObjectFilterCondition);
        // Build our SOSL query
        
        if (isClickOnSearch == true) {
            
            string orderbyquery = 'ORDER BY LastModifiedDate DESC';
            if (String.isBlank(FilterCondition)) {
                if(isSafeObject(sanitizedSObjectAPIName))
                    searchQuery = 'SELECT id,name FROM '+  sanitizedSObjectAPIName +'  WHERE Name LIKE : sanitizedSearchStringSOQL';
                
            } else {
                if(isSafeObject(sanitizedSObjectAPIName))
                    searchQuery = 'SELECT id,name FROM '+  sanitizedSObjectAPIName +' WHERE Name LIKE : sanitizedSearchStringSOQL AND '+sanitizedSObjectFilterCondition ;
            }
            searchQuery += ' ' + orderbyquery + ' Limit 10';
            System.debug('lookup searchQuery1: ' + searchQuery);
            List < sObject > searchList;
            if(isSafeObject(sanitizedSObjectAPIName))
                searchList = Database.query(searchQuery);
            else 
                searchList = null;
            for (SObject so: searchList) {
                results.add(new Result((String) so.get('Name'), so.Id));
            }
            
        } else {
            if (String.isBlank(FilterCondition)) {
                searchQuery = 'FIND {' + String.escapeSingleQuotes(sanitizedSearchString) + '*} IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(sanitizedSObjectAPIName) + '(id,name) Limit 50';
            } else {
                searchQuery = 'FIND {' + String.escapeSingleQuotes(sanitizedSearchString) + '*} IN ALL FIELDS RETURNING ' + String.escapeSingleQuotes(sanitizedSObjectAPIName) +
                    '(id,name WHERE ' + sanitizedSObjectFilterCondition + ' ) Limit 50';
            }
            System.debug('lookup searchQuery2: ' + searchQuery);
            // Execute the Query
            List < List < SObject >> searchList = search.query(searchQuery);
            if (searchList.size() > 0) {
                // Create a list of matches to return
                for (SObject so: searchList[0]) {
                    results.add(new Result((String) so.get('Name'), so.Id));
                }
            }
        }
        return results;
    }
    
    /**
* @description Query list of records matching the search string and return with extra fields.
* @param searchString : Search String corresponding to which records with same name and extra list of fields will be fetched.
* @param sObjectAPIName: object apiname wrt to which query will be done.
* @param FilterCondition : Extenal Filter condition to be applied in query.
* @param isClickOnSearch : TRUE : SOQL ; FALSE : SOSL. 
* @param listOfFieldsToBeQueried : Extra fields for which search string can match to.
*
*/
    @AuraEnabled
    public static Result[] lookupByFields(String searchString, String sObjectAPIName, String FilterCondition, boolean isClickOnSearch, List < String > listOfFieldsToBeQueried) {
        // Sanitze the input
        String sanitizedSObjectAPIName = String.isBlank(sObjectAPIName) ? String.escapeSingleQuotes('') : String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedSearchString = String.isBlank(searchString) ? String.escapeSingleQuotes('a') : String.escapeSingleQuotes(searchString);
        String sanitizedSObjectFilterCondition = String.isBlank(FilterCondition) ? String.escapeSingleQuotes('') : String.escapeSingleQuotes(FilterCondition);
        
        List < Result > results = new List < Result > ();
        String ActiveProduct = 'Active';
        sanitizedSObjectAPIName = String.escapeSingleQuotes(sanitizedSObjectAPIName);
        String sanitizedSearchStringSOQL =  String.escapeSingleQuotes(searchString);
        sanitizedSearchStringSOQL = '%'+sanitizedSearchStringSOQL.trim()+'%';
        
        // Build our SOSL query
        //listOfFieldsToBeQueried = new List < String > ();
        List < String > listOfFieldsToBeQueriedWithoutName = new List < String >();
        system.debug('listOfFieldsToBeQueried=='+listOfFieldsToBeQueried);
        if (listOfFieldsToBeQueried == null) { 
            listOfFieldsToBeQueried = new List < String > ();
            listOfFieldsToBeQueried.add('Id');  
            listOfFieldsToBeQueriedWithoutName = listOfFieldsToBeQueried.clone();
            listOfFieldsToBeQueried.add('Name');
        }   
        
        
        system.debug('listOfFieldsToBeQueried=='+listOfFieldsToBeQueried+'listOfFieldsToBeQueriedWithoutName=='+listOfFieldsToBeQueriedWithoutName);
        if (isClickOnSearch == true) {
            String searchQuery = 'SELECT id,Name FROM Account';
            string orderbyquery = 'ORDER BY LastModifiedDate DESC';
            if (String.isBlank(FilterCondition)) {
                searchQuery = 'SELECT ' + String.escapeSingleQuotes(String.join(listOfFieldsToBeQueried, ', '));
                if(isSafeObject(sanitizedSObjectAPIName))
                    searchQuery += ' FROM '+  sanitizedSObjectAPIName +' WHERE (';
                
                for (String field: listOfFieldsToBeQueried) {
                    if (field != 'Id')
                        searchQuery += field + ' LIKE : sanitizedSearchStringSOQL  OR ';
                }
                
                if (listOfFieldsToBeQueried != null && listOfFieldsToBeQueried.size() > 0) {
                    searchQuery = searchQuery.substring(0, searchQuery.length() - 3);
                    searchQuery += ' ) ';
                }
                
                searchQuery += ' ' + String.escapeSingleQuotes(orderbyquery) + ' Limit 10';
                
            } else {
                
                searchQuery = 'SELECT ' + String.join(listOfFieldsToBeQueried, ', ');
                if(isSafeObject(sanitizedSObjectAPIName))
                    searchQuery += ' FROM '+  sanitizedSObjectAPIName +' WHERE (';
                
                for (String field: listOfFieldsToBeQueried) {
                    if (field != 'Id')
                        searchQuery += field + ' LIKE : sanitizedSearchStringSOQL  OR ';
                }
                
                if (listOfFieldsToBeQueried != null && listOfFieldsToBeQueried.size() > 0) {
                    searchQuery = searchQuery.substring(0, searchQuery.length() - 3);
                    searchQuery += ' ) ';
                }
                searchQuery += ' AND ' + String.escapeSingleQuotes(FilterCondition) ;
                searchQuery += ' ' + String.escapeSingleQuotes(orderbyquery) + ' Limit 10';
            }
            System.debug('lookupByFields searchQuery1: ' + searchQuery);
            
            List < sObject > searchList;
            string QueryString = String.escapeSingleQuotes(searchQuery);
            if(isSafeObject(sanitizedSObjectAPIName))
                searchList = Database.query(QueryString);
            else
                searchList = null;
            
            for (SObject so: searchList) {
                String key = '';
                String value = '';
                //key += '-' + so.get('Name');
                for (String field: listOfFieldsToBeQueriedWithoutName) {
                    if (field.toLowerCase() == 'id')
                        continue;
                    value = (String) so.get(field);
                    if (value != null)
                        key += value + ' -- ';
                }
                
                key += so.get('Name');
                //key = key.substring(1);
                results.add(new Result(key, so.Id));
            }
            
        } else {
            String searchQuery;
            if (String.isBlank(FilterCondition)) {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName;
                searchQuery += '(' + String.join(listOfFieldsToBeQueried, ', ') + ' ) Limit 50';
            } else {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName +
                    '(' + String.join(listOfFieldsToBeQueried, ', ') + ' WHERE ' + FilterCondition + ' ) Limit 50';
            }
            System.debug('lookupByFields searchQuery2: ' + searchQuery);
            String SOSLQuery = String.escapeSingleQuotes(searchQuery);
            // Execute the Query
            List < List < SObject >> searchList = search.query(SOSLQuery);
            
            // Create a list of matches to return
            for (SObject so: searchList[0]) {
                String key = '';
                String value = '';
                key += '-' + so.get('Name');
                for (String field: listOfFieldsToBeQueriedWithoutName) {
                    if (field.toLowerCase() == 'id')
                        continue;
                    value = (String) so.get(field);
                    if (value != null)
                        key += ' -- ' + value;
                }
                
                key = key.substring(1);
                results.add(new Result(key, so.Id));
                // results.add(new Result((String)so.get('Name'), so.Id));
            }
        }
        
        return results;
    }
    
    /**
* Inner class to wrap up an SObject Label and its Id
*/
    public class Result {
        @AuraEnabled public String SObjectLabel {
            get;
            set;
        }
        @AuraEnabled public Id SObjectId {
            get;
            set;
        }
        
        public Result(String sObjectLabel, Id sObjectId) {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    } 
    
    Public static boolean isSafeObject(String objName){
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        SObjectType myObj = schemaMap.get(objName);
        return myObj.getDescribe().isAccessible() ; 
    }
    
}