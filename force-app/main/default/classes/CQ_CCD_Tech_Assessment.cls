/*
* 
*/
public class CQ_CCD_Tech_Assessment {    
    
    public CQ_CCD_Tech_Assessment(Account acc){
        Contact c = new Contact (LastName = 'Contact@'+acc.Name, AccountId = acc.Id);
        insert c;
    }
    
    public static void CQ_CCD_assessment1(){
        for(integer i=1;i<100;i++){
            String uniqueIdentifier = 'Company #'+i;
            processRelatedItem(sortDependency(uniqueIdentifier));
        }
    }
    
    public static void CQ_CCD_assessment2(){        
        Account[] accts = [Select Id, AnnualRevenue From Account];        
        for(Account acct: accts){
            if(acct.AnnualRevenue != Null){
                acct.AnnualRevenue = acct.AnnualRevenue + 0.01 * acct.AnnualRevenue;
                update(acct);
            }
            
        }
    }
    
    
    public static void CQ_CCD_assessment3(){        
        List<Opportunity> oppsList = [Select AccountId, Name from Opportunity LIMIT 10];
        List<Account> acctsList = [Select Id, Name from Account LIMIT 10];        
        for(Opportunity opp :oppsList){  
            for(Account acc :acctsList){               
                if(acc.Id == opp.AccountId){
                    System.debug(opp.Name + ' : ' + acc.Name);
                }
            }
        }
    }
    
    public static void processRelatedItem(Account acc){
        Contact c = new Contact(LastName = 'Contact@'+acc.Name,Account = acc);
        insert c;        
    }
    
    public static void CQ_CCD_assessment4(){        
        List<Opportunity> oppsList = [Select AccountId, Name from Opportunity LIMIT 10];
        List<Account> acctsList = [Select Id, Name from Account LIMIT 10];        
        for(Opportunity opp :oppsList){  
            for(Account acc :acctsList){               
                if(acc.Id == opp.AccountId){
                    System.debug(opp.Name + ' : ' + acc.Name);
                }
            }
        }
    }
   
    public static Account sortDependency(String accName){
        return [SELECT Id,Name FROM Account WHERE Name = :accName];
    }
}