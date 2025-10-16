*** Settings ***
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    https://jsonplaceholder.typicode.com

*** Test Cases ***
Post Request Example
    [Documentation]    Sends a POST request with JSON data and validates the response


    Create Session    jsonplaceholder    ${BASE_URL}
    
    ${payload}=    Create Dictionary    title=Robot Framework    body=API Testing    userId=1
    ${response}=   Post On Session    jsonplaceholder    /posts    json=${payload}
    
    Should Be Equal As Integers    ${response.status_code}    201
    Log    ${response.json()}
    Should Be Equal As Strings     ${response.json()['title']}    Robot Framework

*** Test Cases ***
GET Request With Console Output
    [Documentation]    Fetch a post and print response details to terminal
    Create Session    jsonplaceholder    ${BASE_URL}
    ${resp}=    Get On Session    jsonplaceholder    /posts/1
    
    # Print entire JSON response to terminal
    Log To Console    Full Response: ${resp.json()}
    
    # Print specific fields
    Log To Console    Status Code: ${resp.status_code}
    Log To Console    Post Title: ${resp.json()['title']}
    
    # Assertions
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal As Integers    ${resp.json()['id']}    1

*** Test Cases ***
Print API Response Example
    [Documentation]    GET request and print the full JSON response in the terminal
    Create Session    jsonplaceholder    ${BASE_URL}
    ${resp}=    Get On Session    jsonplaceholder    /posts/1

    Log To Console    ========= API Response =========
    Log To Console    ${resp.json()}
    Log To Console    ================================
