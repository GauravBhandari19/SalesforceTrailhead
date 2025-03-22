@isTest
private class WarehouseSyncScheduleTest {

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        String CRON_EXP = '0 0 1 * * ?'; //seconds min hour dayof month month (optional)day of week

        Test.startTest();
           String jobID =  System.schedule('ScheduledApexTest',CRON_EXP, new WarehouseSyncSchedule());
           System.debug('JOBID==>'+jobID);
           CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobID];
           
           Date date1 = Date.today().addDays(1); // Add one day to today's date
           Time time1 = Time.newInstance(1, 0, 0, 0); // Set time to 1 AM
           DateTime newDateTime = DateTime.newInstance(date1, time1);
           

            System.debug('Newdate====>'+newDateTime);
            System.debug('NextFire===>'+ct.NextFireTime);

            System.assertEquals(ct.NextFireTime, newDateTime, 'Time Does not match');
           

           System.debug(ct);
        Test.stopTest();
    }
}