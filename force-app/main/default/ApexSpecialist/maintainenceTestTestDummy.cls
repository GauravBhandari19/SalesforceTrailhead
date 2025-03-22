@isTest
public class maintainenceTestTestDummy {

    @isTest
    static void testTrigger() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = account.Id);
        insert contact;

        Product2 equipment = new Product2(Name = 'Test Equipment', Warehouse_SKU__c = 'TEST001');
        insert equipment;

        Equipment_Maintenance_Item__c emi = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = '500d200000QE7InAAL',
            Equipment__c='01td20000068dqLAAQ'
        );
        insert emi;

        equipment.Maintenance_Cycle__c = 30;
        update equipment;

        Case testCase = new Case(
            Subject = 'Test Case',
            Type = 'Routine Maintenance',
            Status = 'Open',
            Priority = 'Medium',
            Vehicle__c = null // Update if necessary
        );
        insert testCase;

        emi.Maintenance_Request__c = testCase.Id;
        update emi;

        testCase.Status = 'Closed';
        update testCase;

        List<Case> newCases = [SELECT Id, Subject FROM Case WHERE Subject = :testCase.Subject AND Status = 'New'];
        System.assert(newCases.size() == 1, 'New case was not created');

        Case newCase = newCases[0];
        Date dueDate = Date.today() + (Integer) equipment.Maintenance_Cycle__c;
        System.assert(newCase.Date_Due__c == dueDate, 'Due date is incorrect');


        List<Equipment_Maintenance_Item__c> newEmi = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Equipment__c = :equipment.Id AND Maintenance_Request__c = :newCase.Id];
        System.assert(newEmi.size() == 1, 'New equipment maintenance item was not created');
    }

    
}
