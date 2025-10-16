*** Settings ***
Library    RequestsLibrary
Resource   ../Resources/Payment_Keywords.robot
Suite Setup    Log To Console    Starting Payment Gateway API Tests
Suite Teardown    Log To Console    Finished Payment Gateway API Tests

*** Test Cases ***
Create And Verify Payment Order
    [Documentation]    Validate Cashfree payment order creation and retrieval.
    ${order_id}=    Create Payment Order
    ${status}=    Get Payment Order Status    ${order_id}
    Should Be Equal As Strings    ${status}    ACTIVE