@isTest
private without sharing class TriggerUtility_Test {
  @isTest
  static void CanAddExternalGuidsToObjectWhenFieldIsSpecified() {
    //we aren't going to try to actually insert this record, it doesn't have to be valid, just exist in memory.
    Opportunity o1 = new Opportunity(Name = 'Test1', ExternalGuid__c = null);
    List<Opportunity> opps = new List<Opportunity>{ o1 };

    Test.startTest();
    TriggerUtility.AddUniqueIds(opps, Opportunity.ExternalGuid__c);
    Test.stopTest();

    System.assertNotEquals(
      null,
      opps[0].ExternalGuid__c,
      'Opp record should have an External GUID'
    );
  }

  @isTest
  static void CannotAddExternalGuidsToObjectWhenBadFieldIsSpecified() {
    //we aren't going to try to actually insert this record, it doesn't have to be valid, just exist in memory.
    Opportunity o1 = new Opportunity(Name = 'Test1', ExternalGuid__c = null);
    List<Opportunity> opps = new List<Opportunity>{ o1 };

    TriggerUtility.InvalidExternalIdFieldException iex = null;

    Test.startTest();
    try {
      TriggerUtility.AddUniqueIds(opps, Opportunity.StageName);
    } catch (TriggerUtility.InvalidExternalIdFieldException ex) {
      iex = ex;
    }
    Test.stopTest();

    System.assertNotEquals(
      null,
      iex,
      'Utility should throw an exception if the specified field is not a valid External GUID'
    );
  }

  @isTest
  static void SkipsRecordsWhenTheyAlreadyHaveAnId() {
    //we aren't going to try to actually insert this record, it doesn't have to be valid, just exist in memory.
    final string eid = 'Present';

    Opportunity o1 = new Opportunity(Name = 'Test1', ExternalGuid__c = eid);
    Opportunity o2 = new Opportunity(Name = 'Test2', ExternalGuid__c = null);
    List<Opportunity> opps = new List<Opportunity>{ o1, o2 };

    Test.startTest();
    TriggerUtility.AddUniqueIds(opps, Opportunity.ExternalGuid__c);
    Test.stopTest();

    System.assertEquals(
      eid,
      opps[0].ExternalGuid__c,
      'External GUID should not be changed on record that had one already '
    );

    System.assertNotEquals(
      null,
      opps[1].ExternalGuid__c,
      'Opp record should have an External GUID after skipping record that had one already'
    );
  }
}