/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-01-19 18:43:27
 * @modify date 2024-01-19 18:43:27
 * @desc [description]
 */
public with sharing class CTRecentChangesController {
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges() {
        return CTPersonController.getRecentHealthChanges();
    }
    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges() {
        return CTLocationController.getRecentStatusChanges();
    }
    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        return CTPersonController.searchPeople(searchTerm);
    }
    @AuraEnabled
    public static List<Location__c> searchLocations(String searchTerm){
        return CTLocationController.searchLocations(searchTerm);
    }
}