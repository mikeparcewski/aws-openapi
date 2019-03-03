@Updates
Feature: Testing out updates

  @Smoke @Positive
  Scenario: Create record and update in same region (IU1)
    Given I am a JSON API consumer
    And I am executing test "IU1"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | mike-minus-update                             |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | new                                           |
    And record the response as "result"
    And I am a JSON API consumer
    And I am executing test "IU1-1"
    Then I request PUT "/item/{{response::result->id}}"
    And I set the JSON body from values
      | name        | mike-plus-update                              |
    And I should get a status code of 200
    And I am a JSON API consumer
    And I am executing test "IU1-2"
    Then I request GET "/item/{{response::result->id}}"
    And the response value of "name" should equal "mike-plus-update"

  @Smoke @Positive @CrossRegion
  Scenario: Create record and update in different regions (IU2)
    Given I am a JSON API consumer
    And I am executing test "IU2"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | mike-minus-update                             |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | new                                           |
    And record the response as "result"
    And I am a JSON API consumer
    And I am executing test "IU2-1"
    Then I request PUT "/item/{{response::result->id}}" on "{{vars::Alternative.Region}}"
    And I set the JSON body from values
      | name        | mike-plus-update                              |
    And I should get a status code of 200
    And I wait 3000 "MILLISECONDS"
    And I am a JSON API consumer
    And I am executing test "IU2-2"
    Then I request GET "/item/{{response::result->id}}"
    And the response value of "name" should equal "mike-plus-update"