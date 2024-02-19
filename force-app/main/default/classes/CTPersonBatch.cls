/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-19 18:43:19
 * @modify date 2024-02-19 18:43:19
 * @desc [description]
 */
public with sharing class CTPersonBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        List<String> healthStatus = new List<String> {'Red', 'Orange', 'Yellow'};
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Health_Status__c FROM Person__c WHERE Status_Update_Date__c = :fourteenDaysAgo AND Health_Status__c IN :healthStatus');
    }
        
    public void execute(Database.BatchableContext BC, List<Person__c> trackPerson){
        System.debug('Status initial ' + trackPerson);

        for(Person__c ps: trackPerson){
            ps.Health_Status__c = 'Green';
        }
        System.debug('Status changed ' + trackPerson);
        update trackPerson;
    }
    
    public void finish(Database.BatchableContext BC){
        System.debug('Atualizado Status no Batch!');
    }
}