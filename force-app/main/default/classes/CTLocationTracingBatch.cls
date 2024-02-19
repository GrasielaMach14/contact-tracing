/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-19 18:42:58
 * @modify date 2024-02-19 18:42:58
 * @desc [description]
 */
public with sharing class CTLocationTracingBatch implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id FROM Location_Tracing__c WHERE Visit_Date__c != LAST_N_DAYS:30');
    }
    
    public void execute(Database.BatchableContext BC, List<Location_Tracing__c> traceBatch){
        delete traceBatch;
    }
    
    public void finish(Database.BatchableContext BC){
        System.debug('Finalizado Batch!');
    }
}