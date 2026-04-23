public with sharing class AccountMockSyncQueueable implements Queueable, Database.AllowsCallouts{

    private Set<Id> accountIds;
    private Static final Integer MAX_RETRY = 3;
    public AccountMockSyncQueueable(Set<Id> accIds) {
        this.accountIds = accIds;
    }

    public void execute(QueueableContext context){
        List<Account> accList = [
            SELECT Id, Name, Send_To_Mock__c, Mock_Status__c, Mock_Response__c,
                   Retry_Count__c, Integration_Status__c, Correlation_Id__c
            FROM Account
            WHERE Id IN :accountIds
        ];

        List<Account> updates = new List<Account>();
        List<Integration_Log__c> logList = new List<Integration_Log__c>();

        for(Account acc : accList){
            if(acc.Send_To_Mock__c != true){
                continue;
            }
            
            if(acc.Integration_Status__c == 'Success'){
                continue;
            }

            Integer currentRetry = acc.Retry_Count__c == null ? 0 : Integer.valueOf(acc.Retry_Count__c);
            String CorrelationId = acc.Correlation_Id__c;
            
            if(String.isBlank(CorrelationId)){
                CorrelationId = String.valueOf(Crypto.getRandomLong());
            }
			
            Account upd = new Account(Id = acc.Id);
            upd.Correlation_Id__c = CorrelationId;
            String requestBody = '';
            String responseBody = '';
            String statusCode = '';
            String IntegrationStatus = '';
            String errorMessage = '';
            
            if(String.isBlank(acc.Name)){
                upd.Integration_Status__c = 'Failed';
                upd.Mock_Response__c = 'Validation failed: Name is required';
                updates.add(upd);
                logList.add(IntegrationLogger.logEntry(
                	acc.Id,
    				statusCode,
    				CorrelationId,
    				requestBody,
    				responseBody,
    				IntegrationStatus,
    				errorMessage,
    				currentRetry,
    				'PostmanMock',
    				'account-sync'
                	));
                continue;
            }
            
            if(currentRetry >= MAX_RETRY){
                Continue;
            }

            if(acc.Send_To_Mock__c == true){
                HttpRequest req = new HttpRequest();
                HttpResponse resp = new HttpResponse();
                req.setMethod('POST');
                req.setEndpoint('callout:PostmanMock/account-sync');
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Accept', 'application/json');

                Map<String,Object> body = new Map<String,Object>();
                body.put('accountId',acc.Id);
                body.put('accountName',acc.Name);
                body.put('correlationId', CorrelationId);

                requestBody = JSON.serialize(body);
                req.setBody(requestBody);

                Http http = new Http();
                try{
                    resp = http.send(req);

                    upd.Mock_Status__c = String.valueOf(resp.getStatusCode());
                    statusCode = String.valueOf(resp.getStatusCode());
                    upd.Mock_Response__c = resp.getBody();
                    responseBody = resp.getBody();

                    if(resp.getStatusCode() == 200 && !String.isBlank(resp.getBody())){
                        upd.Integration_Status__c = 'Success';
                        IntegrationStatus = 'Success';
                        Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(resp.getBody());

                        if(responseMap.containsKey('externalRef')){
                            upd.Mock_External_Ref__c = String.valueOf(responseMap.get('externalRef'));
                        }
                    }
                    else if(resp.getStatusCode() == 500 || resp.getStatusCode() == 502 ||
                        resp.getStatusCode() == 503 || resp.getStatusCode() == 504){
                        currentRetry++;
                        upd.Retry_Count__c = currentRetry;

                        if(currentRetry < MAX_RETRY){
                        upd.Integration_Status__c = 'Retrying';
                        IntegrationStatus = 'Retrying';
                    	}
                        else{
                        upd.Integration_Status__c = 'Max Retry Reached';
                        IntegrationStatus = 'Max Retry Reached';
                    	}
                    }
                    else{
                        upd.Integration_Status__c = 'Failed';
                    }
                }
                catch (Exception e) {
                    currentRetry++;
                    
                    upd.Mock_Response__c = 'Exception: ' + e.getMessage();
                    errorMessage = 'Exception: ' + e.getMessage();
                    upd.Retry_Count__c = currentRetry;

                    if(currentRetry < MAX_RETRY){
                        upd.Integration_Status__c = 'Retrying';
                        IntegrationStatus = 'Retrying';
                    }
                    else{
                        upd.Integration_Status__c = 'Max Retry Reached';
                        IntegrationStatus = 'Max Retry Reached';
                    }
                }
                
            }
            updates.add(upd);
            logList.add(IntegrationLogger.logEntry(
                	acc.Id,
    				statusCode,
    				CorrelationId,
    				requestBody,
    				responseBody,
    				IntegrationStatus,
    				errorMessage,
    				currentRetry,
    				'PostmanMock',
    				'account-sync'
                	));
        }
        if(!updates.isEmpty()){
            update updates;
        }
        if(!logList.isEmpty()){
            insert logList;
        }
        
        
    }
}