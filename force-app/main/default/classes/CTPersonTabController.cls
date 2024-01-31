public with sharing class CTPersonTabController {
    @AuraEnabled
    public static UserInformation getPersonDetails(String recordId){
        UserInformation info = new UserInformation();

        Person__c person = CTPersonController.getPersonByID(recordId);
        if(person != null){
            info.name = person.Name;
            info.token = person.Token__c;
            info.phone = person.Mobile__c;
            info.statusUpdateOn = person.Status_Update_Date__c;
            info.status = person.Health_Status__c;
        }
        List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(recordId);

        if(traces != null && traces.size() > 0){
            List<CloseContacts> closeContacts = new List<CloseContacts>();
            // Será definido SET<Id> pq temos Person_1 e Person_2, eles devem serem unificados
            Set<Id> uniqueIds = new Set<Id>();
            uniqueIds.add(recordId);
            
            for(People_Tracing__c trc: traces){
                CloseContacts close = new CloseContacts();

                // Faça duas verificações para Person_1 e Person_2, senão tiver o registro inclua então
                if(!uniqueIds.contains(trc.Person_1__c)){
                    close.id = trc.Person_1__c;
                    close.status = trc.Person_1__r.Health_Status__c;
                    close.token = trc.Person_1__r.Token__c;
                    close.contactDate = trc.Contact_Date__c;
                }
                if(!uniqueIds.contains(trc.Person_2__c)){
                    close.id = trc.Person_2__c;
                    close.status = trc.Person_2__r.Health_Status__c;
                    close.token = trc.Person_2__r.Token__c;
                    close.contactDate = trc.Contact_Date__c;
                }
                closeContacts.add(close);
            }
            // Faça a conexão entre info e closeContact List
            if(closeContacts.size() > 0 && closeContacts != null){
                info.contacts = closeContacts;
                info.contactCount = closeContacts.size();
            }

        }
        // Retorne o tipo UserInformation
        return info;
    }
    // Temos 2 retornos person e traces, eles precisam serem unificados 
    //e para isso será usado o "Wrapper" conforme as linhas abaixo

    // Nesta classe retornaremos dados de Persons_c
    public class UserInformation {
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date statusUpdateOn;
        @AuraEnabled public String phone;
        @AuraEnabled public String status;
        @AuraEnabled public Integer contactCount = 0;
        @AuraEnabled public List<CloseContacts> contacts; // esta variável é a conexão entre as duas classes
    }
    //Nesta classe retornaremos dados de PeopleTracing__c
    public class CloseContacts {
        @AuraEnabled public String id;
        @AuraEnabled public String token;
        @AuraEnabled public Date contactDate;
        @AuraEnabled public String status;
    }
        
}