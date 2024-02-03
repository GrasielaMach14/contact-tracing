/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-02 23:39:21
 * @modify date 2024-02-02 23:39:21
 * @desc [description]
 */
public with sharing class CTLocationTabController {
    @AuraEnabled
    public static LocationInfo getLocationDetails(String recordId){
        LocationInfo info = new LocationInfo();

        Location__c local = CTLocationController.getLocationByID(recordId);

        if(local != null){
            info.name = local.Name;
            info.redScore = Integer.valueOf(local.get('Red_Score__c'));
            info.pincode = local.Pincode__c;
            info.statusDate = local.Status_Update_Date__c;
            info.status = local.Status__c;
        }

        List<Location_Tracing__c> trace = CTLocationTracingController.getVisitors(recordId);
        if(trace != null){
            List<Visitors> visitorsList = new List<Visitors>();
            for(Location_Tracing__c trc: trace){
                Visitors visit = new Visitors();
                visit.id = trc.Person__c;
                visit.status = trc.Person__r.Health_Status__c;
                visit.token = trc.Person__r.Token__c;
                visit.visitDate = trc.Visit_Date__c;
                visitorsList.add(visit);
            }

            info.visitors = visitorsList;
            info.visitorsCount = visitorsList.size();
        }
        return info;
    }

    public class LocationInfo {
        // Id, Name, Address__c, Pincode__c, Status_Update_Date__c,  Status__c
        @AuraEnabled public String name;
        @AuraEnabled public Integer redScore;
        @AuraEnabled public String pincode;
        @AuraEnabled public Date statusDate;
        @AuraEnabled public String status;
        @AuraEnabled public Integer visitorsCount = 0;
        @AuraEnabled public List<Visitors> visitors;
        
    }

    public class Visitors {
        @AuraEnabled public String id;
        @AuraEnabled public String status;
        @AuraEnabled public String token;
        @AuraEnabled public Date visitDate;

    }
}