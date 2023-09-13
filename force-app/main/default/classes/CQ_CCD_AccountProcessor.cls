global class CQ_CCD_AccountProcessor implements Database.Batchable<sObject>{
    global integer count = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id, Name From Account');
    }
    
    global void execute (Database.BatchableContext bc, List<Account> a_list){
        List<Account> a_list_new = new List<Account>();
        for(Account a : a_list){
            a.Name = 'Dreamforce';
           	a_list_new.add(a);
            count += 1;
        }
        update a_list_new;
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('Count = ' + count );
    }
}