/**
 * @description Contains methods for adding unique Ids to records, given the records and an External Id field.
 *
 * @author Carl Bussema
 * @version 1.0, 2020-09-03
 * @see TriggerHandler
 */
public without sharing class TriggerUtility {
  /**
   * @description Exception throw when the external ID field is missing or invalid according to requirements.
   *
   * @author Carl Bussema
   * @version 1.0, 2020-09-03
   * @see TriggerUtility
   */
  public class InvalidExternalIdFieldException extends Exception {
  }

  /**
   * @description uniqueIdLength The exact length of a generated unique Id.
   */
  public static final Integer uniqueIdLength = 36;

  /**
   * @description Adds unique Ids to the list of records, using a field specified
   * @param  records List of records to process. Ones with values already in the external Id field will be skipped.
   * @param externalIdField Refrence to the field to use as the external ID
   * @exception InvalidExternalIdFieldException if the specified field is not unique, not an external Id, not 36 characters, or not creatable
   */
  public static void AddUniqueIds(
    List<SObject> records,
    Schema.SObjectField externalIdField
  ) {
    //be cautious about caching DescribeFieldResults or DescribeSObject results; multiple calls could be made in one transaction for different objects.
    Schema.DescribeFieldResult dfr = externalIdField.getDescribe();
    ValidateExternalIdField(dfr, records.getSObjectType());
    string fName = dfr.getName();

    for (SObject so : records) {
      if (so.get(fName) != null) {
        continue;
      }
      so.put(fName, new Uuid().getValue());
    }
  }

  /**
   * @description Validates the external Id field is unique, external Id, long enough to hold the id, and creatable.
   * @param  dfr A DescribeFieldResult for the field
   * @param objectType The SobjectType. Only used if we have to thrown an exception, to provide better info.
   * @exception InvalidExternalIdFieldException if the field does not meet any of the criteria in the description
   */
  private static void ValidateExternalIdField(
    Schema.DescribeFieldResult dfr,
    SObjectType objectType
  ) {
    if (
      !dfr.isExternalId() ||
      !dfr.isUnique() ||
      dfr.getType() != Schema.DisplayType.STRING ||
      dfr.getLength() < uniqueIdLength
    ) {
      throw new InvalidExternalIdFieldException(
        String.format(
          'Invalid field \'{0}\' specified on {5}. Must be a unique external ID string with at least {1} characters. Field has {2} chars and {3} unique and {4} external and is type {6}',
          new List<object>{
            dfr.getName(),
            uniqueIdLength,
            dfr.getLength(),
            dfr.isUnique() ? 'is' : 'is NOT',
            dfr.isExternalId() ? 'is' : 'is NOT',
            objectType,
            dfr.getType()
          }
        )
      );
    }
  }
}