public with sharing class LeadProcessor implements Database.Batchable<sObject>{
    public Database.QueryLocator start (Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select id from Lead');
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope)
    {
        for (Lead c: scope)
        {
            System.debug('Test Account');
        }

    }

    public void finish(Database.BatchableContext bc)
    {
        System.debug('Finished');
    }
}