trigger AccountBlockBadNames on Account (before insert, before update) {
    for(Account acc : Trigger.new){
        if(acc.Name != null && acc.Name.contains('Bad')){
            acc.Name.addError('Account name cannot contain the word "Bad"');
        }
    }
}