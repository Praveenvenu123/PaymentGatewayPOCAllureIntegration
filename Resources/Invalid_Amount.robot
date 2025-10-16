*** Settings ***
Library    RequestsLibrary
Resource   ../config/testdata.robot

*** Keywords ***

Validate Invalid Payment Request
    [Documentation]    Sends an invalid or edge-case payment request and validates the 400 error response.
    [Arguments]    ${payload}
    Create Session    cashfree    ${BASE_URL}    verify=False

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    x-api-version=${API_VERSION}
    ...    x-client-id=${CLIENT_ID}
    ...    x-client-secret=${CLIENT_SECRET}

    Log To Console    \n📤 Sending Invalid Payment Request with Payload: ${payload}

    ${response}=    POST On Session
    ...    cashfree
    ...    /orders
    ...    json=${payload}
    ...    headers=${headers}
    ...    expected_status=any

    Log To Console    \n✅ Raw API Response: ${response.status_code} | ${response.text}

    # ✅ Validate the response is HTTP 400
    Should Be Equal As Integers    ${response.status_code}    400    msg=❌ Expected 400 Bad Request, got ${response.status_code}

    # ✅ Validate the message contains error keywords
    Should Contain Any    ${response.text}    invalid    error    Invalid    failed
    Log To Console    \n✅ Validation Passed: API correctly rejected invalid request.

    # Store the response for later use if needed
    Set Test Variable    ${RESPONSE}    ${response}
