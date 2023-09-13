@isTest
public class PartCreationAndTaskCreation_Test {
    

    @Testsetup
    public static void testRecords(){
       
         
        compliancequest__SQX_Part_Family__c cPartFamily = New compliancequest__SQX_Part_Family__c();
        cPartFamily.Name = 'Test Family';
        Insert cPartFamily;
        
        compliancequest__SQX_Part__c cPart = New compliancequest__SQX_Part__c();
        
        cPart.compliancequest__Active__c = false;
        cPart.compliancequest__Part_Number__c = '001';
        cPart.compliancequest__Part_Risk_Level__c =3;
        cPart.compliancequest__Part_Family__c = cPartFamily.id;
        cPart.Name = 'test001';        
       // cPart.compliancequest__Reason_For_Change__c
        insert cPart;
        Task tk = New Task(subject = 'Review Part-001', ActivityDate = date.today()+7 ,OwnerId = UserInfo.getUserId(),status ='Not Started' );
        insert tk;
        
    }
    
    @isTest
    private static void testPartAndTaskMethod(){

        PermissionSet ps = [
            select Id
            from PermissionSet
            where Name = 'CQ_System_Administrator'
        ];
        
        Profile profile = [
            select Id
            from Profile
            where Name = 'Standard User'
        ];
        
        User testUser = new User(
            alias = 'testuser',
            email = 'testuser@myexample.com',
            emailencodingkey = 'UTF-8',
            lastname = 'Testing',
            languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            profileid = profile.Id,
            timezonesidkey = 'America/New_York',
            username = 'testuser@myexample.com'
        );
        insert testUser;
        
        PermissionSetAssignment assignment = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = ps.Id
        );
        insert assignment;
        
        Test.startTest();
        System.runAs(testUser) {
            
            Task task = [SELECT Status FROM Task Where Status ='Completed' limit 1];
            
            system.assertEquals(New Task(Status='Completed'), task, 'msg');
        }
        Test.stopTest();  
    }
}