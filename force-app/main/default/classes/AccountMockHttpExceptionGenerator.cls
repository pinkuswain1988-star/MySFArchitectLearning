@isTest
global class AccountMockHttpExceptionGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        throw new CalloutException('Simulated timeout or network failure');
    }
}