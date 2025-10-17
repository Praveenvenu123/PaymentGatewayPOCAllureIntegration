*** Settings ***
Documentation    Create a unique shopping list in Commercetools
Library           RequestsLibrary
Library           Collections
Library           JSONLibrary
Library           DateTime

*** Variables ***
${BASE_URL}       https://api.us-central1.gcp.commercetools.com
${PROJECT_KEY}    chdemoproject
${TOKEN}          Z2VXc8A5FyLN_d6EXw8BSO5eDIHOcHxt
${ENDPOINT}       /${PROJECT_KEY}/shopping-lists

*** Test Cases ***
Create Unique Shopping List Successfully
    [Documentation]    Verify that a new shopping list can be created successfully

    ${unique_suffix}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${unique_key}=       Set Variable    sl-key-${unique_suffix}
    ${unique_name}=      Set Variable    My Shopping List ${unique_suffix}
    ${unique_slug}=      Set Variable    my-shopping-list-${unique_suffix}

    Log To Console    \n🆕 Creating Shopping List with Key: ${unique_key}

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${TOKEN}

    ${quantity1}=    Convert To Integer    5
    ${quantity2}=    Convert To Integer    5
    ${variantId}=    Convert To Integer    1
    ${deleteDays}=   Convert To Integer    100

    ${name}=             Create Dictionary    en=${unique_name}
    ${slug}=             Create Dictionary    en=${unique_slug}
    ${lineItem1}=        Create Dictionary    sku=CCG-01    quantity=${quantity1}
    ${lineItem2}=        Create Dictionary    productId=7b4f89cc-436c-4e34-8cbb-c5069139b6b2    variantId=${variantId}
    @{lineItems}=        Create List    ${lineItem1}    ${lineItem2}

    ${textName}=         Create Dictionary    en=My text item name
    ${textDesc}=         Create Dictionary    en=A note for myself
    ${textItem}=         Create Dictionary    name=${textName}    description=${textDesc}    quantity=${quantity2}
    @{textLineItems}=    Create List    ${textItem}

    ${businessUnit}=     Create Dictionary    key=commercetoolss    typeId=business-unit

    ${body}=    Create Dictionary
    ...    name=${name}
    ...    slug=${slug}
    ...    key=${unique_key}
    ...    deleteDaysAfterLastModification=${deleteDays}
    ...    lineItems=${lineItems}
    ...    textLineItems=${textLineItems}
    ...    businessUnit=${businessUnit}

    # ✅ Create session and send POST request
    Create Session    commerceAPI    ${BASE_URL}    headers=${headers}    verify=${False}
    ${response}=    POST On Session    commerceAPI    ${ENDPOINT}    json=${body}

    Log To Console    \n=== RESPONSE BODY ===
    Log To Console    ${response.text}

    # ✅ Extract status code safely
    ${status_code}=    Set Variable    ${response.status_code}
    Should Be Equal As Integers    ${status_code}    201    msg=Expected 201 Created, got ${status_code}

    # ✅ Convert response JSON to dictionary
    ${json}=    Call Method    ${response}    json

    Dictionary Should Contain Key    ${json}    id
    Dictionary Should Contain Key    ${json}    key
    Should Be Equal As Strings       ${json}[key]    ${unique_key}

    Log To Console    \n✅ Shopping List created successfully!
    Log To Console    \n🆔 ID: ${json}[id]
    Log To Console    \n🔑 Key: ${json}[key]
