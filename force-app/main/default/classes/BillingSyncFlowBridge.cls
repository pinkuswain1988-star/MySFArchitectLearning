public with sharing class BillingSyncFlowBridge {
    public class flowInput {
        @InvocableVariable(required=true)
        public string billingAccountId;

        @InvocableVariable(required=true)
        public string status;
    }

    public class flowOutput {
        @InvocableVariable
        public Boolean success;

        @InvocableVariable
        public String externalRef;

        @InvocableVariable
        public string message;
    }

    @InvocableMethod(label='Call Billing Sync Integration Procedure')
    public static List<flowOutput> callBillingSync(List<flowInput> inputs) {

        List<flowOutput> outputs = new List<flowOutput>();

        for (flowInput inputRec : inputs){
            Map<String, Object> ipInput = new Map<String, Object> {
                'billingAccountId' => inputRec.billingAccountId,
                'status' => inputRec.status
            };

            Map<String, Object> options = new Map<String, Object>();
            String ipName = 'BillingAccount_Sync';

            Map<String, Object> response = (Map<String,Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(ipName, ipInput, options);
            System.debug('response: ' + response);
            flowOutput outputRec = new flowOutput();
            if (response != null) {

                outputRec.success = response.get('success') == null ? false : (Boolean) response.get('success');

                outputRec.externalRef = response.get('externalRef') == null ? null : String.valueOf(response.get('externalRef'));

                outputRec.message = response.get('message') == null ? null : String.valueOf(response.get('message'));

            }
            else {
                outputRec.success = false;
                outputRec.message = 'Integration Procedure returned empty response';
            }
                 outputs.add(outputRec);
            }
            return outputs;
        }

}