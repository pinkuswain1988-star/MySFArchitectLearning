trigger CaseTrigger on Case (before insert, before Update, after insert, after update) {
    try{
        if(Trigger.isInsert == true && Trigger.isBefore == true){
            CaseTriggerHandler.beforeInsert(Trigger.new);
        }
        else if (Trigger.isUpdate && Trigger.isBefore){
            CaseTriggerHandler.beforeUpdate(Trigger.OldMap,Trigger.new);
        }
        else if(Trigger.isAfter && Trigger.isUpdate){
            CaseTriggerHandler.afterUpdate(Trigger.OldMap,Trigger.new);
        }
        
    }
    catch(Exception e){
        system.debug(e);
    }
    
}