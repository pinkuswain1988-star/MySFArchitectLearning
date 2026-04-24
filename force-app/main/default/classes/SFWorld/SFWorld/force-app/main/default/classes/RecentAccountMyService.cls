public with sharing class RecentAccountMyService {

    // Fetch latest accounts
    public static List<Account> getRecentAccounts(Integer limitSize) {
        return [
            SELECT Id, Name, Industry, CreatedDate
            FROM Account
            WHERE Name != null
            ORDER BY CreatedDate DESC
            LIMIT :limitSize
        ];
    }

    // Create account for testing / integration
    public static Account createAccount(String name, String industry) {
        Account acc = new Account(
            Name = name,
            Industry = industry
        );
        insert acc;
        return acc;
    }
}