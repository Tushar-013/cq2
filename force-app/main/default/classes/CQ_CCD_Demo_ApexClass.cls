public class CQ_CCD_Demo_ApexClass {    
    
    public CQ_CCD_Demo_ApexClass(Account acc){
        Contact c = new Contact (LastName = 'Contact@'+acc.Name, AccountId = acc.Id);
        insert c;
    }
    
    public static void processObjects()
    {        
        for(Integer i=1; i<100; i++)
        {
            String uniqueIdentifier = 'Company #'+ i;
            processRelatedItem(sortDependency(uniqueIdentifier));           
        }        
    }
    
    public static void processObjects2(){        
        Account[] accts = [Select Id From Account];        
        for(Account acct: accts){
            if(acct.AnnualRevenue != Null){
                acct.AnnualRevenue = acct.AnnualRevenue + 0.01 * acct.AnnualRevenue;
                update(acct);
            }
            
        }
    }
    
    
    public static void processObjects3(){        
        List<Opportunity> oppsList = [Select Id from Opportunity LIMIT 10];
        List<Account> acctsList = [Select Id from Account LIMIT 10];        
        for(Opportunity opp :oppsList){  
            for(Account acc :acctsList){               
                if(acc.Id == opp.AccountId){
                    opp.Description  = acc.Description;
                    database.update(opp);
                }
            }
        }
    }
    
    public static void processRelatedItem(Account acc){
        Contact c = new Contact (LastName = 'Contact@'+acc.Name, Account = acc);
        insert c;
    }
    
    public static Account sortDependency(String  accountName){
        return [SELECT id FROM Account WHERE Name =: accountName ];
    }
    
}