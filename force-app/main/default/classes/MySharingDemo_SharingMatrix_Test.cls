@isTest
private class MySharingDemo_SharingMatrix_Test {

    @testSetup
    static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];

        User u1 = new User(
            Alias='u1',
            Email='u1@test.com',
            EmailEncodingKey='UTF-8',
            LastName='User1',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId=p.Id,
            TimeZoneSidKey='Pacific/Auckland',
            UserName='u1' + System.currentTimeMillis() + '@test.com'
        );

        User u2 = new User(
            Alias='u2',
            Email='u2@test.com',
            EmailEncodingKey='UTF-8',
            LastName='User2',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId=p.Id,
            TimeZoneSidKey='Pacific/Auckland',
            UserName='u2' + System.currentTimeMillis() + '@test.com'
        );

        insert new List<User>{u1, u2};

        // Create Account owned by each user
        System.runAs(u1) { insert new Account(Name='A_U1'); }
        System.runAs(u2) { insert new Account(Name='A_U2'); }
    }

    private static User getUser(String aliasVal) {
        return [SELECT Id, Alias FROM User WHERE Alias = :aliasVal LIMIT 1];
    }

    @isTest
    static void test_matrix_for_user1() {
        User u1 = getUser('u1');

        System.runAs(u1) {
            // WITH sharing -> should see only own (assuming OWD Private)
            List<Account> withAcc = MySharingDemo_WithSharing.getVisibleAccounts();

            // WITHOUT sharing -> should see all
            List<Account> withoutAcc = MySharingDemo_WithoutSharing.getAccounts();

            // INHERITED -> since caller here is test context (runAs user) and class is inherited,
            // it behaves like "with sharing" because no outer without-sharing context is forcing it.
            List<Account> inheritedAcc = MySharingDemo_InheritedSharing.getAccounts();

            System.assert(withAcc.size() >= 1, 'With sharing should see at least own');
            System.assert(withoutAcc.size() >= withAcc.size(), 'Without sharing should see >= with sharing');
            System.assert(inheritedAcc.size() >= 1, 'Inherited sharing should return records');

            // Stronger assertions if your org OWD is Private for Account:
            // Expect u1 cannot see u2 account in with/inherited
            Boolean withHasU2 = false;
            for (Account a : withAcc) if (a.Name == 'A_U2') withHasU2 = true;
            System.assertEquals(false, withHasU2, 'With sharing should not see U2 account when OWD Private');

            Boolean inheritedHasU2 = false;
            for (Account a : inheritedAcc) if (a.Name == 'A_U2') inheritedHasU2 = true;
            System.assertEquals(false, inheritedHasU2, 'Inherited sharing should not see U2 account when OWD Private');

            Boolean withoutHasU2 = false;
            for (Account a : withoutAcc) if (a.Name == 'A_U2') withoutHasU2 = true;
            System.assertEquals(true, withoutHasU2, 'Without sharing should see U2 account');
        }
    }
}