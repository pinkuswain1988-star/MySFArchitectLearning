public with sharing class AccountQueueable implements Queueable, Database.AllowsCallouts {

    private Id accountId;

    public AccountQueueable(String accId) {
        this.accountId = (Id) accId;
    }

    public void execute(QueueableContext qc) {

        List<Integration_Log__c> logList = new List<Integration_Log__c>();

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('callout:PostmanMock/account-sync');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String, Object>();
        body.put('accountId', accountId);
        req.setBody(JSON.serialize(body));

        Http http = new Http();
        HttpResponse resp;

        try {
            resp = http.send(req);

            if (resp != null && resp.getStatusCode() == 200) {
                Account acc = new Account(
                    Id = accountId,
                    Description = 'Account Sync completed successfully'
                );

                Database.SaveResult result = Database.update(acc, false);

                if (result.isSuccess()) {
                    System.debug('Account Sync completed successfully');

                    logList.add(buildLog(
                        accountId,
                        'SUCCESS',
                        '',
                        '',
                        '',
                        '',
                        '',
                        0,
                        'PostmanMock',
                        'account-sync'
                    ));
                } else {
                    for (Database.Error err : result.getErrors()) {
                        System.debug(err.getMessage());

                        logList.add(buildLog(
                            accountId,
                            'FAILED',
                            '',
                            '',
                            '',
                            '',
                            err.getMessage(),
                            0,
                            'PostmanMock',
                            'account-sync'
                        ));
                    }
                }
            } else {
                String errorMessage = 'Interface Failed';
                if (resp != null) {
                    errorMessage = 'HTTP ' + resp.getStatusCode() + ' - ' + resp.getBody();
                }

                logList.add(buildLog(
                    accountId,
                    'FAILED',
                    '',
                    '',
                    '',
                    '',
                    errorMessage,
                    0,
                    'PostmanMock',
                    'account-sync'
                ));
            }
        } catch (Exception e) {
            logList.add(buildLog(
                accountId,
                'FAILED',
                '',
                '',
                '',
                '',
                e.getMessage(),
                0,
                'PostmanMock',
                'account-sync'
            ));
        }

        if (!logList.isEmpty()) {
            insert logList;
        }
    }

    private static Integration_Log__c buildLog(
        Id recordId,
    	String statusCode,
    	String correlationId,
    	String requestBody,
    	String responseBody,
    	String integrationStatus,
    	String errorMessage,
    	Decimal attemptNumber,
    	String systemName,
    	String operationName
    ) {
       Integration_Log__c log = new Integration_Log__c();
        log.Record_Id__c = String.valueOf(recordId);
        log.Correlation_Id__c = correlationId;
        log.Attempt_Number__c = attemptNumber;
        log.Error_Message__c = errorMessage;
        log.Integration_Status__c = integrationStatus;
        log.Operation_Name__c = operationName;
        log.System_Name__c = operationName;
        log.Request_Body__c = requestBody;
        log.Response_Body__c = responseBody;
        log.Status_Code__c = statusCode;

        return log;
    }
}