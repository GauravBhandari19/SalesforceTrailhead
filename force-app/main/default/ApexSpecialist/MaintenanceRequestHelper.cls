public with sharing class MaintenanceRequestHelper {
    public MaintenanceRequestHelper(List<Case> cases) {
         // Below is bulkified Code 

    
    
    // Fetch only relevant cases and consider them 


    List<Case> allroutineCases = new List<Case>();
    for(Case c: cases)
    {
        if(c.type == 'Routine Maintenance' || c.type == 'Repair')
        {
            allroutineCases.add(c);
        }
    }

    List<Equipment_Maintenance_Item__c> emi = [select id, Name, Equipment__c,Equipment__r.Maintenance_Cycle__c, Maintenance_Request__c from Equipment_Maintenance_Item__c where Maintenance_Request__c IN :allroutineCases];

    Integer lowestNumber = 2000;

    //Find smallest number
    for (Equipment_Maintenance_Item__c e: emi)
    {
        //System.debug('Cycle==>'+ e.Equipment__r.Maintenance_Cycle__c);
        Integer checkNumber = Integer.valueOf(e.Equipment__r.Maintenance_Cycle__c);
        if (checkNumber < lowestNumber)
        {
            lowestNumber = checkNumber;
        }
    }
    System.debug('LIST==>'+emi);

    List<Case> newCases = new List<Case>();

    for(Case c:allroutineCases)
    {
        Case newCase = new Case();
        newCase.status = 'New';
        newCase.Subject = c.Subject;
        newCase.Vehicle__c = c.Vehicle__c;
        newCase.type = c.type;
        newCase.BusinessHoursId=c.BusinessHoursId;
        newCase.Priority = c.Priority;
        newCase.Date_Reported__c = Date.today();
        newCase.Date_Due__c = Date.today()+lowestNumber;
        newCases.add(newCase);

    }
    
    insert newCases;
    
    List<Equipment_Maintenance_Item__c> Newemi = new List<Equipment_Maintenance_Item__c>();

    Map<Id, Id> caseIdMap = new Map<Id,Id>();
    for (Integer i = 0; i < allroutineCases.size(); i++) {
        caseIdMap.put(newCases[i].Id, allroutineCases[i].Id);
    }
    
    for (Equipment_Maintenance_Item__c item : emi) {
        Id newCaseId = null;
        for (Id id : caseIdMap.keySet()) {
            if (caseIdMap.get(id) == item.Maintenance_Request__c) {
                newCaseId = id;
                break;
            }
        }
        if (newCaseId != null) {
            Equipment_Maintenance_Item__c newItem = new Equipment_Maintenance_Item__c(
                Equipment__c = item.Equipment__c,
                Maintenance_Request__c = newCaseId
            );
            newEmi.add(newItem);
        }
    }


    insert (Newemi);


    }
}