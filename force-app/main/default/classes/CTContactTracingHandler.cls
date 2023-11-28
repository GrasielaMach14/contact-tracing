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
}