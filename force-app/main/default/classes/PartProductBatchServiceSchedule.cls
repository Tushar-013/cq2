/*
*********************************************************
Apex Class Name    : PartProductBatchServiceSchedule
Created Date       : 10-05-2023
@description       : This class is used to schedule PartProductBatchServiceSchedule batch class
@author            : Gaurav Gupta
Modification Log:
Ver   Date         Author                               Modification
1.0   10-05-2023   Gaurav Gupta                         Initial Version
*********************************************************
Code to schedule
PartProductBatchServiceSchedule sa = new PartProductBatchServiceSchedule();
string expression='0 0 6 ? * * *';
system.schedule('PartProductBatchServiceSchedule', expression, sa);
*/
public without sharing class PartProductBatchServiceSchedule implements schedulable {
    public static final String CQ_ADMIN_PERMISSION_SET_NAME = 'CQ_Admin';
    public void execute(SchedulableContext sc) {
        List<User> u  = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId() AND Profile.Name = 'System Administrator'];
        if(!u.isEmpty() && FeatureManagement.checkPermission('Is_allow_to_run_PartProductBatchService')) {
            System.debug('is Allowed to run');
            Database.executeBatch(new PartProductBatchService());
        }
    }
}