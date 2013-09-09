Feature: Checkout dotfiles
  In order to copy binaries to a new computer
  I want a one-command way to copy them and their dependencies
  So I don't have to do it myself

  Scenario: Basic UI
    When I get help for "copypasta"
    Then the exit status should be 0
    And the banner should be present
    And there should be a one line summary of what the app does
    And the banner should include the version
    And the banner should document that this app takes options
    And the banner should document that this app's arguments are:
      |binary|which is required|
      |output_dir|which is required|

  Scenario: Happy Path
    Given a binary file at "/usr/local/bin/dot"
    When I successfully run "copypasta /usr/local/bin/dot outputdir"
    Then the binary file "dot" should be copied into the directory "outputdir"
    #And it's library should be copied into the directory "outputdir"