*** Settings ***
Resource    ../Resources/Invalid_Amount.robot
Resource    ../config/testdata.robot

*** Test Cases ***
Invalid Amount Payment Request
    [Tags]    edgecase
    ${invalid_payload}=    Create Dictionary
    ...    order_amount=-10.00
    ...    order_currency=${ORDER_CURRENCY}
    ...    customer_details={"customer_id": "${CUSTOMER_ID}", "customer_email": "${CUSTOMER_EMAIL}", "customer_phone": "${CUSTOMER_PHONE}"}

    Validate Invalid Payment Request    ${invalid_payload}
