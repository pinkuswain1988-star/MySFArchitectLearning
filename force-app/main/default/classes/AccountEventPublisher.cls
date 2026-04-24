public with sharing class AccountEventPublisher {
    public static void publishEvent(Set<Id> accIds) {
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Id IN :accIds];
        List<Account_Sync_Event__e> events = new List<Account_Sync_Event__e>();
        System.debug('Event record creation start');
        for(Account acc : accList){
            Account_Sync_Event__e accSyncEvent = new Account_Sync_Event__e();
            accSyncEvent.AccountId__c = acc.Id;
            accSyncEvent.Action__c = 'Update';
            accSyncEvent.Name__c = acc.Name;

            events.add(accSyncEvent);
        }

        if(!events.isEmpty()){
            EventBus.publish(events);
            System.debug('Event published');
        }
        System.debug('Event record creation End');
    }
}