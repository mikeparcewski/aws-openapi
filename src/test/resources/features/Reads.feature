@Reads
Feature: Read tests

  @Smoke @Positive
  Scenario: Making sure API is up (IR1)
    Given I am a JSON API consumer
    And I am executing test "IR1"
    When I request GET "/items"
    Then I should get a status code of 200