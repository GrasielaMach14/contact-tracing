public with sharing class CTLocationTracingController {
    public static Location_Tracing__c getVisitors(String localId) {
        List<Location_Tracing__c> lstTracing = [SELECT Id, Name, CreatedDate, Person__c, Location__c, Visit_Date__c, 
                                                        Person__r.Token__c, Person__r.Health_Status__c, 
                                                        LastViewedDate, LastModifiedDate FROM Location_Tracing__c 
                                                        WHERE Id =: localId ORDER BY Visit_Date__c DESC];
        if (lstTracing != null && lstTracing.size() > 0) {
            return lstTracing[0];
        }
        return null;
    }
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> peopleId){
        List<Location_Tracing__c> lstTracingPeople = [SELECT Id,  Person__c, Location__c FROM Location_Tracing__c 
                                                                                    WHERE Id IN :peopleId 
                                                                                    AND CreatedDate = LAST_N_DAYS:10];
            
        return lstTracingPeople; 
    }
    public static  List<Location_Tracing__c> getLocationByLocationIds(Set<Id> locationsId){
        List<Location_Tracing__c> records = [SELECT Id, Person__c, Person__r.Health_Status__c, Location__c FROM Location_Tracing__c 
                                                                        WHERE Id IN :locationsId 
                                                                        AND CreatedDate = LAST_N_DAYS:10
                                                                        AND Person__r.Health_Status__c = 'Green'];
        System.debug('Passei o conjunto de Set<Id> '+ locationsId);

      return records;
    }
    //Pegar registros duplicados do rastreamento dos locais
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        //Inserir registros únicos para cada objeto usando o set<id>
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();

        //Iterar sobre a nova lista passada como parâmetro
        for(Location_Tracing__c trc: newLocationTraces){
            locationIds.add(trc.Location__c);
            personIds.add(trc.Person__c);
        }
        //Mapear os locais e pessoas para depois verificar duplicação
        Map<Id, Set<Id>> mapExistingRecords = new Map<Id, Set<Id>>();

        //Consultar registros existentes
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Person__r.Name, Location__c, 
                                                                        Location__r.Name, Visit_Date__c 
                                                                        FROM Location_Tracing__c];
       //Essa lista vazia irá inserir os registros duplicados
       List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
       //Verificar se no map existe Location, se não tiver, inserir agora
        if (existingRecords != null && existingRecords.size() > 0) {
            for(Location_Tracing__c trace: existingRecords){
                if (!mapExistingRecords.containsKey(trace.Location__c)) {
                    mapExistingRecords.put(trace.Location__c, new Set<Id>());
                }
                //e agora vamos add o campo Person__c no map finalizando assim o preenchimento do map
                mapExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }
        //Itere e faça a comparação do registro do parâmetro do método e da lista duplicates
            for (Location_Tracing__c lcTrace : newLocationTraces) {
                if (mapExistingRecords.containsKey(lcTrace.Location__c) 
                && mapExistingRecords.get(lcTrace.Location__c).contains(lcTrace.Person__c)) {
                    duplicates.add(lcTrace);
                }   
            }
        }
        return duplicates;
    }

/*    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> duplicates){
        List<Location_Tracing__c> records = [SELECT Id, Person__c, Person__r.Name, Location__c, 
                                             					Location__r.Name, Visit_Date__c 
                                                                    FROM Location_Tracing__c];
        List<Location_Tracing__c> listTrace = new List<Location_Tracing__c>();
        for(Location_Tracing__c trc: records){
            if(trc.Person__c != duplicates.get(0).Person__c && trc.Location__c != duplicates.get(0).Location__c 
               && trc.Visit_Date__c != duplicates.get(0).Visit_Date__c){
                   System.debug('Não há duplicata ' + listTrace.size());
                   break;
            }
            System.debug('Há duplicação nos registros ' + listTrace.size());
            listTrace.add(trc);
        }
       return listTrace;        
    } */
}

/*
Execute anonimous

// getVisitors
List<Location_Tracing__c> lstTracing = [SELECT Id, Name, CreatedDate, Person__c, Location__c, Visit_Date__c, 
                                         Person__r.Token__c, Person__r.Health_Status__c, 
                                         LastViewedDate, LastModifiedDate FROM Location_Tracing__c];
for(Location_Tracing__c trace: lstTracing){
    System.debug('Id: '+trace.Id
                 +', Name: '+trace.Name
                 +', Token: '+trace.Person__r.Token__c
                 +', Health Status: '+trace.Person__r.Health_Status__c
                 +', Location: '+ trace.Location__c);
}
String traceId = lstTracing.get(3).Id;

System.debug(CTLocationTracingController.getVisitors(traceId));

// getLocationsByPersonIds
List<Location_Tracing__c> lstTracingPeople = [SELECT Id,  Person__c, Location__c 
                                              FROM Location_Tracing__c 
                                              WHERE CreatedDate = LAST_N_DAYS:10];
Set<Id> listIds = new Set<Id>();
for(Location_Tracing__c trace: lstTracingPeople){
    listIds.add(trace.Id);
    System.debug('Id: '+trace.Id
                 +', Person: '+trace.Person__c
                 +', Location: '+ trace.Location__c);
}

System.debug('Chama o método getLocationsByPersonIds:'
             + CTLocationTracingController.getLocationsByPersonIds(listIds));

// getLocationByLocationIds
List<Location_Tracing__c> records = [SELECT Id, Person__c, Person__r.Health_Status__c, 
                                     Location__c FROM Location_Tracing__c 
                                     WHERE CreatedDate = LAST_N_DAYS:10
                                     AND Person__r.Health_Status__c = 'Green'];
Set<Id> listIds = new Set<Id>();
for(Location_Tracing__c trace: records){
    listIds.add(trace.Id);
    System.debug('Id: '+trace.Id
                 +', Person: '+trace.Person__c
                 +', Health Status: '+trace.Person__r.Health_Status__c
                 +', Location: '+ trace.Location__c);
}

System.debug('Chama o método getLocationsByPersonIds:'
             + CTLocationTracingController.getLocationByLocationIds(listIds));

// checkDuplicates 1
List<Location_Tracing__c> records = [SELECT Id, Person__c, Visit_Date__c, 
                                    	 Location__c FROM Location_Tracing__c];
for(Location_Tracing__c trace: records){
    System.debug('Id: '+trace.Id
                 +', Person: '+trace.Person__c
                 +', Visit Date: '+trace.Visit_Date__c
                 +', Location: '+ trace.Location__c);
}
System.debug('AQUI '+ CTLocationTracingController.checkDuplicates(records));



*/