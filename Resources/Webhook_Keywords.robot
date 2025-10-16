*** Settings ***
Library    BuiltIn
Library    JSONLibrary
Library    OperatingSystem
Library    Process


*** Variables ***
${WEBHOOK_PORT}      5000
${WEBHOOK_LOG_FILE}  ${CURDIR}/../webhook_logs/webhook_data.json


*** Keywords ***

Start Webhook Server
    [Documentation]    Start webhook server in background (non-blocking).
    Start   Process    python    webhook/webhook_server.py
    Sleep    3s
    Log To Console    \n🚀 Webhook server started on port ${WEBHOOK_PORT}


Stop Webhook Server
    [Documentation]    Stop webhook server process.
    Terminate  All Processes
    Log To Console    \n🛑 Webhook server stopped.


Validate Webhook Data
    [Documentation]    Validate that webhook JSON log contains expected order and status.
    [Arguments]    ${expected_order_id}    ${expected_status}

    Log To Console    \n🔍 Validating webhook data in ${WEBHOOK_LOG_FILE}
    ${file_exists}=    Run Keyword And Return Status    File Should Exist    ${WEBHOOK_LOG_FILE}
    Should Be True    ${file_exists}    msg=❌ Webhook log file not found!

    ${json}=    Load JSON From File    ${WEBHOOK_LOG_FILE}

    # ✅ Safely handle when JSON contains multiple entries
    ${entry_count}=    Get Length    ${json}
    ${last_index}=     Evaluate    ${entry_count} - 1
    ${last_entry}=     Set Variable    ${json[${last_index}]}

    Log To Console    \n📦 Latest Webhook: ${last_entry}
    Should Be Equal As Strings    ${last_entry['order_id']}    ${expected_order_id}
    Should Be Equal As Strings    ${last_entry['status']}       ${expected_status}
    Log To Console    \n✅ Webhook validation passed for Order ID: ${expected_order_id}
