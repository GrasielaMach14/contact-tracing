/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:42:22
 * @modify date 2024-01-19 18:42:22
 * @desc [description]
 */
@isTest
public with sharing class CTLocationHandlerTest {
    @isTest
    public static void beforeInserLocationTest() {
        List<Location__c> locations = new List<Location__c>();
        locations.add(new Location__c(Name = 'Neighbour 1', Address__c = 'Street 1', Pincode__c = '099878', Status__c = 'Green'));
        locations.add(new Location__c(Name = 'Neighbour 2', Address__c = 'Street 2', Pincode__c = '099877', Status__c = 'Green'));
        insert locations;

        List<Location__c> listLocations = [SELECT Id, Status__c FROM Location__c];
        
        System.assertEquals('Green', listLocations[0].Status__c, 'Status = Green');
    }
    @isTest
    public static void beforeUpdateStatusLocationTest(){
        List<Location__c> locations2 = new List<Location__c>();
        locations2.add(new Location__c(Name = 'Neighbour 1', Address__c = 'Street 1', Pincode__c = '099878', Status__c = 'Green'));
        locations2.add(new Location__c(Name = 'Neighbour 2', Address__c = 'Street 2', Pincode__c = '099877', Status__c = 'Green'));
        
        insert locations2;
        
        List<Location__c> listLocations2 = [SELECT Id, Status__c, Status_Update_Date__c FROM Location__c];
        for(Location__c loc: listLocations2){
            loc.Status__c = 'Red';
            loc.Status_Update_Date__c = Date.today();
        }
        Test.startTest();
            update listLocations2;
        Test.stopTest();

        System.assertEquals(Date.today(), listLocations2[0].Status_Update_Date__c, 'The both Status Update Date are correctly.');
    }
    @isTest
    public static void afterUpdateStatusLocationTest(){
        //Montar antiga lista de Locations
        Map<Id, Location__c> oldMapLocation = new Map<Id,Location__c>();
        
        List<Location__c> locations3 = new List<Location__c>();
        locations3.add(new Location__c(Name = 'Neighbour 1', Address__c = 'Street 1', Pincode__c = '099878', Status__c = 'Green'));
        locations3.add(new Location__c(Name = 'Neighbour 2', Address__c = 'Street 2', Pincode__c = '099877', Status__c = 'Green'));
        locations3.add(new Location__c(Name = 'Neighbour 3', Address__c = 'Street 3', Pincode__c = '099875', Status__c = 'Green'));
        insert locations3;

        List<Person__c> persons = new List<Person__c>();
        persons.add(new Person__c(Name = 'Test 1', Mobile__c = '12345687', Health_Status__c = 'Green'));
        persons.add(new Person__c(Name = 'Test 2', Mobile__c = '12345678', Health_Status__c = 'Green'));
        persons.add(new Person__c(Name = 'Test 3', Mobile__c = '12345689', Health_Status__c = 'Green'));
        insert persons;

        List<Location_Tracing__c> lstTracing = new List<Location_Tracing__c>();
        for(Person__c ps: persons){
            for(Location__c loc: locations3){
                loc.Status__c = 'Red';
                lstTracing.add(new Location_Tracing__c(Person__c = ps.Id, Location__c = loc.Id, Visit_Date__c = Date.today()));
            }
        }
        insert lstTracing;

        List<Person__c> listPeople = new List<Person__c>();
        //Adicionar os registros no map
        for(Location_Tracing__c locTrack: lstTracing){
            if(lstTracing.size() > 0){
                oldMapLocation.put(locTrack.Id, new Location__c(Id = locTrack.Location__c));
            }
            for(Person__c ps: persons){
                ps.Id = lstTracing.get(0).Person__c;
                ps.Health_Status__c = 'Yellow';
                listPeople.add(ps);
            }
        }
		Map<Id, Person__c> mapPersons = new Map<Id, Person__c>();
        mapPersons.putAll(listPeople);
        Test.startTest();
        if(mapPersons.size() > 0){
            update mapPersons.values();
        }
        Test.stopTest();
        System.assertEquals('Yellow', listPeople.get(0).Health_Status__c, 'Ther person status is yellow.');

/*         List<Location_Tracing__c> updateTracing = [SELECT Id, Person__c, Location__c,  Person__r.Health_Status__c , Location__r.Status__c FROM Location_Tracing__c WHERE Location__r.Status__c = 'Green'];
        for(Location_Tracing__c locTrack: updateTracing){
            if(updateTracing.size() > 0){
                locTrack.Location__r.Status__c = 'Red';
                locTrack.Person__r.Health_Status__c = 'Yellow';
            }
        }
		System.debug('Aqui debug 2: '+updateTracing[0].Location__r.Status__c);
        Test.startTest();
            if(updateTracing.size() > 0){
                update updateTracing;
                //Acrescentar na Lista de Locations os registros após update
                List<Location__c> newLocations = new List<Location__c>();
                for(Location_Tracing__c trace: updateTracing){
                    for (Location__c loc2 : locations3) {
                        loc2.Id = trace.Location__c;
                        newLocations.add(loc2);                   
                    }
                }

                CTLocationHandler.afterUpdateStatusLocation(newLocations, oldMapLocation);
            }            
        Test.stopTest();
        System.debug('Final novo: ' + lstTracing +', antigo: '+ oldMapLocation);

        System.assertEquals('Yellow', updateTracing.get(0).Person__r.Health_Status__c, 'The Status of the person is yellow.');
        System.assertEquals('Red', updateTracing.get(0).Location__r.Status__c, 'The Status of the Location is red.'); */
    }
}