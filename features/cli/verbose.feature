Feature: verbose CLI option

  Scenario: raises the logger level to INFO
    When I run uhwm with option -v
    Then the current output must match /log.+info.+level/i