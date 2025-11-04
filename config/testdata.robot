*** Variables ***
${BASE_URL}         https://sandbox.cashfree.com/pg
${API_VERSION}      2022-09-01
${ORDER_AMOUNT}     499.00
${ORDER_CURRENCY}   INR
${BASE_PRICE}      200
${VALID_PROMO}     FREE50
${INVALID_PROMO}   INVALID123
${CLIENT_ID}        TEST10831309d633f31f8dbf37de7c6990313801
${CLIENT_SECRET}    cfsk_ma_test_c656c14cf3550d2b4dbf7c9ddbf9001f_3869dd7d



# ✅ Required Customer Details
${CUSTOMER_ID}      CUST12345
${CUSTOMER_EMAIL}   iampraveenmech@gmail.com
${CUSTOMER_PHONE}   9999999999
${INVALID_AMOUNT}    -10.00
${CUSTOMER_DETAILS}    {"customer_id": "${CUSTOMER_ID}", "customer_email": "${CUSTOMER_EMAIL}", "customer_phone": "${CUSTOMER_PHONE}"}
