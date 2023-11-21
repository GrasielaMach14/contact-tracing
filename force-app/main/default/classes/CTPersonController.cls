public with sharing class CTPersonController {
    public static String getToken(String phone){
        Blob targetBlob = Blob.valueOf('phone');
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        //get String value of hash Blob, transforms Blob to String
        return EncodingUtil.base64Encode(hash);
    }
    //Get all the recent actual dates about the Health Changes 
    public static List<Person__c> getRecentHealthChanges(List<Person__c> lstPrs){
        List<Person__c> recordsLst = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                                    FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST];

 /*       for(Person__c person: recordsLst){
            if(person.CreatedDate.date().daysBetween(person.Status_Update_Date__c) < 10){
                //(system.today()).daysBetween(Date.valueOf(cc1.ClosedDate));
                person.Health_Status__c = 'Green';
            }else if(person.CreatedDate.date().daysBetween(person.Status_Update_Date__c) == 10){
                person.Health_Status__c = 'Yellow';
            }else if(person.CreatedDate.date().daysBetween(person.Status_Update_Date__c) < 15){
                person.Health_Status__c = 'Orange';
            }else if(person.CreatedDate.date().daysBetween(person.Status_Update_Date__c) < 15){
                person.Health_Status__c = 'Red';
            }
            recordsLst.add(person); 
        }*/                                        
        return recordsLst;
    }
    //Find a research of name or mobile or token  in query
    public static List<Person__c> searchPeople(String record){
        record = record + '%';
        List<Person__c> lstPerson = [SELECT Id, Name, Health_Status__c, Mobile__c, 
                                        Status_Update_Date__c, Token__c     
                                        FROM Person__c WHERE Name LIKE :record 
                                            OR Mobile__c =: record 
                                            OR Token__c LIKE :record
                                        ORDER BY Status_Update_Date__c DESC NULLS LAST];
 
        return lstPerson;
    } 
    //Get person using Id
    public static Person__c getPersonByID(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, 
                                                Status_Update_Date__c, Token__c 
                                                FROM Person__c WHERE Id=: personId]; 
        
        if(people != null && people.size() > 0){
            return people[0];
        }

        return null;
    }
}

/*
List<Person__c> persons = [SELECT Id, Name, Mobile__c, Health_Status__c, 
Status_Update_Date__c FROM Person__c];

for(Person__c prs: persons){
    prs.Id = prs.Id;
    prs.Name = prs.Name;
    prs.Mobile__c = prs.Mobile__c;
    prs.Health_Status__c = prs.Health_Status__c;
    prs.Status_Update_Date__c = prs.Status_Update_Date__c;
}
List<Person__c> ctrller = CTPersonController.getRecentHealthChanges(persons);
System.debug('Persons: '+ ctrller);
*/