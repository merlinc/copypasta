Feature: Copy Binaries
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


  Scenario: File Copying Happy Path
    Given a binary file at "/usr/local/bin/dot"
      And a target directory "/tmp/fakedir" that does not already exist
    When I successfully run "copypasta /usr/local/bin/dot /tmp/fakedir"
    Then the directory "/tmp/fakedir" should be created
      And the stdout should contain "creating directory: /tmp/fakedir"
      And the binary file "/usr/local/bin/dot" should be copied into the directory "/tmp/fakedir"
      And the stdout should contain "copying /usr/local/bin/dot to /tmp/fakedir"


  Scenario Outline: File Copying Happy Path as Dry Run
    Given a binary file at "/usr/local/bin/dot"
      And a target directory "/tmp/non-existing-dir" that does not already exist and should not be created
    When I successfully run "copypasta /usr/local/bin/dot /tmp/non-existing-dir --dry-run"
    Then the directory "/tmp/non-existing-dir" should not be created
      But the stdout should contain "creating directory: /tmp/non-existing-dir"
    And the binary file "<file>" should not be copied into the directory "/tmp/non-existing-dir"
      But the stdout should contain "copying <file> to /tmp/non-existing-dir"

    Examples:
      |file|
      |/usr/local/bin/dot|
      |/usr/local/Cellar/graphviz/2.32.0/lib/libgvc.6.dylib| 
      |/usr/local/Cellar/graphviz/2.32.0/lib/libxdot.4.dylib| 
      |/usr/local/Cellar/graphviz/2.32.0/lib/libcgraph.6.dylib| 
      |/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib| 
      |/usr/local/Cellar/graphviz/2.32.0/lib/libcdt.5.dylib| 

  Scenario Outline: Dependency Relinking as Dry Run
    Given a binary file at "/usr/local/bin/dot"
      And a target directory "/tmp/non-existing-dir" that does not already exist and should not be created
    When I successfully run "copypasta /usr/local/bin/dot /tmp/non-existing-dir --dry-run"
    Then the directory "/tmp/non-existing-dir" should not be created
      But the stdout should contain "creating directory: /tmp/non-existing-dir"
    And the binary file "<dependency>" should not be copied into the directory "/tmp/non-existing-dir"
      But the stdout should contain "copying <dependency> to /tmp/non-existing-dir"
    And the copied binary file "<name>" should not be relinked
      But the stdout should contain "relinking <binary> to point to <name>"
    Examples:
      |binary|dependency|name|
      |dot|/usr/local/Cellar/graphviz/2.32.0/lib/libgvc.6.dylib|libgvc.6.dylib|
      |dot|/usr/local/Cellar/graphviz/2.32.0/lib/libxdot.4.dylib|libxdot.4.dylib|
      |dot|/usr/local/Cellar/graphviz/2.32.0/lib/libcgraph.6.dylib|libcgraph.6.dylib|
      |dot|/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib|libpathplan.4.dylib|
      |dot|/usr/local/Cellar/graphviz/2.32.0/lib/libcdt.5.dylib|libcdt.5.dylib|
      |libgvc.6.dylib|/usr/local/Cellar/graphviz/2.32.0/lib/libxdot.4.dylib|libxdot.4.dylib|
      |libgvc.6.dylib|/usr/local/Cellar/graphviz/2.32.0/lib/libcdt.5.dylib|libcdt.5.dylib|
      |libgvc.6.dylib|/usr/local/Cellar/graphviz/2.32.0/lib/libcgraph.6.dylib|libcgraph.6.dylib|
      |libgvc.6.dylib|/usr/local/Cellar/graphviz/2.32.0/lib/libpathplan.4.dylib|libpathplan.4.dylib|
      |libcgraph.6.dylib|/usr/local/Cellar/graphviz/2.32.0/lib/libcdt.5.dylib|libcdt.5.dylib|


#  Scenario: Copying dependent files only
#    Given a binary file at "/lorem"
#    And the following dependencies:
#      | file | dependency |
#      | lorem | ipsum |
#      | ipsum | dolor |
#    When I successfully run "copypasta lorem /tmp/dependent-dir"
#    Then the directory "dependent-dir" contains the file "lorem"
#      And the directory "dependent-dir" contains the file "ipsum"
#      And the directory "dependent-dir" contains the file "dolor"
#      And the number of files in the directory is 3
