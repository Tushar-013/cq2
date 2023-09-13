public class CQ_CCD_AccountTriggerHandler {
   
    @future(callout = true)
    public static void updatePhoneDescription() {
        System.debug('Trigger called');
    }
}