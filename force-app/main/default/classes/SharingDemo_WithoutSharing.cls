public without sharing class SharingDemo_WithoutSharing {
    @AuraEnabled(cacheable=true)
    public static List<Account> fetchAccounts() {
        try {
            return[
                SELECT Id,Name,OwnerId FROM Account
                ORDER BY CreatedDate Desc
                LIMIT 50
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public SharingDemo_WithoutSharing() {

    }
}