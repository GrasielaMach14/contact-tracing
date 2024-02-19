/**
 * @author Grasiela Machado de Lima
 * @email aciatuani@gmail.com
 * @create date 2024-02-19 18:43:33
 * @modify date 2024-02-19 18:43:33
 * @desc [description]
 */
public with sharing class CTStatusUpdateSchedule implements Schedulable {
    public static final String CRON = '0 0 3 * * ?';
    public void execute(SchedulableContext ctx) {
        CTPersonBatch updateHealthStatus = new CTPersonBatch();
        Database.executeBatch(updateHealthStatus, 2000);
        CTLocationBatch updateStatus = new CTLocationBatch();
        Database.executeBatch(updateStatus, 2000);
    }
}