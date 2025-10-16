*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn

*** Variables ***
${GRAPHQL_URL}    https://countries.trevorblades.com/
${REST_BASE}      https://restcountries.com/v3.1
${HEADERS}        {"Content-Type":"application/json"}

*** Test Cases ***
GraphQL - Get Country By Code (countries.trevorblades.com)
    [Documentation]    Query the Countries GraphQL API for country information by ISO code.
    # Example: code = "IN" for India
    ${code}=    Set Variable    IN
    Create Session    gql    ${GRAPHQL_URL}    headers=${HEADERS}

    ${query}=    Catenate    SEPARATOR=\n
    ...    query GetCountry($code: ID!) {
    ...      country(code: $code) {
    ...        code
    ...        name
    ...        native
    ...        capital
    ...        currency
    ...        continent { name }
    ...        languages { code name }
    ...        emoji
    ...      }
    ...    }

    ${vars}=    Create Dictionary    code=${code}
    ${body}=    Create Dictionary    query=${query}    variables=${vars}

    ${resp}=    Post On Session    gql    /    json=${body}
    Log To Console    ======== GraphQL Response ========
    Log To Console    status: ${resp.status_code}
    Log To Console    ${resp.text}
    Log To Console    =================================

    Should Be Equal As Integers    ${resp.status_code}    200
    ${json}=    Set Variable    ${resp.json()}

    # Fail early if GraphQL returned errors
    Run Keyword If    'errors' in ${json}    Fail    GraphQL returned errors: ${json['errors']}

    # Assert shape and values
    Should Contain    ${json}    data
    Should Contain    ${json['data']}    country
    ${country}=    Set Variable    ${json['data']['country']}

    Should Contain    ${country}    code
    Should Contain    ${country}    name
    Should Contain    ${country}    capital

    # Example value assertions for demo
    Should Be Equal As Strings    ${country['code']}    ${code}
    Should Not Be Empty    ${country['name']}
    Log To Console    GraphQL -> country.name = ${country['name']}, capital = ${country['capital']}

REST - Get Country By Code (restcountries.com)
    [Documentation]    Query REST Countries API for the same ISO code and compare response shapes.
    ${code}=    Set Variable    IN
    Create Session    rest    ${REST_BASE}    headers=${HEADERS}

    # GET /alpha/{code}
    ${resp}=    Get Request    rest    /alpha/${code}
    Log To Console    ======== REST Response (/alpha/${code}) ========
    Log To Console    status: ${resp.status_code}
    Log To Console    ${resp.text}
    Log To Console    ================================================

    Should Be Equal As Integers    ${resp.status_code}    200
    ${list}=    Set Variable    ${resp.json()}

    # /alpha returns an array for v3; take first element
    ${r_country}=    Set Variable    ${list[0]}

    # REST fields (v3): name.common, cca2 (code), capital (array), currencies (map), languages (map)
    Should Contain    ${r_country}    name
    Should Contain    ${r_country}    cca2
    Should Contain    ${r_country}    capital

    # Demo assertions to compare with GraphQL
    Should Be Equal As Strings    ${r_country['cca2']}    ${code}
    ${rest_name}=    Set Variable    ${r_country['name']['common']}
    Should Not Be Empty    ${rest_name}
    Log To Console    REST  -> name = ${rest_name}, capital = ${r_country['capital'][0]}


