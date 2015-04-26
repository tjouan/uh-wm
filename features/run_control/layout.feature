Feature: `layout' run control keyword

  Background:
    Given a file named my_layout.rb with:
      """
      class MyLayout
        def register *_
          puts "testing_rc_layout"
        end
      end
      """

  Scenario: configures a layout class
    Given a run control file with:
      """
      layout MyLayout
      """
    When I run uhwm with options -r./my_layout
    Then the output must contain "testing_rc_layout"

  Scenario: configures a layout instance
    Given a run control file with:
      """
      layout MyLayout.new
      """
    When I run uhwm with options -r./my_layout
    Then the output must contain "testing_rc_layout"
