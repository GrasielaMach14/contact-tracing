/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:42:56
 * @modify date 2024-01-19 18:42:56
 * @desc [description]
 */
@isTest
public with sharing class CTLocationTracingHandlerTest {
    @isTest
    public static void beforeInsertLocationTracingTest() {
        List<Person__c> persons = new List<Person__c>();
        persons.add(new Person__c(Name = 'Test 1', Health_Status__c = 'Green', Mobile__c = '12345687'));
        persons.add(new Person__c(Name = 'Test 2', Health_Status__c = 'Green', Mobile__c = '12345678'));
        persons.add(new Person__c(Name = 'Test 3', Health_Status__c = 'Green', Mobile__c = '12345689'));
        insert persons;

        List<Location__c> locations = new List<Location__c>();
        locations.add(new Location__c(Name = 'Neighbour 1', Address__c = 'Street 1', Pincode__c = '099878'));
        locations.add(new Location__c(Name = 'Neighbour 2', Address__c = 'Street 2', Pincode__c = '099877'));
        insert locations;

        List<Location_Tracing__c> locTracing = new List<Location_Tracing__c>();
        locTracing.add(new Location_Tracing__c(Person__c = persons[0].Id, Location__c = locations[0].Id, Visit_Date__c = Date.today()));
        locTracing.add(new Location_Tracing__c(Person__c = persons[0].Id, Location__c = locations[0].Id, Visit_Date__c = Date.today()));
        locTracing.add(new Location_Tracing__c(Person__c = persons[1].Id, Location__c = locations[1].Id, Visit_Date__c = Date.today()));
        locTracing.add(new Location_Tracing__c(Person__c = persons[1].Id, Location__c = locations[1].Id, Visit_Date__c = Date.today()));
        insert locTracing;

        CTLocationTracingHandler.beforeInsertLocationTracing(locTracing);

        List<Location_Tracing__c> listTrace = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c];
        System.assertEquals(locTracing.size(), listTrace.size());
        //System.assertEquals(2, listTrace[0].Person__c);
    }
}