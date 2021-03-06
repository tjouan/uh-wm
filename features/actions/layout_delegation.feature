Feature: `layout_*' action keywords

  Scenario: delegates `layout_*' messages to layout instance as `handle_*'
    Given a file named layout.rb with:
      """
      class Layout
        def initialize **_; end

        def register _; end

        def handle_some_action arg
          puts "testing_layout_action_#{arg}"
        end
      end
      """
    And a run control file with:
      """
      key(:f) { layout_some_action 'with_arg' }
      """
    And uhwm is running with options -v -r./layout.rb -l Layout
    When I press the alt+f keys
    Then the output will contain "testing_layout_action_with_arg"

  Scenario: logs an error about unimplemented messages
    Given uhwm is running with this run control file:
      """
      key(:f) { layout_unknown_action }
      """
    When I press the alt+f keys
    Then the output will match /layout.+no.+implem.+handle_unknown_action/i
