public class AccountValidationHandler {
    public static void Validate(List<Account> accList) {
        List<String> errorLogs = new List<String>();
        for(Account acc : accList){
            if(acc.Name != null && acc.Name.contains('Block')){
                acc.addError('Account Name cannot be Block');
                errorLogs.add('Blocked Account: '+ acc.Name);
            }
        }
        if(!errorLogs.isEmpty()){
            System.enqueueJob(new ErrorLoggerQueueable(errorLogs));
        }
    }
}