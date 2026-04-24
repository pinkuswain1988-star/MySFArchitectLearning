public with sharing class AccountHandler {
    public static void run(){
        if(Trigger.isAfter && Trigger.isInsert){
           AccountService.afterInsert((List<Account>)Trigger.new); 
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            AccountService.afterUpdate((List<Account>) Trigger.new, (Map<Id,Account>) Trigger.oldMap);
            /*Set<Id> accIds = new Set<Id>();
            List<Account> accList = (List<Account>) Trigger.new;
            for(Account acc : accList){
                accIds.add(acc.Id);
            }

            AccountEventPublisher.publishEvent(accIds);*/
        }
    }
}