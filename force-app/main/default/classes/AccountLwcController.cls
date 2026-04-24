public with sharing class AccountLwcController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Industry FROM Account LIMIT 10];
    }

    @AuraEnabled
    public static String triggerOrder(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('Account Id is required');
        }
        return 'Order triggered successfully for ' + accountId;
    }
}