@Deletes
Feature: Testing out deletes

  @Smoke @Positive
  Scenario: Create record and delete in same region (ID1)
    Given I am a JSON API consumer
    And I am executing test "ID1"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | {{faker::internet.uuid,en-US::name}}          |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | new                                           |
    And record the response as "result"
    And I am a JSON API consumer
    And I am executing test "ID1-1"
    Then I request DELETE "/item/{{response::result->id}}"
    And I should get a status code of 200

  @Smoke @Positive @CrossRegion
  Scenario: Create record and delete in same region (ID2)
    Given I am a JSON API consumer
    And I am executing test "ID2"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | {{faker::internet.uuid,en-US::name}}          |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | new                                           |
    And record the response as "result"
    And I wait 3000 "MILLISECONDS"
    And I am a JSON API consumer
    And I am executing test "ID2-1"
    Then I request DELETE "/item/{{response::result->id}}" on "{{vars::Alternative.Region}}"
    And I should get a status code of 200

#  @Smoke @Negative @Delete
#  Scenario: Try to delete a non-existent record (ID3)
#    Given I am a JSON API consumer
#    And I am executing test "ID3"
#    Then I request DELETE "/item/non-existent-key"
#    And I should get a status code of 200