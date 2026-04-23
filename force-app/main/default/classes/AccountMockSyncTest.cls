@isTest
private class AccountMockSyncTest {
    @isTest
    static void AccountMockSyncTest() {
        //create sample data
        Account acc = new Account(
            Name = 'Test Account 4434334',
            Send_To_Mock__c = false
        );
        insert acc;

        Test.setMock(HttpCalloutMock.class, new AccountMockHttpResponseGenerator());


        Test.startTest();
        acc.Send_To_Mock__c = true;
        update acc;
        Test.stopTest();
        

        Account updatedAcc = [
            SELECT Id, Name, Send_To_Mock__c, Mock_Status__c, Mock_Response__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(true, updatedAcc.Send_To_Mock__c);
        System.assertEquals('200', updatedAcc.Mock_Status__c);
        //System.assertEquals('Processed successfully', updatedAcc.Mock_Response__c);

    }
}