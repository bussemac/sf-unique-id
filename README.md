# sf-unique-id
Salesforce: Can be invoked from Apex Triggers or their handlers to automatically add a Guid into an external ID field

# Usage
1. Create a field on the object that you wish to have an External ID. Name it whatever, but remember the API name, you'll need it soon. It needs to be text, 36 characters (or more), unique, external ID. Case-insensitive is recommended but not checked.
1. Copy UUID and UUID Tests into your sandbox, then TriggerUtility.
1. Copy TriggerUtility_Test to your local machine.
1. Edit references to "Opportunity.ExternalGuid__c" with whatever your object & field from step 1 are. (You only need to do this for one object -- for 2nd and subsequent objects you just need to cover your trigger normally, which is left to you.)
1. Upload TriggerUtility_Test to your sandbox.
1. Create an Apex Trigger (or open your Handler class) for the object in question -- it only needs to run `before insert` 
1. Add the following line, substituting your object name and field API name
```java
TriggerUtility.AddUniqueIds(Trigger.New, Opportunity.ExternalGuid__c);
```

(you may also substitute a list instead of `Trigger.New`)

1. As noted, the TriggerUtility-Test class will work for one object. If you do this for multiple objects, each trigger must have its own apex test, but you can copy the first test in that class and just change the object / field name.

