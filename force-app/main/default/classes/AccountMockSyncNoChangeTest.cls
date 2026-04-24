@isTest
private class AccountMockSyncNoChangeTest {
    @isTest
    static void AccountMockSyncNoChangeTest() {

    //Create Sample Data
    Account acc = new Account(
        Name= 'No Change Account',
        Send_To_Mock__c = true
    );
    insert acc;

    acc.Mock_Status__c = null;
    update acc;

    Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());

    Test.startTest();
        acc.Name = 'No Change Test Updated';
        update acc;
    Test.stopTest();

    Account updAcc = [
            SELECT Id, Name, Send_To_Mock__c, Mock_Status__c
            FROM Account
            WHERE Id = :acc.Id
        ];

    system.assertEquals('200', updAcc.Mock_Status__c);
    }
}