Feature: Checkout dotfiles
  In order to copy binaries to a new computer
  I want a one-command way to copy them and their dependencies
  So I don't have to do it myself

  Scenario: Basic UI
    When I get help for "copypasta"
    Then the exit status should be 0
    And the following options should be documented:
      |--dry-run|
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should include the version
    And the banner should document that this app takes options
    And the banner should document that this app's arguments are:
      |binary|which is required|
      |output_dir|which is required|


  Scenario: Happy Path
    Given a binary file at "/usr/local/bin/dot"
    And a target directory "/tmp/fakedir" that does not already exist
    When I successfully run "copypasta /usr/local/bin/dot /tmp/fakedir"
    Then the directory "/tmp/fakedir" should be created
    And the binary file "dot" should be copied into the directory "/tmp/fakedir"
    #And it's library should be copied into the directory "/tmp/fakedir"
Scenario: Happy Path as Dry Run
    Given a binary file at "/usr/local/bin/dot"
      And a target directory "/tmp/non-existing-dir" that does not already exist and should not be created
    When I successfully run "copypasta /usr/local/bin/dot /tmp/non-existing-dir --dry-run"
    Then the directory "/tmp/non-existing-dir" should not be created
      But the stdout should contain "creating directory: /tmp/non-existing-dir"
    And the binary file "dot" should be not copied into the directory "/tmp/non-existing-dir"
      But the stdout should contain "copying /usr/local/bin/dot to /tmp/non-existing-dir"