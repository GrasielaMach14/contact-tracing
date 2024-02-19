/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-19 18:43:41
 * @modify date 2024-02-19 18:43:41
 * @desc [description]
 */
public with sharing class CTLocationBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC){
        List<String> healthStatus = new List<String> {'Red', 'Orange', 'Yellow'};
        Date today = Date.today();
        Date fourteenDaysAgo = today - 14;
        return Database.getQueryLocator('SELECT Id, Status__c FROM Location__c WHERE Status_Update_Date__c = :fourteenDaysAgo AND Status__c IN :healthStatus');
    }
    public void execute(Database.BatchableContext BC, List<Location__c> trackLocation){
        for(Location__c loc: trackLocation) {
            loc.Status__c = 'Green';
        }
        update trackLocation;
    } 
    public void finish(Database.BatchableContext BC){
        System.debug('Atualizado com sucesso');
    }
}