*** Settings ***
Resource    ../Resources/Payment_Keywords.robot

*** Test Cases ***
Verify Order Creation When Payment Server Down
    [Documentation]    Simulate payment server outage and ensure order creation fails gracefully.
    Start Mock Payment Server
    Verify Payment Server Down Scenario
    Stop Mock Payment Server
