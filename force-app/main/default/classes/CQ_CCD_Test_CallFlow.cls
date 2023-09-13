/* 
 * Write unit test code for the CQ_CCD_CallFlow
*/

@isTest
public class CQ_CCD_Test_CallFlow {
    public static testmethod void testGivenCQ_CCD_CallFlow(){

        //Arrange: Create Account
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.AnnualRevenue = 5000;
        insert acc;
        
        //Arrange: Invoke flow
        Map<String, Object> params = new Map<String, Object>();
        
        Test.startTest();
        params.put('recordId', acc.Id);
        Flow.Interview.CQ_CCC_Assessment fetchAnnualRevenue = new Flow.Interview.CQ_CCC_Assessment(params);
        fetchAnnualRevenue.start();
        Test.stopTest(); 
        
        Decimal returnValue = (Decimal) fetchAnnualRevenue.getVariableValue('annualRevenue');
        System.assertEquals(acc.AnnualRevenue, returnValue);
    
    }
}