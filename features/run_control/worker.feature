Feature: `worker' run control keyword

  Scenario: configures the modifier key
    Given uhwm is running with this run control file:
      """
      worker :mux
      """
    Then the output must match /work.+event.+mux/i
