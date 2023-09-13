@isTest
public class CQ_CCD_AccountTriggerTest{
    public static testmethod void testit(){
        List<Account> a_list = new List<Account>();
        for(Integer i=0; i<200; i++){
            Account a = new Account();
            a.Name = 'Name ' + i;
            a_list.add(a);
        }
        insert a_list;
        
        Test.startTest();        
        CQ_CCD_AccountProcessor ap = new CQ_CCD_AccountProcessor();
        Id batchId = Database.executeBatch(ap);
        Test.stopTest();
    }
}