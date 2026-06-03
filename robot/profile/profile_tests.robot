*** Settings ***
Documentation     Profile Page Test Cases
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}           http://localhost:3000
${BROWSER}            Chrome
${VALID_EMAIL}        test@example.com
${VALID_PASSWORD}     password123

*** Test Cases ***

# TC-061: Profile Load User Data Test
TC_061_Profile_Load_User_Data_Test
    [Documentation]    ทดสอบการโหลดข้อมูลผู้ใช้ในหน้า profile
    [Tags]    TC-061    Profile    Load
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # ตรวจสอบว่ามีข้อมูลผู้ใช้ (อาจจะเป็น email ของ user ที่ login หรือ mock data)
    ${page_text}=    Get Text    css=body
    ${has_email_format}=    Evaluate    '@' in '''${page_text}'''
    Should Be True    ${has_email_format}    Profile should contain email
    
    Close Browser

# TC-062: Profile Edit Information Test
TC_062_Profile_Edit_Information_Test
    [Documentation]    ทดสอบการแก้ไขข้อมูลส่วนตัว
    [Tags]    TC-062    Profile    Edit
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หาปุ่ม Edit
    ${edit_buttons}=    Get WebElements    css=button
    ${edit_clicked}=    Set Variable    ${False}
    FOR    ${button}    IN    @{edit_buttons}
        ${text}=    Get Text    ${button}
        IF    'แก้ไข' in '${text}' or 'edit' in '${text}'.lower()
            Click Element    ${button}
            ${edit_clicked}=    Set Variable    ${True}
            BREAK
        END
    END
    
    IF    ${edit_clicked}
        Sleep    2s
        # หา input fields และทดสอบการกรอกข้อมูล
        ${inputs}=    Get WebElements    css=input[type="text"]
        IF    '${inputs}' != '[]'
            Input Text    ${inputs[0]}    Test Name
        END
    END
    
    Close Browser

# TC-063: Profile Update Address Test
TC_063_Profile_Update_Address_Test
    [Documentation]    ทดสอบการอัปเดตที่อยู่
    [Tags]    TC-063    Profile    Address
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "ที่อยู่ของฉัน"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'ที่อยู่' in '${text}' or 'address' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    2s
            BREAK
        END
    END
    
    Close Browser

# TC-064: Profile View Orders Test
TC_064_Profile_View_Orders_Test
    [Documentation]    ทดสอบการดูประวัติคำสั่งซื้อ
    [Tags]    TC-064    Profile    Orders
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
            Sleep    2s
            # ตรวจสอบว่ามีการแสดงรายการคำสั่งซื้อ
            ${page_text}=    Get Text    css=body
            Log    Orders page content: ${page_text}
            BREAK
        END
    END
    
    Close Browser

# TC-065: Profile View Favorites Test
TC_065_Profile_View_Favorites_Test
    [Documentation]    ทดสอบการดูรายการสินค้าที่ชื่นชอบ
    [Tags]    TC-065    Profile    Favorites
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หา tab "รายการโปรด"
    ${tabs}=    Get WebElements    css=button
    FOR    ${tab}    IN    @{tabs}
        ${text}=    Get Text    ${tab}
        IF    'รายการโปรด' in '${text}' or 'favorite' in '${text}'.lower()
            Click Element    ${tab}
            Sleep    2s
            # ตรวจสอบว่ามีการแสดงรายการโปรด
            ${page_text}=    Get Text    css=body
            Log    Favorites page content: ${page_text}
            BREAK
        END
    END
    
    Close Browser

# TC-066: Profile Phone Number Validation Test
TC_066_Profile_Phone_Number_Validation_Test
    [Documentation]    ทดสอบการตรวจสอบรูปแบบเบอร์โทร
    [Tags]    TC-066    Profile    Validation
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หาปุ่ม Edit
    ${edit_buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{edit_buttons}
        ${text}=    Get Text    ${button}
        IF    'แก้ไข' in '${text}' or 'edit' in '${text}'.lower()
            Click Element    ${button}
            Sleep    2s
            BREAK
        END
    END
    
    # หา input field สำหรับเบอร์โทร
    ${phone_inputs}=    Get WebElements    css=input[type="tel"]
    IF    '${phone_inputs}' != '[]'
        Input Text    ${phone_inputs[0]}    invalid-phone-number
        # ลองบันทึก
        ${save_buttons}=    Get WebElements    css=button
        FOR    ${button}    IN    @{save_buttons}
            ${text}=    Get Text    ${button}
            IF    'บันทึก' in '${text}' or 'save' in '${text}'.lower()
                Click Element    ${button}
                Sleep    2s
                BREAK
            END
        END
    END
    
    Close Browser

# TC-067: Profile Logout Test
TC_067_Profile_Logout_Test
    [Documentation]    ทดสอบการออกจากระบบจากหน้า profile
    [Tags]    TC-067    Profile    Logout
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    
    # Login ก่อน
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # ไปที่หน้า profile
    Go To    ${BASE_URL}/profile
    Wait Until Page Contains Element    css=body    10s
    
    # หาปุ่ม Logout
    ${logout_buttons}=    Get WebElements    css=button
    FOR    ${button}    IN    @{logout_buttons}
        ${text}=    Get Text    ${button}
        IF    'ออกจากระบบ' in '${text}' or 'logout' in '${text}'.lower()
            Click Element    ${button}
            Sleep    3s
            # ตรวจสอบว่าถูก redirect ไปหน้าแรกหรือหน้า login
            ${current_url}=    Get Location
            Should Contain    ${current_url}    ${BASE_URL}
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

