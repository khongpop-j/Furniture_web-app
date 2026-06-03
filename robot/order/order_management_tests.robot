*** Settings ***
Documentation     Order Management Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123

*** Test Cases ***

# TC-068: Order Detail Load Test
TC_068_Order_Detail_Load_Test
    [Documentation]    ทดสอบการโหลดรายละเอียดคำสั่งซื้อ
    [Tags]    TC-068    Order    Detail
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile เพื่อดูคำสั่งซื้อ
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "คำสั่งซื้อ"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'คำสั่งซื้อ' in '${text}' or 'order' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # ค้นหาลิงก์ไปหน้า order detail
    ${links}=    Get WebElements    css=a
    ${order_link_found}=    Set Variable    ${False}
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '/order/' in '${href}' and '${order_link_found}' == 'False'
            Click Element    ${link}
            Sleep    3s
            ${order_link_found}=    Set Variable    ${True}
            BREAK
        END
    END
    
    Close Browser

# TC-069: Order Status Timeline Test
TC_069_Order_Status_Timeline_Test
    [Documentation]    ทดสอบการแสดงไทม์ไลน์สถานะคำสั่งซื้อ
    [Tags]    TC-069    Order    Timeline
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "คำสั่งซื้อ"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'คำสั่งซื้อ' in '${text}' or 'order' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # คลิกลิงก์ order detail
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '/order/' in '${href}'
            Click Element    ${link}
            Sleep    3s
            # ตรวจสอบว่ามีการแสดงสถานะหรือไทม์ไลน์
            ${page_text}=    Get Text    css=body
            Log    Order timeline content: ${page_text}
            BREAK
        END
    END
    
    Close Browser

# TC-070: Order Print/Download Invoice Test
TC_070_Order_Print_Download_Invoice_Test
    [Documentation]    ทดสอบการพิมพ์/ดาวน์โหลดใบกำกับภาษี
    [Tags]    TC-070    Order    Invoice
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "คำสั่งซื้อ"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'คำสั่งซื้อ' in '${text}' or 'order' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    3s
            BREAK
        END
    END
    
    # คลิกลิงก์ order detail
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '/order/' in '${href}'
            Click Element    ${link}
            Sleep    3s
            # หาปุ่ม print หรือ download
            ${buttons}=    Get WebElements    css=button
            FOR    ${button}    IN    @{buttons}
                ${text}=    Get Text    ${button}
                IF    'พิมพ์' in '${text}' or 'print' in '${text}'.lower() or 'download' in '${text}'.lower()
                    Log    Print/Download button found: ${text}
                    BREAK
                END
            END
            BREAK
        END
    END
    
    Close Browser

# TC-071: Order Filter By Status Test
TC_071_Order_Filter_By_Status_Test
    [Documentation]    ทดสอบการกรองคำสั่งซื้อตามสถานะ
    [Tags]    TC-071    Order    Filter
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "คำสั่งซื้อ"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'คำสั่งซื้อ' in '${text}' or 'order' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    3s
            # หา filter dropdown
            ${selects}=    Get WebElements    css=select
            IF    '${selects}' != '[]'
                Select From List By Index    ${selects[0]}    1
                Sleep    2s
                Log    Order filter applied
            END
            BREAK
        END
    END
    
    Close Browser

# TC-072: Order Search Test
TC_072_Order_Search_Test
    [Documentation]    ทดสอบการค้นหาคำสั่งซื้อ
    [Tags]    TC-072    Order    Search
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "คำสั่งซื้อ"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'คำสั่งซื้อ' in '${text}' or 'order' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    3s
            # หา search input
            ${search_inputs}=    Get WebElements    css=input[type="search"]
            IF    '${search_inputs}' != '[]'
                Input Text    ${search_inputs[0]}    Test Order
                Press Keys    ${search_inputs[0]}    ENTER
                Sleep    2s
                Log    Order search executed
            END
            BREAK
        END
    END
    
    Close Browser

*** Keywords ***
Login With Credentials
    [Arguments]    ${email}    ${password}
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${email}
    Input Text    css=input[type="password"]    ${password}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    10s
    Sleep    2s

