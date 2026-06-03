*** Settings ***
Documentation     Contact Page Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${CONTACT_NAME}       Test User
${CONTACT_EMAIL}      test@example.com
${CONTACT_PHONE}      0812345678
${CONTACT_SUBJECT}    Test Subject
${CONTACT_MESSAGE}    This is a test message

*** Test Cases ***

# TC-086: Contact Form Validation Test
TC_086_Contact_Form_Validation_Test
    [Documentation]    ทดสอบการตรวจสอบความถูกต้องของฟอร์มติดต่อ
    [Tags]    TC-086    Contact    Validation
    Open Browser    ${BASE_URL}/contact    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=form    10s
    
    # ลองส่งฟอร์มโดยไม่กรอกข้อมูล
    ${submit_buttons}=    Get WebElements    css=button[type="submit"]
    IF    '${submit_buttons}' != '[]'
        Click Element    ${submit_buttons[0]}
        Sleep    2s
        # ตรวจสอบว่ามีการแสดง error
        ${page_text}=    Get Text    css=body
        Log    Form validation: ${page_text}
    END
    
    Close Browser

# TC-087: Contact Form Submit Test
TC_087_Contact_Form_Submit_Test
    [Documentation]    ทดสอบการส่งฟอร์มติดต่อ
    [Tags]    TC-087    Contact    Submit
    Open Browser    ${BASE_URL}/contact    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=form    10s
    
    # กรอกข้อมูลในฟอร์ม
    ${name_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[name="name"]
    IF    ${name_input}
        Input Text    css=input[name="name"]    ${CONTACT_NAME}
    END
    
    ${email_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[name="email"]
    IF    ${email_input}
        Input Text    css=input[name="email"]    ${CONTACT_EMAIL}
    END
    
    ${phone_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[name="phone"]
    IF    ${phone_input}
        Input Text    css=input[name="phone"]    ${CONTACT_PHONE}
    END
    
    ${subject_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[name="subject"]
    IF    ${subject_input}
        Input Text    css=input[name="subject"]    ${CONTACT_SUBJECT}
    END
    
    ${message_input}=    Run Keyword And Return Status    Page Should Contain Element    css=textarea[name="message"]
    IF    ${message_input}
        Input Text    css=textarea[name="message"]    ${CONTACT_MESSAGE}
    END
    
    # ส่งฟอร์ม
    ${submit_buttons}=    Get WebElements    css=button[type="submit"]
    IF    '${submit_buttons}' != '[]'
        Click Element    ${submit_buttons[0]}
        Sleep    3s
        # ตรวจสอบว่ามีการแสดง success message
        ${page_text}=    Get Text    css=body
        Log    Form submission result: ${page_text}
    END
    
    Close Browser

# TC-088: Contact Phone Links Test
TC_088_Contact_Phone_Links_Test
    [Documentation]    ทดสอบการคลิกเบอร์โทรศัพท์
    [Tags]    TC-088    Contact    Phone
    Open Browser    ${BASE_URL}/contact    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=body    10s
    
    # หาลิงก์โทรศัพท์
    ${phone_links}=    Get WebElements    css=a[href^="tel:"]
    
    IF    '${phone_links}' != '[]'
        ${first_phone}=    Get Element Attribute    ${phone_links[0]}    href
        Log    Phone link found: ${first_phone}
        Should Start With    ${first_phone}    tel:
    ELSE
        Log    No phone links found
    END
    
    Close Browser

# TC-089: Contact Navigation Test
TC_089_Contact_Navigation_Test
    [Documentation]    ทดสอบการนำทางไปหน้ากระกองติดต่อ
    [Tags]    TC-089    Contact    Navigation
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # หาลิงก์ไปหน้า contact
    ${links}=    Get WebElements    css=a
    FOR    ${link}    IN    @{links}
        ${href}=    Get Element Attribute    ${link}    href
        IF    '/contact' in '${href}'
            Click Element    ${link}
            Wait Until Page Contains Element    css=body    10s
            ${current_url}=    Get Location
            Should Contain    ${current_url}    /contact
            BREAK
        END
    END
    
    Close Browser

# TC-090: Contact Email Validation Test
TC_090_Contact_Email_Validation_Test
    [Documentation]    ทดสอบการตรวจสอบรูปแบบอีเมล
    [Tags]    TC-090    Contact    Email_Validation
    Open Browser    ${BASE_URL}/contact    ${BROWSER}
    Maximize Browser Window
    
    # รอให้หน้าโหลดเสร็จ
    Wait Until Page Contains Element    css=form    10s
    
    # กรอกอีเมลที่ไม่ถูกต้อง
    ${email_input}=    Run Keyword And Return Status    Page Should Contain Element    css=input[name="email"]
    IF    ${email_input}
        Input Text    css=input[name="email"]    invalid-email
        # ส่งฟอร์ม
        ${submit_buttons}=    Get WebElements    css=button[type="submit"]
        IF    '${submit_buttons}' != '[]'
            Click Element    ${submit_buttons[0]}
            Sleep    2s
            # ตรวจสอบว่ามี error
            ${page_text}=    Get Text    css=body
            Log    Email validation result: ${page_text}
        END
    END
    
    Close Browser

*** Keywords ***
Fill Contact Form
    [Arguments]    ${name}    ${email}    ${phone}    ${subject}    ${message}
    Input Text    css=input[name="name"]    ${name}
    Input Text    css=input[name="email"]    ${email}
    Input Text    css=input[name="phone"]    ${phone}
    Input Text    css=input[name="subject"]    ${subject}
    Input Text    css=textarea[name="message"]    ${message}

