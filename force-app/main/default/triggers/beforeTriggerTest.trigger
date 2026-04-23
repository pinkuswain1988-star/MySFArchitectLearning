trigger beforeTriggerTest on Account (before insert,before update, after insert, after update,before delete, after delete, after undelete) {
try{
    AccountTriggerTestHandler.handle();
}
catch(Exception e){
    system.debug('Exception is ' + e.getMessage());
    system.debug('Exception is ' + e.getStackTraceString());
}
}