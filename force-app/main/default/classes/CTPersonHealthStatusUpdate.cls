public with sharing class CTPersonHealthStatusUpdate {
    @AuraEnabled
    public static void changeToRedStatus(String personId){
        Person__c person = new Person__c(Id=personId);
        person.Health_Status__c = 'Red';
        update person;
        System.debug('Mudei para vermelho' + person);
    }
}