public with sharing class CTLocationHandler {
    public static void beforeInserLocation(List<Location__c> newLocation) {
         for(Location__c loc: newLocation){
           loc.Status__c = 'Green';
        }
    }
    public static void beforeUpdateStatusLocation(List<Location__c> newLocation, Map<Id, Location__c> oldLocationMap){
        for(Location__c loc: newLocation){
            if(loc.Status__c != oldLocationMap.get(loc.Id).Status__c){
                loc.Status_Update_Date__c = Date.today();
            }
        }
    }
    public static void afterUpdateStatusLocation(List<Location__c> newLocation, Map<Id, Location__c> oldLocationMap){
        Set<Id> statusChange = new Set<Id>();
        for(Location__c local: newLocation){
            if(local.Status__c == 'Red' && oldLocationMap.get(local.Id).Status__c != 'Red'){
                statusChange.add(local.Id);
            }
        }
        List<Location_Tracing__c> localTracing = CTLocationTracingController.getLocationByLocationIds(statusChange);
        Set<Id> personId = new Set<Id>();
        for(Location_Tracing__c lcTrack: localTracing){
            personId.add(lcTrack.Person__c);
        }
        List<Person__c> personList = new List<Person__c>();
        for(Id psId : personId) {
            personList.add(new Person__c(Id = psId, Health_Status__c = 'Yellow'));
        }
        if(personList.size() > 0) {
            update personList;
        }
    }
}