public class SavepointDemo {
    public static void run() {
        
        try{
            SavePoint sp1 = Database.setSavepoint();
            insert new Account (Name='Savepoint1');

            SavePoint sp2 = Database.setSavepoint();
            insert new Account (Name=null);
            Database.rollback(sp2);
        }
        catch(Exception e ){
            System.debug('Rolled back to savepoint');
        }
    }
}