@isTest
private class WarehouseCalloutServiceTest {

    @TestSetup
    static void makeData(){
        Product2 p = new Product2(name='Generator 1000 kW', Maintenance_Cycle__c=100, Cost__c=100, Replacement_Part__c=true);
        insert p;
    }
    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
            System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        List<Product2> externalData = [SELECT id, name from product2];
        //System.debug('TRY====>'+externalData);
        System.assertEquals(1, externalData.size(), 'Number');
    }
}