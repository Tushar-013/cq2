@isTest
public class TestFactory {

    public static User createSalesforceUserRecord(String profileName){
        List<Profile> profileToAssignToUser = new List<Profile>();
        profileToAssignToUser = [SELECT Id FROM Profile WHERE Name =: profileName];
        User userRecord = new User();
        if(profileToAssignToUser != NULL && profileToAssignToUser.size() > 0){
            userRecord = new User(
                ProfileId = profileToAssignToUser[0].Id,
                LastName = 'last name',
                Email = 'cqtestassessment@cq.com',
                Username = 'cqtestassessment@cq.com.devorg',
                CompanyName = 'CQ company',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            );
        }
        Insert userRecord;
        Return userRecord;
    }
}