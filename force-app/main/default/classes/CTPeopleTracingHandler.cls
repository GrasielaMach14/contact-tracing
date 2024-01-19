/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:43:14
 * @modify date 2024-01-19 18:43:14
 * @desc [description]
 */
public with sharing class CTPeopleTracingHandler {
    public static void beforeInsertPeople(List<People_Tracing__c> newRecord) {
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecord);
        for(People_Tracing__c track: duplicates){
            track.addError('Duplicates are found in Person 1: '+ track.Person_1__c 
                                                +', Person 2: '+ track.Person_2__c);
        }
    }
}