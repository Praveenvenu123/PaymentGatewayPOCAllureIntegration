*** Settings ***
Library    ../JwtValidator.py   # Imports your custom Python library
Library    BuiltIn

*** Variables ***
# Configuration Variables
${SECRET}                my-secret-key-for-poc
@{ALGORITHMS}            HS256                  # CORRECT: Defined as a list/array
${AUDIENCE}              my-api-service
${ISSUER}                auth-server-poc

# Test Tokens:
# Valid token (signed with 'my-secret-key-for-poc', exp: 2227987200)
${VALID_TOKEN}         eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvZWJvdCIsImlhdCI6MTUxNjIzOTAyMiwiZXhwIjozMDAwMDAwMDAwLCJhdWQiOiJteS1hcGktc2VydmljZSIsImlzcyI6ImF1dGgtc2VydmVyLXBvYyIsInJvbGUiOiJBRE1JTiJ9.M5FgInks1JfNZpOiHHO0Eqlyc6DBiEoOxHGigOniA3U

# Invalid token (signature tampered by appending '_INVALID')
${INVALID_SIGNATURE_TOKEN}    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvZWJvdCIsImlhdCI6MTUxNjIzOTAyMiwiZXhwIjoyMjI3OTg3MjAwLCJhdWQiOiJteS1hcGktc2VydmljZSIsImlzcyI6ImF1dGgtc2VydmVyLXBvYyIsInJvbGUiOiJBRE1JTiJ9.fA9X-J8o2wR4-r0-O2MvRj7YwR_z7q-c-s9g_Q6eP1_INVALID

*** Test Cases ***
Successful JWT Validation (Type 1 & Type 2 Pass)
    [Documentation]    Verifies signature, standard claims (exp, aud, iss), and custom claims.

    # Type 1: Structural/Cryptographic Validation (Core Security Checks)
    ${PAYLOAD}=    Decode And Validate JWT  
    ...    ${VALID_TOKEN}
    ...    ${SECRET}
    ...    @{ALGORITHMS}
    ...    audience=${AUDIENCE}
    ...    issuer=${ISSUER}
    Log To Console    Decoded Payload: ${PAYLOAD}

    # Type 2: Payload Claim Validation (Business Logic Checks)
    Validate Payload Claim    ${PAYLOAD}    name    Joebot
    Validate Payload Claim    ${PAYLOAD}    role    ADMIN
    Log To Console    Token is valid and payload claims match expectations.

Invalid Signature Check (Type 1 Failure)
    [Documentation]    Verifies that a tampered token signature is detected.

    # This asserts that the 'Invalid signature' error is correctly raised
    Run Keyword And Expect Error    *Invalid signature (token integrity failed).*
    ...    Decode And Validate JWT
    ...    ${INVALID_SIGNATURE_TOKEN}
    ...    ${SECRET}
    ...    @{ALGORITHMS}
    ...    audience=${AUDIENCE}
    ...    issuer=${ISSUER}
    Log To Console    Test passed: Invalid signature was correctly rejected.

Invalid Custom Claim Check (Type 2 Failure)
    [Documentation]    Verifies that a wrong business claim is detected.

    # 1. Decode must pass first
    ${PAYLOAD}=    Decode And Validate JWT    ${VALID_TOKEN}    ${SECRET}    @{ALGORITHMS}    audience=${AUDIENCE}    issuer=${ISSUER}

    # 2. Check for an incorrect business claim (asserts failure because we expect 'GUEST' but token has 'ADMIN')
    Run Keyword And Expect Error    *Expected: 'GUEST', Got: 'ADMIN'.*
    ...    Validate Payload Claim    ${PAYLOAD}    role    GUEST
    Log To Console    Test passed: Incorrect payload claim was correctly rejected.