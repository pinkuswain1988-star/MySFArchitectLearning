public class ErrorLoggerQueueableTriggerGuard implements Queueable{
    private List<String> msgs;
    public ErrorLoggerQueueableTriggerGuard(List<String> msgs) {
        this.msgs = (msgs == null) ? new List<String>() : msgs;
    }
    public void execute(QueueableContext context){
        for(String msg : msgs){
            System.debug('Log: ' + msg);
        }
    }
}