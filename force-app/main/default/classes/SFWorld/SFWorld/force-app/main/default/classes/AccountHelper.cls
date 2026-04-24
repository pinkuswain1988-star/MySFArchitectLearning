public with sharing class AccountHelper {
    
    public static List<Account> getActiveAccounts() {
        return [
            SELECT Id, Name, Industry, Type
            FROM Account
            WHERE Name != null
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }

    public static Account createSampleAccount(String accName, String industry) {
        Account acc = new Account();
        acc.Name = accName;
        acc.Industry = industry;
        insert acc;
        return acc;
    }
}