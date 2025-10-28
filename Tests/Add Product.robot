*** Settings ***
Library           RequestsLibrary
Library           Collections

Suite Setup       Create Session    mysession    https://dummyjson.com

*** Variables ***
${ENDPOINT}       /products/add

*** Test Cases ***
Add Product - Validate Response
    [Documentation]    Validate POST /products API for adding a new product
    ${body}=    Create Dictionary    title=Robot Laptop    price=999    description=High-speed automation device
    ${headers}=    Create Dictionary    Content-Type=application/json

    ${response}=    POST On Session    mysession    ${ENDPOINT}    headers=${headers}    json=${body}

    Log To Console    \nResponse Status: ${response.status_code}
    Log To Console    Response Body: ${response.text}

    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id
    Should Be Equal As Strings    ${response.json()['title']}    Robot Laptop
