*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Process
Resource   ../config/testdata.robot

*** Keywords ***

Create Payment Order
    [Documentation]    Create a new payment order in Cashfree sandbox.
    Create Session    cashfree    ${BASE_URL}    verify=False

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    x-api-version=${API_VERSION}
    ...    x-client-id=${CLIENT_ID}
    ...    x-client-secret=${CLIENT_SECRET}

    ${customer_details}=    Create Dictionary
    ...    customer_id=${CUSTOMER_ID}
    ...    customer_email=${CUSTOMER_EMAIL}
    ...    customer_phone=${CUSTOMER_PHONE}

    ${body}=    Create Dictionary
    ...    order_amount=${ORDER_AMOUNT}
    ...    order_currency=${ORDER_CURRENCY}
    ...    customer_details=${customer_details}

    Log To Console    \nRequest Headers: ${headers}
    Log To Console    \nRequest Body: ${body}

    ${response}=    POST On Session    cashfree    /orders    json=${body}    headers=${headers}
    Log To Console    \nOrder Creation Response: ${response.text}

    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${response.status_code}    200
    Set Suite Variable    ${ORDER_ID}    ${json['order_id']}
    Log To Console    \nOrder ID: ${ORDER_ID}
    RETURN    ${ORDER_ID}


Get Payment Order Status
    [Documentation]    Retrieve order details for created order.
    [Arguments]    ${order_id}
    Create Session    cashfree    ${BASE_URL}    verify=False

    ${headers}=    Create Dictionary
    ...    Accept=application/json
    ...    x-api-version=${API_VERSION}
    ...    x-client-id=${CLIENT_ID}
    ...    x-client-secret=${CLIENT_SECRET}

    ${response}=    GET On Session    cashfree    /orders/${order_id}    headers=${headers}
    Log To Console    \nOrder Status Response: ${response.text}

    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json['order_id']}    ${order_id}
    Should Be Equal As Strings    ${json['order_currency']}    ${ORDER_CURRENCY}
    Should Be Equal As Numbers    ${json['order_amount']}    ${ORDER_AMOUNT}

    Log To Console    \nOrder Status: ${json['order_status']}
    RETURN    ${json['order_status']}


Start Mock Payment Server
    [Documentation]    Start mock Flask server in background safely (cross-platform).
    ${proc}=    Run Process    python    ${CURDIR}/../webhook/payment_stub_503.py    shell=True    stdout=NONE    stderr=NONE
    Set Suite Variable    ${proc}
    Sleep    5s

Stop Mock Payment Server
    [Documentation]    Stop the mock server process cleanly.
    Run Keyword And Ignore Error    Terminate Process    ${proc}


Verify Payment Server Down Scenario
    [Documentation]    Attempt to create a payment order when payment server is down.
    ${mock_base_url}=    Set Variable    http://127.0.0.1:5001
    Create Session    cashfree_mock    ${mock_base_url}    verify=False

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    x-api-version=${API_VERSION}
    ...    x-client-id=${CLIENT_ID}
    ...    x-client-secret=${CLIENT_SECRET}

    ${body}=    Create Dictionary
    ...    order_amount=${ORDER_AMOUNT}
    ...    order_currency=${ORDER_CURRENCY}

    Log To Console    \n[Simulating Down Server] Payment POST to ${mock_base_url}/orders
    ${response}=    POST On Session    cashfree_mock    /orders    json=${body}    headers=${headers}    expected_status=any
    Log To Console    \nMock Server Response: ${response.status_code} - ${response.text}

    Should Not Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.text}    "Payment service temporarily unavailable"
