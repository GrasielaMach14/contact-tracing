public with sharing class CTLocationHandler {
    public static void beforeInserLocation(List<Location__c> newLocation) {
         for(Location__c loc: newLocation){
           loc.Status__c = 'Green';
        }
    }
    public static void beforeUpdateDataStatus(List<Location__c> newLocation, Map<Id, Location__c> oldLocationMap){
        for(Location__c loc: newLocation){
            if(loc.Status__c != oldLocationMap.get(loc.Id).Status__c){
                loc.Status_Update_Date__c = Date.today();
            }
        }
    }
}