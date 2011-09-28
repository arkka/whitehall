Feature: Creating policy editions
In order to revise a policy without affecting what the public see
A policy writer
Should be able to create a new edition of a published policy

Scenario: Creating a new edition
  Given I am logged in as a policy writer
  And a published policy exists

  When I create a new edition of the published policy
  And I edit the new edition

  Then the published policy should remain unchanged