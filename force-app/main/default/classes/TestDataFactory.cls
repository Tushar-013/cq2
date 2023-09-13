@isTest
public class TestDataFactory {
    
    // Create user record With Permission
    public static User createUser(){
        string profileName='System Administrator';
        List<Profile> profileAssignToUser = new List<Profile>();
        profileAssignToUser = [SELECT Id FROM Profile WHERE Name =: profileName];
         User userRecord;
        if(profileAssignToUser != NULL && profileAssignToUser.size() > 0){
           userRecord = new User(
                ProfileId = profileAssignToUser[0].Id,
                FirstName = 'Test',
                LastName = 'User',
                Email = 'testuser@example.com',
                Username = 'testuser@example.com.devorg',
                CompanyName = 'Test Company',
                Title = 'Test Title',
                Alias = 'testuser',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            );
            
        }
        Insert userRecord;
        return userRecord;
    }
    public static compliancequest__SQX_Part__c createParts(String partName, String partNumber){
        compliancequest__SQX_Part_Family__c  partFamily = createFamily('Test Family');
            compliancequest__SQX_Part__c cqPart = new compliancequest__SQX_Part__c(
                Name = partName,
                compliancequest__Part_Number__c = partNumber,
                OwnerId = UserInfo.getUserId(),
                compliancequest__Active__c = false,
                compliancequest__Part_Family__c = partFamily.Id,
                compliancequest__Part_Risk_Level__c = 4
            );
        insert cqPart;
        return cqPart;
    }
    
    public static compliancequest__SQX_Part_Family__c createFamily(String familyName){
        compliancequest__SQX_Part_Family__c partFamily = new compliancequest__SQX_Part_Family__c(
            Name = familyName
        );
        insert partFamily;
        return partFamily;
    }
}