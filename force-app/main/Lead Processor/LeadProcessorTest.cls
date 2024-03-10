@isTest
public with sharing class LeadProcessorTest {
    @testSetup
    static void setup()
    {
        List<Lead> lead = new List<Lead>();

        for (Integer i=0; i<200; i++)
        {
            lead.add(
            new Lead(FirstName = 'Lead Name:'+i, LastName = 'Lead Last name', Company= 'Company')
            );
        }
        insert lead;
    }

    @isTest
    static void test()
    {
        Test.startTest(); // To Start the test
        LeadProcessor lp = new LeadProcessor();
        Id ids = Database.executeBatch(lp);
        Test.stopTest();
        System.assertEquals(200, [select count() from Lead where LeadSource = 'Dreamforce']);
    }
}