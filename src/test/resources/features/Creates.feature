@Creates
Feature: Some quick tests

  @Smoke @Negative
  Scenario: Not a valid request, missing some required fields (IC1)
    Given I am a JSON API consumer
    And I am executing test "IC1"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | {{faker::name.firstName,en-US::name}}         |
      | description | {{faker::lorem.paragraph,en-US::description}} |
    And I should get a status code of 400

  @Smoke @Negative
  Scenario: Not a valid request, invalid label (IC2)
    Given I am a JSON API consumer
    And I am executing test "IC2"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | {{faker::internet.uuid,en-US::name}}          |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | bad                                           |
    And I should get a status code of 400


  @Smoke @Positive
  Scenario: Create record and validate in same region (IC3)
    Given I am a JSON API consumer
    And I am executing test "IC3"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | {{faker::internet.uuid,en-US::name}}          |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | new                                           |
    And record the response as "result"
    And I am a JSON API consumer
    And I am executing test "IC3-1"
    Then I request GET "/item/{{response::result->id}}"
    And I should get a status code of 200
    And the response value of "name" should equal "{{cache::name}}"

  @Smoke @Positive @CrossRegion
  Scenario: Create record and validate in another region (IC4)
    Given I am a JSON API consumer
    And I am executing test "IC4"
    When I request POST "/item"
    And I set the JSON body from values
      | name        | {{faker::internet.uuid,en-US::name}}          |
      | description | {{faker::lorem.paragraph,en-US::description}} |
      | labels[0]   | new                                           |
    And record the response as "result"
    And I wait 3000 "MILLISECONDS"
    And I am a JSON API consumer
    And I am executing test "IC4-1"
    Then I request GET "/item/{{response::result->id}}" on "{{vars::Alternative.Region}}"
    And I should get a status code of 200
    And the response value of "name" should equal "{{cache::name}}"

