public with sharing class CTHealthHeaderController {
    // Crie o método em CTPersonController e CTLocationController para organizar a estrutura do cód
    @AuraEnabled
    public static Map<String,Integer> getPersonHealthStatusCount() {
        //Use o tipo Map<String,Integer> para armazenar o Health status e contagem
        return CTPersonController.getHealthStatus();
    }
    @AuraEnabled
    // Chame cada um desses métodos em CTHealthHeaderHelper
    public static Map<String,Integer> getLocationHealthStatusCount(){

        return CTLocationController.getHealthStatusCount();
    }
}