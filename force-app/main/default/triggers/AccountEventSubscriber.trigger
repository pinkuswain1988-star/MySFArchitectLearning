trigger AccountEventSubscriber on Account_Sync_Event__e (after insert) {
    System.debug('=== Subscriber Fired ===');
    if(Trigger.isAfter && Trigger.isInsert){
        for(Account_Sync_Event__e eventRec : Trigger.new){
            System.debug('Received Event for Account: ' + eventRec.AccountId__c);

            System.enqueueJob(new AccountEventQueueable(eventRec.AccountId__c));
        }
        
    }
}