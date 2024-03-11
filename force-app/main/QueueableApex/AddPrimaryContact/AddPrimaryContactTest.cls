@isTest
public with sharing class AddPrimaryContactTest {
    @testSetup
    static void setUp(){
        List<Account> acc = new List<Account>();
        for (Integer i=0; i<50;i++)
        {
            Account a = new Account();
            a.BillingState = 'NY';
            a.Name = 'Test';
            //a.LastName = 'Test'
            acc.add(a);
            
        }
        for (Integer i=0; i<50;i++)
        {
            Account a = new Account();
            a.BillingState = 'CA';
            a.Name = 'Test';
            //a.LastName = 'test';
            acc.add(a);
        }
        insert(acc);
        
    }

    static testmethod void testQueueable()
    {
       
        Contact c = new Contact(LastName='user');
        String state = 'CA';
        AddPrimaryContact updater = new AddPrimaryContact(c, state);
        Test.startTest();
        // Test Queueable Apex
        System.enqueueJob(updater);
        Test.stopTest();
        System.assertEquals(50, [select count() from account where BillingState='CA']);

    }

}