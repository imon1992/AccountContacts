public class VFTestController {
    public Map<Id,AccountWithContactsWrapper> accountWithContactsWrapperMap;
    public Contact newContact  {get; set;}
    public Map<String,Boolean> accountFieldsAccess  {get; set;}
    public Map<String,Boolean> contactFieldsAccessMap  {get; set;}
    public Map<String,Boolean> aviliableActionMap  {get; set;}
    public Boolean displayEditPopup {get; set;}     
    public Boolean displayNewContactPopup {get; set;}
    public Id accountIdForNewContact {get; set;}
    private String soqlForAccounts;
    
    public VFTestController(){
        //need add limit and pagination
        displayEditPopup = false;
        displayNewContactPopup = false;
        newContact = new Contact();
        getObjectsAccessAndSoqlForAccounts();
        setWrapMapForAccount();
    }

    private void getObjectsAccessAndSoqlForAccounts(){
        String[] accountFieldsToCheck = new String[] {'Name','Phone'};
        String[] contactFieldsToCheck = new String[] {'FirstName', 'LastName', 'Department'};
        Map<String,Boolean> accountFieldsAccess = new Map<String,Boolean>();
        AccountWithContactsControllerHelper accountOperation = new AccountWithContactsControllerHelper('Account');
        AccountWithContactsControllerHelper contactOperation = new AccountWithContactsControllerHelper('Contact');
        accountFieldsAccess.putAll(accountOperation.getFieldsAcces('isAccessible',accountFieldsToCheck));
        Boolean accountObjectAcces = ObjectAndFieldsAccessCheck.checkAccessToObject('Contact','isAccessible');
        accountFieldsAccess.put('Contact',accountObjectAcces);
        aviliableActionMap = contactOperation.getActionAccess();

        String soqlPart = accountOperation.getSoql(null);
        contactFieldsAccessMap = contactOperation.getFieldsAcces('isAccessible',contactFieldsToCheck);
        soqlForAccounts = soqlPart.replace('InnerSoql', contactOperation.getSoql('innerSoql'));
    }
    
    private void setWrapMapForAccount(){
        if(accountWithContactsWrapperMap == null){
            Account[] accounts = Database.query(soqlForAccounts);
            Map<Id,AccountWithContactsWrapper> wrapAccounts = new Map<Id,AccountWithContactsWrapper>();
            for(Account account:accounts){
                AccountWithContactsWrapper accountWithContacts=new AccountWithContactsWrapper(account,account.Contacts);
                wrapAccounts.put(account.Id,accountWithContacts);
            }
            accountWithContactsWrapperMap=wrapAccounts;
        }
    }

    public void createNewContact(){
        try{
            newContact.accountId = accountIdForNewContact;
            insert newContact;
            accountWithContactsWrapperMap.get(accountIdForNewContact).accountContact.put(newContact.Id,newContact);
            displayNewContactPopup = false; 
        }catch(dmlexception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Error'));
        }
    }
    
    public void editExistsContact(){
        try{
            update newContact;
            accountWithContactsWrapperMap.get(accountIdForNewContact).accountContact.put(newContact.Id,newContact);
            displayEditPopup = false;
        }catch(dmlexception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Some Error'));
        }
    }
    
    public Map<Id,AccountWithContactsWrapper> getAccounts(){
        return accountWithContactsWrapperMap;
    }

    public void closeEditPopup() {        
        displayEditPopup = false;    
    }     

    public void showEditPopup() {    
        accountIdForNewContact = ApexPages.currentPage().getParameters().get('accountId');
        Id contactId = ApexPages.currentPage().getParameters().get('contactId');
        newContact =  accountWithContactsWrapperMap.get(accountIdForNewContact).accountContact.get(contactId);
        displayEditPopup = true;    
    }

    public void closeNewAccountPopup() {
        displayNewContactPopup = false;
    }     
    
    public void showNewAccountPopup() {     
        accountIdForNewContact = ApexPages.currentPage().getParameters().get('accountId'); 
        newContact = new Contact();  
        displayNewContactPopup = true;    
    }
    
    public class AccountWithContactsWrapper{
        public Account account {get; set;}
        public Map<Id,Contact> accountContact {get; set;}
        public Set<Id> contactToDelete = new Set<Id>();
        public Boolean rerenderDeleteContactButton  {get; set;}
        public AccountWithContactsWrapper(Account account,Contact[] contacts){
            this.account = account;
            accountContact = new Map<Id,Contact>(contacts);
            if(accountContact.size() > 0){
                rerenderDeleteContactButton = true;
            }else{
                rerenderDeleteContactButton = false;
            }
        }
    }
    
    public void deleteContacts(){
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        Id[] contactIdForDeleteList = new List<Id>();
        contactIdForDeleteList.addAll(accountWithContactsWrapperMap.get(accountId).contactToDelete);
        Database.delete(contactIdForDeleteList, true);
        for(Id contactId: accountWithContactsWrapperMap.get(accountId).contactToDelete){
            accountWithContactsWrapperMap.get(accountId).accountContact.remove(contactId);
        }
    }
    
    public void addIdFofDelete(){
        Id contactIdForDelete = ApexPages.currentPage().getParameters().get('contactId');
        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
        
        if(accountWithContactsWrapperMap.get(accountId).contactToDelete.contains(contactIdForDelete)){
            accountWithContactsWrapperMap.get(accountId).contactToDelete.remove(contactIdForDelete);
        }else{
            accountWithContactsWrapperMap.get(accountId).contactToDelete.add(contactIdForDelete);
        }
    }
}