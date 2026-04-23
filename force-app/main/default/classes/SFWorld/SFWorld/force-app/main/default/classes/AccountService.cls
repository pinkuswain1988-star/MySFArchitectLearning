public with sharing class AccountService {
    public static void afterInsert(List<Account> newAccs){
        Set<Id> accIds = new Set<Id>();
        for(Account acc : newAccs){
            if(acc.Send_To_Mock__c == true){
                accIds.add(acc.Id);
            }           
        }
        if(!accIds.isEmpty()){
            System.enqueueJob(new AccountMockSyncQueueable(accIds));
        }       
    }
    
    public static void afterUpdate(List<Account> newAccs, Map<Id,Account> oldAccs){
        Set<Id> accIds = new Set<Id>();
        for(Account ac : newAccs){
            Account oldAc = oldAccs.get(ac.Id);
            if(oldAc.Send_To_Mock__c == false && ac.Send_To_Mock__c == true){
                accIds.add(ac.Id);
            }
        }
        if(!accIds.isEmpty()){
            System.enqueueJob(new AccountMockSyncQueueable(accIds));
        }
    }
}