public with sharing class CTPeopleTracingHandler {
    public static void beforeInsertPeople(List<People_Tracing__c> newRecord) {
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecord);
        for(People_Tracing__c track: duplicates){
            track.addError('Duplicates are found in Person 1: '+ track.Person_1__c 
                                                                                +', Person 2: '+ track.Person_2__c);
        }
    }
}