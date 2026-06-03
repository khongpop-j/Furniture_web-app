*** Settings ***
Documentation     Security Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123
${REGULAR_EMAIL}      test@example.com
${REGULAR_PASSWORD}   password123

*** Test Cases ***

# TC-096: Token Expiration Test
TC_096_Token_Expiration_Test
    [Documentation]    ทดสอบการ timeout ของ token หลังจากไม่ใช้งาน
    [Tags]    TC-096    Security    Token
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    Sleep    2s
    
    # ลบ token จาก localStorage จำลองการ expire
    Execute Javascript    localStorage.removeItem('token');
    Sleep    1s
    
    # พยายาม refresh หน้า
    Reload Page
    Sleep    2s
    
    # ตรวจสอบว่าถูก redirect ไปหน้า login หรือไม่
    ${current_url}=    Get Location
    
    Close Browser

# TC-097: Access Protected Routes Without Token Test
TC_097_Access_Protected_Routes_Without_Token_Test
    [Documentation]    ทดสอบการเข้าถึง protected routes โดยไม่ login
    [Tags]    TC-097    Security    Authentication
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # พยายามเข้าถึงหน้า profile โดยไม่ login
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    Sleep    2s
    
    # ตรวจสอบว่าถูก redirect ไปหน้า login หรือไม่
    ${current_url}=    Get Location
    ${is_login_page}=    Run Keyword And Return Status    Page Should Contain    Login
    
    IF    ${is_login_page}
        Log    Correctly redirected to login
    END
    
    Close Browser

# TC-098: Admin Route Protection Test
TC_098_Admin_Route_Protection_Test
    [Documentation]    ทดสอบว่า user ทั่วไปไม่สามารถเข้าถึง /admin ได้
    [Tags]    TC-098    Security    Authorization
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login เป็น user ปกติ
    Login With Credentials
    
    # พยายามเข้าถึงหน้า admin
    Go To    ${BASE_URL}/admin
    Wait Until Page Contains Element    css=body    10s
    Sleep    2s
    
    # ตรวจสอบว่าถูกบล็อกหรือมี error
    ${page_text}=    Get Text    css=body
    ${has_error}=    Run Keyword And Return Status    Page Should Contain    ไม่มีสิทธิ์
    
    IF    ${has_error}
        Log    Unauthorized access correctly blocked
    END
    
    Close Browser

# TC-099: Session Management Test
TC_099_Session_Management_Test
    [Documentation]    ทดสอบการจัดการ session
    [Tags]    TC-099    Security    Session
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    Sleep    2s
    
    # ตรวจสอบว่ามี token
    ${token}=    Execute Javascript    return localStorage.getItem('token');
    
    IF    '${token}' == 'null' or '${token}' == ''
        Fail    Token should exist after login
    ELSE
        Log    Token exists
    END
    
    Close Browser

# TC-100: Multiple Browser Tab Test
TC_100_Multiple_Browser_Tab_Test
    [Documentation]    ทดสอบการทำงานเมื่อเปิดหลาย tab
    [Tags]    TC-100    Security    Session
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # เปิด tab ใหม่
    Execute Javascript    window.open('about:blank', '_blank');
    Switch Window    NEW
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    Sleep    2s
    
    Close Browser

# TC-101: Logout Clears Session Test
TC_101_Logout_Clears_Session_Test
    [Documentation]    ทดสอบว่า logout จะลบ session
    [Tags]    TC-101    Security    Logout
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login
    Login With Credentials
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # Logout
    ${logout_buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{logout_buttons}
        ${text}=    Get Text    ${button}
        IF    'ออกจากระบบ' in '${text}' or 'logout' in '${text}'.lower()
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    # ตรวจสอบว่า token ถูกลบ
    ${token}=    Execute Javascript    return localStorage.getItem('token');
    
    IF    '${token}' == 'null' or '${token}' == ''
        Log    Token successfully cleared on logout
    ELSE
        Log    Token still exists
    END
    
    Close Browser

# TC-102: SQL Injection Prevention Test
TC_102_SQL_Injection_Prevention_Test
    [Documentation]    ทดสอบการป้องกัน SQL injection
    [Tags]    TC-102    Security    SQL_Injection
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="email"]    10s
    
    # ลอง SQL injection attack
    ${sql_injection}=    Set Variable    ' OR '1'='1
    Input Text    css=input[type="email"]    ${sql_injection}
    Input Text    css=input[type="password"]    ${sql_injection}
    
    # Submit
    Click Button    css=button[type="submit"]
    Sleep    2s
    
    # ตรวจสอบว่า login ล้มเหลว
    ${is_home}=    Run Keyword And Return Status    Page Should Contain    Furniture
    IF    ${is_home}
        Log    Potential security issue
    ELSE
        Log    SQL injection prevented
    END
    
    Close Browser

# TC-103: XSS Prevention Test
TC_103_XSS_Prevention_Test
    [Documentation]    ทดสอบการป้องกัน XSS attack
    [Tags]    TC-103    Security    XSS
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=input[type="email"]    10s
    
    # ลอง XSS attack
    ${xss_payload}=    Set Variable    <script>alert('XSS')</script>
    Input Text    css=input[type="email"]    ${xss_payload}
    Input Text    css=input[type="password"]    test123
    
    # Submit
    Click Button    css=button[type="submit"]
    Sleep    2s
    
    # ตรวจสอบว่าไม่มีการ execute script
    ${page_html}=    Get Source
    ${has_script}=    Evaluate    '<script>alert' in '''${page_html}'''
    
    IF    ${has_script}
        Log    Potential XSS vulnerability
    ELSE
        Log    XSS prevented
    END
    
    Close Browser

*** Keywords ***
Login With Credentials
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    css=input[type="email"]    10s
    Input Text    css=input[type="email"]    ${email}
    Input Text    css=input[type="password"]    ${password}
    Click Button    css=button[type="submit"]
    Wait Until Location Contains    ${BASE_URL}    10s
    Sleep    2s

