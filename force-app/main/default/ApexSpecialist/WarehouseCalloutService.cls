public with sharing class WarehouseCalloutService implements Queueable {
   

    @future(callout=true)
    public static void runService()    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        
        List<Object> jsondata = (List<Object>) JSON.deserializeUntyped(response.getBody());
        //System.debug(jsondata);

        List<Product2> externalData = new List<Product2>();
        for(Object o : jsondata)
        {
            Product2 prod = new Product2();
            Map<String,Object> obj =    (Map<String,Object>)o;
            //prod.Id                     = (Id) obj.get('_id');
            prod.name                   = (String)obj.get('name');
            prod.Replacement_Part__c    = true;
            prod.Current_Inventory__c   = 0;
            prod.Lifespan_Months__c     = (Decimal)obj.get('lifespan');
            prod.Cost__c                = (Decimal) obj.get('cost');
            prod.Maintenance_Cycle__c   = (Decimal) obj.get('maintenanceperiod');
            prod.Warehouse_SKU__c       = (String) obj.get('sku');
            
            externalData.add(prod);
        }

        if(externalData.size()>0)
        {
            upsert externalData;
        }

    }

    public static void execute(QueueableContext context)
    {
        runService();
    }

}