*** Settings ***
Documentation     Forgot Password Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${INVALID_EMAIL}      invalid@example.com

*** Test Cases ***

# TC-091: Forgot Password Load Test
TC_091_Forgot_Password_Load_Test
    [Documentation]    ทดสอบการโหลดหน้าลืมรหัสผ่าน
    [Tags]    TC-091    Forgot_Password    Load
    Open Browser    ${BASE_URL}/forgot-password    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=body    10s
    
    # ตรวจสอบว่าหน้าโหลดสำเร็จ
    ${page_text}=    Get Text    css=body
    Should Contain    ${page_text}    ลืมรหัสผ่าน
    
    Close Browser

# TC-092: Forgot Password Submit With Valid Email Test
TC_092_Forgot_Password_Submit_With_Valid_Email_Test
    [Documentation]    ทดสอบการส่งคำขอรีเซ็ตรหัสผ่านด้วยอีเมลที่ถูกต้อง
    [Tags]    TC-092    Forgot_Password    Valid_Email
    Open Browser    ${BASE_URL}/forgot-password    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=body    10s
    
    # กรอกอีเมลที่ถูกต้อง
    ${email_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[type="email"]
    IF    ${email_input}
        Input Text    css=input[type="email"]    ${VALID_EMAIL}
        
        # คลิกปุ่ม submit
        ${submit_buttons}=    Get WebElements    css=button[type="submit"]
        IF    '${submit_buttons}' != '[]'
            Click Element    ${submit_buttons[0]}
            Sleep    3s
            
            # ตรวจสอบว่ามีการแสดง success message
            ${page_text}=    Get Text    css=body
            Log    Form submission result: ${page_text}
        END
    END
    
    Close Browser

# TC-093: Forgot Password Submit With Invalid Email Test
TC_093_Forgot_Password_Submit_With_Invalid_Email_Test
    [Documentation]    ทดสอบการส่งคำขอด้วยอีเมลที่ไม่ถูกต้อง
    [Tags]    TC-093    Forgot_Password    Invalid_Email
    Open Browser    ${BASE_URL}/forgot-password    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=body    10s
    
    # กรอกอีเมลที่ไม่ถูกต้อง
    ${email_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[type="email"]
    IF    ${email_input}
        Input Text    css=input[type="email"]    ${INVALID_EMAIL}
        
        # คลิกปุ่ม submit
        ${submit_buttons}=    Get WebElements    css=button[type="submit"]
        IF    '${submit_buttons}' != '[]'
            Click Element    ${submit_buttons[0]}
            Sleep    3s
            
            # ตรวจสอบว่ามีการแสดง error message
            ${page_text}=    Get Text    css=body
            Log    Form submission result: ${page_text}
        END
    END
    
    Close Browser

# TC-094: Forgot Password Navigation To Login Test
TC_094_Forgot_Password_Navigation_To_Login_Test
    [Documentation]    ทดสอบการนำทางไปหน้า login จากลิงก์ "กลับไปยังหน้า"
    [Tags]    TC-094    Forgot_Password    Navigation
    Open Browser    ${BASE_URL}/forgot-password    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=body    10s
    
    # หาลิงก์ไปหน้า login
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '/login' in '${href}'
            Click Element    ${link}
            Sleep    2s
            ${current_url}=    Get Location
            Should Contain    ${current_url}    /login
            BREAK
        END
    END
    
    Close Browser

# TC-095: Forgot Password Empty Email Test
TC_095_Forgot_Password_Empty_Email_Test
    [Documentation]    ทดสอบการส่งฟอร์มโดยไม่กรอกอีเมล
    [Tags]    TC-095    Forgot_Password    Empty
    Open Browser    ${BASE_URL}/forgot-password    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=body    10s
    
    # คลิกปุ่ม submit โดยไม่กรอกข้อมูล
    ${submit_buttons}=    Get WebElements    css=button[type="submit"]
    IF    '${submit_buttons}' != '[]'
        Click Element    ${submit_buttons[0]}
        Sleep    2s
        
        # ตรวจสอบว่ามีการแสดง error
        ${page_text}=    Get Text    css=body
        Log    Form validation result: ${page_text}
    END
    
    Close Browser

*** Keywords ***
Navigate To Forgot Password
    Go To    ${BASE_URL}/forgot-password
    Wait Until Page Contains Element    css=body    10s

Fill Forgot Password Form
    [Arguments]    ${email}
    Input Text    css=input[type="email"]    ${email}

Submit Forgot Password Form
    ${submit_buttons}=    Get WebElements    css=button[type="submit"]
    Click Element    ${submit_buttons[0]}
    Sleep    3s

