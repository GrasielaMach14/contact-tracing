public with sharing class CTLocationController {
    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, 
                                                             Status__c FROM Location__c ORDER BY Status_Update_Date__c 
                                                             DESC NULLS LAST LIMIT 100];
    }

    public static List<Location__c> searchLocations(String record){
        record = record + '%';
        List<Location__c> lstLocations = [SELECT Id, Name, Address__c, Pincode__c, Status_Update_Date__c, 
                                                                    Status__c FROM Location__c 
                                                                    WHERE Name LIKE :record 
                                                                        OR Pincode__c LIKE :record 
                                                                        OR Address__c LIKE :record 
                                                                    ORDER BY Status_Update_Date__c DESC NULLS LAST];
        
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

    public static Map<String,Integer> getStatusCount(){
        Map<String,Integer> mapResults = new Map<String,Integer>();

        for(AggregateResult result: [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]){
            String status = String.valueOf(result.get('Status__c'));
            Integer count = Integer.valueOf(result.get('total'));
            mapResults.put(status, count);
        }
        return mapResults;
    }
        //Atualizar Local usando os campos Location__c, Red_Score__c e Status__c 
        public static void updateRedScore(Set<Id> locationsIds){
            List<Location__c> lstLocation = new List<Location__c>();
            AggregateResult[] redPeopleLocation = [SELECT Location__c, COUNT(Id) total FROM Location_Tracing__c 
                                                                    WHERE Person__r.Health_Status__c = 'Red' 
                                                                    AND Visit_Date__c = LAST_N_DAYS:10 
                                                                    AND Id IN: locationsIds 
                                                                    GROUP BY Location__c];
            for(AggregateResult result: redPeopleLocation){
                String localId = String.valueOf(result.get('Location__c'));
                Integer redScore = Integer.valueOf(result.get('total'));
                String status = getStatusLocation(redScore);
                lstLocation.add(new Location__c(Id = localId, Red_Score__c = redScore, Status__c = status));
            }
            if(lstLocation != null && lstLocation.size() > 0){
                update lstLocation;
            }
        }
        //Retornar o valor do Status de Saúde do local e usar no método acima
        public static String getStatusLocation(Integer redScore){
            if(redScore == 0){
                return 'Green';
            }else if(redScore <= 5){
                return 'Yellow';
            }else if(redScore <= 10){
                return 'Orange';
            }else{
                return 'Red';
            }
        }
        //Realize a consulta da contagem dos status da saúde e retorne para CTHealthHeaderController
        public static Map<String,Integer> getHealthStatusCount(){
            AggregateResult[] lstLocation = [SELECT Status__c, COUNT(Id) locals FROM Location__c GROUP BY Status__c];
    
            if(lstLocation != null && lstLocation.size() > 0){
                Map<String,Integer> resultMap = new Map<String,Integer>();
                for(AggregateResult result: lstLocation){
                    resultMap.put(String.valueOf(result.get('Status__c')), Integer.valueOf(result.get('locals')));
                }   
                return resultMap;
            }
            return null;
        }
}