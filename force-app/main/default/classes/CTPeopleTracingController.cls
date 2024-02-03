/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:43:04
 * @modify date 2024-01-19 18:43:04
 * @desc [description]
 */
public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String personId) {
        return [
            SELECT Id, Contact_Date__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c
            FROM People_Tracing__c
            WHERE (Person_1__c = :personId OR Person_2__c = :personId) AND Contact_Date__c = LAST_N_DAYS:30
            ORDER BY Contact_Date__c DESC
        ];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> listPeople){
        Set<Id> personIds = new Set<Id>();
        //Para cada variável adicione em um único Set<Id>
        for(People_Tracing__c trace: listPeople){
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }
        
        Map<Id,Set<Id>> mapExistingRecords = new Map<Id,Set<Id>>();
        // Faça consulta buscando o Id único para cada campo Person__c
        List<People_Tracing__c> existentRecords = [SELECT Person_1__c, Person_2__c FROM People_Tracing__c 
                                                                        WHERE Person_1__c IN: personIds 
                                                                        AND Person_2__c IN: personIds];
        
        List<People_Tracing__c> lstDuplicate = new List<People_Tracing__c>();
        //Duplique as verificações para ver ambos cenários se for Person_1 ou Person_2
        if(existentRecords != null && existentRecords.size() > 0){
            for (People_Tracing__c trce : existentRecords) {
                if(!mapExistingRecords.containsKey(trce.Person_1__c)){
                    mapExistingRecords.put(trce.Person_1__c, new Set<Id>());
                }
                mapExistingRecords.get(trce.Person_1__c).add(trce.Person_2__c);

                if(!mapExistingRecords.containsKey(trce.Person_2__c)){
                    mapExistingRecords.put(trce.Person_2__c, new Set<Id>());
                }
                mapExistingRecords.get(trce.Person_2__c).add(trce.Person_1__c);
            }
            //Faça iteração com a lista passada no parâmetro
            for(People_Tracing__c trce2 : listPeople){
                if(
                    (mapExistingRecords.containsKey(trce2.Person_1__c) 
                    && mapExistingRecords.get(trce2.Person_1__c).contains(trce2.Person_2__c)) 
                    || (mapExistingRecords.containsKey(trce2.Person_2__c) 
                    && mapExistingRecords.get(trce2.Person_2__c).contains(trce2.Person_1__c))
                ){
                    lstDuplicate.add(trce2);
                }
            }
        }
        System.debug('Size: '+lstDuplicate.size());
        return lstDuplicate; 
    }
}