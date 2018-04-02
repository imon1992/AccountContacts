
@isTest 
public class VFTestControllerTest{
     static testMethod void testCreateNewContactSuccess(){

        Account testAccount = new Account(Name ='Test Name');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'First test name',LastName = 'Last Test Name', AccountId = testAccount.id);
        insert testContact;

        Account testAccountForAdd = new Account(Name ='Test Name1');
        insert testAccountForAdd;
        Contact testContactForAddToAccount = new Contact(FirstName = 'First test name1',LastName = 'Last Test Name1');

        VFTestController testController = new VFTestController();

        testController.accountIdForNewContact = testAccountForAdd.id;
        testController.newContact =  testContactForAddToAccount;

        Test.StartTest(); 
            testController.createNewContact();
        Test.StopTest();

        System.assertEquals(testAccount.Name, testController.wraplist.get(testAccount.id).account.Name);
        System.assertEquals(testContactForAddToAccount, testController.wraplist.get(testAccountForAdd.id).accountContact.get(testContactForAddToAccount.id));
        System.assertEquals(false, testController.displayNewContactPopup);

    }

    static testMethod void testEditExistsContactSuccess(){

        Account testAccount = new Account(Name ='Test Name');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'First test name',LastName = 'Last Test Name', AccountId = testAccount.id);
        insert testContact;
        testContact.FirstName = 'New Test Name';

        VFTestController testController = new VFTestController();

        testController.accountIdForNewContact = testAccount.id;
        testController.newContact =  testContact;

        Test.StartTest(); 
            testController.editExistsContact();
        Test.StopTest();

        System.assertEquals(testContact, testController.wraplist.get(testAccount.id).accountContact.get(testContact.id));
        System.assertEquals(false, testController.displayEditPopup);

    }

    static testMethod void testCloseEditPopup(){

        VFTestController testController = new VFTestController();

        Test.StartTest(); 
            testController.closeEditPopup();
        Test.StopTest();

        System.assertEquals(false, testController.displayEditPopup);
    }

    static testMethod void testCloseNewAccountPopup(){

        VFTestController testController = new VFTestController();

        Test.StartTest(); 
            testController.closeNewAccountPopup();
        Test.StopTest();

        System.assertEquals(false, testController.displayNewContactPopup);
    }

    static testMethod void testShowEditPopup(){
        PageReference myVfPage = Page.test;
        Test.setCurrentPage(myVfPage);

        Account testAccount = new Account(Name ='Test Name');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'First test name',LastName = 'Last Test Name',accountId = testAccount.id);
        insert testContact;

        ApexPages.currentPage().getParameters().put('accountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('contactId',testContact.id);

        VFTestController testController = new VFTestController();

        Test.StartTest(); 
            testController.showEditPopup();
        Test.StopTest();

        System.assertEquals(testContact, testController.newContact);
        System.assertEquals(true, testController.displayEditPopup);
    }

    static testMethod void testShowNewAccountPopup(){
        PageReference myVfPage = Page.test;
        Test.setCurrentPage(myVfPage);

        Account testAccount = new Account(Name ='Test Name');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'First test name',LastName = 'Last Test Name',accountId = testAccount.id);
        insert testContact;

        ApexPages.currentPage().getParameters().put('accountId',testAccount.id);

        VFTestController testController = new VFTestController();

        Test.StartTest(); 
            testController.showNewAccountPopup();
        Test.StopTest();

        System.assertEquals(testAccount.id, testController.accountIdForNewContact);
        System.assertEquals(true, testController.displayNewContactPopup);
    }

    static testMethod void testDeleteContacts(){
        PageReference myVfPage = Page.test;
        Test.setCurrentPage(myVfPage);

        Account testAccount = new Account(Name ='Test Name');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'First test name',LastName = 'Last Test Name',accountId = testAccount.id);
        Contact testContact2 = new Contact(FirstName = 'First test name',LastName = 'Last Test Name',accountId = testAccount.id);
        
        Contact[] testContacts= new List<Contact>();
        testContacts.add(testContact);
        testContacts.add(testContact2);
        insert testContacts;

        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        contactMap.putAll(testContacts);
        contactMap.remove(testContact.id);
        Set<Id> contctIdsForDeleteSet = new Set<Id>{testContact.id};
        ApexPages.currentPage().getParameters().put('accountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('contactId',testContact.id);

        VFTestController testController = new VFTestController();

        Test.StartTest();
            testController.addIdFofDelete();
            testController.deleteContacts();
        Test.StopTest();

        System.assertEquals(contactMap, testController.wraplist.get(testAccount.id).accountContact);
    }
    static testMethod void testAddIdFofDelete(){
        PageReference myVfPage = Page.test;
        Test.setCurrentPage(myVfPage);

        Account testAccount = new Account(Name ='Test Name');
        insert testAccount;
        Contact testContact = new Contact(FirstName = 'First test name',LastName = 'Last Test Name',accountId = testAccount.id);
        Contact testContact2 = new Contact(FirstName = 'First test name',LastName = 'Last Test Name',accountId = testAccount.id);
        
        Contact[] testContacts= new List<Contact>();
        testContacts.add(testContact);
        testContacts.add(testContact2);
        insert testContacts;

        Set<Id> contctIdsForDeleteSet = new Set<Id>{testContact.id};
        ApexPages.currentPage().getParameters().put('accountId',testAccount.id);
        ApexPages.currentPage().getParameters().put('contactId',testContact.id);

        VFTestController testController = new VFTestController();

        Test.StartTest(); 
            testController.addIdFofDelete();
        Test.StopTest();

        System.assertEquals(contctIdsForDeleteSet, testController.wraplist.get(testAccount.id).contactToDelete);
    }
}