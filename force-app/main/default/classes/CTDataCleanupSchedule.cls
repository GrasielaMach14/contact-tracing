public with sharing class CTDataCleanupSchedule implements Schedulable {
    public static final String CRON = '0 0 0 15 * ?';
    public void execute(SchedulableContext ctx) {
        CTPeopleTracingBatch trackPeople = new CTPeopleTracingBatch(); 
        Database.executeBatch(trackPeople, 2000);
        CTLocationTracingBatch trackLocation = new CTLocationTracingBatch();
        Database.executeBatch(trackLocation, 2000);
    }
}