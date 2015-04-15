Feature: `key' run control keyword

  Scenario: defines code to run when given key is pressed
    Given a run control file with:
      """
      key(:f) { puts 'trigger f key code' }
      """
    And uhwm is running
    When I press the alt+f keys
    Then the output must contain "trigger f key code"

  Scenario: translates common key names to their X equivalent
    Given a run control file with:
      """
      key(:enter) { puts 'trigger return key code' }
      """
    And uhwm is running
    When I press the alt+Return keys
    Then the output must contain "trigger return key code"

  Scenario: translates upcased key names to combination with shift key
    Given a run control file with:
      """
      key(:F) { puts 'trigger shift+f key code' }
      """
    And uhwm is running
    When I press the alt+shift+f keys
    Then the output must contain "trigger shift+f key code"