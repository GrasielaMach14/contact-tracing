public with sharing class CTLocationTracingHandler {
    public static void beforeInsertLocationTracing(List<Location_Tracing__c> newRecords) {
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecords);
        for(Location_Tracing__c lcTrack: duplicates){
            lcTrack.addError('Duplicates values in Location: '+lcTrack.Location__c+', Person: '+lcTrack.Person__c);
        }
    }
}