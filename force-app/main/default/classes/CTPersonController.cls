public with sharing class CTPersonController {
    public static String getToken(String phone){
        Blob targetBlob = Blob.valueOf('phone');
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        //get String value of hash Blob, transforms Blob to String
        return EncodingUtil.base64Encode(hash);
    }
    //Get all the recent actual dates about the Health Changes 
    public static List<Person__c> getRecentHealthChanges(List<Person__c> lstPrs){
        List<Person__c> recordsLst = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                                    FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST];
                                      
        return recordsLst;
    }
    //Find a research of name or mobile or token  in query
    public static List<Person__c> searchPeople(String record){
        record = record + '%';
        List<Person__c> lstPerson = [SELECT Id, Name, Health_Status__c, Mobile__c, 
                                        Status_Update_Date__c, Token__c     
                                        FROM Person__c WHERE Name LIKE :record 
                                            OR Mobile__c =: record 
                                            OR Token__c LIKE :record
                                        ORDER BY Status_Update_Date__c DESC NULLS LAST];
 
        return lstPerson;
    } 
    //Get person using Id
    public static Person__c getPersonByID(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, 
                                                Status_Update_Date__c, Token__c 
                                                FROM Person__c WHERE Id=: personId]; 
        
        if(people != null && people.size() > 0){
            return people[0];
        }

        return null;
    }

    public static Map<String,Integer> getHealthStatusCount(){
 
        Map<String,Integer> mapResults = new Map<String,Integer>();
      
        for(AggregateResult result: [SELECT Health_Status__c, COUNT(Id) total 
                                                    FROM Person__c 
                                                    GROUP BY Health_Status__c]){
            String healthStatus = String.valueOf(result.get('Health_Status__c'));
            Integer total = Integer.valueOf(result.get('total'));
            mapResults.put(healthStatus, total);           
        }    
        return mapResults;
    }
    //Buscar cohabitantes entre as pessoas marcados com laranja
    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed){
        //Lista definindo o status de saúde da pessoa
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};
        //Lista que consulta pessoas em contato no local e que sejam cohabitantes
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                            WHERE (Person_1__c IN: personIds OR Person_2__c IN: personIds) 
                                                            AND Contact_Type__c = 'Cohabitant' 
                                                            AND (Person_1__r.Health_Status__c IN: healthStatus 
                                                            OR Person_2__r.Health_Status__c IN: healthStatus)];
        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c pt: peopleTraces){
            //Senão for Person_1 então será o cohabitante(3ª pessoa em contato)
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                cohabitants.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            //Senao for Person_2 então será o cohabitante(3ª pessoa em contato)
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                cohabitants.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return cohabitants;
    }
    //Buscar vizinhos entre as pessoas marcadas com amarelo
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed){
        //Lista que consulta pessoas em contato no local e que sejam vizinhas
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                            WHERE (Person_1__c IN: personIds OR Person_2__c IN: personIds) 
                                                            AND Contact_Type__c = 'Neighbour' 
                                                            AND (Person_1__r.Health_Status__c = 'Green' 
                                                            OR Person_2__r.Health_Status__c = 'Green')];
        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c pt: peopleTraces){
            //Senão for Person_1 então será o vizinho(3ª pessoa em contato)
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            //Senao for Person_2 então será o vizinho(3ª pessoa em contato)
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return neighbours;
    }
    //Buscar primeiro contato entre as pessoas marcadas com laranja
    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed){
        //Lista definindo o status de saúde da pessoa
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};
        //Lista que consulta pessoas em contato no local e que sejam outros
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                            WHERE (Person_1__c IN: personIds OR Person_2__c IN: personIds) 
                                                            AND Contact_Type__c = 'Other' 
                                                            AND Contact_Date__c = LAST_N_DAYS:10
                                                            AND (Person_1__r.Health_Status__c IN: healthStatus 
                                                            OR Person_2__r.Health_Status__c IN: healthStatus)];
        Set<Id> primaryContact = new Set<Id>();
        for(People_Tracing__c pt: peopleTraces){
            //Senão for Person_1 então será o primeiro contato(3ª pessoa em contato)
            if(!alreadyProcessed.contains(pt.Person_1__c)){
                primaryContact.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            //Senao for Person_2 então será o segundo contato de acordo com o 1º
            if(!alreadyProcessed.contains(pt.Person_2__c)){
                primaryContact.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return primaryContact;
    }
     //Buscar segundo contato entre as pessoas marcadas com amarelo, referenciando o primeiro contato
     public static Set<Id> getSecundaryContacts(Set<Id> primaryContactIds, Set<Id> alreadyProcessed){
        //Lista definindo o status de saúde da pessoa
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};
        //Lista que consulta pessoas em contato no local verificando os primeiros contatos para encontrar o segundo contato
        List<People_Tracing__c> peopleTraces = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                            WHERE (Person_1__c IN: primaryContactIds OR Person_2__c IN: primaryContactIds) 
                                                            AND Contact_Type__c = 'OTHER'
                                                            AND Contact_Date__c = LAST_N_DAYS:10 
                                                            AND (Person_1__r.Health_Status__c IN:healthStatus 
                                                            OR Person_2__r.Health_Status__c IN:healthStatus)];
        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c pt: peopleTraces){
            //Senão for Person_1 então será o próximo contato)
            if(!primaryContactIds.contains(pt.Person_1__c)){
                secondaryContacts.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            //Senão for Person_2 então será o próximo contato)
            if(!primaryContactIds.contains(pt.Person_2__c)){
                secondaryContacts.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return secondaryContacts;
    }
    
}

/*
List<Person__c> persons = [SELECT Id, Name, Mobile__c, Health_Status__c, 
Status_Update_Date__c FROM Person__c];

for(Person__c prs: persons){
    prs.Id = prs.Id;
    prs.Name = prs.Name;
    prs.Mobile__c = prs.Mobile__c;
    prs.Health_Status__c = prs.Health_Status__c;
    prs.Status_Update_Date__c = prs.Status_Update_Date__c;
}
List<Person__c> ctrller = CTPersonController.getRecentHealthChanges(persons);
System.debug('Persons: '+ ctrller);
*/