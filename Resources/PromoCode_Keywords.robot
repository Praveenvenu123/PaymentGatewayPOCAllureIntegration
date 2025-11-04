*** Settings ***
Library    ../PromoAPI.py

*** Keywords ***
Apply Promo Code And Verify
    [Arguments]    ${price}    ${promo_code}
    ${response}=    Apply Promo    ${price}    ${promo_code}
    RETURN    ${response}
