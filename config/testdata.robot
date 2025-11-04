*** Variables ***
${BASE_URL}         https://sandbox.cashfree.com/pg
${API_VERSION}      2022-09-01
${ORDER_AMOUNT}     499.00
${ORDER_CURRENCY}   INR
${BASE_PRICE}      200
${VALID_PROMO}     FREE50
${INVALID_PROMO}   INVALID123

# ✅ Required Customer Details
${CUSTOMER_ID}      CUST12345
${CUSTOMER_EMAIL}   iampraveenmech@gmail.com
${CUSTOMER_PHONE}   9999999999
${INVALID_AMOUNT}    -10.00
${CUSTOMER_DETAILS}    {"customer_id": "${CUSTOMER_ID}", "customer_email": "${CUSTOMER_EMAIL}", "customer_phone": "${CUSTOMER_PHONE}"}
