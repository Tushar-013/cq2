@isTest private class MixedDML { 
    static testMethod void mixedDMLExample() { 
        User u; 
        Account a; 
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        // Insert account as current user 
        System.runAs (thisUser) { 
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            u = new User(alias = 'jsmith', 
                         email='jsmith@acme.com',
                         emailencodingkey='UTF-8', lastname='Smith', 
                         languagelocalekey='en_US', 
                         localesidkey='en_US', profileid = p.Id, 
                         timezonesidkey='America/Los_Angeles',
                         username='jsmith@ac12312sadsfasdfad2312312me.com'); 
            insert u;
            a = new Account(name='Acme'); insert a; 
        } 
    } 
}