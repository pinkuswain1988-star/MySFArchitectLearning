@IsTest
private class AccountHelperTest {

    @IsTest
    static void testCreateSampleAccount() {
        Test.startTest();
        Account acc = AccountHelper.createSampleAccount('Test Telecom Account', 'Telecommunications');
        Test.stopTest();

        System.assertNotEquals(null, acc.Id);
        System.assertEquals('Test Telecom Account', acc.Name);
        System.assertEquals('Telecommunications', acc.Industry);
    }

    @IsTest
    static void testGetActiveAccounts() {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            accList.add(new Account(
                Name = 'Test Account ' + i,
                Industry = 'Telecommunications'
            ));
        }
        insert accList;

        Test.startTest();
        List<Account> result = AccountHelper.getActiveAccounts();
        Test.stopTest();

        System.assert(result.size() > 0);
    }
}