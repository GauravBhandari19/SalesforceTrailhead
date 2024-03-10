public with sharing class LeadProcessor implements Database.Batchable<sObject>{

    // Start Message that returns a Query Locator
    public Database.QueryLocator start (Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select id from Lead');
    }

    // Execute Message 
    public void execute(Database.BatchableContext bc, List<Lead> scope)
    {
        List<Lead> toUpdate = new List<Lead>();

        for (Lead c: scope)
        {
            System.debug('Test Account');
            c.LeadSource = 'Dreamforce';
            toUpdate.add(c);
        }

        update toUpdate;    
    }

    public void finish(Database.BatchableContext bc)
    {
        System.debug('Finished');
    }
}