@isTest
private class MaintenanceRequestHelperTest {

@TestSetup
static void makeData(){
    String suppliedEmail= 'someemail@gmail.com';    
    List<Case> casesToAdd = new List<Case>();
        for (Integer i=0; i<100;i++)
        {
            Case c = new Case(Type='Routine Maintenance', SuppliedEmail=suppliedEmail+i);
            casesToAdd.add(c);
        }
        for (Integer i=0; i<100;i++)
        {
            Case c = new Case(Type='Repair', SuppliedEmail=suppliedEmail+i);
            casesToAdd.add(c);
        }
        try{
            insert casesToAdd;   
        }
        catch(Exception e)
        {
            System.debug('Exception:'+e);
        }
        
    
    List<Equipment_Maintenance_Item__c> emi = new List<Equipment_Maintenance_Item__c>();

    Product2 p = new Product2(name='Generator 1000 kW', Maintenance_Cycle__c=100, Cost__c=100, Replacement_Part__c=true);
    insert p;

    System.debug('PRODUCT===>'+p);
    
    for(Integer i=0;i<casesToAdd.size();i++)
    {
        //Equipment_Maintenance_Item__c e = new Equipment_Maintenance_Item__c(Maintenance_Request__c=casesToAdd[i].Id, Equipment__c='01td20000068dqLAAQ');

        Equipment_Maintenance_Item__c e = new Equipment_Maintenance_Item__c(Maintenance_Request__c=casesToAdd[i].Id, Equipment__c=p.id);
        System.debug('INSIDE==>'+p.Maintenance_Cycle__c);
        emi.add(e);
    }

    insert emi;
    Integer maintainenceCycle = (Integer)p.Maintenance_Cycle__c;
    System.debug('EMI==>'+emi);
    System.debug('Main Cycle==>'+maintainenceCycle);
   
    
}

    @isTest //Test TRIGGER
    static void testTrigger() {


        List<Equipment_Maintenance_Item__c> emi = [SELECT id, name, equipment__c, equipment__r.Maintenance_Cycle__c from Equipment_Maintenance_Item__c];
        //Find smallest number
        Integer lowestNumber = 20000;
        for (Equipment_Maintenance_Item__c e: emi)
        {
            //System.debug('Cycle==>'+ e.Equipment__c);
            System.debug('Cycle==>'+ e.Equipment__r.Maintenance_Cycle__c);
            Integer checkNumber = (Integer) e.Equipment__r.Maintenance_Cycle__c;
            if (checkNumber < lowestNumber)
            {
                lowestNumber = checkNumber;
            }
        }
        System.assertEquals(100, lowestNumber);



        //**************************** */
        List<Product2> prod = [Select id, name, Maintenance_Cycle__c from Product2 LIMIT 100];
        //System.debug('Starting Product Sync======>'+prod);
        //System.debug('Starting Product Sync======>');
        //List<Object> v1 = prod;
        for (Product2 p : prod)
        {
            //System.debug('Main==>'+p.Maintenance_Cycle__c);
            System.debug(prod);
    
        }
        //**************************** */
        String suppliedEmail= 'someemail@gmail.com';

        List<Case> existingCases =[SELECT id from Case where SuppliedEmail Like :suppliedEmail+'%'];
        List<Case> newCases = new List<Case>();

        for(Case c: existingCases)
        {
            c.Status= 'Closed';
            newCases.add(c);
        }
        update newCases;

        
        
        
        List<Case> getList = [SELECT id from Case where SuppliedEmail Like :suppliedEmail+'%'];
        System.debug(getList+'SIZE===>'+getList.size());
        System.assertEquals(200, getList.size(), 'Matches');

    }

    @isTest
    public static void testCallout()
    {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
            System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        List<Product2> externalData = [SELECT id, name from product2];
        //System.debug('TRY====>'+externalData);
        System.assertEquals(1, externalData.size(), 'Number');


    }

    @isTest
    public static void testScheduler()
    {
        //String CRON_EXP = '0 0 0 15 3 ? 2042';
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