public with sharing class CTPeopleTracingSchedule implements Schedulable{
    // Defina aqui o agendamento | segundos minutos horas Dias Meses 
    public static final String CRON = '0 0 15 * * ?';
    public void execute(SchedulableContext ctx) {
        CTPeopleTracingBatch track = new CTPeopleTracingBatch(); 
        Database.executeBatch(track, 2000);
    }
}