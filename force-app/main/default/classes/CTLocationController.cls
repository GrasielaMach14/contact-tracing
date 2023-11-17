public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges(List<Location__c> records){
        List<Location__c> lstRecord = [SELECT Id, Name, Address__c, Pincode__c, Status_Update_Date__c, 
                                                            Status__c FROM Location__c  
                                                            ORDER BY Status_Update_Date__c DESC LIMIT 100];

        return lstRecord;
    }

    public static List<Location__c> searchLocations(String record){
        record = record + '%';
        List<Location__c> lstLocations = [SELECT Id, Name, Address__c, Pincode__c, Status_Update_Date__c, 
                                                                    Status__c FROM Location__c 
                                                                    WHERE Name LIKE :record 
                                                                        OR Pincode__c LIKE :record 
                                                                        OR Address__c LIKE :record 
                                                                    ORDER BY Status_Update_Date__c DESC];
        
        return lstLocations;
    }

    public static Location__c getLocationByID(String locationId){
        List<Location__c> lstLocation = [SELECT Id, Name, Address__c, Pincode__c, Status_Update_Date__c, 
                                                    Status__c FROM Location__c WHERE Id =: locationId];
        if(lstLocation != null && lstLocation.size() > 0){
            return lstLocation[0];
        }        
        return null;
    }
}