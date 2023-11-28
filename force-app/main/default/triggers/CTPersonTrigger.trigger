trigger CTPersonTrigger on Person__c (before insert, after insert, before update, after update, after delete, after undelete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            CTContactTracingHandler.beforeInsertPerson(Trigger.new);
        }
        when BEFORE_UPDATE {
            CTContactTracingHandler.beforeUpdatePerson(Trigger.new, Trigger.oldMap);
        }
    }

}