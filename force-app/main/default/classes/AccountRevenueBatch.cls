global class AccountRevenueBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, AccountId, Amount FROM Opportunity WHERE StageName = 'Closed Won']);
    }
    global void execute(Database.BatchableContext BC, List<Opportunity> opps){
        Map<Id, Decimal> revenueMap = new Map<Id, Decimal>();

        for(Opportunity opp : opps){
            if(!revenueMap.containsKey(opp.AccountId)){
                revenueMap.put(opp.AccountId,0);
            }
            revenueMap.put(opp.AccountId, revenueMap.get(opp.AccountId) + opp.Amount);
        }
        List<Account> accUpdates = new List<Account>();
        for(Id accid : revenueMap.keySet()){
            accUpdates.add(new Account(Id=accid, Total_Revenue__c=revenueMap.get(accid)));
        }

        update accUpdates;
    }

    global void finish(Database.BatchableContext BC){
        System.debug('Batch Job Completed');
    }
}