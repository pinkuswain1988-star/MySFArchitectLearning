trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    try{
        ContactHandler.run();
    }
    catch(Exception e){
        throw e;
    }
}