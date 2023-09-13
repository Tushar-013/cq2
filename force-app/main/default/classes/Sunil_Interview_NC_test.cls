@istest
public class Sunil_Interview_NC_test {
@testsetup
    public static void testsetup(){
   List<case> caselist = new List<case>();
    
    //Create a new standard user
    User testUser = new User(
        FirstName = 'Test',
        LastName = 'User',
        Email = 'testuser@example.com',
        Username = 'sunilkumar123@exampleusername.com',
        Alias = 'testuser',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US'
        );
        
    // Set a profile for the user
    Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        testUser.ProfileId = profile.Id;
        insert testUser;
        
    //create part family
    compliancequest__SQX_Part_Family__c partfamily = new compliancequest__SQX_Part_Family__c();
        partfamily.Name = 'test';
        insert partfamily;
        
       compliancequest__SQX_Part__c part = new compliancequest__SQX_Part__c(); 
        part.Name ='test';
        part.compliancequest__Part_Number__c ='1234';
        part.compliancequest__Part_Family__c =partfamily.Id;
        part.compliancequest__Part_Risk_Level__c = 3;
        insert part;
        
    compliancequest__SQX_Department__c dept = new compliancequest__SQX_Department__c();
        dept.Name = 'test';
        insert dept;
        
    //Create Case problem type
    Case nccase = new case();
    	nccase.Status = 'New';
    	nccase.Subject = 'sub4324';
    	nccase.Description ='Descr23424';
        nccase.Type = 'Problem';
        
	//Create normal case
	case normalcase = new case();
    normalcase.Status = 'New';
    normalcase.Subject = 'Phone';
    normalcase.Description = 'test';
    normalcase.Type = 'Question';
    caselist.add(normalcase);
        
    insert caselist;

    }
    
    
    @istest
    public static void createCaseWithoutPermission(){
    
    //get user
    User stduser = [select id from user where FirstName = 'Test' Limit 1];
    system.runAs(stduser){
        
    //Create case without permission set
    case case1 = new case();
    case1.Subject = 'Phone';
    case1.Description = 'test';
    case1.Type = 'Problem';
    database.SaveResult SaveResult = Database.insert(case1, false);
        
    //Assert : case record should not create or update
    system.assertEquals(false, SaveResult.isSuccess(), 'case record should not create but created');
        
    //Create Case problem type
    Case nccase = new case();
    	nccase.Status = 'New';
    	nccase.Subject = 'sub4324';
    	nccase.Description ='Descr23424';
        nccase.Type = 'Question';
        insert nccase;
    
    //update case
    nccase.Type = 'Problem';
   
    SaveResult = Database.update(nccase, false);
     
    //Assert  : case record should not create or update
    system.assertEquals(false, SaveResult.isSuccess(), 'case record should not update but update');
        
    }
    }
    
    @istest
    public static void createCasewithtypeProblem(){
    
    //get user
    User stduser = [select id from user where FirstName = 'Test' Limit 1];
	
    // Set a profile for the user  with CQ admin exr permissions
   PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin_Extended_Permissions' Limit 1];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = stduser.Id;
        psa.PermissionSetId = ps.Id;
        insert psa; 
    system.runAs(stduser){
      //create case  
     case case1 = new case();
    case1.Subject = 'Phone';
    case1.Description = 'test';
    case1.Type = 'Problem';
    insert case1;
        
     //check nc
     List<case> caserec1 = [select id,CQ_CAN_SQX_NC_Reference__c from case where id=: case1.Id];
        
    //Assert : check nc is created or not
    system.assertEquals(1,caserec1.size(),'nc record should create but not created');
    }
    }
    
    @istest
    public static void updateCasewithProbleType(){
    
     //get user
    User stduser = [select id from user where FirstName = 'Test' Limit 1];
	
    // Set a profile for the user  with CQ admin exr permissions
   PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Admin_Extended_Permissions' Limit 1];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = stduser.Id;
        psa.PermissionSetId = ps.Id;
        insert psa; 
    system.runAs(stduser){
        
    //Create Case problem type
    Case nccase = new case();
    	nccase.Status = 'New';
    	nccase.Subject = 'sub4324';
    	nccase.Description ='Descr23424';
        nccase.Type = 'Question';
        insert nccase;
        
    //Update case
    nccase.Type = 'Problem';
    update nccase;
    
    //check nc
    List<case> caserec1 = [select id,CQ_CAN_SQX_NC_Reference__c from case where id=: nccase.Id];
        
    //Assert : check nc is created or not
    system.assertEquals(1,caserec1.size(),'nc record should create but not created');
    }
  }
}