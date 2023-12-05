trigger CTLocationTrigger on Location__c (before insert, after insert, before update, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTLocationHandler.beforeInserLocation(Trigger.new);   
        }
        when BEFORE_UPDATE {
            CTLocationHandler.beforeUpdateStatusLocation(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            CTLocationHandler.afterUpdateStatusLocation(Trigger.new, Trigger.oldMap);
        }
    }
}