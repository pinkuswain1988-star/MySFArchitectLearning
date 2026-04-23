global with sharing class AccountAsyncIntegration implements vlocity_cmt.VlocityOpenInterface {
    
    // Add the 'options' parameter to the signature
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        try {
            if (methodName == 'processRequest') {
                processRequest(input, output);
                return true; // Return true to indicate method was found and executed
            }
        } catch (Exception e) {
            output.put('error', e.getMessage());
            return false;
        }
        return false;
    }

    public void processRequest(Map<String, Object> input, Map<String, Object> output) {
        String accId = (String)input.get('accountId');

        if (String.isNotBlank(accId)) {
            System.enqueueJob(new AccountQueueable(accId));
            output.put('status', 'Submitted');
        } else {
            output.put('status', 'Error: Missing Account ID');
        }
    }
}