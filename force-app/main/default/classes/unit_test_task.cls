public class unit_test_task {

    public static void test(){
        
        compliancequest__SQX_Part_Family__c cspf = new compliancequest__SQX_Part_Family__c();
        cspf.Name = 'test Family';
        insert cspf;
        
      compliancequest__SQX_Part__c csp = new compliancequest__SQX_Part__c();
        csp.Name = 'test';
        csp.compliancequest__Part_Number__c = '12345';
        csp.compliancequest__Part_Risk_Level__c = 1;
        csp.compliancequest__Part_Family__c = cspf.id;
        insert csp;
        
        
    }
    
}