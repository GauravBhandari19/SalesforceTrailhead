public with sharing class AddPrimaryContact implements Queueable {

    private Contact globalContact;
    private String globalState;


    public AddPrimaryContact(Contact c, String s) {
        this.globalContact = c;
        this.globalState = s;
    }


    public void execute(QueueableContext context) {
        List<Account> accounts = [select id from Account where BillingState = :this.globalState LIMIT 200];
        List<Contact> contactToAdd = new List<Contact>();

        for (Account a: accounts)
        {
            Contact cloneContact = globalContact.clone();
            cloneContact.AccountId = a.Id;
            contactToAdd.add(cloneContact);
        }
        insert contactToAdd;

    }
}