public class ErrorLoggerQueueable implements Queueable{
    private List<String> message;
    public ErrorLoggerQueueable(List<String> msg) {
        this.message = msg;
    }
    public void execute(QueueableContext context){
        for(String msg : message){
            System.debug('Logged Error: ' + msg);
        }
    }
}