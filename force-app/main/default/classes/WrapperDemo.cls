public class WrapperDemo {
    public static SimpleResponse CreateAccount(String name) {
        SimpleResponse r = new SimpleResponse();
        try{
        Account acc = new Account(Name=name);
        insert acc;
        r.OK = true;
        r.Message = 'Account created successfully';
        }
        catch(Exception e){
            r.OK = false;
            r.Message = 'Account creation failed';
            r.Message += 'Error: ' + e.getMessage();
            r.Message += 'Line Number: ' + e.getLineNumber();
            r.Message += 'Stack Trace:';
            r.errors.add(e.getMessage());
        }
        return r;

    }
}