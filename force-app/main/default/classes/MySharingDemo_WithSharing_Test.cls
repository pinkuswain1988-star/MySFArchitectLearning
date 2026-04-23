
@isTest
private class MySharingDemo_WithSharing_Test {

    @testSetup
    static void setupData() {
        // TO DO: implement unit test
        Profile P = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        User u = new User(
            Alias = 'testu',
            Email='testuser@test.com',
            EmailEncodingKey='UTF-8',
            LastName='Test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='testuser' + System.currentTimeMillis() + '@test.com'
        );
        insert u;
    }
    private static User getUser() {
        return [SELECT Id FROM User WHERE Alias='tusr' LIMIT 1];
    }
    @isTest
    static void testSharingBehavior() {
        User u = getUser();

        System.runAs(u) {
            Test.startTest();
            List<Account> result = MySharingDemo_WithSharing.getVisibleAccounts();
            Test.stopTest();
            System.assert(result.size() > 0);
        }
    }
}