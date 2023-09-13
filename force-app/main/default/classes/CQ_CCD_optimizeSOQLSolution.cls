public class CQ_CCD_optimizeSOQLSolution {
    public static void CQ_CCD_optimizeDMLStatement(){
        
        // Create a list to store the records
        List<Account> accList = new List<Account>();
        
        for(Integer i=1; i<10; i++){
            Account acc = new Account();
            acc.name = 'Roman' + i;
            accList.add(acc); // Create new records and add them to the list
        }
        // Insert the list outside the loop
        insert(accList);     
    }
    
    public static void optimizeSOQLStatement(){
        
        // Create a list to store the records
        List<Account> accList = new List<Account>();
        
        // Query in the loop itself
        for(Account acct: [Select Id, AnnualRevenue From Account]){
            if(acct.AnnualRevenue != Null){
                acct.AnnualRevenue = acct.AnnualRevenue + 0.01 * acct.AnnualRevenue;
            	accList.add(acct);
            } 
        }
        // Update the list outside the loop
        update(accList);
    }
    
    public static void optimizeLoops(){
        
        List<Opportunity> oppsList = [Select Id, Name from Opportunity LIMIT 10];
        
        // Use of map to replace nested for loop
        Map<Id, Account> accountsMap = new Map<Id, Account>([Select Id, Name from Account LIMIT 10]);
        for(Opportunity opp :oppsList){
            Account acc = accountsMap.get(opp.AccountId);
            System.debug(opp.Name + ' : ' + acc.Name);
        }

    }    

}