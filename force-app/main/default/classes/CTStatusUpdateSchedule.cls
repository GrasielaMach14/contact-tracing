public with sharing class CTStatusUpdateSchedule implements Schedulable {
    public static final String CRON = '0 0 0 15 * ?';
    public void execute(SchedulableContext ctx) {
        CTPersonBatch updateHealthStatus = new CTPersonBatch();
        Database.executeBatch(updateHealthStatus, 2000);
    }
}