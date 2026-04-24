public with sharing class FlsStripDemo {
    public static void run() {
        List<Account> accList = new List<Account>{
            new Account (Name='FLSTest',Phone='1234567890')
        };

       System.SObjectAccessDecision decision =
            Security.stripInaccessible(
                AccessType.CREATABLE,
                accList
            );
        List<Account> sanitized = (List<Account>) decision.getRecords();
        insert sanitized;
        System.debug('✅ Inserted sanitized records');
        System.debug('Removed fields: ' + decision.getRemovedFields());
    }
}