@isTest

public with sharing class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2042';

    @isTest
    static void testJob()
    {
        List<Lead> toCreate = new List<Lead>();


        for (Integer i=0; i<200; i++)
        {
            Lead l = new Lead();
            l.FirstName='Test';
            l.LastName='Test';
            l.Company='test';
            toCreate.add(l);
        }
        insert toCreate;

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP,
            new DailyLeadProcessor());

        Test.stopTest();

    }
}