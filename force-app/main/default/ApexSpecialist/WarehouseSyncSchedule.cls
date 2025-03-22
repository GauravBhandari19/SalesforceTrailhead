global with sharing class WarehouseSyncSchedule implements Schedulable {
    
    global void execute(System.SchedulableContext context)
    {
        WarehouseCalloutService WarehouseSyncScheduleJob = new WarehouseCalloutService();
        System.enqueueJob(WarehouseSyncScheduleJob);

    }
   
}