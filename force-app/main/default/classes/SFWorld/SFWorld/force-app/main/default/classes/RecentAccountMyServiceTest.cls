@IsTest
private class RecentAccountMyServiceTest {

    @IsTest
    static void testCreateAccount() {

        Test.startTest();
        Account acc = RecentAccountService.createAccount(
            'Telecom NZ Customer',
            'Telecommunications'
        );
        Test.stopTest();

        System.assertNotEquals(null, acc.Id);
        System.assertEquals('Telecom NZ Customer', acc.Name);
    }

    @IsTest
    static void testGetRecentAccounts() {

        List<Account> accList = new List<Account>();

        for(Integer i = 0; i < 5; i++){
            accList.add(new Account(
                Name = 'Test Acc ' + i,
                Industry = 'Telecommunications'
            ));
        }

        insert accList;

        Test.startTest();
        List<Account> result =
            RecentAccountService.getRecentAccounts(3);
        Test.stopTest();

        System.assertEquals(3, result.size());
    }
}