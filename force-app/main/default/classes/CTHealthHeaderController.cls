public with sharing class CTHealthHeaderController {
    @AuraEnabled
    public static Integer getPersonHealthStatusCount() {
        AggregateResult[] lstPerson = [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c];
        Integer countPerson;

        for(AggregateResult result: lstPerson){
            countPerson = Integer.valueOf(result.get('total'));
        }
        return countPerson;
    }
    @AuraEnabled
    public static Integer getLocationHealthStatusCount(){
        AggregateResult[] lstLocation = [SELECT Status__c, COUNT(Id) locals FROM Location__c GROUP BY Status__c];
        Integer countLocation;

        for(AggregateResult result2 : lstLocation){
            countLocation = Integer.valueOf(result2.get('locals'));
        }
        return countLocation;
    }
}