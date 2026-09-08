@report @report_ai_analysis @javascript
Feature: Delete AI Analysis Reports
  In order to manage old or unwanted reports
  As a teacher with delete capability
  I need to be able to delete reports with confirmation

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | One      | teacher1@example.com |
      | teacher2 | Teacher   | Two      | teacher2@example.com |
      | manager1 | Manager   | One      | manager1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | teacher2 | C1     | editingteacher |
      | manager1 | C1     | manager        |
    And the following "report_ai_analysis > reports" exist:
      | title              | course | user     | status    | prompt                | queue_task |
      | Report to Delete   | C1     | teacher1 | completed | Test analysis         | 0          |
      | Another Report     | C1     | teacher1 | pending   | Another test          | 1          |
      | Teacher2 Report    | C1     | teacher2 | completed | Teacher 2's analysis  | 0          |
    And the AI analysis backend is configured

  Scenario: Teacher can see delete link for their own reports
    Given I am on the "Course 1" "Course" page logged in as "teacher1"
    When I navigate to "Reports > AI Conversation Analysis" in current page administration
    Then I should see "Delete" in the "Report to Delete" "table_row"
    And I should see "Delete" in the "Another Report" "table_row"

  Scenario: Manager can delete any report
    Given I am on the "Course 1" "Course" page logged in as "manager1"
    And I navigate to "Reports > AI Conversation Analysis" in current page administration
    When I click on "Delete" "link" in the "Teacher2 Report" "table_row"
    And I press "Continue"
    Then I should see "Report deleted successfully"
    And I should not see "Teacher2 Report"

  Scenario: Deleting a pending report removes it from queue
    Given I am on the "Course 1" "Course" page logged in as "teacher1"
    And I navigate to "Reports > AI Conversation Analysis" in current page administration
    And I remember AI analysis report "Another Report"
    And AI analysis report "Another Report" should have "1" queued tasks
    When I click on "Delete" "link" in the "Another Report" "table_row"
    And I press "Continue"
    Then I should see "Report deleted successfully"
    And I should not see "Another Report"
    And AI analysis report "Another Report" should have "0" queued tasks

  Scenario: Cancelling pending work invalidates its generation and removes its task
    Given I am on the "Course 1" "Course" page logged in as "teacher1"
    And I navigate to "Reports > AI Conversation Analysis" in current page administration
    And I remember AI analysis report "Another Report"
    When I click on "Cancel" "link" in the "Another Report" "table_row"
    Then I should see "Report cancelled successfully"
    And AI analysis report "Another Report" should have "status" "cancelled"
    And AI analysis report "Another Report" should have "0" queued tasks

  Scenario: Destructive actions reject an invalid session key even for the owner
    Given I am on the "Course 1" "Course" page logged in as "teacher1"
    Then a direct "delete" request for AI analysis report "Report to Delete" with an invalid sesskey should be denied
    And a direct "cancel" request for AI analysis report "Another Report" with an invalid sesskey should be denied
