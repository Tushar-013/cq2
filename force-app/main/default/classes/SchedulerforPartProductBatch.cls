/**
 * This class is a scheduler for the BatchforAttachingProductstoPart batch class 
 */
public without sharing class SchedulerforPartProductBatch implements schedulable {
    public void execute(SchedulableContext sc) {
        List<User> u  = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() AND Profile.Name = 'System Administrator'];
        if(!u.isEmpty() && FeatureManagement.checkPermission('Allow_Part_Product_Linking')) {
            System.debug('run by admin');
            Database.executeBatch(new BatchforAttachingProductstoPart());
        }
    }
}