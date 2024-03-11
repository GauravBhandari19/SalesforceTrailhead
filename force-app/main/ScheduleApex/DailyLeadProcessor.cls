public with sharing class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext sc)
    {
        List<Lead> leads = [select id from Lead where LeadSource ='' LIMIT 200];
        List<Lead> toupdate = new List<Lead>();

        for (Lead l : leads)
        {
            Lead le = new Lead();
            le=l;
            le.LeadSource = 'Dreamforce';
            toupdate.add(le);
        }
        update toupdate;
        
    }
}