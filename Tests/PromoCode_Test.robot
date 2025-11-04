
*** Settings ***
Documentation     Validate promo code functionality using API
Resource          ../Resources/PromoCode_Keywords.robot
Resource          ../config/testdata.robot

*** Test Cases ***
Valid Promo Code Should Reduce Price
    ${price}=    Set Variable    250
    ${promo}=    Set Variable    FREE50
    ${result}=   Apply Promo    ${price}    ${promo}

    ${original}=    Set Variable    ${result['original_price']}
    ${final}=       Set Variable    ${result['final_price']}

    Log To Console    \n--- Promo Calculation ---
    Log To Console    Original Price: ${original}
    Log To Console    Final Price After Applying ${promo}: ${final}
    Log To Console    -----------------------------
    Log    ✅ Promo applied successfully. Price changed from ${original} to ${final}

    Should Be True    ${final} < ${original}

Invalid Promo Code Should Show Error
    ${price}=    Set Variable    200
    ${promo}=    Set Variable    INVALID123
    ${response}=    Apply Promo Code And Verify   ${price}    ${promo}
    Should Contain    ${response['error']}    Invalid promo code
