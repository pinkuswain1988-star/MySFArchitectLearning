public inherited sharing class MySharingDemo_InheritedSharing {

    public static List<Account> getAccounts() {
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new MySharingDemo_InheritedSharing.AuthorizationException('No Read access on Account');
        }

        List<Account> accList = [
            SELECT Id, Name, OwnerId
            FROM Account
        ];

        accList = (List<Account>) Security.stripInaccessible(
            AccessType.READABLE,
            accList
        ).getRecords();

        return accList;
    }
}