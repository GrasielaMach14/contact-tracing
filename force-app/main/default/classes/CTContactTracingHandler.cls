public with sharing class CTContactTracingHandler {
    public static void beforeInsertPerson(List<Person__c> newRecord) {
        for(Person__c prs: newRecord){
            prs.Health_Status__c = 'Green';
            prs.Token__c = CTPersonController.getToken(prs.Mobile__c);
        }
    }
    public static void beforeUpdatePerson(List<Person__c> newPerson, Map<Id, Person__c> oldPersonMap){
        for(Person__c ps: newPerson){
            if(ps.Health_Status__c != oldPersonMap.get(ps.Id).Health_Status__c){
                ps.Status_Update_Date__c = Date.today();
            }
        }
    }
    public static void afterUpdatePerson(List<Person__c> newPerson, Map<Id, Person__c> oldPersonMap){
        Set<Id> statusChange = new Set<Id>();
        Set<Id> statusRed = new Set<Id>();
        for(Person__c ps: newPerson){
            if(ps.Health_Status__c != oldPersonMap.get(ps.Id).Health_Status__c){
                statusChange.add(ps.Id);
            }
            if(ps.Health_Status__c == 'Red' && oldPersonMap.get(ps.Id).Health_Status__c != 'Red'){
                statusRed.add(ps.Id);
            }
        }
        //Verificar os registros que já foram processados para não serem executados novamente
        Set<Id> alreadyProcessed = new Set<Id>();
        Set<Id> statusOrange = new Set<Id>();
        Set<Id> statusYellow = new Set<Id>();
        //Próximo segundo contato do cohabitante em vermelho será laranja
        statusOrange.addAll(CTPersonController.getCohabitants(statusRed, alreadyProcessed));
        //Próximo segundo contato do vizinho em vermelho será amarelo
        statusYellow.addAll(CTPersonController.getNeighbours(statusRed, alreadyProcessed));
        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(statusRed, alreadyProcessed);
        //Próximo segundo contato do contato principal em vermelho será laranja
        statusOrange.addAll(primaryContacts);
        //O contato principal em vermelho terá o contato secundário em amarelo
        statusYellow.addAll(CTPersonController.getSecundaryContacts(primaryContacts, alreadyProcessed));
    }
}